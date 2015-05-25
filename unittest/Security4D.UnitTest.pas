unit Security4D.UnitTest;

interface

uses
  TestFramework,
  System.Classes,
  System.SysUtils,
  Security4D,
  Security4D.UnitTest.Authenticator,
  Security4D.UnitTest.Credentials,
  Security4D.UnitTest.Authorizer,
  Security4D.UnitTest.Car;

type

  TTestSecurity4D = class(TTestCase)
  private
    procedure CheckLoggedIn();
    procedure LoginInvalidUser();
    procedure CarInsert();
    procedure CarUpdate();
    procedure CarDelete();
    procedure CarView();
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestAuthentication();
    procedure TestPermissions();
    procedure TestNotLogged();
    procedure TestAfterLoginSuccessful();
    procedure TestAfterLogoutSuccessful();
    procedure TestInterceptor();
  end;

implementation

{ TTestSecurity4D }

procedure TTestSecurity4D.CarDelete;
var
  vCar: TCar;
begin
  vCar := TCar.Create;
  try
    vCar.Delete;
  finally
    FreeAndNil(vCar);
  end;
end;

procedure TTestSecurity4D.CarInsert;
var
  vCar: TCar;
begin
  vCar := TCar.Create;
  try
    vCar.Insert;
  finally
    FreeAndNil(vCar);
  end;
end;

procedure TTestSecurity4D.CarUpdate;
var
  vCar: TCar;
begin
  vCar := TCar.Create;
  try
    vCar.Update;
  finally
    FreeAndNil(vCar);
  end;
end;

procedure TTestSecurity4D.CarView;
var
  vCar: TCar;
begin
  vCar := TCar.Create;
  try
    vCar.View;
  finally
    FreeAndNil(vCar);
  end;
end;

procedure TTestSecurity4D.CheckLoggedIn;
begin
  Security.Context.CheckLoggedIn;
end;

procedure TTestSecurity4D.LoginInvalidUser;
begin
  if Security.Context.IsLoggedIn then
    Security.Context.Logout;

  Credentials.Username := 'user';
  Credentials.Password := 'user';
  Credentials.Role := ROLE_ADMIN;

  Security.Context.Login;
end;

procedure TTestSecurity4D.SetUp;
begin
  inherited;

end;

procedure TTestSecurity4D.TearDown;
begin
  inherited;

end;

procedure TTestSecurity4D.TestAfterLoginSuccessful;
var
  vMsg: string;
begin
  if Security.Context.IsLoggedIn then
    Security.Context.Logout;

  Security.Context.OnAfterLoginSuccessful(
    procedure
    begin
      vMsg := 'Login Successful';
    end);

  Credentials.Username := 'bob';
  Credentials.Password := 'bob';
  Credentials.Role := ROLE_ADMIN;

  Security.Context.Login;

  CheckEquals('Login Successful', vMsg);

  Security.Context.Logout;
  Security.Context.OnAfterLoginSuccessful(nil);
end;

procedure TTestSecurity4D.TestAfterLogoutSuccessful;
var
  vMsg: string;
begin
  if Security.Context.IsLoggedIn then
    Security.Context.Logout;

  Security.Context.OnAfterLogoutSuccessful(
    procedure
    begin
      vMsg := 'Login Successful';
    end);

  Credentials.Username := 'bob';
  Credentials.Password := 'bob';
  Credentials.Role := ROLE_ADMIN;

  Security.Context.Login;
  Security.Context.Logout;

  CheckEquals('Login Successful', vMsg);

  Security.Context.OnAfterLoginSuccessful(nil);
end;

procedure TTestSecurity4D.TestAuthentication;
begin
  if Security.Context.IsLoggedIn then
    Security.Context.Logout;

  Credentials.Username := 'bob';
  Credentials.Password := 'bob';
  Credentials.Role := ROLE_ADMIN;

  Security.Context.Login;
  CheckTrue(Security.Context.IsLoggedIn);
  Security.Context.CheckLoggedIn;
  Security.Context.Logout;
  CheckFalse(Security.Context.IsLoggedIn);

  Credentials.Username := 'jeff';
  Credentials.Password := 'jeff';
  Credentials.Role := ROLE_MANAGER;

  Security.Context.Login;
  CheckTrue(Security.Context.IsLoggedIn);
  Security.Context.CheckLoggedIn;
  Security.Context.Logout;
  CheckFalse(Security.Context.IsLoggedIn);

  Credentials.Username := 'nick';
  Credentials.Password := 'nick';
  Credentials.Role := ROLE_NORMAL;

  Security.Context.Login;
  CheckTrue(Security.Context.IsLoggedIn);
  Security.Context.CheckLoggedIn;
  Security.Context.Logout;
  CheckFalse(Security.Context.IsLoggedIn);

  CheckException(LoginInvalidUser, EAuthorizationException);
end;

procedure TTestSecurity4D.TestInterceptor;
begin
  if Security.Context.IsLoggedIn then
    Security.Context.Logout;

  Credentials.Username := 'nick';
  Credentials.Password := 'nick';
  Credentials.Role := ROLE_NORMAL;

  Security.Context.Login;

  CheckException(CarInsert, EAuthorizationException);
  CheckException(CarUpdate, EAuthorizationException);
  CheckException(CarDelete, EAuthorizationException);
  CarView();

  Security.Context.Logout;

  Credentials.Username := 'bob';
  Credentials.Password := 'bob';
  Credentials.Role := ROLE_ADMIN;

  Security.Context.Login;

  CarInsert();
  CarUpdate();
  CarDelete();
  CarView();
end;

procedure TTestSecurity4D.TestNotLogged;
begin
  if Security.Context.IsLoggedIn then
    Security.Context.Logout;

  CheckException(CheckLoggedIn, EAuthorizationException);
end;

procedure TTestSecurity4D.TestPermissions;
begin
  if Security.Context.IsLoggedIn then
    Security.Context.Logout;

  Credentials.Username := 'bob';
  Credentials.Password := 'bob';
  Credentials.Role := ROLE_ADMIN;

  Security.Context.Login;
  CheckTrue(Security.Context.IsLoggedIn);
  Security.Context.CheckLoggedIn;
  CheckTrue(Security.Context.HasRole(ROLE_ADMIN));
  CheckTrue(Security.Context.HasPermission('Car', 'Insert'));
  CheckTrue(Security.Context.HasPermission('Car', 'Update'));
  CheckTrue(Security.Context.HasPermission('Car', 'Delete'));
  CheckTrue(Security.Context.HasPermission('Car', 'View'));
  Security.Context.Logout;
  CheckFalse(Security.Context.IsLoggedIn);

  Credentials.Username := 'jeff';
  Credentials.Password := 'jeff';
  Credentials.Role := ROLE_MANAGER;

  Security.Context.Login;
  CheckTrue(Security.Context.IsLoggedIn);
  Security.Context.CheckLoggedIn;
  CheckTrue(Security.Context.HasRole(ROLE_MANAGER));
  CheckTrue(Security.Context.HasPermission('Car', 'Insert'));
  CheckTrue(Security.Context.HasPermission('Car', 'Update'));
  CheckTrue(Security.Context.HasPermission('Car', 'Delete'));
  CheckTrue(Security.Context.HasPermission('Car', 'View'));
  Security.Context.Logout;
  CheckFalse(Security.Context.IsLoggedIn);

  Credentials.Username := 'nick';
  Credentials.Password := 'nick';
  Credentials.Role := ROLE_NORMAL;

  Security.Context.Login;
  CheckTrue(Security.Context.IsLoggedIn);
  Security.Context.CheckLoggedIn;
  CheckTrue(Security.Context.HasRole(ROLE_NORMAL));
  CheckFalse(Security.Context.HasPermission('Car', 'Insert'));
  CheckFalse(Security.Context.HasPermission('Car', 'Update'));
  CheckFalse(Security.Context.HasPermission('Car', 'Delete'));
  CheckTrue(Security.Context.HasPermission('Car', 'View'));
  Security.Context.Logout;
  CheckFalse(Security.Context.IsLoggedIn);
end;

initialization

RegisterTest(TTestSecurity4D.Suite);

end.
