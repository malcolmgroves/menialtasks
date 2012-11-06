unit Views.Task;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Rtti, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, ViewModel.Task,
  Data.Bind.GenData, Data.Bind.Components, Data.Bind.ObjectScope,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, FMX.Edit, FMX.ExtCtrls, System.Actions, FMX.ActnList,
  FMX.ListBox, Model.Task, Generics.Collections, FMX.Layouts, FMX.Memo;

type
  TTaskView = class(TForm)
    TaskBindSource: TPrototypeBindSource;
    ActionList1: TActionList;
    actSave: TAction;
    actCancel: TAction;
    Button1: TButton;
    Button2: TButton;
    EditTitle: TEdit;
    Label1: TLabel;
    LinkControlToField1: TLinkControlToField;
    BindingsList1: TBindingsList;
    CalendarEditDue: TCalendarEdit;
    Label2: TLabel;
    LinkControlToField2: TLinkControlToField;
    MemoDetails: TMemo;
    LinkControlToField3: TLinkControlToField;
    Label3: TLabel;
    procedure TaskBindSourceCreateAdapter(Sender: TObject;
      var ABindSourceAdapter: TBindSourceAdapter);
    procedure actSaveUpdate(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
    procedure LinkControlToField1AssignedValue(Sender: TObject;
      AssignValueRec: TBindingAssignValueRec; const Value: TValue);
  private
    { Private declarations }
    FViewModel : TTaskViewModel;
    FAutoPosting : Boolean;
    function ViewModel : TTaskViewModel;
  public
    constructor Create(AOwner: TComponent; AViewModel : TTaskViewModel); reintroduce;

    { Public declarations }

  end;

implementation

{$R *.fmx}

{ TForm1 }

procedure TTaskView.actCancelExecute(Sender: TObject);
begin
  ViewModel.Cancel;
end;

procedure TTaskView.actSaveExecute(Sender: TObject);
begin
  ViewModel.Save;
end;

procedure TTaskView.actSaveUpdate(Sender: TObject);
begin
  actSave.Enabled := ViewModel.CanSave;
end;

constructor TTaskView.Create(AOwner: TComponent; AViewModel: TTaskViewModel);
begin
  FViewModel := AViewModel;
  FAutoPosting := False;

  inherited Create(AOwner);
end;


procedure TTaskView.LinkControlToField1AssignedValue(Sender: TObject;
  AssignValueRec: TBindingAssignValueRec; const Value: TValue);
begin
  // auto-post changes back to the adapted object
  if TaskBindSource.Editing then
  begin
    if not FAutoPosting then
    begin
      FAutoPosting := True;
      try
        TaskBindSource.Post;
      finally
        FAutoPosting := False;
      end;
    end;
  end;
end;

procedure TTaskView.TaskBindSourceCreateAdapter(Sender: TObject;
  var ABindSourceAdapter: TBindSourceAdapter);
begin
  ABindSourceAdapter := TObjectBindSourceAdapter<TTask>.Create(TaskBindSource,
                                                               ViewModel.Task,
                                                               False);
end;

function TTaskView.ViewModel: TTaskViewModel;
begin
  Result := FViewModel;
end;

end.
