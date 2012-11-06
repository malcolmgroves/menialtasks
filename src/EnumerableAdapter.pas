unit EnumerableAdapter;

interface

uses
  System.SysUtils, System.Variants, System.Classes, System.Rtti, System.Bindings.Outputs,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.ObjectScope,
  Generics.Collections;

type

  TBaseEnumerableBindSourceAdapter = class(TBaseListBindSourceAdapter)
  protected
    function GetCanModify: Boolean; override;
    function GetCanActivate: Boolean; override;
    function SupportsNestedFields: Boolean; override;
    procedure AddFields; virtual;
  public
    procedure Edit(AForce: Boolean); override;
    procedure Reload; virtual; // Reload enumerator
    procedure Cancel;  // Cancel pending edits
  end;

  TEnumerableBindSourceAdapter<T: class> = class(TBaseEnumerableBindSourceAdapter)
  private
    FArray: TArray<T>;
    FEnumerable: TEnumerable<T>;
  protected
    function GetObjectType: TRttiType; override;
    function GetCurrent: TObject; override;
    function GetCount: Integer; override;
  public
    constructor Create(AOwner: TComponent; const AEnumerable: TEnumerable<T>); reintroduce; overload; virtual;
    procedure Reload; override;
    procedure SetEnumerable(const AValue: TEnumerable<T>);
    function GetEnumerable: TEnumerable<T>;
    function Current : T;
  end;

implementation

{ TBaseEnumerableBindSourceAdapter }

procedure TBaseEnumerableBindSourceAdapter.AddFields;
var
  LType: TRttiType;
  LGetMemberObject: IGetMemberObject;
begin
  LType := GetObjectType;
  LGetMemberObject := TBindSourceAdapterGetMemberObject.Create(Self);
  AddFieldsToList(LType, Self, Self.Fields, LGetMemberObject);
  AddPropertiesToList(LType, Self, Self.Fields, LGetMemberObject);
end;

procedure TBaseEnumerableBindSourceAdapter.Cancel;
var
  LScope: TBaseObjectBindSource;
begin
  // Cancel pending edits in any bind sources that are using this adapter
  for LScope in Scopes do
  begin
    if LScope.Editing then
      LScope.Cancel;
  end;
end;

function TBaseEnumerableBindSourceAdapter.SupportsNestedFields: Boolean;
begin
  Result := True;
end;

function TBaseEnumerableBindSourceAdapter.GetCanActivate: Boolean;
begin
  Result := True;
end;

procedure TBaseEnumerableBindSourceAdapter.Edit(AForce: Boolean);
begin
  if GetCount = 0 then
    Exit;               // Prevent auto insert
  inherited;
end;

function TBaseEnumerableBindSourceAdapter.GetCanModify: Boolean;
begin
  Result := (GetCount > 0) and  (loptAllowModify in Options);

end;

procedure TBaseEnumerableBindSourceAdapter.Reload;
begin
  //
end;

{ TEnumerableBindSourceAdapter<T> }

constructor TEnumerableBindSourceAdapter<T>.Create(AOwner: TComponent; const AEnumerable: TEnumerable<T>);
begin
  Create(AOwner);
  AddFields;
  SetEnumerable(AEnumerable);
end;

procedure TEnumerableBindSourceAdapter<T>.SetEnumerable(const AValue: TEnumerable<T>);
begin
  FEnumerable := AValue;
  Reload;
end;

function TEnumerableBindSourceAdapter<T>.GetEnumerable: TEnumerable<T>;
begin
  Result := FEnumerable;
end;

function TEnumerableBindSourceAdapter<T>.Current: T;
begin
  Result := T(GetCurrent);
end;

function TEnumerableBindSourceAdapter<T>.GetCount: Integer;
begin
  Result := Length(FArray);
end;

function TEnumerableBindSourceAdapter<T>.GetCurrent: TObject;
begin
  if (ItemIndex >= 0) and (ItemIndex + ItemIndexOffset < GetCount) then
    Result := FArray[ItemIndex +  ItemIndexOffset]
  else
    Result := nil;
end;

function TEnumerableBindSourceAdapter<T>.GetObjectType: TRttiType;
var
  LType: TRttiType;
  LCtxt: TRttiContext;
begin
  LType := LCtxt.GetType(TypeInfo(T));
  Result := LType;
end;

procedure TEnumerableBindSourceAdapter<T>.Reload;
var
  LItem: T;
  LScope: TBaseObjectBindSource;
  LActive: Boolean;
begin
  // Make sure fields are not holding buffered edits
  Cancel;
  // Toggle Active to update controls
  LActive := Active;
  Active := False;
  if FEnumerable <> nil then
    FArray := FEnumerable.ToArray
  else
    FArray := nil;
  // Make sure itemindex is in range
  if ItemIndex > GetCount then
    ItemIndex := GetCount-1;
  Active := LActive;
end;

end.
