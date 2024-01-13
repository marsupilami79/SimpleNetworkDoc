object AddPortsForm: TAddPortsForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'AddPortsForm'
  ClientHeight = 171
  ClientWidth = 212
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 12
    Width = 33
    Height = 15
    Caption = 'Pr'#228'fix:'
  end
  object Label2: TLabel
    Left = 8
    Top = 42
    Width = 23
    Height = 15
    Caption = 'von:'
  end
  object Label3: TLabel
    Left = 8
    Top = 72
    Width = 18
    Height = 15
    Caption = 'bis:'
  end
  object Label4: TLabel
    Left = 8
    Top = 101
    Width = 21
    Height = 15
    Caption = 'Typ:'
  end
  object PrefixEdt: TEdit
    Left = 47
    Top = 8
    Width = 151
    Height = 23
    TabOrder = 0
  end
  object FromNbrEdt: TSpinEdit
    Left = 47
    Top = 37
    Width = 151
    Height = 24
    MaxValue = 100
    MinValue = 0
    TabOrder = 1
    Value = 1
  end
  object ToNbrEdt: TSpinEdit
    Left = 47
    Top = 67
    Width = 151
    Height = 24
    MaxValue = 100
    MinValue = 0
    TabOrder = 2
    Value = 1
  end
  object BitBtn1: TBitBtn
    Left = 8
    Top = 138
    Width = 92
    Height = 25
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 4
  end
  object BitBtn2: TBitBtn
    Left = 106
    Top = 138
    Width = 92
    Height = 25
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 5
  end
  object PortTypeCB: TComboBox
    Left = 47
    Top = 97
    Width = 151
    Height = 23
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 3
    Text = 'Device Port'
    Items.Strings = (
      'Device Port'
      'Infrastructure Port')
  end
end
