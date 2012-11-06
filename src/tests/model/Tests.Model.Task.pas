unit Tests.Model.Task;

interface
uses
  TestFramework, Model.Task;

type
  TestTTask = class(TTestCase)
  strict private
    FTask: TTask;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCreateTaskDueInThePast;
    procedure TestAssignTask;
  end;

implementation
uses
  SysUtils, DateUtils, Model.Exceptions;

procedure TestTTask.SetUp;
begin
  FTask := TTask.Create;
end;

procedure TestTTask.TearDown;
begin
  FTask.Free;
  FTask := nil;
end;

procedure TestTTask.TestAssignTask;
const
  CTaskTitle = 'My Title';
  CTaskDetails = 'My Task Details';
var
  LTask: TTask;
  LTaskDue : TDateTime;
begin
  LTaskDue := Now;
  LTask := TTask.Create;
  try
    LTask.Title := CTaskTitle;
    LTask.Due := LTaskDue;
    LTask.Details := CTaskDetails;
    FTask.Assign(LTask);
    Check(FTask.Title = CTaskTitle);
    Check(FTask.Due = LTaskDue);
    Check(FTask.Details = CTaskDetails);
  finally
    LTask.Free;
  end;
end;


procedure TestTTask.TestCreateTaskDueInThePast;
begin
  StartExpectingException(PastTaskException);
  FTask.Due := IncMinute(Now, -10);
  StopExpectingException();
end;

initialization
  RegisterTest('Model', TestTTask.Suite);
end.

