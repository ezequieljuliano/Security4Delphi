unit App.Context;

interface

uses

  Security,
  Security.Context,
  Security.Aspect,
  Authenticator,
  Authorizer,
  Aspect,
  Aspect.Context;

function SecurityContext: ISecurityContext;
function AspectContext: IAspectContext;

implementation

var

  SecurityContextInstance: ISecurityContext = nil;
  AspectContextInstance: IAspectContext = nil;

function AspectContext: IAspectContext;
begin
  if (AspectContextInstance = nil) then
  begin
    AspectContextInstance := TAspectContext.Create;
    AspectContextInstance.RegisterAspect(TSecurityAspect.Create(SecurityContext));
  end;
  Result := AspectContextInstance;
end;

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
