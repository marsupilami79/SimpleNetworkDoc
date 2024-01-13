object UsedListRpt: TUsedListRpt
  Left = 0
  Top = 0
  Caption = 'UsedListRpt'
  ClientHeight = 845
  ClientWidth = 815
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Rpt: TRLReport
    Left = 8
    Top = 8
    Width = 794
    Height = 1123
    DataSource = MainForm.ReportDS
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    object DetailsB: TRLBand
      Left = 38
      Top = 73
      Width = 718
      Height = 24
      BeforePrint = DetailsBBeforePrint
      object RLDBText1: TRLDBText
        Left = 3
        Top = 6
        Width = 44
        Height = 16
        AutoSize = False
        DataField = 'ROOM'
        DataSource = MainForm.ReportDS
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'RoomTxt'
        Font.Style = []
        ParentFont = False
        Text = ''
      end
      object RLDBText2: TRLDBText
        Left = 47
        Top = 6
        Width = 226
        Height = 16
        AutoSize = False
        DataField = 'USEDBY'
        DataSource = MainForm.ReportDS
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'RoomTxt'
        Font.Style = []
        ParentFont = False
        Text = ''
      end
      object RLDBText3: TRLDBText
        Left = 283
        Top = 6
        Width = 126
        Height = 16
        AutoSize = False
        DataField = 'PNAME'
        DataSource = MainForm.ReportDS
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'RoomTxt'
        Font.Style = []
        ParentFont = False
        Text = ''
      end
      object PartnerNameLbl: TRLLabel
        Left = 415
        Top = 6
        Width = 300
        Height = 16
        AutoSize = False
      end
    end
    object HeaderB: TRLBand
      Left = 38
      Top = 38
      Width = 718
      Height = 35
      BandType = btHeader
      object RLLabel1: TRLLabel
        Left = 3
        Top = 13
        Width = 41
        Height = 16
        Caption = 'Raum'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object RLLabel2: TRLLabel
        Left = 47
        Top = 13
        Width = 92
        Height = 16
        Caption = 'Nutzer / Ger'#228't'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object RLLabel3: TRLLabel
        Left = 283
        Top = 13
        Width = 30
        Height = 16
        Caption = 'Port'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object RLLabel4: TRLLabel
        Left = 415
        Top = 13
        Width = 102
        Height = 16
        Caption = 'gepatcht nach'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
  end
  object RLPDFFilter1: TRLPDFFilter
    DocumentInfo.Creator = 
      'FortesReport Community Edition v4.0.0.1 \251 Copyright '#169' 1999-20' +
      '21 Fortes Inform'#225'tica'
    DisplayName = 'PDF Dokument'
    Left = 104
    Top = 168
  end
  object RLHTMLFilter1: TRLHTMLFilter
    DocumentStyle = dsCSS2
    DisplayName = 'Webseite'
    Left = 184
    Top = 168
  end
  object RLXLSXFilter1: TRLXLSXFilter
    DisplayName = 'Exceltabelle'
    Left = 272
    Top = 168
  end
end
