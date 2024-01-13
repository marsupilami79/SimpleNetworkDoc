unit FormSelectPort;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Data.DB,
  ZAbstractRODataset, ZDataset, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids, NWDocTypes;

type
  TSelectPortForm = class(TForm)
    ListQ: TZReadOnlyQuery;
    UpBtn: TButton;
    ParentEdt: TEdit;
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    DBGrid1: TDBGrid;
    ListDS: TDataSource;
    procedure ListQAfterOpen(DataSet: TDataSet);
    procedure OkBtnClick(Sender: TObject);
    procedure UpBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private-Deklarationen }
    FSelectedPort: String;
    AssetType: TAssetType;
    AssetParent: String;
    AssetID: String;
    procedure UpdateView(NewID: String; NewType: TAssetType);
  public
    { Public-Deklarationen }
    property SelectedPort: String read FSelectedPort;
    procedure SetAsset(ID: String);
  end;

var
  SelectPortForm: TSelectPortForm;

function SelectPatchPort(StartAsset: String = ''): String;

implementation

uses Unit1, IksZeosHelper, CentralDM;

{$R *.dfm}


function SelectPatchPort(StartAsset: String = ''): String;
var
  Form: TSelectPortForm;
begin
  Application.CreateForm(TSelectPortForm, Form);
  try
    Form.SetAsset(StartAsset);
    if Form.ShowModal = mrOk then
      Result := Form.SelectedPort
    else
      Result := '';
  finally
    FreeAndNil(Form);
  end;
end;


procedure TSelectPortForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ListQ.Close;
end;

procedure TSelectPortForm.ListQAfterOpen(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID').Visible := False;
end;

procedure TSelectPortForm.OkBtnClick(Sender: TObject);
var
  NewType: TAssetType;
  NewName: String;
  NewParent: String;
begin
   if ListQ.Active and (ListQ.RecordCount > 0) then begin
     if AssetType = atDevice then begin
       FSelectedPort := ListQ.FieldByName('ID').AsString;
       ModalResult := mrOk;
     end else begin
       NewParent := AssetID;
       NewType := StrToAssetType(ListQ.FieldByName('TYPE').AsString);
       NewName := ParentEdt.Text;
       if NewName <> '' then
         NewName := NewName + ' -> ';
       NewName := NewName + ListQ.FieldByName('NAME').AsString;
       UpdateView(ListQ.FieldByName('ID').AsString, NewType);
       ParentEdt.Text := NewName;
       AssetParent := NewParent;
     end;
   end;
end;

procedure TSelectPortForm.SetAsset(ID: String);
var
  FullName: String;
  Parent: String;
  AssetType: TAssetType;
begin
  if ID <> '' then begin
    MainForm.getAssetInfo(ID, FullName, Parent, AssetType);
    ParentEdt.Text := FullName;
    UpdateView(ID, AssetType);
    AssetParent := Parent;
  end else begin
    ParentEdt.Text := '';
    AssetParent := '';
    UpdateView('', atBuilding);
  end;
end;

procedure TSelectPortForm.UpBtnClick(Sender: TObject);
begin
  SetAsset(AssetParent);
end;

procedure TSelectPortForm.UpdateView(NewID: String; NewType: TAssetType);
begin
  ListQ.Close;
  if NewID = '' then begin
    ListQ.SelectSQL('select ID, NAME from BUILDINGS');
    UpBtn.Enabled := False;
  end else begin
    case Newtype of
      atBuilding, atRoom, atRack: begin
        ListQ.SelectSQL('select ID, NAME, TYPE from PARENTS where PARENT = :P0', [NewID]);
        ListQ.FieldByName('TYPE').Visible := False;
      end;
      atDevice:
        ListQ.SelectSQL('select ID, NAME, COMMENT from PATCHPORTS PP where PP.DEVICE = :P0 and (SELECT count(*) from PATCHLINKS PL where PP.ID in (PL.PORT1, PL.PORT2)) = 0', [NewID]);
    end;
    UpBtn.Enabled := True;
  end;
  AssetType := NewType;
  AssetID := NewID;
end;

end.
