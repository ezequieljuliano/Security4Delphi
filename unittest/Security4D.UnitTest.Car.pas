unit Security4D.UnitTest.Car;

interface

uses
  Security4D.Aspect,
  Security4D.UnitTest.Credential;

type

  TCar = class
  private
    fAction: string;
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

    property Action: string read fAction;
  end;

implementation

{ TCar }

procedure TCar.Delete;
begin
  fAction := 'Car Deleted';
end;

procedure TCar.Insert;
begin
  fAction := 'Car Inserted';
end;

procedure TCar.Update;
begin
  fAction := 'Car Updated';
end;

procedure TCar.View;
begin
  fAction := 'Car Viewed';
end;

end.
