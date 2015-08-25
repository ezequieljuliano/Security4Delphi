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
    constructor Create; overload;
    constructor Create(const pUsername, pPassword, pRole: string); overload;

    property Username: string read FUsername write FUsername;
    property Password: string read FPassword write FPassword;
    property Role: string read FRole write FRole;
  end;

implementation

{ TCredentials }

constructor TCredentials.Create;
begin
  FUsername := EmptyStr;
  FPassword := EmptyStr;
  FRole := EmptyStr;
end;

constructor TCredentials.Create(const pUsername, pPassword, pRole: string);
begin
  FUsername := pUsername;
  FPassword := pPassword;
  FRole := pRole;
end;

end.
