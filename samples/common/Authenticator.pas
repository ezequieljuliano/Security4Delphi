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
