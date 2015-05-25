unit Security4D.UnitTest.Credentials;

interface

uses
  System.SysUtils;

const
  ROLE_ADMIN = 'Admin';
  ROLE_MANAGER = 'Manager';
  ROLE_NORMAL = 'Normal';

type

  TCredentials = class
  strict private
    FUsername: string;
    FPassword: string;
    FRole: string;
  public
    procedure Clear();

    property Username: string read FUsername write FUsername;
    property Password: string read FPassword write FPassword;
    property Role: string read FRole write FRole;
  end;

function Credentials(): TCredentials;

implementation

type

  TSingletonCredentials = class sealed
  strict private
    class var Instance: TCredentials;
    class constructor Create;
    class destructor Destroy;
  public
    class function GetInstance: TCredentials; static;
  end;

function Credentials(): TCredentials;
begin
  Result := TSingletonCredentials.GetInstance;
end;

{ TCredentials }

procedure TCredentials.Clear;
begin
  FUsername := EmptyStr;
  FPassword := EmptyStr;
  FRole := EmptyStr;
end;

{ TSingletonCredentials }

class constructor TSingletonCredentials.Create;
begin
  Instance := TCredentials.Create;
end;

class destructor TSingletonCredentials.Destroy;
begin
  FreeAndNil(Instance);
end;

class function TSingletonCredentials.GetInstance: TCredentials;
begin
  Result := Instance;
end;

end.
