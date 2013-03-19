unit ViewModel.Main;

interface
uses
  Model.TaskList, ViewModel.Task, Model.Task;

type
  TOnEditTask = reference to function (Sender : TObject; TaskViewModel : TTaskViewModel) : boolean;
  TMainViewModel = class
  private
    FTasks : TTaskList;
    FOnEditTask: TOnEditTask;
    function DoOnEditTask(TaskViewModel : TTaskViewModel): boolean; virtual;
  public
    constructor Create;
    destructor Destroy; override;
    property Tasks : TTaskList read FTasks;
    procedure AddNewTask;
    procedure EditTask(ATask : TTask);
    property OnEditTask : TOnEditTask read FOnEditTask write FOnEditTask;
  end;

implementation

{ TMainViewModel }


procedure TMainViewModel.AddNewTask;
var
  LTaskViewModel : TTaskViewModel;
  NewTask : TTask;
begin
  NewTask := TTask.Create;
  LTaskViewModel := TTaskViewModel.Create(NewTask);
  try
    if DoOnEditTask(LTaskViewModel) then
      Tasks.AddTask(NewTask);
  finally
    LTaskViewModel.Free;
  end;
end;

constructor TMainViewModel.Create;
begin
  FTasks := TTaskList.Create;
end;

destructor TMainViewModel.Destroy;
begin
  FTasks.Free;
  inherited;
end;

function TMainViewModel.DoOnEditTask(TaskViewModel : TTaskViewModel) : boolean;
begin
  if Assigned(FOnEditTask) then
    Result := FOnEditTask(self, TaskViewModel)
  else
    Result := False;
end;

procedure TMainViewModel.EditTask(ATask: TTask);
var
  LTaskViewModel : TTaskViewModel;
begin
  LTaskViewModel := TTaskViewModel.Create(ATask);
  try
    DoOnEditTask(LTaskViewModel);
  finally
    LTaskViewModel.Free;
  end;
end;

end.
