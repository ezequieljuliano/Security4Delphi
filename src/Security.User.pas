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

unit Security.User;

interface

uses

  Security;

type

  TUser = class(TInterfacedObject, IUser)
  private
    fId: string;
    fDetails: TObject;
    fOwns: Boolean;
  protected
    function GetId: string;
    function GetDetails: TObject;
  public
    constructor Create(id: string; details: TObject; owns: Boolean = True);
    destructor Destroy; override;
  end;

implementation

{ TUser }

constructor TUser.Create(id: string; details: TObject; owns: Boolean);
begin
  inherited Create;
  fId := id;
  fDetails := details;
  fOwns := owns;
end;

destructor TUser.Destroy;
begin
  if fOwns and Assigned(fDetails) then
    fDetails.Free;
  inherited Destroy;
end;

function TUser.GetDetails: TObject;
begin
  Result := fDetails;
end;

function TUser.GetId: string;
begin
  Result := fId;
end;

end.
