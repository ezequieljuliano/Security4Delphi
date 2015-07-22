unit Security4D.UnitTest.Authorizer;

interface

uses
  Security4D,
  Security4D.UnitTest.Credentials,
  System.SysUtils;

type

  TAuthorizer = class(TInterfacedObject, IAuthorizer)
  public
    function HasRole(const pRole: string): Boolean;
    function HasPermission(const pResource, pOperation: string): Boolean;
  end;

implementation

{ TAuthorizer }

function TAuthorizer.HasPermission(const pResource, pOperation: string): Boolean;
var
  vCredentials: TCredentials;
begin
  Result := False;

  if not Security.Context.IsLoggedIn then
    raise EAuthenticationException.Create('Unauthenticated user!');

  if Security.Context.HasRole(ROLE_ADMIN) then
    Result := True
  else
  begin
    vCredentials := (Security.Context.AuthenticatedUser.Attribute as TCredentials);
    if (vCredentials.Role.Equals(ROLE_MANAGER)) and (pResource.Equals('Car')) and (pOperation.Equals('Insert')) then
      Result := True;
    if (vCredentials.Role.Equals(ROLE_MANAGER)) and (pResource.Equals('Car')) and (pOperation.Equals('Update')) then
      Result := True;
    if (vCredentials.Role.Equals(ROLE_MANAGER)) and (pResource.Equals('Car')) and (pOperation.Equals('Delete')) then
      Result := True;
    if (vCredentials.Role.Equals(ROLE_MANAGER)) and (pResource.Equals('Car')) and (pOperation.Equals('View')) then
      Result := True;
    if (vCredentials.Role.Equals(ROLE_NORMAL)) and (pResource.Equals('Car')) and (pOperation.Equals('View')) then
      Result := True;
  end;
end;

function TAuthorizer.HasRole(const pRole: string): Boolean;
begin
  if not Security.Context.IsLoggedIn then
    raise EAuthenticationException.Create('Unauthenticated user!');

  Result := (Security.Context.AuthenticatedUser.Attribute as TCredentials).Role.Equals(pRole);
end;

end.
