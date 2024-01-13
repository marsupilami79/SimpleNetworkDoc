object SelectPortForm: TSelectPortForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'SelectPortForm'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  DesignSize = (
    624
    441)
  TextHeight = 15
  object UpBtn: TButton
    Left = 8
    Top = 8
    Width = 33
    Height = 23
    Caption = ' '#11014' '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = UpBtnClick
  end
  object ParentEdt: TEdit
    Left = 56
    Top = 8
    Width = 560
    Height = 23
    ReadOnly = True
    TabOrder = 1
    Text = 'ParentEdt'
  end
  object OkBtn: TBitBtn
    Left = 8
    Top = 408
    Width = 113
    Height = 25
    Caption = 'OK'
    Default = True
    NumGlyphs = 2
    TabOrder = 2
    OnClick = OkBtnClick
  end
  object CancelBtn: TBitBtn
    Left = 503
    Top = 408
    Width = 113
    Height = 25
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 3
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 37
    Width = 608
    Height = 365
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = ListDS
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 4
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnDblClick = OkBtnClick
  end
  object ListQ: TZReadOnlyQuery
    AfterOpen = ListQAfterOpen
    Connection = DM.MainConn
    Params = <>
    Options = [doCalcDefaults, doPreferPrepared]
    Left = 48
    Top = 40
  end
  object ListDS: TDataSource
    DataSet = ListQ
    Left = 104
    Top = 40
  end
end
