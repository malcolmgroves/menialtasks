unit Model.Task;

interface
uses
  System.Classes;

type
  TTask = class(TPersistent)
  private
    FTitle: string;
    FDue: TDate;
    FDetails: string;
    procedure SetDue(const Value: TDate);
    function GetIsValid: Boolean;
  public
    constructor Create; virtual;
    procedure Assign(Source: TPersistent); override;
    property Title: string read FTitle write FTitle;
    property Details : string read FDetails write FDetails;
    property Due: TDate read FDue write SetDue;
    property IsValid : Boolean read GetIsValid;
  end;

implementation
uses
  SysUtils, DateUtils, Model.Exceptions, Types;

{ TTask }

procedure TTask.Assign(Source: TPersistent);
begin
  if Source is TTask then
  begin
    Title := TTask(Source).Title;
    Due := TTask(Source).Due;
    Details := TTask(Source).Details;
  end
  else
    inherited Assign(Source);
end;

constructor TTask.Create;
begin
  Due := IncDay(Now, 7);
end;

function TTask.GetIsValid: Boolean;
begin
  Result := Title <> '';
end;

procedure TTask.SetDue(const Value: TDate);
begin
  if FDue <> Value then
  begin
    if CompareDate(Now, Value) = GreaterThanValue then
      raise PastTaskException.Create(Format('Current DateTime %s : Task Due : %s',
                                            [DateTimeToStr(Now), DateTimeToStr(Value)]));
    FDue := Value;
  end;
end;

end.
