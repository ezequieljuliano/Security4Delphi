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

unit Security.Aspect;

interface

uses

  System.SysUtils,
  System.Rtti,
  Aspect,
  Aspect.Core,
  Security,
  Security.Core;

type

  RequiredRoleAttribute = class(AspectAttribute)
  private
    fRole: string;
  protected
    { protected declarations }
  public
    constructor Create(role: string);
    property Role: string read fRole;
  end;

  RequiredAnyRoleAttribute = class(AspectAttribute)
  private
    fRoles: string;
  protected
    { protected declarations }
  public
    constructor Create(roles: string);
    property Roles: string read fRoles;
  end;

  RequiredAuthorityAttribute = class(AspectAttribute)
  private
    fAuthority: string;
  protected
    { protected declarations }
  public
    constructor Create(authority: string);
    property Authority: string read fAuthority;
  end;

  RequiredAnyAuthorityAttribute = class(AspectAttribute)
  private
    fAuthorities: string;
  protected
    { protected declarations }
  public
    constructor Create(authorities: string);
    property Authorities: string read fAuthorities;
  end;

  TSecurityAspect = class(TAspectObject, IAspect)
  private
    const
    HAS_NO_AUTHORITY = 'You do not have permission to access this feature.';
    HAS_NO_ROLE = 'You do not have role to access this feature.';
  private
    fContext: ISecurityContext;
  protected
    procedure OnBefore(
      instance: TObject;
      method: TRttiMethod;
      const args: TArray<TValue>;
      out invoke: Boolean;
      out result: TValue
      ); override;
  public
    constructor Create(context: ISecurityContext);
  end;

implementation

{ RequiredAuthorityAttribute }

constructor RequiredAuthorityAttribute.Create(authority: string);
begin
  inherited Create;
  fAuthority := authority;
end;

{ RequiredAnyAuthorityAttribute }

constructor RequiredAnyAuthorityAttribute.Create(authorities: string);
begin
  inherited Create;
  fAuthorities := authorities;
end;

{ RequiredRoleAttribute }

constructor RequiredRoleAttribute.Create(role: string);
begin
  inherited Create;
  fRole := role;
end;

{ RequiredAnyRoleAttribute }

constructor RequiredAnyRoleAttribute.Create(roles: string);
begin
  inherited Create;
  fRoles := roles;
end;

{ TSecurityAspect }

constructor TSecurityAspect.Create(context: ISecurityContext);
begin
  inherited Create;
  fContext := context;
end;

procedure TSecurityAspect.OnBefore(instance: TObject;
  method: TRttiMethod;
  const args: TArray<TValue>;
  out invoke: Boolean;
  out result: TValue);
var
  attribute: TCustomAttribute;
  hasAuthority: Boolean;
  hasRole: Boolean;
  values: TArray<string>;
begin
  hasAuthority := True;
  for attribute in method.GetAttributes do
    if attribute is RequiredAuthorityAttribute then
    begin
      hasAuthority := fContext.HasAuthority(RequiredAuthorityAttribute(attribute).Authority);
      if hasAuthority then
        Break;
    end
    else if attribute is RequiredAnyAuthorityAttribute then
    begin
      values := RequiredAnyAuthorityAttribute(attribute).Authorities.Split([',']);
      hasAuthority := fContext.HasAnyAuthority(values);
      if hasAuthority then
        Break;
    end;

  hasRole := True;
  for attribute in method.GetAttributes do
    if attribute is RequiredRoleAttribute then
    begin
      hasRole := fContext.HasRole(RequiredRoleAttribute(attribute).Role);
      if hasRole then
        Break;
    end
    else if attribute is RequiredAnyRoleAttribute then
    begin
      values := RequiredAnyRoleAttribute(attribute).Roles.Split([',']);
      hasRole := fContext.HasAnyRole(values);
      if hasRole then
        Break;
    end;

  if not hasAuthority then
    raise EAuthorizationException.Create(HAS_NO_AUTHORITY);

  if not hasRole then
    raise EAuthorizationException.Create(HAS_NO_ROLE);
end;

end.
