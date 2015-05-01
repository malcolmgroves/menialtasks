unit ViewModel.Task;

interface
uses
  Model.Task;

type
  TTaskViewModel = class;
  TTaskNotification = reference to procedure (Sender : TTaskViewModel; Task : TTask);
  TTaskViewModel = class(TObject)
  private
    FTask: TTask;
    FOriginalTask: TTask;
    FOnSaveTask : TTaskNotification;
    function GetCanSave: Boolean;
  public
    constructor Create(ATask : TTask); virtual;
    destructor Destroy; override;
    property Task: TTask read FTask write FTask;
    property CanSave : Boolean read GetCanSave;
    property OnSaveTask : TTaskNotification read FOnSaveTask write FOnSaveTask;
    procedure Save;
    procedure Cancel;
  end;

implementation

{ TTaskViewModel }

function TTaskViewModel.GetCanSave: Boolean;
begin
  Result := FTask.IsValid
end;

procedure TTaskViewModel.Save;
begin
  FOriginalTask.Assign(FTask);
  if Assigned(FOnSaveTask) then
    FOnSaveTask(self, FOriginalTask);
end;

procedure TTaskViewModel.Cancel;
begin
  // don't assign the staging back to FTask.
end;

constructor TTaskViewModel.Create(ATask : TTask);
begin
  FOriginalTask := ATask;
  FTask := TTask.Create;
  FTask.Assign(FOriginalTask);
end;

destructor TTaskViewModel.Destroy;
begin
  FTask.Free;
  inherited;
end;

end.
