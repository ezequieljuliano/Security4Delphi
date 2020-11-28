unit Main.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Person, Person.Repository, App.Context, Security,
  Security.User, Credential;

type

  TMainView = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EdtId: TEdit;
    EdtName: TEdit;
    EdtAge: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    GroupBox2: TGroupBox;
    Button5: TButton;
    EdtUsername: TEdit;
    EdtPassword: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    EdtRole: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    fPersonRepository: TPersonRepository;
  public
    { Public declarations }
  end;

var
  MainView: TMainView;

implementation

{$R *.dfm}

procedure TMainView.Button1Click(Sender: TObject);
var
  person: TPerson;
begin
  person := TPerson.Create(0, EdtName.Text, StrToIntDef(EdtAge.Text, 0));
  try
    fPersonRepository.Insert(person);
    EdtId.Text := person.Id.ToString;
    ShowMessage('Successfully included person.');
  finally
    person.Free;
  end;
end;

procedure TMainView.Button2Click(Sender: TObject);
var
  person: TPerson;
begin
  person := TPerson.Create(StrToIntDef(EdtId.Text, 0), EdtName.Text, StrToIntDef(EdtAge.Text, 0));
  try
    fPersonRepository.Update(person);
    ShowMessage('Successfully updated person.');
  finally
    person.Free;
  end;
end;

procedure TMainView.Button3Click(Sender: TObject);
var
  personId: Integer;
begin
  personId := StrToIntDef(InputBox('Person', 'Id', ''), 0);
  if fPersonRepository.Delete(personId) then
    ShowMessage('Successfully deleted person.');
end;

procedure TMainView.Button4Click(Sender: TObject);
var
  person: TPerson;
  personId: Integer;
begin
  personId := StrToIntDef(InputBox('Person', 'Id', ''), 0);

  person := fPersonRepository.FindById(personId);
  try
    EdtId.Text := person.Id.ToString;
    EdtName.Text := person.Name;
    EdtAge.Text := person.Age.ToString;
  finally
    person.Free;
  end;
end;

procedure TMainView.Button5Click(Sender: TObject);
begin
  if SecurityContext.IsLoggedIn then
    SecurityContext.Logout;
  SecurityContext.Login(
    TUser.Create(
    TGuid.NewGuid.ToString,
    TCredential.Create(EdtUsername.Text, EdtPassword.Text, EdtRole.Text))
    );
end;

procedure TMainView.FormCreate(Sender: TObject);
begin
  fPersonRepository := TPersonRepository.Create;
end;

procedure TMainView.FormDestroy(Sender: TObject);
begin
  fPersonRepository.Free;
end;

end.
