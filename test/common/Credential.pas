unit Credential;

interface

uses

  System.SysUtils;

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
    constructor Create(username, password, role: string); overload;

    property Username: string read fUsername write fUsername;
    property Password: string read fPassword write fPassword;
    property Role: string read fRole write fRole;
  end;

const

  ROLE_GUEST = 'GUEST';
  ROLE_MANAGER = 'MANAGER';
  ROLE_ADMIN = 'ADMIN';

implementation

{ TCredential }

constructor TCredential.Create(username, password, role: string);
begin
  inherited Create;
  fUsername := username;
  fPassword := password;
  fRole := role;
end;

constructor TCredential.Create;
begin
  Create(EmptyStr, EmptyStr, ROLE_GUEST);
end;

end.
