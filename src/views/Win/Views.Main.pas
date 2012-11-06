unit Views.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Rtti, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, ViewModel.Main,
  Data.Bind.ObjectScope, Data.Bind.Components, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Grid, FMX.Layouts, FMX.Grid, FMX.ListBox, Data.Bind.GenData,
  System.Actions, FMX.ActnList, Fmx.Bind.Navigator, Model.Task, EnumerableAdapter,
  FMX.Memo;

type
  TViewMain = class(TForm)
    ViewModelBindSource: TAdapterBindSource;
    ViewModelGeneratorAdapter: TDataGeneratorAdapter;
    BindingsList1: TBindingsList;
    TaskListBindSource: TPrototypeBindSource;
    LinkFillControlToField1: TLinkFillControlToField;
    NavigatorViewModelBindSource: TBindNavigator;
    Button2: TButton;
    ActionList1: TActionList;
    Grid1: TGrid;
    LinkGridToDataSource1: TLinkGridToDataSource;
    Label2: TLabel;
    LinkPropertyToField2: TLinkPropertyToField;
    Button3: TButton;
    MemoDetails: TMemo;
    LinkControlToField1: TLinkControlToField;
    procedure FormDestroy(Sender: TObject);
    procedure ViewModelBindSourceCreateAdapter(Sender: TObject;
      var ABindSourceAdapter: TBindSourceAdapter);
    procedure TaskListBindSourceCreateAdapter(Sender: TObject;
      var ABindSourceAdapter: TBindSourceAdapter);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
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
  Model.TaskList, Views.Task, ViewModel.Task;

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

procedure TViewMain.ViewModelBindSourceCreateAdapter(Sender: TObject;
  var ABindSourceAdapter: TBindSourceAdapter);
begin
  ABindSourceAdapter := TObjectBindSourceAdapter<TMainViewModel>.Create(ViewModelBindSource,
                                                                        ViewModel, False);
end;

procedure TViewMain.TaskListBindSourceCreateAdapter(Sender: TObject;
  var ABindSourceAdapter: TBindSourceAdapter);
begin
  ABindSourceAdapter := TEnumerableBindSourceAdapter<TTask>.Create(TaskListBindSource,
                                                                   ViewModel.Tasks.GetEnumerable);
end;

{$ENDREGION}

procedure TViewMain.Button2Click(Sender: TObject);
begin
  ViewModel.AddNewTask;
end;

procedure TViewMain.Button3Click(Sender: TObject);
begin
  ViewModel.EditTask(TaskAdapter.Current);
end;

procedure TViewMain.FormDestroy(Sender: TObject);
begin
  FViewModel.Free;
end;


function TViewMain.ViewModel: TMainViewModel;
begin
  if not Assigned(FViewModel) then
  begin
    FViewModel := TMainViewModel.Create;
    FViewModel.OnEditTask := procedure (Sender : TObject; TaskViewModel : TTaskViewModel)
                             var
                               LTaskView : TTaskView;
                             begin
                               LTaskView := TTaskView.Create(nil, TaskViewModel);
                               try
                                 if LTaskView.ShowModal = mrOk then
                                   RefreshBindings;
                               finally
                                 LTaskView.Free;
                               end;
                             end;
  end;

  Result := FViewModel;
end;



end.
