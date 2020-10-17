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

unit App.Context;

interface

uses

  Security,
  Security.Context,
  Security.Aspect,
  Authenticator,
  Authorizer,
  Aspect,
  Aspect.Context;

function SecurityContext: ISecurityContext;
function AspectContext: IAspectContext;

implementation

var

  SecurityContextInstance: ISecurityContext = nil;
  AspectContextInstance: IAspectContext = nil;

function AspectContext: IAspectContext;
begin
  if (AspectContextInstance = nil) then
  begin
    AspectContextInstance := TAspectContext.Create;
    AspectContextInstance.RegisterAspect(TSecurityAspect.Create(SecurityContext));
  end;
  Result := AspectContextInstance;
end;

function SecurityContext: ISecurityContext;
begin
  if (SecurityContextInstance = nil) then
  begin
    SecurityContextInstance := TSecurityContext.Create;
    SecurityContextInstance.RegisterAuthenticator(TAuthenticator.Create(SecurityContextInstance));
    SecurityContextInstance.RegisterAuthorizer(TAuthorizer.Create(SecurityContextInstance));
  end;
  Result := SecurityContextInstance;
end;

end.
