object WikiImportForm: TWikiImportForm
  Left = 0
  Top = 0
  Caption = 'WikiImportForm'
  ClientHeight = 584
  ClientWidth = 1037
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 67
    Height = 15
    Caption = 'Wiki-Tabelle:'
  end
  object Label2: TLabel
    Left = 784
    Top = 8
    Width = 149
    Height = 15
    Caption = 'Ersetzungstabelle f'#252'r Ger'#228'te:'
  end
  object ReplacementM: TMemo
    Left = 784
    Top = 29
    Width = 245
    Height = 516
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'ReplacementM')
    ParentFont = False
    TabOrder = 0
  end
  object WikiTextM: TSynEdit
    Left = 8
    Top = 29
    Width = 770
    Height = 516
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    TabOrder = 1
    CodeFolding.GutterShapeSize = 11
    CodeFolding.CollapsedLineColor = clGrayText
    CodeFolding.FolderBarLinesColor = clGrayText
    CodeFolding.IndentGuidesColor = clGray
    CodeFolding.IndentGuides = True
    CodeFolding.ShowCollapsedLine = False
    CodeFolding.ShowHintMark = True
    UseCodeFolding = False
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = []
    Lines.Strings = (
      'WikiTextM')
    FontSmoothing = fsmNone
  end
  object ImportBtn: TButton
    Left = 8
    Top = 551
    Width = 121
    Height = 25
    Caption = 'Import'
    TabOrder = 2
    OnClick = ImportBtnClick
  end
  object TempQ: TZReadOnlyQuery
    Connection = DM.MainConn
    Params = <>
    Options = [doCalcDefaults, doPreferPrepared]
    Left = 224
    Top = 56
  end
  object PatchQ: TZQuery
    Connection = DM.MainConn
    SQL.Strings = (
      
        'select * from patchlinks where :PORT1 in (PORT1, PORT2) or :PORT' +
        '2 in (PORT1, PORT2)')
    Params = <
      item
        Name = 'PORT1'
      end
      item
        Name = 'PORT2'
      end>
    Left = 136
    Top = 56
    ParamData = <
      item
        Name = 'PORT1'
      end
      item
        Name = 'PORT2'
      end>
  end
  object PortQ: TZQuery
    Connection = DM.MainConn
    SQL.Strings = (
      'select * from patchports where id = :PORT')
    Params = <
      item
        Name = 'PORT'
      end>
    Left = 136
    Top = 112
    ParamData = <
      item
        Name = 'PORT'
      end>
  end
end
