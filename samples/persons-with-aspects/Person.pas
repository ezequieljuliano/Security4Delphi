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

unit Person;

interface

type

  TPerson = class
  private
    fId: Integer;
    fName: string;
    fAge: Integer;
  protected
    { protected declarations }
  public
    constructor Create; overload;
    constructor Create(id: Integer; name: string; age: Integer); overload;

    property Id: Integer read fId write fId;
    property Name: string read fName write fName;
    property Age: Integer read fAge write fAge;
  end;

implementation

{ TPerson }

constructor TPerson.Create(id: Integer; name: string; age: Integer);
begin
  Create;
  fId := id;
  fName := name;
  fAge := age;
end;

constructor TPerson.Create;
begin
  inherited Create;
end;

end.
