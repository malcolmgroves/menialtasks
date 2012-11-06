unit Tests.ViewModel.Task;

interface
uses
  TestFramework, ViewModel.Task, Model.Task;

type
  TestTTaskViewModel = class(TTestCase)
  strict private
    FTaskViewModel: TTaskViewModel;
  private
    FTask: TTask;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCanSaveEmptyTitle;
    procedure TestCanSaveValidTitle;
    procedure TestEditTaskSave;
    procedure TestEditTaskCancel;
  end;

implementation
uses
  SysUtils, DateUtils, Model.Exceptions;

procedure TestTTaskViewModel.SetUp;
begin
  FTask := TTask.Create;
  FTaskViewModel := TTaskViewModel.Create(FTask);
end;

procedure TestTTaskViewModel.TearDown;
begin
  FTaskViewModel.Free;
  FTaskViewModel := nil;
  FTask.Free;
end;


procedure TestTTaskViewModel.TestCanSaveEmptyTitle;
begin
  FTaskViewModel.Task.Title := '';
  CheckFalse(FTaskViewModel.CanSave, 'Should not be able to save a Task with an empty Title');
end;

procedure TestTTaskViewModel.TestCanSaveValidTitle;
begin
  FTaskViewModel.Task.Title := 'Test Title';
  CheckTrue(FTaskViewModel.CanSave, 'Should be able to save a Task with a valid Title');
end;


procedure TestTTaskViewModel.TestEditTaskCancel;
var
  LOldTaskTitle : string;
  LOldTaskDue : TDateTime;
  LOldTaskDetails : string;
begin
  LOldTaskTitle := FTaskViewModel.Task.Title;
  LOldTaskDue := FTaskViewModel.Task.Due;
  LOldTaskDetails := FTaskViewModel.Task.Details;

  FTaskViewModel.Task.Title := 'whatever';
  FTaskViewModel.Task.Due := Now;
  FTaskViewModel.Task.Details := 'whatever';
  FTaskViewModel.Cancel;

  Check(FTask.Title = LOldTaskTitle);
  Check(FTask.Due = LOldTaskDue);
  Check(FTask.Details = LOldTaskDetails);
end;

procedure TestTTaskViewModel.TestEditTaskSave;
var
  LNewTaskTitle : string;
  LNewTaskDue : TDateTime;
  LNewTaskDetails : string;
begin
  LNewTaskTitle := 'whatever';
  LNewTaskDue := Now;
  LNewTaskDetails := 'whatever';

  FTaskViewModel.Task.Title := LNewTaskTitle;
  FTaskViewModel.Task.Due := LNewTaskDue;
  FTaskViewModel.Task.Details := LNewTaskDetails;
  FTaskViewModel.Save;

  Check(FTask.Title = LNewTaskTitle);
  Check(FTask.Due = LNewTaskDue);
  Check(FTask.Details = LNewTaskDetails);
end;

initialization
  RegisterTest('ViewModels', TestTTaskViewModel.Suite);
end.

