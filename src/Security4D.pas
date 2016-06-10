unit Security4D;

interface

uses
  System.SysUtils;

type

  ESecurityException = class(Exception);
  EAuthenticatorException = class(ESecurityException);
  EAuthorizerException = class(ESecurityException);
  EAuthorizationException = class(ESecurityException);
  EAuthenticationException = class(ESecurityException);

  ISecurity = interface
    ['{B15DCFD8-2069-4627-AB4B-CB618D71819D}']
  end;

  IUser = interface(ISecurity)
    ['{4CCA6359-1BBC-41F6-9CE9-4B3F00DDE0D4}']
    function GetId: string;
    function GetAttribute: TObject;

    property Id: string read GetId;
    property Attribute: TObject read GetAttribute;
  end;

  IAuthenticator = interface(ISecurity)
    ['{246AFE44-0901-4DAE-8CD4-6A3A4E9021B0}']
    function GetAuthenticatedUser: IUser;

    procedure Authenticate(user: IUser);
    procedure Unauthenticate;

    property AuthenticatedUser: IUser read GetAuthenticatedUser;
  end;

  IAuthorizer = interface(ISecurity)
    ['{EB117E9A-F25C-4EF9-9F55-F08D46675BE2}']
    function HasRole(const role: string): Boolean;
    function HasPermission(const resource, operation: string): Boolean;
  end;

  ISecurityContext = interface(ISecurity)
    ['{66F6C8D2-DF1E-479A-946A-1B6111F182DF}']
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

    property AuthenticatedUser: IUser read GetAuthenticatedUser;
  end;

implementation

end.
