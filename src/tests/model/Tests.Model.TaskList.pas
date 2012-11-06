unit Tests.Model.TaskList;

interface
uses
  TestFramework, Model.Task, Model.TaskList;

type
  TestTTaskList = class(TTestCase)
  strict private
    FTaskList: TTaskList;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestAddNewTask;
    procedure TestAddNilTask;
    procedure TestAddDuplicateTask;
  end;

implementation
uses
  SysUtils, DateUtils, Model.Exceptions;

procedure TestTTaskList.SetUp;
begin
  FTaskList := TTaskList.Create;
end;

procedure TestTTaskList.TearDown;
begin
  FTaskList.Free;
  FTaskList := nil;
end;

procedure TestTTaskList.TestAddDuplicateTask;
var
  LTask: TTask;
begin
  LTask := TTask.Create;
  FTaskList.AddTask(LTask);
  StartExpectingException(DuplicateTaskException);
  FTaskList.AddTask(LTask);
  StopExpectingException('Adding the same task twice should have thrown a DuplicateTaskException');
end;

procedure TestTTaskList.TestAddNewTask;
var
  LTask: TTask;
begin
  LTask := FTaskList.AddNewTask;
  Check(FTaskList.Count = 1, 'TaskList should contain 1 Task after calling AddNewTask');
  Check(FTaskList.Contains(LTask), 'TaskList should contain the Task returned by AddNewTask');
end;

procedure TestTTaskList.TestAddNilTask;
begin
  StartExpectingException(NilParamException);
  FTaskList.AddTask(nil);
  StopExpectingException('Adding a nil Task to the Tasklist should have thrown a NilParamException');
end;

initialization
  RegisterTest('Model', TestTTaskList.Suite);
end.

