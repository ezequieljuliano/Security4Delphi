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

unit Credential;

interface

uses

  System.SysUtils;

type

  TCredential = class
  private
    fUsername: string;
    fPassword: string;
    fRole: string;
  protected
    { protected declarations }
  public
    constructor Create; overload;
    constructor Create(username, password, role: string); overload;

    property Username: string read fUsername write fUsername;
    property Password: string read fPassword write fPassword;
    property Role: string read fRole write fRole;
  end;

const

  ROLE_GUEST = 'GUEST';
  ROLE_MANAGER = 'MANAGER';
  ROLE_ADMIN = 'ADMIN';

implementation

{ TCredential }

constructor TCredential.Create(username, password, role: string);
begin
  inherited Create;
  fUsername := username;
  fPassword := password;
  fRole := role;
end;

constructor TCredential.Create;
begin
  Create(EmptyStr, EmptyStr, ROLE_GUEST);
end;

end.
