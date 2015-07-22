unit Security4D;

interface

uses
  System.SysUtils,
  System.Generics.Collections;

type

  ESecurityException = class(Exception);
  EAuthenticatorException = class(ESecurityException);
  EAuthorizerException = class(ESecurityException);
  EAuthorizationException = class(ESecurityException);
  EAuthenticationException = class(ESecurityException);

  ISecurity = interface
    ['{A3F4C03B-4693-4B96-BB1C-B9664D720489}']
  end;

  TActivatorDelegate<TInterface: ISecurity> = reference to function: TInterface;

  IAuthenticatedUser = interface(ISecurity)
    ['{27A9EA53-CA1C-48BA-85E3-6C45A8D9C53D}']
    function GetId(): string;
    function GetAttribute(): TObject;

    property Id: string read GetId;
    property Attribute: TObject read GetAttribute;
  end;

  IAuthenticator = interface(ISecurity)
    ['{396B22CF-0C77-4809-8EB1-FAFE5782B50C}']
    function GetAuthenticatedUser(): IAuthenticatedUser;

    procedure Authenticate();
    procedure Unauthenticate();

    property AuthenticatedUser: IAuthenticatedUser read GetAuthenticatedUser;
  end;

  IAuthorizer = interface(ISecurity)
    ['{B117537E-6E56-455B-A448-08D6E62D6F75}']
    function HasRole(const pRole: string): Boolean;
    function HasPermission(const pResource, pOperation: string): Boolean;
  end;

  ISecurityContext = interface(ISecurity)
    ['{66F6C8D2-DF1E-479A-946A-1B6111F182DF}']
    function GetAuthenticatedUser(): IAuthenticatedUser;

    procedure RegisterAuthenticator(pDelegate: TActivatorDelegate<IAuthenticator>);
    procedure RegisterAuthorizer(pDelegate: TActivatorDelegate<IAuthorizer>);

    procedure OnAfterLoginSuccessful(pEvent: TProc);
    procedure OnAfterLogoutSuccessful(pEvent: TProc);

    procedure Login();
    procedure Logout();

    function IsLoggedIn(): Boolean;
    procedure CheckLoggedIn();

    function HasRole(const pRole: string): Boolean;
    function HasPermission(const pResource, pOperation: string): Boolean;

    property AuthenticatedUser: IAuthenticatedUser read GetAuthenticatedUser;
  end;

  Security = class sealed
  strict private
  const
    CanNotBeInstantiatedException = 'This class can not be instantiated!';
  strict private

    {$HINTS OFF}

    constructor Create;

    {$HINTS ON}

  public
    class function Context(): ISecurityContext; static;
    class function NewAuthenticatedUser(const pId: string; pAttribute: TObject): IAuthenticatedUser; static;
  end;

implementation

type

  TSecurity = class(TInterfacedObject, ISecurity);

  TDefaultAuthenticator = class(TSecurity, IAuthenticator)
  strict private
  const
    ClassNotFoundException = 'Security Authenticator not defined!';
  strict private
    function GetAuthenticatedUser(): IAuthenticatedUser;
  public
    procedure Authenticate();
    procedure Unauthenticate();

    property AuthenticatedUser: IAuthenticatedUser read GetAuthenticatedUser;
  end;

  TDefaultAuthorizer = class(TSecurity, IAuthorizer)
  strict private
  const
    ClassNotFoundException = 'Security Authorizer not defined!';
  public
    function HasRole(const pRole: string): Boolean;
    function HasPermission(const pResource, pOperation: string): Boolean;
  end;

  TAuthenticatedUser = class(TSecurity, IAuthenticatedUser)
  strict private
    FId: string;
    FAttribute: TObject;
    function GetId(): string;
    function GetAttribute(): TObject;
  public
    constructor Create(const pId: string; pAttribute: TObject);

    property Id: string read GetId;
    property Attribute: TObject read GetAttribute;
  end;

  TSecurityContext = class(TSecurity, ISecurityContext)
  strict private
  const
    NotLoggedInException = 'User not authenticated!';
  strict private
  type
    TRegistration<T: ISecurity> = class
    strict private
      FDelegate: TActivatorDelegate<T>;
      FInstance: T;
    public
      property Delegate: TActivatorDelegate<T> read FDelegate write FDelegate;
      property Instance: T read FInstance write FInstance;
    end;
  strict private
    FAuthenticator: TRegistration<IAuthenticator>;
    FAuthorizer: TRegistration<IAuthorizer>;

    FOnAfterLoginSuccessful: TProc;
    FOnAfterLogoutSuccessful: TProc;

    function GetAuthenticator(): IAuthenticator;
    function GetAuthorizer(): IAuthorizer;
    function GetAuthenticatedUser(): IAuthenticatedUser;
  public
    constructor Create();
    destructor Destroy; override;

    procedure RegisterAuthenticator(pDelegate: TActivatorDelegate<IAuthenticator>);
    procedure RegisterAuthorizer(pDelegate: TActivatorDelegate<IAuthorizer>);

    procedure OnAfterLoginSuccessful(pEvent: TProc);
    procedure OnAfterLogoutSuccessful(pEvent: TProc);

    procedure Login();
    procedure Logout();

    function IsLoggedIn(): Boolean;
    procedure CheckLoggedIn();

    function HasRole(const pRole: string): Boolean;
    function HasPermission(const pResource, pOperation: string): Boolean;

    property AuthenticatedUser: IAuthenticatedUser read GetAuthenticatedUser;
  end;

  TSingletonSecurityContext = class sealed
  strict private
    class var Instance: ISecurityContext;
    class constructor Create;
    class destructor Destroy;
  public
    class function GetInstance: ISecurityContext; static;
  end;

  { TDefaultAuthenticator }

procedure TDefaultAuthenticator.Authenticate;
begin
  raise EAuthenticatorException.Create(ClassNotFoundException);
end;

function TDefaultAuthenticator.GetAuthenticatedUser: IAuthenticatedUser;
begin
  raise EAuthenticatorException.Create(ClassNotFoundException);
end;

procedure TDefaultAuthenticator.Unauthenticate;
begin
  raise EAuthenticatorException.Create(ClassNotFoundException);
end;

{ TDefaultAuthorizer }

function TDefaultAuthorizer.HasPermission(const pResource, pOperation: string): Boolean;
begin
  raise EAuthorizerException.Create(ClassNotFoundException);
end;

function TDefaultAuthorizer.HasRole(const pRole: string): Boolean;
begin
  raise EAuthorizerException.Create(ClassNotFoundException);
end;

{ TAuthenticatedUser }

constructor TAuthenticatedUser.Create(const pId: string; pAttribute: TObject);
begin
  FId := pId;
  FAttribute := pAttribute;
end;

function TAuthenticatedUser.GetAttribute: TObject;
begin
  Result := FAttribute;
end;

function TAuthenticatedUser.GetId: string;
begin
  Result := FId;
end;

{ TSecurityContext }

procedure TSecurityContext.CheckLoggedIn;
begin
  if not IsLoggedIn then
    raise EAuthorizationException.Create(NotLoggedInException);
end;

constructor TSecurityContext.Create;
begin
  FAuthenticator := TRegistration<IAuthenticator>.Create();
  FAuthorizer := TRegistration<IAuthorizer>.Create();
  FOnAfterLoginSuccessful := nil;
  FOnAfterLogoutSuccessful := nil;
end;

destructor TSecurityContext.Destroy;
begin
  FreeAndNil(FAuthenticator);
  FreeAndNil(FAuthorizer);
  inherited;
end;

function TSecurityContext.GetAuthenticator: IAuthenticator;
begin
  if (FAuthenticator.Instance = nil) then
  begin
    if Assigned(FAuthenticator.Delegate()) then
      FAuthenticator.Instance := FAuthenticator.Delegate();

    if (FAuthenticator.Instance = nil) then
      FAuthenticator.Instance := TDefaultAuthenticator.Create();
  end;
  Result := FAuthenticator.Instance;
end;

function TSecurityContext.GetAuthorizer: IAuthorizer;
begin
  if (FAuthorizer.Instance = nil) then
  begin
    if Assigned(FAuthorizer.Delegate()) then
      FAuthorizer.Instance := FAuthorizer.Delegate();

    if (FAuthorizer.Instance = nil) then
      FAuthorizer.Instance := TDefaultAuthorizer.Create();
  end;
  Result := FAuthorizer.Instance;
end;

function TSecurityContext.GetAuthenticatedUser: IAuthenticatedUser;
begin
  Result := GetAuthenticator.AuthenticatedUser;
end;

function TSecurityContext.HasPermission(const pResource, pOperation: string): Boolean;
begin
  CheckLoggedIn();
  try
    Result := GetAuthorizer().HasPermission(pResource, pOperation);
  except
    on E: Exception do
      raise EAuthorizationException.Create(E.Message);
  end;
end;

function TSecurityContext.HasRole(const pRole: string): Boolean;
begin
  CheckLoggedIn();
  try
    Result := GetAuthorizer().HasRole(pRole);
  except
    on E: Exception do
      raise EAuthorizationException.Create(E.Message);
  end;
end;

function TSecurityContext.IsLoggedIn: Boolean;
begin
  Result := (GetAuthenticatedUser <> nil);
end;

procedure TSecurityContext.Login;
begin
  try
    GetAuthenticator().Authenticate();
  except
    on E: Exception do
      raise EAuthorizationException.Create(E.Message);
  end;
  if Assigned(FOnAfterLoginSuccessful) then
    FOnAfterLoginSuccessful();
end;

procedure TSecurityContext.Logout;
begin
  try
    GetAuthenticator().Unauthenticate();
  except
    on E: Exception do
      raise EAuthorizationException.Create(E.Message);
  end;
  if Assigned(FOnAfterLogoutSuccessful) then
    FOnAfterLogoutSuccessful();
end;

procedure TSecurityContext.OnAfterLoginSuccessful(pEvent: TProc);
begin
  FOnAfterLoginSuccessful := pEvent;
end;

procedure TSecurityContext.OnAfterLogoutSuccessful(pEvent: TProc);
begin
  FOnAfterLogoutSuccessful := pEvent;
end;

procedure TSecurityContext.RegisterAuthenticator(
  pDelegate: TActivatorDelegate<IAuthenticator>);
begin
  FAuthenticator.Delegate := pDelegate;
end;

procedure TSecurityContext.RegisterAuthorizer(pDelegate: TActivatorDelegate<IAuthorizer>);
begin
  FAuthorizer.Delegate := pDelegate;
end;

{ TSingletonSecurityContext }

class constructor TSingletonSecurityContext.Create;
begin
  Instance := TSecurityContext.Create;
end;

class destructor TSingletonSecurityContext.Destroy;
begin
  Instance := nil;
end;

class function TSingletonSecurityContext.GetInstance: ISecurityContext;
begin
  Result := Instance;
end;

{ Security }

class function Security.Context: ISecurityContext;
begin
  Result := TSingletonSecurityContext.GetInstance;
end;

constructor Security.Create;
begin
  raise ESecurityException.Create(CanNotBeInstantiatedException);
end;

class function Security.NewAuthenticatedUser(const pId: string; pAttribute: TObject): IAuthenticatedUser;
begin
  Result := TAuthenticatedUser.Create(pId, pAttribute);
end;

end.
