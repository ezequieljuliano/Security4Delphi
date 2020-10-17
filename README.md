# Security For Delphi
The Security4Delphi consists of an library that enables the use of the concept of security in your Delphi applications.

## About The Project
Security is a an concern of great importance for most applications and the focus of endless discussions on development teams. The implementation of the security context has been designed in a simple and flexible way, regardless of presentation or technology layer, leaving you free to implement their own solution or use the existing extensions.

The authentication mechanism aims to verify the user's identity of a system. 

Already io authorization mechanism is responsible for ensuring that only authorized users are granted access to certain features of a system. The authorization may happen in two ways: permission functionality and enable by role.

### Key validation features
* Login
* Logout
* IsLoggedIn
* CheckLoggedIn
* HasRole
* HasAnyRole
* HasAuthority
* HasAnyAuthority
* GetAuthenticatedUser

### Built With
* [Delphi Community Edition](https://www.embarcadero.com/br/products/delphi/starter) - The IDE used 

## Getting Started
To get a local copy up and running follow these simple steps.

### Prerequisites
To use this library an updated version of Delphi IDE (XE or higher) is required.

### Installation
Clone the repo
```
git clone https://github.com/ezequieljuliano/Security4Delphi.git
```

Add the "Search Path" of your IDE or your project the following directories:
```
Security4Delphi\src
```

## Usage
To provide the security context paradigm in your project with Security4Delphi you need:

* Create your implementation of the IAuthenticator interface.
* Create your implementation of the IAuthorizer interface.
* Register your implementations in context.
* Use the context and validate authentication and authorization.

### Sample
To illustrate usage let's look at a solution for managing logs of an application.

Create your implementation of the IAuthenticator interface:
```
  TAuthenticator = class(TAbstractSecurityProvider, IAuthenticator)
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
```

Create your implementation of the IAuthorizer interface:
```
  TAuthorizer = class(TAbstractSecurityProvider, IAuthorizer)
  private
    { private declarations }
  protected
    function HasRole(role: string): Boolean;
    function HasAnyRole(roles: array of string): Boolean;

    function HasAuthority(authority: string): Boolean;
    function HasAnyAuthority(authorities: array of string): Boolean;
  public
    { public declarations }
  end;
```

Register your implementations in context:
```
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
```

Use the context and validate authentication and authorization:
```
function TPersonRepository.Delete(personId: Integer): Boolean;
begin
  if not SecurityContext.HasAnyRole(['ROLE_ADMIN', 'ROLE_MANAGER']) then
    raise EAuthorizationException.Create('You do not have role to access this feature.');

  if not SecurityContext.HasAuthority('PERSON_DELETE') then
    raise EAuthorizationException.Create('You do not have permission to access this feature.');

  Result := True;
end;
```

### Optional Feature - Aspects

Protecting the system with [RequiredRole], [RequiredAnyRole], [RequiredAuthority] and [RequiredAnyAuthority] aspects:

Using Security4Delphi together with [Aspect4Delphi](https://github.com/ezequieljuliano/Aspect4Delphi) is possible to make use of the concept of aspect-oriented programming (AOP).  

```
  TPersonRepository = class
  private
    { private declarations }
  protected
    { protected declarations }
  public
    constructor Create;
    destructor Destroy; override;

    [RequiredRole('ROLE_ADMIN')]
    [RequiredAuthority('PERSON_INSERT')]
    function Insert(person: TPerson): TPerson; virtual;

    [RequiredAnyRole('ROLE_ADMIN,ROLE_MANAGER')]
    [RequiredAuthority('PERSON_UPDATE')]
    function Update(person: TPerson): TPerson; virtual;

    [RequiredAnyRole('ROLE_ADMIN,ROLE_MANAGER')]
    [RequiredAuthority('PERSON_DELETE')]
    function Delete(personId: Integer): Boolean; virtual;

    [RequiredAnyRole('ROLE_ADMIN,ROLE_MANAGER,ROLE_GUEST')]
    [RequiredAuthority('PERSON_VIEW')]
    function FindById(personId: Integer): TPerson; virtual;
  end;
```

## Roadmap

See the [open issues](https://github.com/ezequieljuliano/Security4Delphi/issues) for a list of proposed features (and known issues).

## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

Distributed under the APACHE LICENSE. See `LICENSE` for more information.

## Contact

To contact us use the options:
* E-mail  : ezequieljuliano@gmail.com
* Twitter : [@ezequieljuliano](https://twitter.com/ezequieljuliano)
* Linkedin: [ezequiel-juliano-müller](https://www.linkedin.com/in/ezequiel-juliano-müller-43988a4a)

## Project Link
[https://github.com/ezequieljuliano/Security4Delphi](https://github.com/ezequieljuliano/Security4Delphi)