unit Security4D.UnitTest.Car;

interface

uses
  Aspect4D,
  Security4D.Aspect,
  Security4D.UnitTest.Credentials;

type

  TCar = class
  strict private
    FAction: string;
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

    property Action: string read FAction;
  end;

implementation

{ TCar }

constructor TCar.Create;
begin
  Aspect.Weaver.Proxify(Self);
end;

procedure TCar.Delete;
begin
  FAction := 'Car Deleted';
end;

destructor TCar.Destroy;
begin
  Aspect.Weaver.Unproxify(Self);
  inherited;
end;

procedure TCar.Insert;
begin
  FAction := 'Car Inserted';
end;

procedure TCar.Update;
begin
  FAction := 'Car Updated';
end;

procedure TCar.View;
begin
  FAction := 'Car Viewed';
end;

end.
