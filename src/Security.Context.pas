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

unit Security.Context;

interface

uses

  System.SysUtils,
  Security,
  Security.Core;

type

  TSecurityContext = class(TInterfacedObject, ISecurityContext)
  private
    const
    USER_NOT_AUTHENTICATED = 'User not authenticated.';
  private
    fAuthenticator: IAuthenticator;
    fAuthorizer: IAuthorizer;
    fOnAfterLoginSuccessful: TProc;
    fOnAfterLogoutSuccessful: TProc;
  protected
    function GetAuthenticator: IAuthenticator;
    function GetAuthorizer: IAuthorizer;
    function GetAuthenticatedUser: IUser;

    procedure RegisterAuthenticator(authenticator: IAuthenticator);
    procedure RegisterAuthorizer(authorizer: IAuthorizer);

    procedure OnAfterLoginSuccessful(event: TProc);
    procedure OnAfterLogoutSuccessful(event: TProc);

    procedure Login(user: IUser);
    procedure Logout;

    function IsLoggedIn: Boolean;
    procedure CheckLoggedIn;

    function HasRole(role: string): Boolean;
    function HasAnyRole(roles: array of string): Boolean;

    function HasAuthority(authority: string): Boolean;
    function HasAnyAuthority(authorities: array of string): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TSecurityContext }

procedure TSecurityContext.CheckLoggedIn;
begin
  if not IsLoggedIn then
    raise EAuthenticationException.Create(USER_NOT_AUTHENTICATED);
end;

constructor TSecurityContext.Create;
begin
  inherited Create;
  fAuthenticator := nil;
  fAuthorizer := nil;
  fOnAfterLoginSuccessful := nil;
  fOnAfterLogoutSuccessful := nil;
end;

destructor TSecurityContext.Destroy;
begin
  inherited Destroy;
end;

function TSecurityContext.GetAuthenticatedUser: IUser;
begin
  Result := GetAuthenticator.AuthenticatedUser;
end;

function TSecurityContext.GetAuthenticator: IAuthenticator;
begin
  if not Assigned(fAuthenticator) then
    fAuthenticator := TDefaultAuthenticator.Create;
  Result := fAuthenticator;
end;

function TSecurityContext.GetAuthorizer: IAuthorizer;
begin
  if not Assigned(fAuthorizer) then
    fAuthorizer := TDefaultAuthorizer.Create;
  Result := fAuthorizer;
end;

function TSecurityContext.HasAnyAuthority(authorities: array of string): Boolean;
begin
  CheckLoggedIn;
  try
    Result := GetAuthorizer.HasAnyAuthority(authorities);
  except
    on E: Exception do
      raise EAuthorizationException.Create(E.Message);
  end;
end;

function TSecurityContext.HasAnyRole(roles: array of string): Boolean;
begin
  CheckLoggedIn;
  try
    Result := GetAuthorizer.HasAnyRole(roles);
  except
    on E: Exception do
      raise EAuthorizationException.Create(E.Message);
  end;
end;

function TSecurityContext.HasAuthority(authority: string): Boolean;
begin
  CheckLoggedIn;
  try
    Result := GetAuthorizer.HasAuthority(authority);
  except
    on E: Exception do
      raise EAuthorizationException.Create(E.Message);
  end;
end;

function TSecurityContext.HasRole(role: string): Boolean;
begin
  CheckLoggedIn;
  try
    Result := GetAuthorizer.HasRole(role);
  except
    on E: Exception do
      raise EAuthorizationException.Create(E.Message);
  end;
end;

function TSecurityContext.IsLoggedIn: Boolean;
begin
  Result := Assigned(GetAuthenticatedUser());
end;

procedure TSecurityContext.Login(user: IUser);
begin
  try
    GetAuthenticator.Authenticate(user);
  except
    on E: Exception do
      raise EAuthenticationException.Create(E.Message);
  end;
  if Assigned(fOnAfterLoginSuccessful) then
    fOnAfterLoginSuccessful();
end;

procedure TSecurityContext.Logout;
begin
  try
    GetAuthenticator.Unauthenticate;
  except
    on E: Exception do
      raise EAuthenticationException.Create(E.Message);
  end;
  if Assigned(fOnAfterLogoutSuccessful) then
    fOnAfterLogoutSuccessful();
end;

procedure TSecurityContext.OnAfterLoginSuccessful(event: TProc);
begin
  fOnAfterLoginSuccessful := event;
end;

procedure TSecurityContext.OnAfterLogoutSuccessful(event: TProc);
begin
  fOnAfterLogoutSuccessful := event;
end;

procedure TSecurityContext.RegisterAuthenticator(authenticator: IAuthenticator);
begin
  fAuthenticator := authenticator;
end;

procedure TSecurityContext.RegisterAuthorizer(authorizer: IAuthorizer);
begin
  fAuthorizer := authorizer;
end;

end.
