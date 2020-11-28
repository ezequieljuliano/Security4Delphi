program SecurityTests;

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
  Security.Core in '..\src\Security.Core.pas',
  Security in '..\src\Security.pas',
  Security.User in '..\src\Security.User.pas',
  Security.Context in '..\src\Security.Context.pas',
  Authenticator in 'common\Authenticator.pas',
  Credential in 'common\Credential.pas',
  Authorizer in 'common\Authorizer.pas',
  Security.Test in 'Security.Test.pas',
  Security.Aspect in '..\src\Security.Aspect.pas',
  Security.Aspect.Test in 'Security.Aspect.Test.pas';

{$R *.RES}

begin

  ReportMemoryLeaksOnShutdown := True;

  DUnitTestRunner.RunRegisteredTests;

end.
