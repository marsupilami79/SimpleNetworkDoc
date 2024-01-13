object DM: TDM
  Height = 213
  Width = 277
  object MainConn: TZConnection
    ControlsCodePage = cCP_UTF16
    ClientCodepage = 'UTF8'
    Catalog = ''
    Properties.Strings = (
      'codepage=UTF8'
      'RawStringEncoding=DB_CP')
    AutoEncodeStrings = False
    HostName = 'www.iks.ag'
    Port = 0
    Database = 'nwd_tmhg'
    User = 'TMHG'
    Password = 'aMu6ohNucheu9EQunoo7GiejRa0Sie7v'
    Protocol = 'WebServiceProxy'
    Left = 40
    Top = 16
  end
  object ListQ: TZQuery
    Connection = MainConn
    Params = <>
    Left = 128
    Top = 16
  end
  object TempQ: TZReadOnlyQuery
    Connection = MainConn
    Params = <>
    Options = [doCalcDefaults, doPreferPrepared]
    Left = 40
    Top = 72
  end
end
