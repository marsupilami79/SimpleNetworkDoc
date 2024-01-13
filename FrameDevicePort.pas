unit FrameDevicePort;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DBFrames, Vcl.StdCtrls,
  Vcl.Mask, Vcl.ExtCtrls, Vcl.DBCtrls;

type
  TDevicePortFrame = class(TDBFrame)
    BezeichnungEdt: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    KommentarEdt: TDBEdit;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

implementation

{$R *.dfm}

end.
