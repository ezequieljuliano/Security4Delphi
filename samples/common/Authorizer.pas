unit Authorizer;

interface

uses

  System.SysUtils,
  Security,
  Security.Core,
  Credential;

type

  TAuthorizer = class(TAbstractSecurityProvider, IAuthorizer)
  private
    { private declarations }
  protected
    function HasRole(role: string): Boolean;
    function HasAnyRole(roles: array of string): Boolean;

    function HasAuthority(authority: string): Boolean;
    function HasAnyAuthority(authorities: array of string): Boolean;
  public
    { public declarations }
  end;

implementation

{ TAuthorizer }

function TAuthorizer.HasAnyAuthority(authorities: array of string): Boolean;
var
  i: Integer;
  credential: TCredential;
begin
  Result := False;

  if HasRole(ROLE_ADMIN) then
    Exit(True);

  credential := TCredential(GetContext.AuthenticatedUser.Details);
  for i := Low(authorities) to High(authorities) do
  begin
    if (credential.Role.Equals(ROLE_MANAGER)) then
    begin
      if authorities[I].Equals('PERSON_INSERT') then
        Exit(True)
      else if authorities[I].Equals('PERSON_UPDATE') then
        Exit(True)
      else if authorities[I].Equals('PERSON_DELETE') then
        Exit(True)
      else if authorities[I].Equals('PERSON_VIEW') then
        Exit(True);
    end
    else if (credential.Role.Equals(ROLE_GUEST)) then
    begin
      if authorities[I].Equals('PERSON_VIEW') then
        Exit(True);
    end;
  end;
end;

function TAuthorizer.HasAnyRole(roles: array of string): Boolean;
var
  i: Integer;
  credential: TCredential;
begin
  Result := False;

  if not GetContext.IsLoggedIn then
    raise EAuthenticationException.Create('User not authenticated.');

  credential := TCredential(GetContext.AuthenticatedUser.Details);
  for i := Low(roles) to High(roles) do
    if credential.Role.Equals(roles[I]) then
      Exit(True);
end;

function TAuthorizer.HasAuthority(authority: string): Boolean;
begin
  Result := HasAnyAuthority([authority]);
end;

function TAuthorizer.HasRole(role: string): Boolean;
begin
  Result := HasAnyRole([role]);
end;

end.
