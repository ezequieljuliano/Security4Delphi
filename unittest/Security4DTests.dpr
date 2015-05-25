program Security4DTests;
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
  Security4D.UnitTest in 'Security4D.UnitTest.pas',
  Security4D in '..\src\Security4D.pas',
  Security4D.UnitTest.Authenticator in 'Security4D.UnitTest.Authenticator.pas',
  Security4D.UnitTest.Credentials in 'Security4D.UnitTest.Credentials.pas',
  Security4D.UnitTest.Authorizer in 'Security4D.UnitTest.Authorizer.pas',
  Security4D.UnitTest.Register in 'Security4D.UnitTest.Register.pas',
  Security4D.UnitTest.Car in 'Security4D.UnitTest.Car.pas',
  Security4D.Aspect in '..\src\Security4D.Aspect.pas';

{$R *.RES}

begin

  ReportMemoryLeaksOnShutdown := True;

  DUnitTestRunner.RunRegisteredTests;

end.
