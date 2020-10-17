object MainView: TMainView
  Left = 0
  Top = 0
  Caption = 'MainView'
  ClientHeight = 235
  ClientWidth = 520
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 92
    Width = 497
    Height = 137
    Caption = 'Person'
    TabOrder = 0
    object Label1: TLabel
      Left = 24
      Top = 29
      Width = 10
      Height = 13
      Caption = 'Id'
    end
    object Label2: TLabel
      Left = 111
      Top = 29
      Width = 27
      Height = 13
      Caption = 'Name'
    end
    object Label3: TLabel
      Left = 399
      Top = 29
      Width = 19
      Height = 13
      Caption = 'Age'
    end
    object EdtId: TEdit
      Left = 24
      Top = 48
      Width = 81
      Height = 21
      Color = clInfoBk
      Enabled = False
      TabOrder = 0
    end
    object EdtName: TEdit
      Left = 111
      Top = 48
      Width = 282
      Height = 21
      TabOrder = 1
    end
    object EdtAge: TEdit
      Left = 399
      Top = 48
      Width = 81
      Height = 21
      TabOrder = 2
    end
    object Button1: TButton
      Left = 24
      Top = 91
      Width = 81
      Height = 25
      Caption = 'Insert'
      TabOrder = 3
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 111
      Top = 91
      Width = 81
      Height = 25
      Caption = 'Update'
      TabOrder = 4
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 198
      Top = 91
      Width = 81
      Height = 25
      Caption = 'Delete'
      TabOrder = 5
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 285
      Top = 91
      Width = 81
      Height = 25
      Caption = 'Find By Id'
      TabOrder = 6
      OnClick = Button4Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 8
    Width = 497
    Height = 78
    Caption = 'Current Security User'
    TabOrder = 1
    object Label4: TLabel
      Left = 17
      Top = 22
      Width = 48
      Height = 13
      Caption = 'Username'
    end
    object Label5: TLabel
      Left = 149
      Top = 22
      Width = 46
      Height = 13
      Caption = 'Password'
    end
    object Button5: TButton
      Left = 399
      Top = 39
      Width = 81
      Height = 25
      Caption = 'Change'
      TabOrder = 3
      OnClick = Button5Click
    end
    object EdtUsername: TEdit
      Left = 17
      Top = 41
      Width = 126
      Height = 21
      TabOrder = 0
    end
    object EdtPassword: TEdit
      Left = 149
      Top = 41
      Width = 130
      Height = 21
      TabOrder = 1
    end
    object EdtRole: TComboBox
      Left = 285
      Top = 41
      Width = 108
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 2
      Text = 'ROLE_ADMIN'
      Items.Strings = (
        'ROLE_ADMIN'
        'ROLE_MANAGER'
        'ROLE_GUEST')
    end
  end
end
