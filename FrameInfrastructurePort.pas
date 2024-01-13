unit FrameInfrastructurePort;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DBFrames, Vcl.StdCtrls,
  Vcl.Mask, Vcl.ExtCtrls, Vcl.DBCtrls;

type
  TInfrastructurePortFrame = class(TDBFrame)
    BezeichnungEdt: TDBEdit;
    Label1: TLabel;
    KommentarLbl: TLabel;
    KommentarEdt: TDBEdit;
    Label3: TLabel;
    RaumEdt: TDBEdit;
    BenutztDurchLbl: TLabel;
    BenutztDurchEdt: TDBEdit;
    procedure DBFrameResize(Sender: TObject);
  private
    { Private-Deklarationen }
    Margin: Integer;
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

constructor TInfrastructurePortFrame.Create(AOwner: TComponent);
begin
  inherited;
  Margin := BenutztDurchEdt.Left - BenutztDurchLbl.Left - BenutztDurchLbl.Width;
end;

procedure TInfrastructurePortFrame.DBFrameResize(Sender: TObject);
var
  EditWidth: Integer;
begin
  if Margin > 0 then begin
     EditWidth := (ClientWidth - BenutztDurchEdt.Left - KommentarLbl.Width - 3 * Margin) div 2;
     BenutztDurchEdt.Width := EditWidth;
     KommentarLbl.Left := BenutztDurchEdt.Left + BenutztDurchEdt.Width + 2 * Margin;
     KommentarEdt.Left := KommentarLbl.Left + KommentarLbl.Width + Margin;
     KommentarEdt.Width := EditWidth;
  end;
end;

end.
