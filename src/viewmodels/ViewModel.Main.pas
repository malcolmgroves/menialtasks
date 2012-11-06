unit ViewModel.Main;

interface
uses
  Model.TaskList, ViewModel.Task, Model.Task;

type
  TOnEditTask = reference to procedure (Sender : TObject; TaskViewModel : TTaskViewModel);
  TMainViewModel = class
  private
    FTasks : TTaskList;
    FOnEditTask: TOnEditTask;
    procedure DoOnEditTask(TaskViewModel : TTaskViewModel); virtual;
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
begin
  LTaskViewModel := TTaskViewModel.Create(Tasks.AddNewTask);
  try
    DoOnEditTask(LTaskViewModel);
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

procedure TMainViewModel.DoOnEditTask(TaskViewModel : TTaskViewModel);
begin
  if Assigned(FOnEditTask) then
    FOnEditTask(self, TaskViewModel);
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
