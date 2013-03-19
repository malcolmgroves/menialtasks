program MenialTasksiOS;

uses
  System.StartUpCopy,
  FMX.Forms,
  Views.Main in '..\views\iOS\Views.Main.pas' {ViewMain},
  ViewModel.Main in '..\viewmodels\ViewModel.Main.pas',
  Model.TaskList in '..\model\Model.TaskList.pas',
  Model.Task in '..\model\Model.Task.pas',
  Model.Exceptions in '..\model\Model.Exceptions.pas',
  Common.Exceptions in '..\common\Common.Exceptions.pas',
  EnumerableAdapter in '..\EnumerableAdapter.pas',
  ViewModel.Task in '..\viewmodels\ViewModel.Task.pas',
  Views.Task in '..\views\iOS\Views.Task.pas' {TaskView};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TViewMain, ViewMain);
  Application.Run;
end.
