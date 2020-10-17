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

unit Authenticator;

interface

uses

  System.SysUtils,
  Security,
  Security.Core,
  Credential;

type

  TAuthenticator = class(TAbstractSecurityProvider, IAuthenticator)
  private
    fAuthenticated: Boolean;
    fAuthenticatedUser: IUser;
  protected
    function GetAuthenticatedUser: IUser;

    procedure Authenticate(user: IUser);
    procedure Unauthenticate;
  public
    procedure AfterConstruction; override;
  end;

implementation

{ TAuthenticator }

procedure TAuthenticator.AfterConstruction;
begin
  inherited AfterConstruction;
  fAuthenticated := False;
  fAuthenticatedUser := nil;
end;

procedure TAuthenticator.Authenticate(user: IUser);
var
  credential: TCredential;
begin
  fAuthenticated := False;
  fAuthenticatedUser := nil;

  if not Assigned(user) then
    raise EAuthenticationException.Create('User not defined in security layer.');

  credential := TCredential(user.Details);

  if (credential.Username.Equals('admin')) and (credential.Password.Equals('1234')) then
    fAuthenticated := True
  else if (credential.Username.Equals('manager')) and (credential.Password.Equals('1234')) then
    fAuthenticated := True
  else if (credential.Username.Equals('guest')) and (credential.Password.Equals('1234')) then
    fAuthenticated := True;

  if not fAuthenticated then
    raise EAuthenticationException.Create('User not authenticated.');

  fAuthenticatedUser := user;
end;

function TAuthenticator.GetAuthenticatedUser: IUser;
begin
  Result := fAuthenticatedUser;
end;

procedure TAuthenticator.Unauthenticate;
begin
  fAuthenticated := False;
  fAuthenticatedUser := nil;
end;

end.
