object InfrastructurePortFrame: TInfrastructurePortFrame
  Left = 0
  Top = 0
  Width = 944
  Height = 32
  TabOrder = 0
  OnResize = DBFrameResize
  OldCreateOrder = False
  PixelsPerInch = 0
  TextHeight = 0
  ClientWidth = 944
  ClientHeight = 32
  object Label1: TLabel
    Left = 3
    Top = 7
    Width = 177
    Height = 41
    Caption = 'Bezeichnung:'
  end
  object KommentarLbl: TLabel
    Left = 647
    Top = 7
    Width = 161
    Height = 41
    Caption = 'Kommentar:'
  end
  object Label3: TLabel
    Left = 163
    Top = 7
    Width = 83
    Height = 41
    Caption = 'Raum:'
  end
  object BenutztDurchLbl: TLabel
    Left = 287
    Top = 7
    Width = 192
    Height = 41
    Caption = 'Benutzt durch:'
  end
  object BezeichnungEdt: TDBEdit
    Left = 80
    Top = 3
    Width = 65
    Height = 49
    DataField = 'NAME'
    TabOrder = 0
  end
  object KommentarEdt: TDBEdit
    Left = 724
    Top = 3
    Width = 209
    Height = 49
    DataField = 'COMMENT'
    TabOrder = 1
  end
  object RaumEdt: TDBEdit
    Left = 203
    Top = 3
    Width = 65
    Height = 49
    DataField = 'ROOM'
    TabOrder = 2
  end
  object BenutztDurchEdt: TDBEdit
    Left = 370
    Top = 3
    Width = 269
    Height = 49
    DataField = 'USEDBY'
    TabOrder = 3
  end
end
