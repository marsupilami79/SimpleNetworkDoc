unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls,
  Vcl.StdCtrls, ZAbstractConnection, ZConnection, Vcl.ExtCtrls,
  FrameInfrastructurePort, FrameDevicePort, DBFrames, NWDocTypes, Vcl.DBCtrls;

type
  TAssetData = class
    AssetType: TAssetType;
    ID: String;
  end;

  TBuildingData = Class(TAssetData);

  TParentedAsset = Class(TAssetData)
    Parent: String;
  End;

  TRoomData = Class(TParentedAsset);

  TRackData = class(TParentedAsset);

  TDeviceData = class(TParentedAsset);

  TMainForm = class(TForm)
    AssetsTV: TTreeView;
    ListG: TDBGrid;
    ConnectBtn: TButton;
    AddRoomBtn: TButton;
    AddRackBtn: TButton;
    AddDeviceBtn: TButton;
    AddPortsBtn: TButton;
    DisplayP: TPanel;
    ButtonsP: TPanel;
    ListDS: TDataSource;
    PatchPathLbl: TLabel;
    PatchPathEdt: TEdit;
    AddRemovePatchBtn: TButton;
    WikiImportBtn: TButton;
    PrintUsageBtn: TButton;
    ReportQ: TZReadOnlyQuery;
    ReportDS: TDataSource;
    PortInfoNav: TDBNavigator;
    procedure ConnectBtnClick(Sender: TObject);
    procedure AssetsTVChange(Sender: TObject; Node: TTreeNode);
    procedure AddRoomBtnClick(Sender: TObject);
    procedure AddRackBtnClick(Sender: TObject);
    procedure AddDeviceBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AddPortsBtnClick(Sender: TObject);
    procedure WikiImportBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PrintUsageBtnClick(Sender: TObject);
  private
    { Private-Deklarationen }
    Margin: Integer;
    PortFrame: TDBFrame;
    AssetNameCache: TStringList;
    FIKSMode: Boolean;
    procedure AddAssetsFromQuery(ParentNode: TTreeNode; Query: TDataSet);
    procedure AddBuildingAssets(BuildingNode: TTreeNode);
    procedure AddRoomAssets(RoomNode: TTreeNode);
    procedure AddRackAssets(RackNode: TTreeNode);
    procedure AddRoomToNode(Node: TTreeNode; Src: TDataSet);
    procedure AddRackToNode(Node: TTReeNode; Src: TDataSet);
    procedure AddDeviceToNode(Node: TTReeNode; Src: TDataSet);
    procedure AddNodeChildAssets(Node: TTreeNode);
    procedure AddNodeAssets(Node: TTReeNode);
    procedure EnableOperations(AssetType: TAssetType);
    function GetPatchPartner(Port: String): String;
    function GetPatchPartnerName(Port: String): String;
    procedure GetPortInfo(const Port: String; out FullName, Room, UsedBy: String);
    procedure PatchBtnAddPatch(Sender: TObject);
    procedure PatchBtnRemovePatch(Sender: TObject);
    procedure ListQAfterClose(DataSet: TDataSet);
    procedure ListQAfterScroll(DataSet: TDataSet);
    procedure ListQAfterOpen(DataSet: TDataSet);
    procedure ListQCalcFields(DataSet: TDataSet);
  public
    { Public-Deklarationen }
    function GetPortFullName(Port: String): String;
    procedure GetAssetInfo(const ID: String; out FullName, Parent: String; out AssetType: TAssetType);
    function GetAssetFullName(ID: String): String;
    property IKSMode: Boolean read FIKSMode;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses IksZeosHelper, ZBase64, FormAddPort, FormSelectPort, FormWikiImport, ReportUsedList, IniFiles, CentralDM;

function StripFileExt(FileName: String): String;
begin
  result := copy(FileName, 1, Length(FileName) - Length(ExtractFileExt(FileName)));
end;

function GenBase64Uuid: String;
var
  Z: TBytes;
begin
  Setlength(Z, 16);
  CreateGUID(PGUID(@Z[0])^);
  Result := String(ZEncodeBase64(Z));
end;

procedure TMainForm.ConnectBtnClick(Sender: TObject);
var
  Node: TTreeNode;
  Data: TBuildingData;
  x: Integer;
begin
  DM.MainConn.Connect;
  DM.TempQ.SelectSQL('select * from buildings order by lower(name)');
  try
    while not DM.TempQ.Eof do begin
      Data := TBuildingData.Create;
      Data.AssetType := atBuilding;
      Data.ID := DM.TempQ.FieldByName('ID').AsString;
      Node := AssetsTV.Items.AddChildObject(nil,  {'🏠' +} DM.TempQ.FieldByName('NAME').AsString, Data);
      DM.TempQ.Next;
    end;
  finally
    DM.TempQ.Close;
  end;

  for x := AssetsTV.Items.Count - 1 downto 0 do begin
    AddNodeAssets(AssetsTV.Items[x]);
  end;

  AssetsTV.AlphaSort();

  ConnectBtn.Hide;
end;

procedure TMainForm.AddAssetsFromQuery(ParentNode: TTreeNode;  Query: TDataSet);
var
  AssetType: String;
begin
  while not Query.EOF do begin
    AssetType := Query.FieldByName('type').AsString;
    if AssetType = 'room' then
      AddRoomToNode(ParentNode, Query)
    else if AssetType = 'rack' then
      AddRackToNode(ParentNode, Query)
    else if AssetType = 'device' then
      AddDeviceToNode(ParentNode, Query);
    Query.Next;
  end;
end;

procedure TMainForm.AddBuildingAssets(BuildingNode: TTreeNode);
begin
  DM.TempQ.SelectSQL('select id, parent, name, cast(''room'' as varchar(50)) as type from rooms where parent = :P0 union all select id, parent, name, ''rack'' from racks where parent = :P0 union all select id, parent, name, ''device'' from devices where parent = :P0', [TBuildingData(BuildingNode.Data).ID]);
  try
    AddAssetsFromQuery(BuildingNode, DM.TempQ);
  finally
    DM.TempQ.Close;
  end;

  AddNodeChildAssets(BuildingNode);
end;

procedure TMainForm.AddRoomAssets(RoomNode: TTreeNode);
begin
  DM.TempQ.SelectSQL('select id, parent, name, cast(''rack'' as varchar(50)) as type from racks where parent = :P0 union all select id, parent, name, ''device'' from devices where parent = :P0', [TRoomData(RoomNode.Data).ID]);
  try
    AddAssetsFromQuery(RoomNode, DM.TempQ);
  finally
    DM.TempQ.Close;
  end;

  AddNodeChildAssets(RoomNode);
end;

procedure TMainForm.AddRoomBtnClick(Sender: TObject);
var
  RoomName: String;
  RoomId: String;
  ParentID: String;
  RoomData: TRoomData;
  Node: TTreeNode;
begin
  RoomName := Trim(InputBox('Neuer Name', 'Bitte den Namen des neuen Raums angeben:', ''));
  if RoomName <> '' then begin
    Node := AssetsTV.Selected;
    if Assigned(Node.Data) then begin
      ParentID := TAssetData(Node.Data).ID;
      RoomId := GenBase64Uuid;
      DM.TempQ.ExecuteSQL('insert into rooms (id, parent, name) values (:P0, :P1, :P2)', [RoomID, ParentID, RoomName]);

      RoomData := TRoomData.Create;
      RoomData.Parent := ParentID;
      RoomData.ID := RoomId;
      RoomData.AssetType := atRoom;
      AssetsTV.Items.AddChildObject(Node, RoomName, RoomData);
    end;
  end;
end;

procedure TMainForm.AddRackAssets(RackNode: TTreeNode);
begin
  DM.TempQ.SelectSQL('select id, name, parent, cast(''device'' as varchar(50)) as type from devices where parent = :P0', [TRackData(RackNode.Data).ID]);
  try
    AddAssetsFromQuery(RackNode, DM.TempQ);
  finally
    DM.TempQ.Close;
  end;

  AddNodeChildAssets(RackNode);
end;

procedure TMainForm.AddRackBtnClick(Sender: TObject);
var
  RackName: String;
  RackId: String;
  ParentID: String;
  RackData: TRackData;
  Node: TTreeNode;
begin
  RackName := Trim(InputBox('Neuer Name', 'Bitte den Namen des neuen Schranks angeben:', ''));
  if RackName <> '' then begin
    Node := AssetsTV.Selected;
    if Assigned(Node.Data) then begin
      ParentID := TAssetData(Node.Data).ID;
      RackId := GenBase64Uuid;
      DM.TempQ.ExecuteSQL('insert into racks (id, parent, name) values (:P0, :P1, :P2)', [RackID, ParentID, RackName]);

      RackData := TRackData.Create;
      RackData.Parent := ParentID;
      RackData.ID := RackId;
      RackData.AssetType := atRack;
      AssetsTV.Items.AddChildObject(Node, RackName, RackData);
    end;
  end;
end;

procedure TMainForm.AddRoomToNode(Node: TTreeNode; Src: TDataSet);
var
  Data: TRoomData;
begin
  Data := TRoomData.Create;
  Data.ID := Src.FieldByName('ID').AsString;
  Data.Parent := Src.FieldByName('PARENT').AsString;
  Data.AssetType := atRoom;
  AssetsTV.Items.AddChildObject(Node, {'🚪' +} Src.FieldByName('NAME').AsString, Data);
end;

procedure TMainForm.EnableOperations(AssetType: TAssetType);
begin
  AddRoomBtn.Enabled := AssetType in [atBuilding];
  AddRackBtn.Enabled := AssetType in [atBuilding, atRoom];
  AddDeviceBtn.Enabled := AssetType in [atBuilding, atRoom, atRack];
  AddPortsBtn.Enabled := AssetType in [atDevice];
  WikiImportBtn.Enabled := AssetType in [atDevice];
  PrintUsageBtn.Enabled := AssetType in [atRoom, atRack];
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  IniName: String;
  IniFile: TIniFile;
begin
  DM.ListQ.AfterOpen := ListQAfterOpen;
  DM.ListQ.AfterClose := ListQAfterClose;
  DM.ListQ.AfterScroll := ListQAfterScroll;
  DM.ListQ.OnCalcFields := ListQCalcFields;

  Margin := ListG.Left - AssetsTV.Left - AssetsTV.Width;
  DisplayP.Align := alClient;
  ButtonsP.Align := alBottom;

  AssetNameCache := TStringList.Create;
  AssetNameCache.NameValueSeparator := ':';

  IniName := StripFileExt(Application.ExeName);
  IniName := IniName + '.ini';

  if FileExists(IniName) then begin
    IniFile := TIniFile.Create(IniName);
    try
      FIKSMode := IniFile.ReadBool('generic', 'iksmode', false);
    finally
      FreeAndNil(IniFile);
    end;
  end;

  AddRoomBtn.Visible := IKSMode;
  AddRackBtn.Visible := IKSMode;
  AddDeviceBtn.Visible := IKSMode;
  AddPortsBtn.Visible := IKSMode;
  WikiImportBtn.Visible := IKSMode;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if Assigned(AssetNameCache) then
    FreeAndNil(AssetNameCache);
end;

procedure TMainForm.ListQAfterClose(DataSet: TDataSet);
begin
  if Assigned(PortFrame) then
    FreeAndNil(PortFrame);

  PatchPathLbl.Visible := False;
  PatchPathEdt.Visible := False;
  AddRemovePatchBtn.Visible := False;
end;

procedure TMainForm.ListQAfterOpen(DataSet: TDataSet);
begin
  PatchPathLbl.Visible := True;
  PatchPathEdt.Visible := True;
  AddRemovePatchBtn.Visible := True;
end;

procedure TMainForm.ListQAfterScroll(DataSet: TDataSet);
var
  PortType: String;
  PartnerName: String;

  procedure ReCreateFrame(FrameClass: TDBFrameClass);
  begin
    if not Assigned(PortFrame) or (FrameClass.ClassName <> PortFrame.ClassName) then begin
      if Assigned(PortFrame) then
        FreeAndNil(PortFrame);
      PortFrame := FrameClass.Create(DisplayP);
    end;
  end;
begin
  PortType := DataSet.FieldByName('TYPE').AsString;
  if PortType = 'i' then
    ReCreateFrame(TInfrastructurePortFrame)
  else if PortType = 'd' then
    ReCreateFrame(TDevicePortFrame);

  if Assigned((PortFrame)) then begin
    PortFrame.Parent := DisplayP;
    PortFrame.Top := ListG.Top + ListG.Height + Margin;
    PortFrame.Left := ListG.Left;
    PortFrame.Width := ListG.Width - PortInfoNav.Width - Margin;
    PortFrame.Anchors := [TAnchorKind.akLeft, TAnchorKind.akBottom, TAnchorKind.akRight];
    PortFrame.DataSource := ListDS;
    PortFrame.Visible := True;
  end;

  PartnerName := GetPatchPartnerName(DataSet.FieldByName('ID').AsString);
  PatchPathEdt.Text := PartnerName;
  if PartnerName = '' then begin
    AddRemovePatchBtn.Caption := 'Patch hinzufügen';
    AddRemovePatchBtn.OnClick := PatchBtnAddPatch;
  end else begin
    AddRemovePatchBtn.Caption := 'Patch entfernen';
    AddRemovePatchBtn.OnClick := PatchBtnRemovePatch;
  end;
end;

procedure TMainForm.ListQCalcFields(DataSet: TDataSet);
var
  PartnerPort: String;
  UsedBy, FullName, Room: String;
begin
  PartnerPort := GetPatchPartner(DM.ListQ.FieldByName('ID').AsString);
  if DataSet.FieldByName('TYPE').AsString = 'i' then begin
    DataSet.FieldByName('USEDBY_D').AsString := DataSet.FieldByName('USEDBY').AsString;
    DataSet.FieldByName('ROOM_D').AsString := DataSet.FieldByName('ROOM').AsString;
    FullName := GetPortFullName(PartnerPort);
  end else begin
    if PartnerPort <> '' then begin
      GetPortInfo(PartnerPort, FullName, Room, UsedBy);
      DataSet.FieldByName('USEDBY_D').AsString := UsedBy;
      DataSet.FieldByName('ROOM_D').AsString := Room;
    end;
  end;
  DataSet.FieldByName('PatchPartner').AsString := FullName;
end;

procedure TMainForm.AssetsTVChange(Sender: TObject; Node: TTreeNode);
var
  AssetType: TAssetType;
  AssetID: String;
begin
  if Assigned(Node.Data) then begin
    AssetType := TAssetData(Node.Data).AssetType;
    AssetID := TAssetData(Node.Data).ID;
    EnableOperations(AssetType);

    DM.ListQ.Close;
    if AssetType = atDevice then begin
      DM.ReloadPortList(AssetID);
    end;
  end;
end;

procedure TMainForm.PrintUsageBtnClick(Sender: TObject);
var
  Parent: String;
  Report: TUsedListRpt;
begin
  Parent := TAssetData(AssetsTV.Selected.Data).ID;
  ReportQ.ParamByName('PARENT').AsString := Parent;
  ReportQ.Open;
  try
    Report := TUsedListRpt.Create(self);
    try
      //Report.Rpt.Prepare;
      Report.Rpt.Preview;
    finally
      FreeAndNil(Report);
    end;
  finally
    ReportQ.Close;
  end;
end;

procedure TMainForm.AddRackToNode(Node: TTReeNode; Src: TDataSet);
var
  Data: TRackData;
begin
  Data := TRackData.Create;
  Data.ID := Src.FieldByName('ID').AsString;
  Data.Parent := Src.FieldByName('PARENT').AsString;
  Data.AssetType := atRack;
  AssetsTV.Items.AddChildObject(Node, {'🗄' +} Src.FieldByName('NAME').AsString, Data);
end;

procedure TMainForm.AddDeviceBtnClick(Sender: TObject);
var
  DeviceName: String;
  DeviceId: String;
  ParentID: String;
  DeviceData: TDeviceData;
  Node: TTreeNode;
begin
  DeviceName := Trim(InputBox('Neuer Name', 'Bitte den Namen des neuen Gerätes angeben:', ''));
  if DeviceName <> '' then begin
    Node := AssetsTV.Selected;
    if Assigned(Node.Data) then begin
      ParentID := TAssetData(Node.Data).ID;
      DeviceId := GenBase64Uuid;
      DM.TempQ.ExecuteSQL('insert into devices (id, parent, name) values (:P0, :P1, :P2)', [DeviceID, ParentID, DeviceName]);

      DeviceData := TDeviceData.Create;
      DeviceData.Parent := ParentID;
      DeviceData.ID := DeviceId;
      DeviceData.AssetType := atDevice;
      AssetsTV.Items.AddChildObject(Node, DeviceName, DeviceData);
    end;
  end;
end;

procedure TMainForm.AddDeviceToNode(Node: TTReeNode; Src: TDataSet);
var
  Data: TDeviceData;
begin
  Data := TDeviceData.Create;
  Data.ID := Src.FieldByName('ID').AsString;
  Data.Parent := Src.FieldByName('PARENT').AsString;
  Data.AssetType := atDevice;
  AssetsTV.Items.AddChildObject(Node, {'💻' +} Src.FieldByName('NAME').AsString, Data);
end;

procedure TMainForm.AddNodeChildAssets(Node: TTreeNode);
var
  Child: TTreeNode;
begin
  Child := Node.getFirstChild;

  while Assigned(Child) do begin
    AddNodeAssets(Child);
    Child := Child.getNextSibling;
  end;
end;

procedure TMainForm.AddPortsBtnClick(Sender: TObject);
var
  Form: TAddPortsForm;
  AssetID: String;
  x: Integer;
  PortType: String;
  PortPrefix: String;
  PortMax: Integer;
begin
  if Assigned(AssetsTV.Selected.Data) then begin
     if TAssetData(AssetsTV.Selected.Data).AssetType = atDevice then
       AssetID := TAssetData(AssetsTV.Selected.Data).ID;
  end;

  if AssetID <> '' then begin
    Form := TAddPortsForm.Create(Self);
    try
      Form.ShowModal;
      if Form.ModalResult = mrOk then begin
        if Form.PortTypeCB.ItemIndex = 0 then
          PortType := 'd'
        else
          PortType := 'i';

        PortPrefix := Trim(Form.PrefixEdt.Text);

        PortMax := DM.TempQ.GetSingletonSelect('select coalesce(max(ordernr), 0) from patchports where device = :P0', [AssetID]);

        DM.TempQ.SQL.Text := 'insert into patchports (ID, DEVICE, TYPE, NAME, ORDERNR, LDAT) values (:ID, :DEVICE, :TYPE, :NAME, :ORDERNR, CAST(''NOW'' as TIMESTAMP))';
        DM.TempQ.ParamByName('DEVICE').AsString := AssetID;
        DM.TempQ.ParamByName('TYPE').AsString := PortType;

        for x := Form.FromNbrEdt.Value to Form.ToNbrEdt.Value do begin
          DM.TempQ.ParamByName('ID').AsString := GenBase64Uuid;
          DM.TempQ.ParamByName('NAME').AsString := PortPrefix + IntToStr(x);
          DM.TempQ.ParamByName('ORDERNR').AsInteger := x + PortMax;
          DM.TempQ.ExecSQL;
        end;
      end;
    finally
      FreeAndNil(Form);
    end;

    DM.ReloadPortList;
  end;
end;

procedure TMainForm.AddNodeAssets(Node: TTReeNode);
begin
  if Assigned(Node.Data) then begin
    case TAssetData(Node.Data).AssetType of
      atBuilding: AddBuildingAssets(Node);
      atRoom: AddRoomAssets(Node);
      atRack: AddRackAssets(Node);
      atDevice: ;
    end;
  end;
end;

function TMainForm.GetPatchPartner(Port: String): String;
begin
  DM.TempQ.SQL.Text := 'select PORT1, PORT2 from patchlinks where :ID in (PORT1, PORT2)';
  DM.TempQ.ParamByName('ID').AsString := Port;
  DM.TempQ.Open;
  try
    if DM.TempQ.RecordCount = 0 then
      Result := ''
    else begin
      Result := DM.TempQ.FieldByName('PORT1').AsString;
      if Port = Result then
        Result := DM.TempQ.FieldByName('PORT2').AsString;
    end;
  finally
    DM.TempQ.Close;
  end;
end;


function TMainForm.GetPatchPartnerName(Port: String): String;
var
  PartnerPort: String;
  Parent: String;
begin
  PartnerPort := GetPatchPartner(Port);
  if PartnerPort = '' then
    Result := ''
  else
    Result := GetPortFullName(PartnerPort);
end;

function TMainForm.GetPortFullName(Port: String): String;
var
  Parent: String;
begin
  try
    // Device bestimmen
    DM.TempQ.SelectSQL('select DEVICE, NAME from patchports where ID = :P0', [Port]);
    Parent := DM.TempQ.FieldByName('DEVICE').AsString;
    Result := DM.TempQ.FieldByName('NAME').AsString;
  finally
    DM.TempQ.Close;
  end;

  if Parent <> '' then
    Result := GetAssetFullName(Parent) + ' -> ' + Result;
end;

procedure TMainForm.GetPortInfo(const Port: String; out FullName, Room, UsedBy: String);
begin
  DM.TempQ.SelectSQL('select USEDBY, ROOM from PATCHPORTS where ID = :P0', [Port]);
  try
    if DM.TempQ.RecordCount > 0 then begin
      Room := DM.TempQ.FieldByName('ROOM').AsString;
      UsedBy := DM.TempQ.FieldByName('USEDBY').AsString;
    end else begin
      Room := '';
      UsedBy := '';
    end;
  finally
    DM.TempQ.Close;
  end;
  FullName := GetPortFullName(Port);
end;


procedure TMainForm.PatchBtnAddPatch(Sender: TObject);
var
  PatchPartner: String;
  CurrentPort: String;
  Parent: String;
begin
  if Assigned(AssetsTV.Selected.Parent) then begin
    if Assigned(AssetsTV.Selected.Parent.Data) then
      Parent := TAssetData(AssetsTV.Selected.Parent.Data).ID;
  end else begin
    Parent := '';
  end;

  PatchPartner := SelectPatchPort(Parent);
  if (PatchPartner <> '') then begin
    CurrentPort := DM.ListQ.FieldByName('ID').AsString;
    if CurrentPort <> PatchPartner then begin
      DM.TempQ.ExecuteSQL('insert into patchlinks (ID, PORT1, PORT2) values (:P0, :P1, :P2)', [GenBase64UUID, CurrentPort, PatchPartner]);
      AddRemovePatchBtn.Caption := 'Patch entfernen';
      AddRemovePatchBtn.OnClick := PatchBtnRemovePatch;
      PatchPathEdt.Text := GetPortFullName(PatchPartner);
      DM.ListQ.Edit;
      DM.ListQ.Post;
    end else begin
      MessageDlg('Kannst du nicht verbinden Port mit sich selbst.', TMsgDlgType.mtError, [mbOk], 0);
    end;
  end;
end;

procedure TMainForm.PatchBtnRemovePatch(Sender: TObject);
begin
  if DM.ListQ.Active and (DM.ListQ.RecordCount > 0) then begin
    DM.TempQ.ExecuteSQL('delete from patchlinks where :P0 in (PORT1, PORT2)', [DM.ListQ.FieldByName('ID').AsString]);
    PatchPathEdt.Text := '';
    AddRemovePatchBtn.Caption := 'Patch hinzufügen';
    AddRemovePatchBtn.OnClick := PatchBtnAddPatch;
    DM.ListQ.Edit;
    DM.ListQ.Post;
  end;
end;

procedure TMainForm.WikiImportBtnClick(Sender: TObject);
var
  Form: TWikiImportForm;
begin
  Form := TWikiImportForm.Create(self);
  try
    Form.DeviceName := AssetsTV.Selected.Text;
    Form.DeviceID := TAssetData(AssetsTV.Selected.Data).ID;
    Form.ShowModal;
  finally
    FreeAndNil(Form);
  end;

  DM.ReloadPortList;
end;

procedure TMainForm.GetAssetInfo(const ID: String; out FullName, Parent: String; out AssetType: TAssetType);
var
  ParentFullName: String;
begin
  DM.TempQ.SelectSQL('select * from parents where ID = :P0', [ID]);
  try
    FullName := DM.TempQ.FieldByName('NAME').AsString;
    Parent := DM.TempQ.FieldByName('PARENT').AsString;
    AssetType := StrToAssetType(DM.TempQ.FieldByName('TYPE').AsString);
  finally
    DM.TempQ.Close;
  end;

  ParentFullName := GetAssetFullName(Parent);
  if ParentFullName <> '' then
    FullName := ParentFullName + ' -> ' + FullName;
end;

function TMainForm.GetAssetFullName(ID: String): String;
var
  Parent: String;
  ParentName: String;
begin
  Result := AssetNameCache.Values[ID];
  if Result = '' then begin
    DM.TempQ.SelectSQL('select name, parent from parents where id = :P0', [ID]);
    try
      if DM.TempQ.RecordCount = 0 then
        Parent := ''
      else begin
        Parent := DM.TempQ.FieldByName('PARENT').AsString;
        Result := DM.TempQ.FieldByName('NAME').AsString + Result;
      end;
    finally
      DM.TempQ.Close;
    end;

    if Result <> '' then begin
      if Parent <> '' then
        ParentName := GetAssetFullName(Parent);
      if Parent <> '' then
        Result := ParentName + ' -> ' + Result;
      AssetNameCache.Add(ID + ':' + Result);
    end;
  end;
end;


end.
