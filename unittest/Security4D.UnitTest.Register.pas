unit Security4D.UnitTest.Register;

interface

implementation

uses
  Security4D,
  Security4D.UnitTest.Authenticator,
  Security4D.UnitTest.Authorizer,
  Security4D.UnitTest.Credentials;

procedure SecurityRegister();
begin
  Security.Context.RegisterAuthenticator(
    function: IAuthenticator
    begin
      Result := TAuthenticator.Create(Credentials);
    end
    );

  Security.Context.RegisterAuthorizer(
    function: IAuthorizer
    begin
      Result := TAuthorizer.Create;
    end
    );
end;

initialization

SecurityRegister();

end.
