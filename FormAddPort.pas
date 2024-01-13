unit FormAddPort;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.Buttons;

type
  TAddPortsForm = class(TForm)
    PrefixEdt: TEdit;
    FromNbrEdt: TSpinEdit;
    ToNbrEdt: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    PortTypeCB: TComboBox;
    Label4: TLabel;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  AddPortsForm: TAddPortsForm;

implementation

{$R *.dfm}

end.
