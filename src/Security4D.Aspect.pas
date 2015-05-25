unit Security4D.Aspect;

interface

uses
  System.SysUtils,
  System.Rtti,
  Aspect4D,
  Security4D;

type

  RequiredPermissionAttribute = class(AspectAttribute)
  strict private
    FResource: string;
    FOperation: string;
  public
    constructor Create(const pResource, pOperation: string);

    property Resource: string read FResource;
    property Operation: string read FOperation;
  end;

  RequiredRoleAttribute = class(AspectAttribute)
  strict private
    FRole: string;
  public
    constructor Create(const pRole: string);

    property Role: string read FRole;
  end;

  TSecurityAspect = class(TAspect, IAspect)
  strict private
  const
    NoPermissionException = 'You do not have permission to access this feature!';
    NoRoleException = 'You do not have role to access this feature!';
  public
    procedure DoBefore(pInstance: TObject;
      pMethod: TRttiMethod; const pArgs: TArray<TValue>; out pDoInvoke: Boolean;
      out pResult: TValue);

    procedure DoAfter(pInstance: TObject;
      pMethod: TRttiMethod; const pArgs: TArray<TValue>; var pResult: TValue);

    procedure DoException(pInstance: TObject;
      pMethod: TRttiMethod; const pArgs: TArray<TValue>; out pRaiseException: Boolean;
      pTheException: Exception; out pResult: TValue);
  end;

implementation

{ RequiredPermissionAttribute }

constructor RequiredPermissionAttribute.Create(const pResource, pOperation: string);
begin
  FResource := pResource;
  FOperation := pOperation;
end;

{ RequiredRoleAttribute }

constructor RequiredRoleAttribute.Create(const pRole: string);
begin
  FRole := pRole;
end;

{ TSecurityAspect }

procedure TSecurityAspect.DoAfter(pInstance: TObject; pMethod: TRttiMethod;
  const pArgs: TArray<TValue>; var pResult: TValue);
begin
  // Method unused
end;

procedure TSecurityAspect.DoBefore(pInstance: TObject; pMethod: TRttiMethod;
  const pArgs: TArray<TValue>; out pDoInvoke: Boolean; out pResult: TValue);
var
  vAtt: TCustomAttribute;
  vHasPermission: Boolean;
  vHasRole: Boolean;
begin
  vHasPermission := True;
  for vAtt in pMethod.GetAttributes do
    if vAtt is RequiredPermissionAttribute then
    begin
      vHasPermission := Security.Context.HasPermission(
        RequiredPermissionAttribute(vAtt).Resource, RequiredPermissionAttribute(vAtt).Operation
        );
      if vHasPermission then
        Break;
    end;

  vHasRole := True;
  for vAtt in pMethod.GetAttributes do
    if vAtt is RequiredRoleAttribute then
    begin
      vHasRole := Security.Context.HasRole(RequiredRoleAttribute(vAtt).Role);
      if vHasRole then
        Break;
    end;

  if not vHasPermission then
    raise EAuthorizationException.Create(NoPermissionException);

  if not vHasRole then
    raise EAuthorizationException.Create(NoRoleException);
end;

procedure TSecurityAspect.DoException(pInstance: TObject; pMethod: TRttiMethod;
  const pArgs: TArray<TValue>; out pRaiseException: Boolean; pTheException: Exception;
  out pResult: TValue);
begin
  // Method unused
end;

initialization

Aspect.Register(TSecurityAspect);

end.
