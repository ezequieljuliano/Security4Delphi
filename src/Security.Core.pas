unit Security.Core;

interface

uses

  System.SysUtils,
  Security;

type

  ESecurityException = class(Exception)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

  EAuthenticatorException = class(ESecurityException)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

  EAuthorizerException = class(ESecurityException)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

  EAuthorizationException = class(ESecurityException)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

  EAuthenticationException = class(ESecurityException)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

  TDefaultAuthenticator = class(TInterfacedObject, IAuthenticator)
  private
    const
    CLASS_NOT_DEFINED = 'Security Authenticator not defined.';
  protected
    function GetAuthenticatedUser: IUser;

    procedure Authenticate(user: IUser);
    procedure Unauthenticate;
  public
    { public declarations }
  end;

  TDefaultAuthorizer = class(TInterfacedObject, IAuthorizer)
  private
    const
    CLASS_NOT_DEFINED = 'Security Authorizer not defined.';
  protected
    function HasRole(role: string): Boolean;
    function HasAnyRole(roles: array of string): Boolean;

    function HasAuthority(authority: string): Boolean;
    function HasAnyAuthority(authorities: array of string): Boolean;
  public
    { public declarations }
  end;

  TAbstractSecurityProvider = class abstract(TInterfacedObject)
  private
    fContext: Pointer;
  protected
    function GetContext: ISecurityContext;
  public
    constructor Create(context: ISecurityContext);
  end;

implementation

{ TDefaultAuthenticator }

procedure TDefaultAuthenticator.Authenticate(user: IUser);
begin
  raise EAuthenticatorException.Create(CLASS_NOT_DEFINED);
end;

function TDefaultAuthenticator.GetAuthenticatedUser: IUser;
begin
  raise EAuthenticatorException.Create(CLASS_NOT_DEFINED);
end;

procedure TDefaultAuthenticator.Unauthenticate;
begin
  raise EAuthenticatorException.Create(CLASS_NOT_DEFINED);
end;

{ TDefaultAuthorizer }

function TDefaultAuthorizer.HasAnyAuthority(authorities: array of string): Boolean;
begin
  raise EAuthorizerException.Create(CLASS_NOT_DEFINED);
end;

function TDefaultAuthorizer.HasAnyRole(roles: array of string): Boolean;
begin
  raise EAuthorizerException.Create(CLASS_NOT_DEFINED);
end;

function TDefaultAuthorizer.HasAuthority(authority: string): Boolean;
begin
  raise EAuthorizerException.Create(CLASS_NOT_DEFINED);
end;

function TDefaultAuthorizer.HasRole(role: string): Boolean;
begin
  raise EAuthorizerException.Create(CLASS_NOT_DEFINED);
end;

{ TAbstractSecurityProvider }

constructor TAbstractSecurityProvider.Create(context: ISecurityContext);
begin
  inherited Create;
  fContext := Pointer(context);
end;

function TAbstractSecurityProvider.GetContext: ISecurityContext;
begin
  Result := ISecurityContext(fContext);
end;

end.
