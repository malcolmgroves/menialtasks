unit Tests.ViewModel.Main;

interface
uses
  TestFramework, ViewModel.Main;

type
  TestTMainViewModel = class(TTestCase)
  strict private
    FMainViewModel: TMainViewModel;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestTasksIsInstantiatedOnCreate;
    procedure TestTaskNotAddedOnCancel;
    procedure TestTaskAddedOnSave;
  end;

implementation
uses
  SysUtils, DateUtils, Model.Exceptions, ViewModel.Task;

procedure TestTMainViewModel.SetUp;
begin
  FMainViewModel := TMainViewModel.Create;
end;

procedure TestTMainViewModel.TearDown;
begin
  FMainViewModel.Free;
  FMainViewModel := nil;
end;

procedure TestTMainViewModel.TestTaskAddedOnSave;
begin
  FMainViewModel.OnEditTask := procedure (Sender : TObject; TaskViewModel : TTaskViewModel)
                               begin
                                 TaskViewModel.Save;
                               end;

  FMainViewModel.AddNewTask;
  Check(FMainViewModel.Tasks.Count = 1, 'Pressing Save on AddNewTask should add a Task to the TaskList');
end;

procedure TestTMainViewModel.TestTaskNotAddedOnCancel;
begin
  FMainViewModel.OnEditTask := procedure (Sender : TObject; TaskViewModel : TTaskViewModel)
                               begin
                                 TaskViewModel.Cancel;
                               end;

  FMainViewModel.AddNewTask;
  Check(FMainViewModel.Tasks.Count = 0, 'Calling Cancel on AddNewTask should not add a Task to the TaskList');
end;

procedure TestTMainViewModel.TestTasksIsInstantiatedOnCreate;
begin
  Check(Assigned(FMainViewModel.Tasks), 'Tasks should be Assigned but is not');
end;

initialization
  RegisterTest('ViewModels', TestTMainViewModel.Suite);
end.

