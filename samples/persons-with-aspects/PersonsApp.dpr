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

program PersonsApp;

uses
  Vcl.Forms,
  Main.View in 'Main.View.pas' {MainView},
  App.Context in 'App.Context.pas',
  Person in 'Person.pas',
  Person.Repository in 'Person.Repository.pas',
  Authenticator in '..\common\Authenticator.pas',
  Authorizer in '..\common\Authorizer.pas',
  Credential in '..\common\Credential.pas';

{$R *.res}

begin

  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainView, MainView);
  Application.Run;

end.
