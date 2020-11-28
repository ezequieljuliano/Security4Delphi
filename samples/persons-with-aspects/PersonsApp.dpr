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
