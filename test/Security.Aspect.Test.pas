unit Security.Aspect.Test;

interface

uses

  Security,
  Security.Core,
  Security.Context,
  Security.User,
  Security.Aspect,
  Aspect,
  Aspect.Context,
  Authenticator,
  Authorizer,
  Credential,
  TestFramework,
  System.Rtti,
  System.SysUtils,
  System.Classes;

type

  TTestSecurityAspect = class(TTestCase)
  private type

    TCarRepository = class
    private
      fAction: string;
    protected
      { protected declarations }
    public
      [RequiredAuthority('CAR_INSERT')]
      procedure Insert; virtual;

      [RequiredAuthority('CAR_UPDATE')]
      procedure Update; virtual;

      [RequiredAuthority('CAR_DELETE')]
      procedure Delete; virtual;

      [RequiredRole(ROLE_ADMIN)]
      [RequiredRole(ROLE_MANAGER)]
      [RequiredRole(ROLE_GUEST)]
      procedure View; virtual;

      [RequiredAnyRole(ROLE_ADMIN + ',' + ROLE_MANAGER)]
      procedure CheckStatus; virtual;

      [RequiredAnyAuthority('CAR_INSERT,CAR_UPDATE')]
      procedure CheckStock; virtual;

      property Action: string read fAction;
    end;

  private
    fSecurityContext: ISecurityContext;
    fAspectContext: IAspectContext;
    fCarRepository: TCarRepository;
    procedure CarInsert;
    procedure CarUpdate;
    procedure CarDelete;
    procedure CarView;
    procedure CarCheckStock;
    procedure CarCheckStatus;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestAllActions;
  end;

implementation

{ TTestSecurityAspect }

procedure TTestSecurityAspect.CarCheckStatus;
begin
  fCarRepository.CheckStatus;
end;

procedure TTestSecurityAspect.CarCheckStock;
begin
  fCarRepository.CheckStock;
end;

procedure TTestSecurityAspect.CarDelete;
begin
  fCarRepository.Delete;
end;

procedure TTestSecurityAspect.CarInsert;
begin
  fCarRepository.Insert;
end;

procedure TTestSecurityAspect.CarUpdate;
begin
  fCarRepository.Update;
end;

procedure TTestSecurityAspect.CarView;
begin
  fCarRepository.View;
end;

procedure TTestSecurityAspect.SetUp;
begin
  inherited;
  fSecurityContext := TSecurityContext.Create;
  fSecurityContext.RegisterAuthenticator(TAuthenticator.Create(fSecurityContext));
  fSecurityContext.RegisterAuthorizer(TAuthorizer.Create(fSecurityContext));

  fAspectContext := TAspectContext.Create;
  fAspectContext.RegisterAspect(TSecurityAspect.Create(fSecurityContext));

  fCarRepository := TCarRepository.Create;
  fAspectContext.Weaver.Proxify(fCarRepository);
end;

procedure TTestSecurityAspect.TearDown;
begin
  inherited;
  fAspectContext.Weaver.Unproxify(fCarRepository);
  fCarRepository.Free;
end;

procedure TTestSecurityAspect.TestAllActions;
begin
  if fSecurityContext.IsLoggedIn then
    fSecurityContext.Logout;

  fSecurityContext.Login(TUser.Create('U003', TCredential.Create('nick', '1234', ROLE_GUEST)));
  CheckException(CarInsert, EAuthorizationException);
  CheckException(CarUpdate, EAuthorizationException);
  CheckException(CarDelete, EAuthorizationException);
  CheckException(CarCheckStock, EAuthorizationException);
  CheckException(CarCheckStatus, EAuthorizationException);
  CarView();

  fSecurityContext.Logout;
  fSecurityContext.Login(TUser.Create('U002', TCredential.Create('jeff', '1234', ROLE_ADMIN)));
  CarInsert();
  CarUpdate();
  CarDelete();
  CarCheckStock();
  CarCheckStatus();
  CarView();

  fSecurityContext.Logout;
  fSecurityContext.Login(TUser.Create('U001', TCredential.Create('bob', '1234', ROLE_ADMIN)));
  CarInsert();
  CarUpdate();
  CarDelete();
  CarCheckStock();
  CarCheckStatus();
  CarView();
end;

{ TTestSecurityAspect.TCarRepository }

procedure TTestSecurityAspect.TCarRepository.CheckStatus;
begin
  fAction := 'Check Status';
end;

procedure TTestSecurityAspect.TCarRepository.CheckStock;
begin
  fAction := 'Check Stock';
end;

procedure TTestSecurityAspect.TCarRepository.Delete;
begin
  fAction := 'Car Deleted';
end;

procedure TTestSecurityAspect.TCarRepository.Insert;
begin
  fAction := 'Car Inserted';
end;

procedure TTestSecurityAspect.TCarRepository.Update;
begin
  fAction := 'Car Updated';
end;

procedure TTestSecurityAspect.TCarRepository.View;
begin
  fAction := 'Car Viewed';
end;

initialization

RegisterTest(TTestSecurityAspect.Suite);

end.
