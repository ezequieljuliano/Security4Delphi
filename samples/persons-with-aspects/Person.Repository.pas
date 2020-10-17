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

unit Person.Repository;

interface

uses

  Person,
  Security.Aspect,
  App.Context;

type

  TPersonRepository = class
  private
    { private declarations }
  protected
    { protected declarations }
  public
    constructor Create;
    destructor Destroy; override;

    [RequiredRole('ROLE_ADMIN')]
    [RequiredAuthority('PERSON_INSERT')]
    function Insert(person: TPerson): TPerson; virtual;

    [RequiredAnyRole('ROLE_ADMIN,ROLE_MANAGER')]
    [RequiredAuthority('PERSON_UPDATE')]
    function Update(person: TPerson): TPerson; virtual;

    [RequiredAnyRole('ROLE_ADMIN,ROLE_MANAGER')]
    [RequiredAuthority('PERSON_DELETE')]
    function Delete(personId: Integer): Boolean; virtual;

    [RequiredAnyRole('ROLE_ADMIN,ROLE_MANAGER,ROLE_GUEST')]
    [RequiredAuthority('PERSON_VIEW')]
    function FindById(personId: Integer): TPerson; virtual;
  end;

implementation

{ TPersonRepository }

constructor TPersonRepository.Create;
begin
  inherited Create;
  AspectContext.Weaver.Proxify(Self);
end;

function TPersonRepository.Delete(personId: Integer): Boolean;
begin
  Result := True;
end;

destructor TPersonRepository.Destroy;
begin
  AspectContext.Weaver.Unproxify(Self);
  inherited Destroy;
end;

function TPersonRepository.FindById(personId: Integer): TPerson;
begin
  Result := TPerson.Create(personId, 'Ezequiel', 31);
end;

function TPersonRepository.Insert(person: TPerson): TPerson;
begin
  person.Id := Random(1000);
  Result := person;
end;

function TPersonRepository.Update(person: TPerson): TPerson;
begin
  Result := person;
end;

end.
