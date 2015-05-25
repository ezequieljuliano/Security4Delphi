# Security For Delphi

The Security4Delphi is an API that is a an issue of great importance for most applications and the focus of endless discussions on development teams: access control. The implementation of the security context has been designed in a simple and flexible way, regardless of presentation or technology layer, leaving you free to implement their own solution or use the existing extensions.

The authentication mechanism aims to verify the user's identity of a system. Already io authorization mechanism is responsible for ensuring that only authorized users are granted access to certain features of a system. The authorization may happen in two ways: permission functionality and enable by paper.

The key piece to make these possible mechanisms is the security context, represented by ISecurityContext interface. That they are defined methods responsible for managing authentication mechanisms such as, for example, perform login/logout of users and check whether they are or not authenticated and authorized. To use the security context, just inject it into your code.

The Security4Delphi requires Delphi XE or greater.

# Creating Its Implementation #

The key to the security module are the IAuthenticator and IAuthorizer interfaces. To create a new mechanism for authentication and authorization, you only need to implement these two interfaces in your application. Below is a sample implementation:

**Authenticator**

    uses Security4D;

	TAuthenticator = class(TInterfacedObject, IAuthenticator)
    private
       FAuthenticated: Boolean;
       FUser: IUser;
       FCredentials: TCredentials;
    public
       constructor Create(pCredentials: TCredentials);
    
       function GetUser(): IUser;
    
       procedure Authenticate();
       procedure Unauthenticate();
    
       property User: IUser read GetUser;
     end;

    procedure TAuthenticator.Authenticate;
    var
      vUsername, vPassword: string;
    begin
      vUsername := FCredentials.Username;
      vPassword := FCredentials.Password;
    
      if (vUsername.Equals('admin')) and (vPassword.Equals('admin')) then
    	FAuthenticated := True;
    
      if not FAuthenticated then
    	raise EAuthenticationException.Create('Unauthenticated user!');
    end;
    
    constructor TAuthenticator.Create(pCredentials: TCredentials);
    begin
      FAuthenticated := False;
      FUser := nil;
      FCredentials := pCredentials;
    end;
    
    function TAuthenticator.GetUser: IUser;
    begin
      if FAuthenticated then
      begin
    	if (FUser = nil) then
      	   FUser := Security.User(FCredentials.Username, FCredentials);
       	Result := FUser;
      end
      else
    	Result := nil;
    end;
    
    procedure TAuthenticator.Unauthenticate;
    begin
      FCredentials.Clear;
      FAuthenticated := False;
    end;

**Authorizer**

    uses Security4D;

	TAuthorizer = class(TInterfacedObject, IAuthorizer)
    public
       function HasRole(const pRole: string): Boolean;
       function HasPermission(const pResource, pOperation: string): Boolean;
    end;

    function TAuthorizer.HasPermission(const pResource, pOperation: string): Boolean;
    var
      vCredentials: TCredentials;
    begin
      Result := False;
    
      if not Security.Context.IsLoggedIn then
    	raise EAuthenticationException.Create('Unauthenticated user!');
    
      if Security.Context.HasRole(ROLE_ADMIN) then
    	Result := True
      else
      begin
    	vCredentials := (Security.Context.User.Attribute as TCredentials);
    	if (vCredentials.Role.Equals(ROLE_MANAGER)) and 
		  (pResource.Equals('Car')) and (pOperation.Equals('Insert')) then
      	  Result := True;
      end;
    end;
    
    function TAuthorizer.HasRole(const pRole: string): Boolean;
    begin
      if not Security.Context.IsLoggedIn then
    raise EAuthenticationException.Create('Unauthenticated user!');
    
      Result := (Security.Context.User.Attribute as TCredentials)
        .Role.Equals(pRole);
    end;

Now add in the security context of your authenticator and authorizer:

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

After all configured to use the security context you simply add the Uses of Security4D.pas and use in their codes:

     if Security.Context.IsLoggedIn then
    	Security.Context.Logout;
    
     Credentials.Username := 'bob';
     Credentials.Password := 'bob';
     Credentials.Role := ROLE_ADMIN;

     Security.Context.Login;

     if Security.Context.HasRole(ROLE_ADMIN) then
       ShowMessage('Is Admin');

	 if Security.Context.HasPermission('Car', 'Insert') then
       ShowMessage('Has Permission');

# Protecting the system with [RequiredPermission] and [RequiredRole] #

Using Security4Delphi together with [Aspect4Delphi](https://github.com/ezequieljuliano/Aspect4Delphi) is possible to make use of the concept of aspect-oriented programming (AOP).  

The custom attribute [RequiredPermission] lets you mark a class or method and states that access to this feature requires permission to perform an operation. Operation in this context is defined by the developer name is a system feature.

The custom attribute [RequiredRole] uses the concept of roles - or profiles - to protect resources. A method annotated with [RequiredRole] require the authenticated user has the role indicated to access the resource. 

Example of use with the security aspect, remember to give Uses of Security4D.Aspect.pas and leaving as virtual methods:

    uses Aspect4D, Security4D.Aspect;

	TCar = class
    public
	    constructor Create;
	    destructor Destroy; override;
	    
	    [RequiredPermission('Car', 'Insert')]
	    procedure Insert(); virtual;
	    
	    [RequiredPermission('Car', 'Update')]
	    procedure Update(); virtual;
	    
	    [RequiredPermission('Car', 'Delete')]
	    procedure Delete(); virtual;
	    
	    [RequiredRole(ROLE_ADMIN)]
	    [RequiredRole(ROLE_MANAGER)]
	    [RequiredRole(ROLE_NORMAL)]
	    procedure View(); virtual;
    end;

    constructor TCar.Create;
    begin
      	Aspect.Weaver.Proxify(Self);
    end;
    
    destructor TCar.Destroy;
    begin
      	Aspect.Weaver.Unproxify(Self);
      	inherited;
    end;