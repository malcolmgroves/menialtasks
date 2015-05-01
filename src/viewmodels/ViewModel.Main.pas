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
  LTaskViewModel.OnSaveTask := procedure(Sender : TTaskViewModel; Task : TTask)
                               begin
                                 Tasks.AddTask(Task);
                               end;
  if Assigned(FOnEditTask) then
    FOnEditTask(self, LTaskViewModel);
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

procedure TMainViewModel.EditTask(ATask: TTask);
var
  LTaskViewModel : TTaskViewModel;
begin
  LTaskViewModel := TTaskViewModel.Create(ATask);
  if Assigned(FOnEditTask) then
    FOnEditTask(self, LTaskViewModel);
end;

end.
