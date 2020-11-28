unit Person;

interface

type

  TPerson = class
  private
    fId: Integer;
    fName: string;
    fAge: Integer;
  protected
    { protected declarations }
  public
    constructor Create; overload;
    constructor Create(id: Integer; name: string; age: Integer); overload;

    property Id: Integer read fId write fId;
    property Name: string read fName write fName;
    property Age: Integer read fAge write fAge;
  end;

implementation

{ TPerson }

constructor TPerson.Create(id: Integer; name: string; age: Integer);
begin
  Create;
  fId := id;
  fName := name;
  fAge := age;
end;

constructor TPerson.Create;
begin
  inherited Create;
end;

end.
