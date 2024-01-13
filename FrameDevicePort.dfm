object DevicePortFrame: TDevicePortFrame
  Left = 0
  Top = 0
  Width = 454
  Height = 34
  TabOrder = 0
  OldCreateOrder = False
  PixelsPerInch = 0
  TextHeight = 0
  ClientWidth = 454
  ClientHeight = 34
  DesignSize = (
    454
    34)
  object Label1: TLabel
    Left = 3
    Top = 7
    Width = 71
    Height = 15
    Caption = 'Bezeichnung:'
  end
  object Label2: TLabel
    Left = 155
    Top = 7
    Width = 66
    Height = 15
    Caption = 'Kommentar:'
  end
  object BezeichnungEdt: TDBEdit
    Left = 80
    Top = 3
    Width = 65
    Height = 23
    DataField = 'NAME'
    ReadOnly = True
    TabOrder = 0
  end
  object KommentarEdt: TDBEdit
    Left = 232
    Top = 3
    Width = 209
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    DataField = 'COMMENT'
    TabOrder = 1
  end
end
