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

unit Security.Test;

interface

uses

  Security,
  Security.Core,
  Security.Context,
  Security.User,
  Authenticator,
  Authorizer,
  Credential,
  TestFramework,
  System.Rtti,
  System.SysUtils,
  System.Classes;

type

  TTestSecurity = class(TTestCase)
  private
    fSecurityContext: ISecurityContext;
    procedure LoginInvalidUser;
    procedure CheckLoggedIn;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestAuthentication;
    procedure TestAuthorization;
    procedure TestNotLogged;
    procedure TestAfterLoginSuccessful;
    procedure TestAfterLogoutSuccessful;
  end;

implementation

{ TTestSecurity }

procedure TTestSecurity.CheckLoggedIn;
begin
  fSecurityContext.CheckLoggedIn;
end;

procedure TTestSecurity.LoginInvalidUser;
begin
  if fSecurityContext.IsLoggedIn then
    fSecurityContext.Logout;
  fSecurityContext.Login(TUser.Create('9999', TCredential.Create('user', '9999', ROLE_ADMIN)));
end;

procedure TTestSecurity.SetUp;
begin
  inherited;
  fSecurityContext := TSecurityContext.Create;
  fSecurityContext.RegisterAuthenticator(TAuthenticator.Create(fSecurityContext));
  fSecurityContext.RegisterAuthorizer(TAuthorizer.Create(fSecurityContext));
end;

procedure TTestSecurity.TearDown;
begin
  inherited;
end;

procedure TTestSecurity.TestAfterLoginSuccessful;
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

  fSecurityContext.Login(TUser.Create('U001', TCredential.Create('bob', '1234', ROLE_ADMIN)));

  CheckEquals('Login Successful', msg);

  fSecurityContext.Logout;
  fSecurityContext.OnAfterLoginSuccessful(nil);
end;

procedure TTestSecurity.TestAfterLogoutSuccessful;
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

  fSecurityContext.Login(TUser.Create('U001', TCredential.Create('bob', '1234', ROLE_ADMIN)));

  fSecurityContext.Logout;

  CheckEquals('Logout Successful', msg);

  fSecurityContext.OnAfterLoginSuccessful(nil);
end;

procedure TTestSecurity.TestAuthentication;
begin
  if fSecurityContext.IsLoggedIn then
    fSecurityContext.Logout;

  fSecurityContext.Login(TUser.Create('U001', TCredential.Create('bob', '1234', ROLE_ADMIN)));
  CheckTrue(fSecurityContext.IsLoggedIn);
  fSecurityContext.CheckLoggedIn;
  fSecurityContext.Logout;
  CheckFalse(fSecurityContext.IsLoggedIn);

  fSecurityContext.Login(TUser.Create('U002', TCredential.Create('jeff', '1234', ROLE_MANAGER)));
  CheckTrue(fSecurityContext.IsLoggedIn);
  fSecurityContext.CheckLoggedIn;
  fSecurityContext.Logout;
  CheckFalse(fSecurityContext.IsLoggedIn);

  fSecurityContext.Login(TUser.Create('U003', TCredential.Create('nick', '1234', ROLE_GUEST)));
  CheckTrue(fSecurityContext.IsLoggedIn);
  fSecurityContext.CheckLoggedIn;
  fSecurityContext.Logout;
  CheckFalse(fSecurityContext.IsLoggedIn);

  CheckException(LoginInvalidUser, EAuthenticationException);
end;

procedure TTestSecurity.TestAuthorization;
begin
  if fSecurityContext.IsLoggedIn then
    fSecurityContext.Logout;

  fSecurityContext.Login(TUser.Create('U001', TCredential.Create('bob', '1234', ROLE_ADMIN)));
  CheckTrue(fSecurityContext.IsLoggedIn);
  fSecurityContext.CheckLoggedIn;
  CheckTrue(fSecurityContext.HasRole(ROLE_ADMIN));
  CheckTrue(fSecurityContext.HasAnyRole([ROLE_ADMIN, ROLE_MANAGER, ROLE_GUEST]));
  CheckTrue(fSecurityContext.HasAuthority('CAR_INSERT'));
  CheckTrue(fSecurityContext.HasAuthority('CAR_UPDATE'));
  CheckTrue(fSecurityContext.HasAuthority('CAR_DELETE'));
  CheckTrue(fSecurityContext.HasAuthority('CAR_VIEW'));
  fSecurityContext.Logout;
  CheckFalse(fSecurityContext.IsLoggedIn);

  fSecurityContext.Login(TUser.Create('U002', TCredential.Create('jeff', '1234', ROLE_MANAGER)));
  CheckTrue(fSecurityContext.IsLoggedIn);
  fSecurityContext.CheckLoggedIn;
  CheckTrue(fSecurityContext.HasRole(ROLE_MANAGER));
  CheckTrue(fSecurityContext.HasAnyRole([ROLE_ADMIN, ROLE_MANAGER, ROLE_GUEST]));
  CheckFalse(fSecurityContext.HasAnyRole([ROLE_ADMIN]));
  CheckTrue(fSecurityContext.HasAuthority('CAR_INSERT'));
  CheckTrue(fSecurityContext.HasAuthority('CAR_UPDATE'));
  CheckTrue(fSecurityContext.HasAuthority('CAR_DELETE'));
  CheckTrue(fSecurityContext.HasAuthority('CAR_VIEW'));
  fSecurityContext.Logout;
  CheckFalse(fSecurityContext.IsLoggedIn);

  fSecurityContext.Login(TUser.Create('U003', TCredential.Create('nick', '1234', ROLE_GUEST)));
  CheckTrue(fSecurityContext.IsLoggedIn);
  fSecurityContext.CheckLoggedIn;
  CheckTrue(fSecurityContext.HasRole(ROLE_GUEST));
  CheckTrue(fSecurityContext.HasAnyRole([ROLE_ADMIN, ROLE_MANAGER, ROLE_GUEST]));
  CheckFalse(fSecurityContext.HasAnyRole([ROLE_ADMIN, ROLE_MANAGER]));
  CheckFalse(fSecurityContext.HasAuthority('CAR_INSERT'));
  CheckFalse(fSecurityContext.HasAuthority('CAR_UPDATE'));
  CheckFalse(fSecurityContext.HasAuthority('CAR_DELETE'));
  CheckTrue(fSecurityContext.HasAuthority('CAR_VIEW'));
  fSecurityContext.Logout;
  CheckFalse(fSecurityContext.IsLoggedIn);
end;

procedure TTestSecurity.TestNotLogged;
begin
  if fSecurityContext.IsLoggedIn then
    fSecurityContext.Logout;
  CheckException(CheckLoggedIn, EAuthenticationException);
end;

initialization

RegisterTest(TTestSecurity.Suite);

end.
