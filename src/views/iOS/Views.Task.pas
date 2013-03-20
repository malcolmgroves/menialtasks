unit Views.Task;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, Data.Bind.GenData,
  Data.Bind.Components, Data.Bind.ObjectScope, System.Actions, FMX.ActnList,
  FMX.StdCtrls, ViewModel.Task, FMX.Layouts, FMX.Memo,
  FMX.Edit, FMX.ExtCtrls, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt;

type
  TTaskView = class(TForm)
    Header: TToolBar;
    btnBack: TButton;
    btnDone: TButton;
    ActionList1: TActionList;
    actCancel: TAction;
    actSave: TAction;
    TaskBindSource: TPrototypeBindSource;
    Label1: TLabel;
    Edit1: TEdit;
    CalendarEdit1: TCalendarEdit;
    Memo1: TMemo;
    Label2: TLabel;
    Label3: TLabel;
    BindingsList1: TBindingsList;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    LinkControlToField3: TLinkControlToField;
    LayoutKeyboardShift: TLayout;
    VertScrollBox1: TVertScrollBox;
    procedure TaskBindSourceCreateAdapter(Sender: TObject;
      var ABindSourceAdapter: TBindSourceAdapter);
    procedure LinkControlToField3AssignedValue(Sender: TObject;
      AssignValueRec: TBindingAssignValueRec; const Value: TValue);
    procedure actCancelExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actSaveUpdate(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
  private
    FViewModel : TTaskViewModel;
    FAutoPosting : Boolean;
  public
    constructor Create(AOwner: TComponent; AViewModel : TTaskViewModel); reintroduce;

  end;

var
  TaskView: TTaskView;

implementation
uses
  Model.Task, FMX.InertialMovement;

{$R *.fmx}

procedure TTaskView.actCancelExecute(Sender: TObject);
begin
  FViewModel.Cancel;
end;

procedure TTaskView.actSaveExecute(Sender: TObject);
begin
  FViewModel.Save;
end;

procedure TTaskView.actSaveUpdate(Sender: TObject);
begin
  actSave.Enabled := FViewModel.CanSave;
end;

constructor TTaskView.Create(AOwner: TComponent; AViewModel: TTaskViewModel);
begin
  FViewModel := AViewModel;
  FAutoPosting := False;

  inherited Create(AOwner);
end;

procedure TTaskView.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  LayoutKeyboardShift.Visible := False;
  VertScrollBox1.AniCalculations.ViewportPosition := TPointD.Create(0, 1);
//  VertScrollBox1.AnimateFloatDelay('VScrollBar.Value', FocusedControl.AbsoluteRect.Top - 80, 0.2, 0.2);
end;

procedure TTaskView.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
var
  FocusedControl: TControl;
begin
  // Make shift of VertScrollBox1 on keyboard's height
  LayoutKeyboardShift.Visible := True;
  LayoutKeyboardShift.Height := Bounds.Height;
  // We Make ocontent ffset to focused control
  if Assigned(Focused) and (Focused.GetObject is TControl) then
  begin
    FocusedControl := TControl(Focused.GetObject);
    if (FocusedControl.AbsoluteRect.IntersectsWith(TRectF.Create(Bounds))) then
      VertScrollBox1.AnimateFloatDelay('VScrollBar.Value', FocusedControl.AbsoluteRect.Top - 80, 0.2, 0.2);

  end;
end;

procedure TTaskView.LinkControlToField3AssignedValue(Sender: TObject;
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
                                                               FViewModel.Task,
                                                               False);
end;

end.
