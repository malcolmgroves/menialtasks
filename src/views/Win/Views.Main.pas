unit Views.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Rtti, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, ViewModel.Main,
  Data.Bind.ObjectScope, Data.Bind.Components, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Grid, FMX.Layouts, FMX.Grid, FMX.ListBox, Data.Bind.GenData,
  System.Actions, FMX.ActnList, Fmx.Bind.Navigator, Model.Task, EnumerableAdapter,
  FMX.Memo, FMX.StdCtrls, FMX.Objects, Data.Bind.Controls, FMX.MultiView,
  FMX.Controls.Presentation;

type
  TViewMain = class(TForm)
    ViewModelBindSource: TAdapterBindSource;
    ViewModelGeneratorAdapter: TDataGeneratorAdapter;
    BindingsList1: TBindingsList;
    TaskListBindSource: TPrototypeBindSource;
    LinkFillControlToField1: TLinkFillControlToField;
    Button2: TButton;
    ActionList1: TActionList;
    Button3: TButton;
    Rectangle1: TRectangle;
    ListBox1: TListBox;
    Label1: TLabel;
    LinkListControlToField1: TLinkListControlToField;
    Panel3: TPanel;
    Rectangle2: TRectangle;
    Text1: TText;
    LinkPropertyToFieldText: TLinkPropertyToField;
    Line1: TLine;
    Text2: TText;
    LinkPropertyToFieldText2: TLinkPropertyToField;
    Circle1: TCircle;
    Text3: TText;
    LinkPropertyToFieldText3: TLinkPropertyToField;
    NavigatorViewModelBindSource: TBindNavigator;
    MultiView1: TMultiView;
    Button1: TButton;
    ToolBar1: TToolBar;
    Label2: TLabel;
    procedure FormDestroy(Sender: TObject);
    procedure ViewModelBindSourceCreateAdapter(Sender: TObject;
      var ABindSourceAdapter: TBindSourceAdapter);
    procedure TaskListBindSourceCreateAdapter(Sender: TObject;
      var ABindSourceAdapter: TBindSourceAdapter);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ListBox1ItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    FViewModel : TMainViewModel;
    function ViewModel : TMainViewModel;
    function TaskAdapter : TEnumerableBindSourceAdapter<TTask>;
    procedure RefreshBindings;
  public

  end;

var
  ViewMain: TViewMain;

implementation
uses
  Model.TaskList, Views.Task, ViewModel.Task;

{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}

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


procedure TViewMain.ListBox1ItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  if TPresentationState.Opened in MultiView1.Presenter.State then
    MultiView1.HideMaster;
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
                               LTaskView.ShowModal(procedure(ModalResult : TModalResult)
                                                   begin
                                                     TaskViewModel.Free;
                                                     RefreshBindings;
                                                   end);
                             end;
  end;

  Result := FViewModel;
end;



end.
