object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 614
  ClientWidth = 1284
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object DisplayP: TPanel
    Left = 0
    Top = 0
    Width = 811
    Height = 353
    Caption = 'DisplayP'
    TabOrder = 0
    DesignSize = (
      811
      353)
    object PatchPathLbl: TLabel
      Left = 311
      Top = 320
      Width = 75
      Height = 15
      Anchors = [akLeft, akBottom]
      Caption = 'Verbunden zu:'
      Visible = False
    end
    object ListG: TDBGrid
      Left = 311
      Top = 8
      Width = 495
      Height = 265
      Anchors = [akLeft, akTop, akRight, akBottom]
      DataSource = ListDS
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
    end
    object AssetsTV: TTreeView
      Left = 8
      Top = 8
      Width = 297
      Height = 306
      Anchors = [akLeft, akTop, akBottom]
      HideSelection = False
      Indent = 19
      SortType = stText
      TabOrder = 1
      OnChange = AssetsTVChange
    end
    object PatchPathEdt: TEdit
      Left = 392
      Top = 317
      Width = 282
      Height = 23
      Anchors = [akLeft, akRight, akBottom]
      ReadOnly = True
      TabOrder = 2
      Visible = False
    end
    object AddRemovePatchBtn: TButton
      Left = 680
      Top = 316
      Width = 126
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Patch hinzuf'#252'gen'
      TabOrder = 3
      Visible = False
    end
    object PrintUsageBtn: TButton
      Left = 8
      Top = 320
      Width = 129
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Belegung drucken'
      Enabled = False
      TabOrder = 4
      OnClick = PrintUsageBtnClick
    end
    object PortInfoNav: TDBNavigator
      Left = 758
      Top = 279
      Width = 48
      Height = 25
      DataSource = ListDS
      VisibleButtons = [nbPost, nbCancel]
      Anchors = [akRight, akBottom]
      TabOrder = 5
    end
  end
  object ButtonsP: TPanel
    Left = 8
    Top = 359
    Width = 803
    Height = 41
    TabOrder = 1
    DesignSize = (
      803
      41)
    object AddDeviceBtn: TButton
      Left = 251
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = '+ Ger'#228't'
      Enabled = False
      TabOrder = 0
      OnClick = AddDeviceBtnClick
    end
    object AddPortsBtn: TButton
      Left = 332
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = '+ Ports'
      Enabled = False
      TabOrder = 1
      OnClick = AddPortsBtnClick
    end
    object AddRackBtn: TButton
      Left = 170
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = '+ Schrank'
      Enabled = False
      TabOrder = 2
      OnClick = AddRackBtnClick
    end
    object AddRoomBtn: TButton
      Left = 89
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = '+ Raum'
      Enabled = False
      TabOrder = 3
      OnClick = AddRoomBtnClick
    end
    object ConnectBtn: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Verbinden'
      TabOrder = 4
      OnClick = ConnectBtnClick
    end
    object WikiImportBtn: TButton
      Left = 413
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'WikiImport'
      Enabled = False
      TabOrder = 5
      OnClick = WikiImportBtnClick
    end
  end
  object ListDS: TDataSource
    DataSet = DM.ListQ
    Left = 536
    Top = 207
  end
  object ReportQ: TZReadOnlyQuery
    Connection = DM.MainConn
    SQL.Strings = (
      'with recursive ports as ('
      '  select ID, NAME, PARENT from parents where PARENT = :PARENT'
      '  union all'
      
        '  select PA.ID, PO.NAME || '#39' -> '#39' || PA.NAME, PA.PARENT from par' +
        'ents PA'
      '    join ports PO on (PO.ID = PA.PARENT)'
      ')'
      'select'
      '  P.NAME || '#39' -> '#39' || PP.NAME as PNAME,'
      '  PP.ROOM,'
      '  PP.USEDBY,'
      
        '  case when PL.PORT1 = PP.ID then PL.PORT2 else PL.PORT1 end as ' +
        'PARTNERPORT'
      'from ports P'
      '  join patchports PP on (PP.DEVICE = P.ID)'
      '  join patchlinks PL on (PP.ID in (PL.PORT1, PL.PORT2))'
      'where'
      '  (PP.TYPE = '#39'i'#39')'
      'order by ROOM, USEDBY ')
    Params = <
      item
        Name = 'PARENT'
      end>
    Options = [doCalcDefaults, doPreferPrepared]
    Left = 56
    Top = 200
    ParamData = <
      item
        Name = 'PARENT'
      end>
  end
  object ReportDS: TDataSource
    DataSet = ReportQ
    Left = 120
    Top = 200
  end
end
