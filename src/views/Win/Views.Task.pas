unit Views.Task;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Rtti, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, ViewModel.Task,
  Data.Bind.GenData, Data.Bind.Components, Data.Bind.ObjectScope,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, FMX.Edit, FMX.ExtCtrls, System.Actions, FMX.ActnList,
  FMX.ListBox, Model.Task, Generics.Collections, FMX.Layouts, FMX.Memo, FMX.StdCtrls,
  FMX.CalendarEdit, FMX.ComboEdit, FMX.Controls.Presentation, FMX.DateTimeCtrls,
  FMX.ScrollBox;

type
  TTaskView = class(TForm)
    TaskBindSource: TPrototypeBindSource;
    ActionList1: TActionList;
    actSave: TAction;
    actCancel: TAction;
    Button1: TButton;
    Button2: TButton;
    EditTitle: TEdit;
    LinkControlToField1: TLinkControlToField;
    BindingsList1: TBindingsList;
    MemoDetails: TMemo;
    LinkControlToField3: TLinkControlToField;
    ListBox1: TListBox;
    lbiTitle: TListBoxItem;
    lbiDue: TListBoxItem;
    lbiDetails: TListBoxItem;
    DateEdit1: TDateEdit;
    LinkControlToField4: TLinkControlToField;
    ToolBar1: TToolBar;
    Label1: TLabel;
    procedure TaskBindSourceCreateAdapter(Sender: TObject;
      var ABindSourceAdapter: TBindSourceAdapter);
    procedure actSaveUpdate(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FViewModel : TTaskViewModel;
  public
    constructor Create(AOwner: TComponent; AViewModel : TTaskViewModel); reintroduce;
  end;

implementation

{$R *.fmx}
{$R *.NmXhdpiPh.fmx ANDROID}
{$R *.iPhone4in.fmx IOS}
{$R *.Macintosh.fmx _MACOS}
{$R *.Windows.fmx MSWINDOWS}

{ TForm1 }

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
  inherited Create(AOwner);
end;


procedure TTaskView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TTaskView.FormResize(Sender: TObject);
begin
  lbiDetails.Height := ListBox1.Height - lbiTitle.Height - lbiDue.Height - 45;
end;

procedure TTaskView.TaskBindSourceCreateAdapter(Sender: TObject;
  var ABindSourceAdapter: TBindSourceAdapter);
begin
  ABindSourceAdapter := TObjectBindSourceAdapter<TTask>.Create(TaskBindSource,
                                                               FViewModel.Task,
                                                               False);
  ABindSourceAdapter.AutoPost := True;
end;

end.
