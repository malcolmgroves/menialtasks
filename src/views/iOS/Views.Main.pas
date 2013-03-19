unit Views.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Data.Bind.GenData, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.ObjectScope, FMX.Layouts, FMX.ListBox, EnumerableAdapter,
  ViewModel.Main, Model.Task, System.Actions, FMX.ActnList;

type
  TViewMain = class(TForm)
    Header: TToolBar;
    HeaderLabel: TLabel;
    Layout1: TLayout;
    ListBox1: TListBox;
    TaskListBindSource: TPrototypeBindSource;
    BindingsList1: TBindingsList;
    Button1: TButton;
    ActionList1: TActionList;
    actAddTask: TAction;
    LinkListControlToField1: TLinkListControlToField;
    procedure FormDestroy(Sender: TObject);
    procedure TaskListBindSourceCreateAdapter(Sender: TObject;
      var ABindSourceAdapter: TBindSourceAdapter);
    procedure actAddTaskExecute(Sender: TObject);
    procedure ListBox1ItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    { Private declarations }
    FViewModel : TMainViewModel;
    function ViewModel : TMainViewModel;
    function TaskAdapter : TEnumerableBindSourceAdapter<TTask>;
    procedure RefreshBindings;
  public
    { Public declarations }
  end;

var
  ViewMain: TViewMain;

implementation
uses
  Model.TaskList, ViewModel.Task, Views.Task;

{$R *.fmx}

{$REGION 'LiveBindings Related Code'}

procedure TViewMain.RefreshBindings;
begin
  if TaskAdapter.GetEnumerable = nil then
    TaskAdapter.SetEnumerable(ViewModel.Tasks.GetEnumerable)
  else
    TaskAdapter.Reload;
end;

function TViewMain.TaskAdapter: TEnumerableBindSourceAdapter<TTask>;
begin
  Result := TEnumerableBindSourceAdapter<TTask>(TaskListBindSource.InternalAdapter);
end;
procedure TViewMain.TaskListBindSourceCreateAdapter(Sender: TObject;
  var ABindSourceAdapter: TBindSourceAdapter);
begin
  ABindSourceAdapter := TEnumerableBindSourceAdapter<TTask>.Create(TaskListBindSource,
                                                                   ViewModel.Tasks.GetEnumerable);
end;

{$ENDREGION}

function TViewMain.ViewModel: TMainViewModel;
begin
  if not Assigned(FViewModel) then
  begin
    FViewModel := TMainViewModel.Create;
    FViewModel.OnEditTask := function (Sender : TObject; TaskViewModel : TTaskViewModel) : boolean
                             var
                               LTaskView : TTaskView;
                             begin
                               LTaskView := TTaskView.Create(nil, TaskViewModel);
                               try
                                 Result := LTaskView.ShowModal = mrOk;
                               finally
                                 LTaskView.Free;
                               end;
                             end;
  end;

  Result := FViewModel;
end;

procedure TViewMain.actAddTaskExecute(Sender: TObject);
begin
  ViewModel.AddNewTask;
  RefreshBindings;
end;

procedure TViewMain.FormDestroy(Sender: TObject);
begin
  FViewModel.Free;
end;


procedure TViewMain.ListBox1ItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  ViewModel.EditTask(TaskAdapter.Current);
  RefreshBindings;
end;

end.
