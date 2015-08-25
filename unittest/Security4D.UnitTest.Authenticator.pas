unit Security4D.UnitTest.Authenticator;

interface

uses
  System.SysUtils,
  Security4D,
  Security4D.UnitTest.Credentials;

type

  TAuthenticator = class(TInterfacedObject, IAuthenticator)
  strict private
    FAuthenticated: Boolean;
    FAuthenticatedUser: IUser;
    function GetAuthenticatedUser(): IUser;
  public
    constructor Create();

    procedure Authenticate(pUser: IUser);
    procedure Unauthenticate();

    property AuthenticatedUser: IUser read GetAuthenticatedUser;
  end;

implementation

{ TAuthenticator }

procedure TAuthenticator.Authenticate(pUser: IUser);
var
  vUsername, vPassword: string;
begin
  FAuthenticated := False;
  FAuthenticatedUser := nil;

  if (pUser = nil) then
    raise EAuthenticationException.Create('User not set to security layer!');

  vUsername := TCredentials(pUser.Attribute).Username;
  vPassword := TCredentials(pUser.Attribute).Password;

  if (vUsername.Equals('bob')) and (vPassword.Equals('bob')) then
    FAuthenticated := True
  else if (vUsername.Equals('jeff')) and (vPassword.Equals('jeff')) then
    FAuthenticated := True
  else if (vUsername.Equals('nick')) and (vPassword.Equals('nick')) then
    FAuthenticated := True;

  if FAuthenticated then
    FAuthenticatedUser := pUser
  else
    raise EAuthenticationException.Create('Unauthenticated user!');
end;

constructor TAuthenticator.Create();
begin
  FAuthenticated := False;
  FAuthenticatedUser := nil;
end;

function TAuthenticator.GetAuthenticatedUser: IUser;
begin
  Result := FAuthenticatedUser;
end;

procedure TAuthenticator.Unauthenticate;
begin
  FAuthenticated := False;
  FAuthenticatedUser := nil;
end;

end.
