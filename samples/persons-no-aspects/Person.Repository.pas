unit Person.Repository;

interface

uses

  Person,
  Security.Core,
  App.Context;

type

  TPersonRepository = class
  private
    { private declarations }
  protected
    { protected declarations }
  public
    function Insert(person: TPerson): TPerson; virtual;
    function Update(person: TPerson): TPerson; virtual;
    function Delete(personId: Integer): Boolean; virtual;
    function FindById(personId: Integer): TPerson; virtual;
  end;

implementation

{ TPersonRepository }

function TPersonRepository.Delete(personId: Integer): Boolean;
begin
  if not SecurityContext.HasAnyRole(['ROLE_ADMIN', 'ROLE_MANAGER']) then
    raise EAuthorizationException.Create('You do not have role to access this feature.');

  if not SecurityContext.HasAuthority('PERSON_DELETE') then
    raise EAuthorizationException.Create('You do not have permission to access this feature.');

  Result := True;
end;

function TPersonRepository.FindById(personId: Integer): TPerson;
begin
  if not SecurityContext.HasAnyRole(['ROLE_ADMIN', 'ROLE_MANAGER', 'ROLE_GUEST']) then
    raise EAuthorizationException.Create('You do not have role to access this feature.');

  if not SecurityContext.HasAuthority('PERSON_VIEW') then
    raise EAuthorizationException.Create('You do not have permission to access this feature.');

  Result := TPerson.Create(personId, 'Ezequiel', 31);
end;

function TPersonRepository.Insert(person: TPerson): TPerson;
begin
  if not SecurityContext.HasAnyRole(['ROLE_ADMIN']) then
    raise EAuthorizationException.Create('You do not have role to access this feature.');

  if not SecurityContext.HasAuthority('PERSON_INSERT') then
    raise EAuthorizationException.Create('You do not have permission to access this feature.');

  person.Id := Random(1000);
  Result := person;
end;

function TPersonRepository.Update(person: TPerson): TPerson;
begin
  if not SecurityContext.HasAnyRole(['ROLE_ADMIN', 'ROLE_MANAGER']) then
    raise EAuthorizationException.Create('You do not have role to access this feature.');

  if not SecurityContext.HasAuthority('PERSON_UPDATE') then
    raise EAuthorizationException.Create('You do not have permission to access this feature.');

  Result := person;
end;

end.
