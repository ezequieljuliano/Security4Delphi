unit Security4D.UnitTest;

interface

uses
  TestFramework,
  System.Classes,
  System.SysUtils,
  Aspect4D,
  Aspect4D.Impl,
  Security4D,
  Security4D.Impl,
  Security4D.Aspect,
  Security4D.UnitTest.Authenticator,
  Security4D.UnitTest.Credential,
  Security4D.UnitTest.Authorizer,
  Security4D.UnitTest.Car;

type

  TTestSecurity4D = class(TTestCase)
  private
    fSecurityContext: ISecurityContext;
    fAspectContext: IAspectContext;
    fCar: TCar;
    procedure CheckLoggedIn;
    procedure LoginInvalidUser;
    procedure CarInsert;
    procedure CarUpdate;
    procedure CarDelete;
    procedure CarView;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestAuthentication;
    procedure TestPermissions;
    procedure TestNotLogged;
    procedure TestAfterLoginSuccessful;
    procedure TestAfterLogoutSuccessful;
    procedure TestSecurityAspect;
  end;

implementation

{ TTestSecurity4D }

procedure TTestSecurity4D.CarDelete;
begin
  fCar.Delete;
end;

procedure TTestSecurity4D.CarInsert;
begin
  fCar.Insert;
end;

procedure TTestSecurity4D.CarUpdate;
begin
  fCar.Update;
end;

procedure TTestSecurity4D.CarView;
begin
  fCar.View;
end;

procedure TTestSecurity4D.CheckLoggedIn;
begin
  fSecurityContext.CheckLoggedIn;
end;

procedure TTestSecurity4D.LoginInvalidUser;
begin
  if fSecurityContext.IsLoggedIn then
    fSecurityContext.Logout;

  fSecurityContext.Login(TUser.Create('user', TCredential.Create('user', 'user', ROLE_ADMIN)));
end;

procedure TTestSecurity4D.SetUp;
begin
  inherited;
  fSecurityContext := TSecurityContext.Create;
  fSecurityContext.RegisterAuthenticator(TAuthenticator.Create(fSecurityContext));
  fSecurityContext.RegisterAuthorizer(TAuthorizer.Create(fSecurityContext));

  fAspectContext := TAspectContext.Create;
  fAspectContext.Register(TSecurityAspect.Create(fSecurityContext));

  fCar := TCar.Create;
  fAspectContext.Weaver.Proxify(fCar);
end;

procedure TTestSecurity4D.TearDown;
begin
  inherited;
  fAspectContext.Weaver.Unproxify(fCar);
  fCar.Free;
end;

procedure TTestSecurity4D.TestAfterLoginSuccessful;
var
  msg: string;
begin
  if fSecurityContext.IsLoggedIn then
    fSecurityContext.Logout;

  fSecurityContext.OnAfterLoginSuccessful(
    procedure
    begin
      msg := 'Login Successful';
    end);

  fSecurityContext.Login(TUser.Create('bob', TCredential.Create('bob', 'bob', ROLE_ADMIN)));

  CheckEquals('Login Successful', msg);

  fSecurityContext.Logout;
  fSecurityContext.OnAfterLoginSuccessful(nil);
end;

procedure TTestSecurity4D.TestAfterLogoutSuccessful;
var
  msg: string;
begin
  if fSecurityContext.IsLoggedIn then
    fSecurityContext.Logout;

  fSecurityContext.OnAfterLogoutSuccessful(
    procedure
    begin
      msg := 'Logout Successful';
    end);

  fSecurityContext.Login(TUser.Create('bob', TCredential.Create('bob', 'bob', ROLE_ADMIN)));

  fSecurityContext.Logout;

  CheckEquals('Logout Successful', msg);

  fSecurityContext.OnAfterLoginSuccessful(nil);
end;

procedure TTestSecurity4D.TestAuthentication;
begin
  if fSecurityContext.IsLoggedIn then
    fSecurityContext.Logout;

  fSecurityContext.Login(TUser.Create('bob', TCredential.Create('bob', 'bob', ROLE_ADMIN)));
  CheckTrue(fSecurityContext.IsLoggedIn);
  fSecurityContext.CheckLoggedIn;
  fSecurityContext.Logout;
  CheckFalse(fSecurityContext.IsLoggedIn);

  fSecurityContext.Login(TUser.Create('jeff', TCredential.Create('jeff', 'jeff', ROLE_MANAGER)));
  CheckTrue(fSecurityContext.IsLoggedIn);
  fSecurityContext.CheckLoggedIn;
  fSecurityContext.Logout;
  CheckFalse(fSecurityContext.IsLoggedIn);

  fSecurityContext.Login(TUser.Create('nick', TCredential.Create('nick', 'nick', ROLE_NORMAL)));
  CheckTrue(fSecurityContext.IsLoggedIn);
  fSecurityContext.CheckLoggedIn;
  fSecurityContext.Logout;
  CheckFalse(fSecurityContext.IsLoggedIn);

  CheckException(LoginInvalidUser, EAuthorizationException);
end;

procedure TTestSecurity4D.TestSecurityAspect;
begin
  if fSecurityContext.IsLoggedIn then
    fSecurityContext.Logout;

  fSecurityContext.Login(TUser.Create('nick', TCredential.Create('nick', 'nick', ROLE_NORMAL)));

  CheckException(CarInsert, EAuthorizationException);
  CheckException(CarUpdate, EAuthorizationException);
  CheckException(CarDelete, EAuthorizationException);
  CarView();

  fSecurityContext.Logout;

  fSecurityContext.Login(TUser.Create('bob', TCredential.Create('bob', 'bob', ROLE_ADMIN)));

  CarInsert();
  CarUpdate();
  CarDelete();
  CarView();
end;

procedure TTestSecurity4D.TestNotLogged;
begin
  if fSecurityContext.IsLoggedIn then
    fSecurityContext.Logout;

  CheckException(CheckLoggedIn, EAuthorizationException);
end;

procedure TTestSecurity4D.TestPermissions;
begin
  if fSecurityContext.IsLoggedIn then
    fSecurityContext.Logout;

  fSecurityContext.Login(TUser.Create('bob', TCredential.Create('bob', 'bob', ROLE_ADMIN)));
  CheckTrue(fSecurityContext.IsLoggedIn);
  fSecurityContext.CheckLoggedIn;
  CheckTrue(fSecurityContext.HasRole(ROLE_ADMIN));
  CheckTrue(fSecurityContext.HasPermission('Car', 'Insert'));
  CheckTrue(fSecurityContext.HasPermission('Car', 'Update'));
  CheckTrue(fSecurityContext.HasPermission('Car', 'Delete'));
  CheckTrue(fSecurityContext.HasPermission('Car', 'View'));
  fSecurityContext.Logout;
  CheckFalse(fSecurityContext.IsLoggedIn);

  fSecurityContext.Login(TUser.Create('jeff', TCredential.Create('jeff', 'jeff', ROLE_MANAGER)));
  CheckTrue(fSecurityContext.IsLoggedIn);
  fSecurityContext.CheckLoggedIn;
  CheckTrue(fSecurityContext.HasRole(ROLE_MANAGER));
  CheckTrue(fSecurityContext.HasPermission('Car', 'Insert'));
  CheckTrue(fSecurityContext.HasPermission('Car', 'Update'));
  CheckTrue(fSecurityContext.HasPermission('Car', 'Delete'));
  CheckTrue(fSecurityContext.HasPermission('Car', 'View'));
  fSecurityContext.Logout;
  CheckFalse(fSecurityContext.IsLoggedIn);

  fSecurityContext.Login(TUser.Create('nick', TCredential.Create('nick', 'nick', ROLE_NORMAL)));
  CheckTrue(fSecurityContext.IsLoggedIn);
  fSecurityContext.CheckLoggedIn;
  CheckTrue(fSecurityContext.HasRole(ROLE_NORMAL));
  CheckFalse(fSecurityContext.HasPermission('Car', 'Insert'));
  CheckFalse(fSecurityContext.HasPermission('Car', 'Update'));
  CheckFalse(fSecurityContext.HasPermission('Car', 'Delete'));
  CheckTrue(fSecurityContext.HasPermission('Car', 'View'));
  fSecurityContext.Logout;
  CheckFalse(fSecurityContext.IsLoggedIn);
end;

initialization

RegisterTest(TTestSecurity4D.Suite);

end.
