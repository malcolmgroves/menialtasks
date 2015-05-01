program MenialTasksTests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  Tests.Model.Task in 'model\Tests.Model.Task.pas',
  Tests.Model.TaskList in 'model\Tests.Model.TaskList.pas',
  Tests.ViewModel.Task in 'viewmodels\Tests.ViewModel.Task.pas',
  Tests.ViewModel.Main in 'viewmodels\Tests.ViewModel.Main.pas',
  Model.TaskList in '..\model\Model.TaskList.pas',
  Model.Task in '..\model\Model.Task.pas',
  Model.Exceptions in '..\model\Model.Exceptions.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

