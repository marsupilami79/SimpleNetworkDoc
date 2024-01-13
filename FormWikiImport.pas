unit FormWikiImport;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SynEdit, Vcl.StdCtrls, ZAbstractDataset,
  ZDataset, Data.DB, ZAbstractRODataset;

type
  TWikiImportForm = class(TForm)
    ReplacementM: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    WikiTextM: TSynEdit;
    TempQ: TZReadOnlyQuery;
    PatchQ: TZQuery;
    ImportBtn: TButton;
    PortQ: TZQuery;
    procedure ImportBtnClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    DeviceID: String;
    DeviceName: String;
  end;

var
  WikiImportForm: TWikiImportForm;

implementation

uses Unit1, Types, IksTools, IksZeosHelper, CentralDM;

{$R *.dfm}

procedure TWikiImportForm.ImportBtnClick(Sender: TObject);
var
  LineNo: Integer;
  Line: String;
  Fields: TStringDynArray;
  Room, UsedBy, MyPort, TargetDev, TargetPort, Comment: String;

  Position: Integer;
  TempStr: String;
  isPhonePort: Boolean;
const
  cnRoom = 0;
  cnUsedBy = 1;
  cnPort = 2;
  cnTarget = 3;
  cnComment = 4;

  function CleanupField(const InStr: String): String;
  begin
    Result := Trim(InStr);
    if Result = '---' then
      Result := ''
  end;
begin
  PatchQ.Connection.StartTransaction;
  try
    for LineNo := 0 to WikiTextM.Lines.Count do begin
      Line := WikiTextM.Lines.Strings[LineNo];
      if trim(Line) = '' then
        break;
      Fields := Explode(Line, '|');

      Room := CleanupField(Fields[cnRoom]);
      UsedBy := CleanupField(Fields[cnUsedBy]);
      MyPort := CleanupField(Fields[cnPort]);
      TargetPort := CleanupField(Fields[cnTarget]);
      Comment := CleanupField(Fields[cnComment]);

      if TargetPort <> '' then begin
        Position := Pos('/', TargetPort);
        if Position = 0  then
          raise Exception.Create('/ nicht in >' + TargetPort + '< gefunden');

        TargetDev := Copy(TargetPort, 1, Position - 1);
        Delete(TargetPort, 1, Position);

        isPhonePort := TargetDev = 'TK';

        if isPhonePort then begin
          Position := Pos('/', TargetPort);
          if Position > 0 then
            TargetPort[Position] := '.';
        end;

        TempStr := ReplacementM.Lines.Values[TargetDev];
        if TempStr <> '' then
          TargetDev := TempStr;

        TargetDev := TempQ.GetSingletonSelect('select id from devices where NAME = :P0', [TargetDev]);

        TargetPort := TempQ.GetSingletonSelect('select id from patchports where device = :P0 and NAME = :P1', [TargetDev, TargetPort]);

        if MyPort.StartsWith(DeviceName) then
          Delete(MyPort, 1, length(DeviceName));

        MyPort := TempQ.GetSingletonSelect('select id from patchports where device = :P0 and NAME = :P1', [DeviceID, MyPort]);

        PatchQ.ParamByName('PORT1').AsString := MyPort;
        PatchQ.ParamByName('PORT2').AsString := TargetPort;
        PatchQ.Open;

        try
          if PatchQ.RecordCount = 0 then begin
            PatchQ.Append;
            try
              PatchQ.FieldByName('ID').AsString := GenBase64UUID;
              PatchQ.FieldByName('PORT1').AsString := MyPort;
              PatchQ.FieldByName('PORT2').AsString := TargetPort;
              PatchQ.Post
            except
              PatchQ.Cancel;
              raise;
            end;
          end else begin
            PatchQ.Edit;
            try
              if PatchQ.FieldByName('PORT1').AsString = MyPort then
                PatchQ.FieldByName('PORT2').AsString := TargetPort
              else
                PatchQ.FieldByName('PORT1').AsString := TargetPort;
              PatchQ.Post;
            except
              PatchQ.Cancel;
              raise;
            end;
          end;
        finally
          PatchQ.Close;
        end;

        PortQ.ParamByName('PORT').AsString := MyPort;
        PortQ.Open;
        try
          if PortQ.RecordCount = 0 then
            raise Exception.Create('Port ' + MyPort + ' nicht gefunden.');

          PortQ.Edit;
          try
            if Room <> '' then
              PortQ.FieldByName('ROOM').AsString := Room;
            if UsedBy <> '' then
              PortQ.FieldByName('USEDBY').AsString := UsedBy;
            if Comment <> '' then
              PortQ.FieldByName('COMMENT').AsString := Comment;
            PortQ.Post;
          except
            PortQ.Cancel;
            raise;
          end;
        finally
          PortQ.Close;
        end;
      end;
    end;

    PatchQ.Connection.Commit;
  except
    PatchQ.Connection.Rollback;
    raise;
  end;
  ShowMessage('Import erfolgreich.');
end;

end.
