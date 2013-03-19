program MenialTasks;

uses
  FMX.Forms,
  EnumerableAdapter in '..\EnumerableAdapter.pas',
  Views.Main in '..\views\Win\Views.Main.pas' {ViewMain},
  Views.Task in '..\views\Win\Views.Task.pas' {TaskView},
  Common.Exceptions in '..\common\Common.Exceptions.pas',
  Model.TaskList in '..\model\Model.TaskList.pas',
  Model.Task in '..\model\Model.Task.pas',
  Model.Exceptions in '..\model\Model.Exceptions.pas',
  ViewModel.Task in '..\viewmodels\ViewModel.Task.pas',
  ViewModel.Main in '..\viewmodels\ViewModel.Main.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TViewMain, ViewMain);
  Application.Run;
end.
