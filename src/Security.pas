unit Security;

interface

uses

  System.SysUtils;

type

  IUser = interface
    ['{1F72A9F5-035F-45BE-8ABF-610D8F346F7D}']
    function GetId: string;
    function GetDetails: TObject;

    property Id: string read GetId;
    property Details: TObject read GetDetails;
  end;

  IAuthenticator = interface
    ['{70AB3F03-EF27-49EB-8AED-AD85393FCC9E}']
    function GetAuthenticatedUser: IUser;

    procedure Authenticate(user: IUser);
    procedure Unauthenticate;

    property AuthenticatedUser: IUser read GetAuthenticatedUser;
  end;

  IAuthorizer = interface
    ['{6827D304-AC42-4E95-8302-F50D99E39E83}']
    function HasRole(role: string): Boolean;
    function HasAnyRole(roles: array of string): Boolean;

    function HasAuthority(authority: string): Boolean;
    function HasAnyAuthority(authorities: array of string): Boolean;
  end;

  ISecurityContext = interface
    ['{8B6AA783-155B-4AC1-ADF8-78C5907313A9}']
    function GetAuthenticatedUser: IUser;

    procedure RegisterAuthenticator(authenticator: IAuthenticator);
    procedure RegisterAuthorizer(authorizer: IAuthorizer);

    procedure OnAfterLoginSuccessful(event: TProc);
    procedure OnAfterLogoutSuccessful(event: TProc);

    procedure Login(user: IUser);
    procedure Logout;

    function IsLoggedIn: Boolean;
    procedure CheckLoggedIn;

    function HasRole(role: string): Boolean;
    function HasAnyRole(roles: array of string): Boolean;

    function HasAuthority(authority: string): Boolean;
    function HasAnyAuthority(authorities: array of string): Boolean;

    property AuthenticatedUser: IUser read GetAuthenticatedUser;
  end;

implementation

end.
