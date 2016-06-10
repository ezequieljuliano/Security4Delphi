# Security For Delphi

The Security4Delphi is an API that is a an issue of great importance for most applications and the focus of endless discussions on development teams: access control. The implementation of the security context has been designed in a simple and flexible way, regardless of presentation or technology layer, leaving you free to implement their own solution or use the existing extensions.
The authentication mechanism aims to verify the user's identity of a system. 
Already io authorization mechanism is responsible for ensuring that only authorized users are granted access to certain features of a system. The authorization may happen in two ways: permission functionality and enable by paper.

The key piece to make these possible mechanisms is the security context, represented by ISecurityContext interface. That they are defined methods responsible for managing authentication mechanisms such as, for example, perform Login/Logout or HasRole/HasPermission of users and check whether they are or not authenticated and authorized. To use the security context, just inject it into your code.

The Security4Delphi requires Delphi XE or greater.

# Creating Its Implementation #

The key to the security module are the IAuthenticator and IAuthorizer interfaces. To create a new mechanism for authentication and authorization, you only need to implement these two interfaces in your application. The library already has an abstract base class called TSecurityProvider. 

Below is a sample implementation:

**Authenticator**

	uses
	  Security4D,
	  Security4D.Impl;

	type
	
	  TAuthenticator = class(TSecurityProvider, IAuthenticator)
	  private
	    fAuthenticated: Boolean;
	    fAuthenticatedUser: IUser;
	  protected
	    function GetAuthenticatedUser: IUser;
	    procedure Authenticate(user: IUser);
	    procedure Unauthenticate;
	  public
	    procedure AfterConstruction; override;
	  end;
    
	{ TAuthenticator }
	
	procedure TAuthenticator.AfterConstruction;
	begin
	  inherited;
	  fAuthenticated := False;
	  fAuthenticatedUser := nil;
	end;
	
	procedure TAuthenticator.Authenticate(user: IUser);
	var
	  username, password: string;
	begin
	  fAuthenticated := False;
	  fAuthenticatedUser := nil;
	
	  if not Assigned(user) then
	    raise EAuthenticationException.Create('User not set to security layer.');
	
	  username := TCredential(user.Attribute).Username;
	  password := TCredential(user.Attribute).Password;
	
	  if (username.Equals('bob')) and (password.Equals('bob')) then
	    fAuthenticated := True
	  else if (username.Equals('jeff')) and (password.Equals('jeff')) then
	    fAuthenticated := True
	  else if (username.Equals('nick')) and (password.Equals('nick')) then
	    fAuthenticated := True;
	
	  if fAuthenticated then
	    fAuthenticatedUser := user
	  else
	    raise EAuthenticationException.Create('Unauthenticated user.');
	end;
	
	function TAuthenticator.GetAuthenticatedUser: IUser;
	begin
	  Result := fAuthenticatedUser;
	end;
	
	procedure TAuthenticator.Unauthenticate;
	begin
	  fAuthenticated := False;
	  fAuthenticatedUser := nil;
	end;

**Authorizer**

	uses
	  Security4D,
	  Security4D.Impl;

	type
	
	  TAuthorizer = class(TSecurityProvider, IAuthorizer)
	  private
	    { private declarations }
	  protected
	    function HasRole(const role: string): Boolean;
	    function HasPermission(const resource, operation: string): Boolean;
	  public
	    { public declarations }
	  end;

	{ TAuthorizer }
	
	function TAuthorizer.HasPermission(const resource, operation: string): Boolean;
	var
	  credential: TCredential;
	begin
	  Result := False;
	  if HasRole(ROLE_ADMIN) then
	    Result := True
	  else
	  begin
	    credential := (SecurityContext.AuthenticatedUser.Attribute as TCredential);
	    if (credential.Role.Equals(ROLE_MANAGER)) and (resource.Equals('Car')) and (operation.Equals('Insert')) then
	      Result := True;
	    if (credential.Role.Equals(ROLE_MANAGER)) and (resource.Equals('Car')) and (operation.Equals('Update')) then
	      Result := True;
	    if (credential.Role.Equals(ROLE_MANAGER)) and (resource.Equals('Car')) and (operation.Equals('Delete')) then
	      Result := True;
	    if (credential.Role.Equals(ROLE_MANAGER)) and (resource.Equals('Car')) and (operation.Equals('View')) then
	      Result := True;
	    if (credential.Role.Equals(ROLE_NORMAL)) and (resource.Equals('Car')) and (operation.Equals('View')) then
	      Result := True;
	  end;
	end;
	
	function TAuthorizer.HasRole(const role: string): Boolean;
	begin
	  if not SecurityContext.IsLoggedIn then
	    raise EAuthenticationException.Create('Unauthenticated user.');
	  Result := (SecurityContext.AuthenticatedUser.Attribute as TCredential).Role.Equals(role);
	end;

Now create your security context and add your authenticator and authorizer:
	  
	  fSecurityContext: ISecurityContext;

	  fSecurityContext := TSecurityContext.Create;
	  fSecurityContext.RegisterAuthenticator(TAuthenticator.Create(fSecurityContext));
	  fSecurityContext.RegisterAuthorizer(TAuthorizer.Create(fSecurityContext));

After all configured to use the security context you simply add the Uses of Security4D.pas and use in their codes:

	  if fSecurityContext.IsLoggedIn then
	    fSecurityContext.Logout;
    
      fSecurityContext.Login(TUser.Create('user', TCredential.Create('user', 'user', ROLE_ADMIN)));    

      if fSecurityContext.HasRole(ROLE_ADMIN) then
        ShowMessage('Is Admin');

	  if fSecurityContext.HasPermission('Car', 'Insert') then
        ShowMessage('Has Permission');

# Protecting the system with [RequiredPermission] and [RequiredRole] #

Using Security4Delphi together with [Aspect4Delphi](https://github.com/ezequieljuliano/Aspect4Delphi) is possible to make use of the concept of aspect-oriented programming (AOP).  

The custom attribute [RequiredPermission] lets you mark a method and states that access to this feature requires permission to perform an operation. Operation in this context is defined by the developer name is a system feature.

The custom attribute [RequiredRole] uses the concept of roles - or profiles - to protect resources. A method annotated with [RequiredRole] require the authenticated user has the role indicated to access the resource. 

Example of use with the security aspect, remember to give Uses of Aspect4D.pas, Security4D.Aspect.pas and leaving as virtual methods:

    uses 
       Security4D.Aspect;

	type
	
	  TCar = class
	  private
	    { private declarations }
	  protected
	    { protected declarations }
	  public
	    [RequiredPermission('Car', 'Insert')]
	    procedure Insert; virtual;
	
	    [RequiredPermission('Car', 'Update')]
	    procedure Update; virtual;
	
	    [RequiredPermission('Car', 'Delete')]
	    procedure Delete; virtual;
	
	    [RequiredRole(ROLE_ADMIN)]
	    [RequiredRole(ROLE_MANAGER)]
	    [RequiredRole(ROLE_NORMAL)]
	    procedure View; virtual;
	  end;

Now create your aspect context, add the security aspect and proxify the object:

    uses
	   Aspect4D,
  	   Aspect4D.Impl, 
       Security4D.Aspect;

     fAspectContext: IAspectContext;
     fCar: TCar;

	 fAspectContext := TAspectContext.Create;
	 fAspectContext.Register(TSecurityAspect.Create(fSecurityContext));
	
	 fCar := TCar.Create;
	 fAspectContext.Weaver.Proxify(fCar);

After using the object do Unproxify:

	 fAspectContext.Weaver.Unproxify(fCar);
	 fCar.Free;