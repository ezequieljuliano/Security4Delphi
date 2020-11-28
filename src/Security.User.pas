unit Security.User;

interface

uses

  Security;

type

  TUser = class(TInterfacedObject, IUser)
  private
    fId: string;
    fDetails: TObject;
    fOwns: Boolean;
  protected
    function GetId: string;
    function GetDetails: TObject;
  public
    constructor Create(id: string; details: TObject; owns: Boolean = True);
    destructor Destroy; override;
  end;

implementation

{ TUser }

constructor TUser.Create(id: string; details: TObject; owns: Boolean);
begin
  inherited Create;
  fId := id;
  fDetails := details;
  fOwns := owns;
end;

destructor TUser.Destroy;
begin
  if fOwns and Assigned(fDetails) then
    fDetails.Free;
  inherited Destroy;
end;

function TUser.GetDetails: TObject;
begin
  Result := fDetails;
end;

function TUser.GetId: string;
begin
  Result := fId;
end;

end.
