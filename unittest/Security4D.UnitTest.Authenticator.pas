unit Security4D.UnitTest.Authenticator;

interface

uses
  Security4D,
  Security4D.UnitTest.Credentials,
  System.SysUtils;

type

  TAuthenticator = class(TInterfacedObject, IAuthenticator)
  strict private
    FAuthenticated: Boolean;
    FUser: IUser;
    FCredentials: TCredentials;
  public
    constructor Create(pCredentials: TCredentials);

    function GetUser(): IUser;

    procedure Authenticate();
    procedure Unauthenticate();

    property User: IUser read GetUser;
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
  FUser := nil;
  FCredentials := pCredentials;
end;

function TAuthenticator.GetUser: IUser;
begin
  if FAuthenticated then
  begin
    if (FUser = nil) then
      FUser := Security.User(FCredentials.Username, FCredentials);
    Result := FUser;
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
