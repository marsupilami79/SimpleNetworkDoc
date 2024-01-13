program Project1;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {MainForm},
  FormAddPort in 'FormAddPort.pas' {AddPortsForm},
  Vcl.Themes,
  Vcl.Styles,
  FrameDevicePort in 'FrameDevicePort.pas' {DevicePortFrame: TFrame},
  FrameInfrastructurePort in 'FrameInfrastructurePort.pas' {InfrastructurePortFrame: TDBFrame},
  FormSelectPort in 'FormSelectPort.pas' {SelectPortForm},
  NWDocTypes in 'NWDocTypes.pas',
  FormWikiImport in 'FormWikiImport.pas' {WikiImportForm},
  ReportUsedList in 'ReportUsedList.pas' {UsedListRpt},
  CentralDM in 'Shared\CentralDM.pas' {DM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10 Clear Day');
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
