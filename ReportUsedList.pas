unit ReportUsedList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RLReport, RLXLSXFilter, RLHTMLFilter,
  RLFilters, RLPDFFilter;

type
  TUsedListRpt = class(TForm)
    Rpt: TRLReport;
    DetailsB: TRLBand;
    HeaderB: TRLBand;
    RLLabel1: TRLLabel;
    RLLabel2: TRLLabel;
    RLLabel3: TRLLabel;
    RLLabel4: TRLLabel;
    RLDBText1: TRLDBText;
    RLDBText2: TRLDBText;
    RLDBText3: TRLDBText;
    PartnerNameLbl: TRLLabel;
    RLPDFFilter1: TRLPDFFilter;
    RLHTMLFilter1: TRLHTMLFilter;
    RLXLSXFilter1: TRLXLSXFilter;
    procedure DetailsBBeforePrint(Sender: TObject; var PrintIt: Boolean);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  UsedListRpt: TUsedListRpt;

implementation

uses Unit1, CentralDM;

{$R *.dfm}

procedure TUsedListRpt.DetailsBBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  PrintIt := True;
  PartnerNameLbl.Caption := MainForm.GetPortFullName(MainForm.ReportQ.FieldByName('PARTNERPORT').AsString);
end;

end.
