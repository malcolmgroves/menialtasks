program MenialTasks;

uses
  FMX.Forms,
  EnumerableAdapter in '..\EnumerableAdapter.pas',
  Views.Main in '..\views\Win\Views.Main.pas' {ViewMain},
  Views.Task in '..\views\Win\Views.Task.pas' {TaskView};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TViewMain, ViewMain);
  Application.Run;
end.
