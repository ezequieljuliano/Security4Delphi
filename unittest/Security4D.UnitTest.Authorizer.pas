unit Security4D.UnitTest.Authorizer;

interface

uses
  Security4D,
  Security4D.Impl,
  Security4D.UnitTest.Credential,
  System.SysUtils;

type

  TAuthorizer = class(TSecurityProvider, IAuthorizer)
  private
    { private declarations }
  protected
    function HasRole(const role: string): Boolean;
    function HasPermission(const resource, operation: string): Boolean;
  public
    { public declarations }
  end;

implementation

{ TAuthorizer }

function TAuthorizer.HasPermission(const resource, operation: string): Boolean;
var
  credential: TCredential;
begin
  Result := False;
  if HasRole(ROLE_ADMIN) then
    Result := True
  else
  begin
    credential := (SecurityContext.AuthenticatedUser.Attribute as TCredential);
    if (credential.Role.Equals(ROLE_MANAGER)) and (resource.Equals('Car')) and (operation.Equals('Insert')) then
      Result := True;
    if (credential.Role.Equals(ROLE_MANAGER)) and (resource.Equals('Car')) and (operation.Equals('Update')) then
      Result := True;
    if (credential.Role.Equals(ROLE_MANAGER)) and (resource.Equals('Car')) and (operation.Equals('Delete')) then
      Result := True;
    if (credential.Role.Equals(ROLE_MANAGER)) and (resource.Equals('Car')) and (operation.Equals('View')) then
      Result := True;
    if (credential.Role.Equals(ROLE_NORMAL)) and (resource.Equals('Car')) and (operation.Equals('View')) then
      Result := True;
  end;
end;

function TAuthorizer.HasRole(const role: string): Boolean;
begin
  if not SecurityContext.IsLoggedIn then
    raise EAuthenticationException.Create('Unauthenticated user.');
  Result := (SecurityContext.AuthenticatedUser.Attribute as TCredential).Role.Equals(role);
end;

end.
