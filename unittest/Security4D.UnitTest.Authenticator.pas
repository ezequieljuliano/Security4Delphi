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
    FAuthenticatedUser: IAuthenticatedUser;
    FCredentials: TCredentials;
    function GetAuthenticatedUser(): IAuthenticatedUser;
  public
    constructor Create(pCredentials: TCredentials);

    procedure Authenticate();
    procedure Unauthenticate();

    property AuthenticatedUser: IAuthenticatedUser read GetAuthenticatedUser;
  end;

implementation

{ TAuthenticator }

procedure TAuthenticator.Authenticate;
var
  vUsername, vPassword: string;
begin
  vUsername := FCredentials.Username;
  vPassword := FCredentials.Password;

  if (vUsername.Equals('bob')) and (vPassword.Equals('bob')) then
    FAuthenticated := True
  else if (vUsername.Equals('jeff')) and (vPassword.Equals('jeff')) then
    FAuthenticated := True
  else if (vUsername.Equals('nick')) and (vPassword.Equals('nick')) then
    FAuthenticated := True
  else
    FAuthenticated := False;

  if not FAuthenticated then
    raise EAuthenticationException.Create('Unauthenticated user!');
end;

constructor TAuthenticator.Create(pCredentials: TCredentials);
begin
  FAuthenticated := False;
  FAuthenticatedUser := nil;
  FCredentials := pCredentials;
end;

function TAuthenticator.GetAuthenticatedUser: IAuthenticatedUser;
begin
  if FAuthenticated then
  begin
    if (FAuthenticatedUser = nil) then
      FAuthenticatedUser := Security.NewAuthenticatedUser(FCredentials.Username, FCredentials);
    Result := FAuthenticatedUser;
  end
  else
    Result := nil;
end;

procedure TAuthenticator.Unauthenticate;
begin
  FCredentials.Clear;
  FAuthenticated := False;
end;

end.
