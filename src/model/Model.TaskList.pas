unit Model.TaskList;

interface
uses
  Generics.Collections, Model.Task;

type
  TTaskList = class
  private
    FTasks : TObjectList<TTask>;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddTask(Task : TTask);
    function AddNewTask : TTask;
    function GetEnumerable: TEnumerable<TTask>;
    function Contains(Task : TTask) : boolean;
    property Count : Integer read GetCount;
  end;

implementation
uses
  Model.Exceptions;

{ TTaskList }

function TTaskList.AddNewTask: TTask;
var
  LTask : TTask;
begin
  LTask := TTask.Create;
  AddTask(LTask);
  Result := LTask;
end;

procedure TTaskList.AddTask(Task: TTask);
begin
  if not Assigned(Task) then
    raise NilParamException.Create('Task passed in is not Assigned');

  if Contains(Task) then
    raise DuplicateTaskException.Create('TaskList already contains this Task');

  FTasks.Add(Task);
end;

function TTaskList.Contains(Task: TTask): boolean;
begin
  if not Assigned(Task) then
    raise NilParamException.Create('Task passed in is not Assigned');

  Result := FTasks.Contains(Task);
end;

constructor TTaskList.Create;
begin
  FTasks := TObjectList<TTask>.Create(True);
end;

destructor TTaskList.Destroy;
begin
  FTasks.Free;
  inherited;
end;

function TTaskList.GetCount: Integer;
begin
  Result := FTasks.Count;
end;

function TTaskList.GetEnumerable: TEnumerable<TTask>;
begin
  Result := FTasks;
end;

end.
