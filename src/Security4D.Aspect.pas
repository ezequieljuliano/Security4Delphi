unit Security4D.Aspect;

interface

uses
  System.SysUtils,
  System.Rtti,
  Aspect4D,
  Security4D;

type

  RequiredPermissionAttribute = class(AspectAttribute)
  private
    fResource: string;
    fOperation: string;
  protected
    { protected declarations }
  public
    constructor Create(const resource, operation: string);

    property Resource: string read fResource;
    property Operation: string read fOperation;
  end;

  RequiredRoleAttribute = class(AspectAttribute)
  private
    fRole: string;
  protected
    { protected declarations }
  public
    constructor Create(const role: string);

    property Role: string read fRole;
  end;

  TSecurityAspect = class(TAspect, IAspect)
  private
    const
    NO_PERMISSION = 'You do not have permission to access this feature.';
    NO_ROLE = 'You do not have role to access this feature.';
  private
    fSecurityContext: ISecurityContext;
  protected
    function GetName: string;

    procedure DoBefore(instance: TObject; method: TRttiMethod;
      const args: TArray<TValue>; out invoke: Boolean; out result: TValue);

    procedure DoAfter(instance: TObject; method: TRttiMethod;
      const args: TArray<TValue>; var result: TValue);

    procedure DoException(instance: TObject; method: TRttiMethod;
      const args: TArray<TValue>; out raiseException: Boolean;
      theException: Exception; out result: TValue);
  public
    constructor Create(securityContext: ISecurityContext);
  end;

implementation

{ RequiredPermissionAttribute }

constructor RequiredPermissionAttribute.Create(const resource, operation: string);
begin
  inherited Create;
  fResource := resource;
  fOperation := operation;
end;

{ RequiredRoleAttribute }

constructor RequiredRoleAttribute.Create(const role: string);
begin
  inherited Create;
  fRole := role;
end;

{ TSecurityAspect }

constructor TSecurityAspect.Create(securityContext: ISecurityContext);
begin
  inherited Create;
  fSecurityContext := securityContext;
end;

procedure TSecurityAspect.DoAfter(instance: TObject; method: TRttiMethod; const args: TArray<TValue>; var result: TValue);
begin
  // Method unused
end;

procedure TSecurityAspect.DoBefore(instance: TObject; method: TRttiMethod; const args: TArray<TValue>; out invoke: Boolean;
  out result: TValue);
var
  att: TCustomAttribute;
  hasPermission: Boolean;
  hasRole: Boolean;
begin
  hasPermission := True;
  for att in method.GetAttributes do
    if att is RequiredPermissionAttribute then
    begin
      hasPermission := fSecurityContext.HasPermission(
        RequiredPermissionAttribute(att).Resource, RequiredPermissionAttribute(att).Operation
        );
      if hasPermission then
        Break;
    end;

  hasRole := True;
  for att in method.GetAttributes do
    if att is RequiredRoleAttribute then
    begin
      hasRole := fSecurityContext.HasRole(RequiredRoleAttribute(att).Role);
      if hasRole then
        Break;
    end;

  if not hasPermission then
    raise EAuthorizationException.Create(NO_PERMISSION);

  if not hasRole then
    raise EAuthorizationException.Create(NO_ROLE);
end;

procedure TSecurityAspect.DoException(instance: TObject; method: TRttiMethod; const args: TArray<TValue>; out raiseException: Boolean;
  theException: Exception; out result: TValue);
begin
  // Method unused
end;

function TSecurityAspect.GetName: string;
begin
  Result := Self.QualifiedClassName;
end;

end.
