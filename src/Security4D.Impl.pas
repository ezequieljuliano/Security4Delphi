unit Security4D.Impl;

interface

uses
  System.SysUtils,
  Security4D;

type

  TSecurity = class(TInterfacedObject, ISecurity)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

  TSecurityProvider = class abstract(TSecurity)
  private
    fSecurityContext: Pointer;
  protected
    function SecurityContext: ISecurityContext;
  public
    constructor Create(securityContext: ISecurityContext);
  end;

  TDefaultAuthenticator = class(TSecurity, IAuthenticator)
  private
    const
    CLASS_NOT_FOUND = 'Security Authenticator not defined.';
  protected
    function GetAuthenticatedUser: IUser;

    procedure Authenticate(user: IUser);
    procedure Unauthenticate;
  public
    { public declarations }
  end;

  TDefaultAuthorizer = class(TSecurity, IAuthorizer)
  private
    const
    CLASS_NOT_FOUND = 'Security Authorizer not defined.';
  protected
    function HasRole(const role: string): Boolean;
    function HasPermission(const resource, operation: string): Boolean;
  public
    { public declarations }
  end;

  TUser = class(TSecurity, IUser)
  private
    fId: string;
    fAttribute: TObject;
    fOwns: Boolean;
  protected
    function GetId: string;
    function GetAttribute: TObject;
  public
    constructor Create(const id: string; attribute: TObject; const owns: Boolean = True);
    destructor Destroy; override;
  end;

  TSecurityContext = class(TSecurity, ISecurityContext)
  private
    const
    NOT_LOGGED_IN = 'User not authenticated.';
  private
    fAuthenticator: IAuthenticator;
    fAuthorizer: IAuthorizer;
    fOnAfterLoginSuccessful: TProc;
    fOnAfterLogoutSuccessful: TProc;
  protected
    function GetAuthenticator: IAuthenticator;
    function GetAuthorizer: IAuthorizer;
    function GetAuthenticatedUser: IUser;

    procedure RegisterAuthenticator(authenticator: IAuthenticator);
    procedure RegisterAuthorizer(authorizer: IAuthorizer);

    procedure OnAfterLoginSuccessful(event: TProc);
    procedure OnAfterLogoutSuccessful(event: TProc);

    procedure Login(user: IUser);
    procedure Logout;

    function IsLoggedIn: Boolean;
    procedure CheckLoggedIn;

    function HasRole(const role: string): Boolean;
    function HasPermission(const resource, operation: string): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TDefaultAuthenticator }

procedure TDefaultAuthenticator.Authenticate(user: IUser);
begin
  raise EAuthenticatorException.Create(CLASS_NOT_FOUND);
end;

function TDefaultAuthenticator.GetAuthenticatedUser: IUser;
begin
  raise EAuthenticatorException.Create(CLASS_NOT_FOUND);
end;

procedure TDefaultAuthenticator.Unauthenticate;
begin
  raise EAuthenticatorException.Create(CLASS_NOT_FOUND);
end;

{ TDefaultAuthorizer }

function TDefaultAuthorizer.HasPermission(const resource, operation: string): Boolean;
begin
  raise EAuthorizerException.Create(CLASS_NOT_FOUND);
end;

function TDefaultAuthorizer.HasRole(const role: string): Boolean;
begin
  raise EAuthorizerException.Create(CLASS_NOT_FOUND);
end;

{ TUser }

constructor TUser.Create(const id: string; attribute: TObject; const owns: Boolean);
begin
  inherited Create;
  fId := id;
  fAttribute := attribute;
  fOwns := owns;
end;

destructor TUser.Destroy;
begin
  if fOwns and Assigned(fAttribute) then
    fAttribute.Free;
  inherited Destroy;
end;

function TUser.GetAttribute: TObject;
begin
  Result := fAttribute;
end;

function TUser.GetId: string;
begin
  Result := fId;
end;

{ TSecurityContext }

procedure TSecurityContext.CheckLoggedIn;
begin
  if not IsLoggedIn then
    raise EAuthorizationException.Create(NOT_LOGGED_IN);
end;

constructor TSecurityContext.Create;
begin
  inherited Create;
  fAuthenticator := nil;
  fAuthorizer := nil;
  fOnAfterLoginSuccessful := nil;
  fOnAfterLogoutSuccessful := nil;
end;

destructor TSecurityContext.Destroy;
begin
  inherited Destroy;
end;

function TSecurityContext.GetAuthenticatedUser: IUser;
begin
  Result := GetAuthenticator.AuthenticatedUser;
end;

function TSecurityContext.GetAuthenticator: IAuthenticator;
begin
  if not Assigned(fAuthenticator) then
    fAuthenticator := TDefaultAuthenticator.Create;
  Result := fAuthenticator;
end;

function TSecurityContext.GetAuthorizer: IAuthorizer;
begin
  if not Assigned(fAuthorizer) then
    fAuthorizer := TDefaultAuthorizer.Create;
  Result := fAuthorizer;
end;

function TSecurityContext.HasPermission(const resource, operation: string): Boolean;
begin
  CheckLoggedIn;
  try
    Result := GetAuthorizer.HasPermission(resource, operation);
  except
    on E: Exception do
      raise EAuthorizationException.Create(E.Message);
  end;
end;

function TSecurityContext.HasRole(const role: string): Boolean;
begin
  CheckLoggedIn;
  try
    Result := GetAuthorizer.HasRole(role);
  except
    on E: Exception do
      raise EAuthorizationException.Create(E.Message);
  end;
end;

function TSecurityContext.IsLoggedIn: Boolean;
begin
  Result := Assigned(GetAuthenticatedUser());
end;

procedure TSecurityContext.Login(user: IUser);
begin
  try
    GetAuthenticator.Authenticate(user);
  except
    on E: Exception do
      raise EAuthorizationException.Create(E.Message);
  end;
  if Assigned(fOnAfterLoginSuccessful) then
    fOnAfterLoginSuccessful();
end;

procedure TSecurityContext.Logout;
begin
  try
    GetAuthenticator.Unauthenticate;
  except
    on E: Exception do
      raise EAuthorizationException.Create(E.Message);
  end;
  if Assigned(fOnAfterLogoutSuccessful) then
    fOnAfterLogoutSuccessful();
end;

procedure TSecurityContext.OnAfterLoginSuccessful(event: TProc);
begin
  fOnAfterLoginSuccessful := event;
end;

procedure TSecurityContext.OnAfterLogoutSuccessful(event: TProc);
begin
  fOnAfterLogoutSuccessful := event;
end;

procedure TSecurityContext.RegisterAuthenticator(authenticator: IAuthenticator);
begin
  fAuthenticator := authenticator;
end;

procedure TSecurityContext.RegisterAuthorizer(authorizer: IAuthorizer);
begin
  fAuthorizer := authorizer;
end;

{ TSecurityProvider }

constructor TSecurityProvider.Create(securityContext: ISecurityContext);
begin
  inherited Create;
  fSecurityContext := Pointer(securityContext);
end;

function TSecurityProvider.SecurityContext: ISecurityContext;
begin
  Result := ISecurityContext(fSecurityContext);
end;

end.
