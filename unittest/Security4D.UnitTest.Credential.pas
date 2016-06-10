unit Security4D.UnitTest.Credential;

interface

uses
  System.SysUtils;

const
  ROLE_ADMIN = 'Admin';
  ROLE_MANAGER = 'Manager';
  ROLE_NORMAL = 'Normal';

type

  TCredential = class
  private
    fUsername: string;
    fPassword: string;
    fRole: string;
  protected
    { protected declarations }
  public
    constructor Create; overload;
    constructor Create(const username, password, role: string); overload;

    property Username: string read fUsername write fUsername;
    property Password: string read fPassword write fPassword;
    property Role: string read fRole write fRole;
  end;

implementation

{ TCredential }

constructor TCredential.Create;
begin
  Create(EmptyStr, EmptyStr, ROLE_NORMAL);
end;

constructor TCredential.Create(const username, password, role: string);
begin
  inherited Create;
  fUsername := username;
  fPassword := password;
  fRole := role;
end;

end.
