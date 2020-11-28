unit App.Context;

interface

uses

  Security,
  Security.Context,
  Authenticator,
  Authorizer;

function SecurityContext: ISecurityContext;

implementation

var

  SecurityContextInstance: ISecurityContext = nil;

function SecurityContext: ISecurityContext;
begin
  if (SecurityContextInstance = nil) then
  begin
    SecurityContextInstance := TSecurityContext.Create;
    SecurityContextInstance.RegisterAuthenticator(TAuthenticator.Create(SecurityContextInstance));
    SecurityContextInstance.RegisterAuthorizer(TAuthorizer.Create(SecurityContextInstance));
  end;
  Result := SecurityContextInstance;
end;

end.
