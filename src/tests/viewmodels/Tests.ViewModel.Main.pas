unit Tests.ViewModel.Main;

interface
uses
  TestFramework, ViewModel.Main;

type
  TestTMainViewModel = class(TTestCase)
  strict private
    FMainViewModel: TMainViewModel;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestTasksIsInstantiatedOnCreate;
  end;

implementation
uses
  SysUtils, DateUtils, Model.Exceptions;

procedure TestTMainViewModel.SetUp;
begin
  FMainViewModel := TMainViewModel.Create;
end;

procedure TestTMainViewModel.TearDown;
begin
  FMainViewModel.Free;
  FMainViewModel := nil;
end;

procedure TestTMainViewModel.TestTasksIsInstantiatedOnCreate;
begin
  Check(Assigned(FMainViewModel.Tasks), 'Tasks should be Assigned but is not');
end;

initialization
  RegisterTest('ViewModels', TestTMainViewModel.Suite);
end.

