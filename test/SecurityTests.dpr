// ***************************************************************************
//
// Security For Delphi
//
// Copyright (c) 2015-2020 Ezequiel Juliano Müller
//
// ***************************************************************************
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// ***************************************************************************

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
