unit Security4D.UnitTest.Authenticator;

interface

uses
  System.SysUtils,
  Security4D,
  Security4D.Impl,
  Security4D.UnitTest.Credential;

type

  TAuthenticator = class(TSecurityProvider, IAuthenticator)
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
  inherited;
  fAuthenticated := False;
  fAuthenticatedUser := nil;
end;

procedure TAuthenticator.Authenticate(user: IUser);
var
  username, password: string;
begin
  fAuthenticated := False;
  fAuthenticatedUser := nil;

  if not Assigned(user) then
    raise EAuthenticationException.Create('User not set to security layer.');

  username := TCredential(user.Attribute).Username;
  password := TCredential(user.Attribute).Password;

  if (username.Equals('bob')) and (password.Equals('bob')) then
    fAuthenticated := True
  else if (username.Equals('jeff')) and (password.Equals('jeff')) then
    fAuthenticated := True
  else if (username.Equals('nick')) and (password.Equals('nick')) then
    fAuthenticated := True;

  if fAuthenticated then
    fAuthenticatedUser := user
  else
    raise EAuthenticationException.Create('Unauthenticated user.');
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
