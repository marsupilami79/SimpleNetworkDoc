unit NWDocTypes;

interface

type
  TAssetType = (atBuilding, atRoom, atRack, atDevice);

function StrToAssetType(TypeStr: String): TAssetType;

implementation

uses SysUtils;

function StrToAssetType(TypeStr: String): TAssetType;
begin
  TypeStr := LowerCase(TypeStr);
  if TypeStr = 'device' then
    Result := atDevice
  else if TypeStr = 'rack' then
    Result := atRack
  else if TypeStr = 'room' then
    Result := atRoom
  else if TypeStr = 'building' then
    Result := atBuilding
  else
    raise Exception.Create('Cannot convert asset type name >' + TypeStr + ' to an asset type.');
end;

end.
