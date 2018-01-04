unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WinSock, ComObj, StdCtrls, XPMan, ActiveX, ComCtrls, IniFiles;

type
  TMain = class(TForm)
    RefreshBtn: TButton;
    AddBtn: TButton;
    XPManifest1: TXPManifest;
    RemBtn: TButton;
    ListView: TListView;
    AbtBtn: TButton;
    procedure RefreshBtnClick(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure RemBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AbtBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Main: TMain;

  //Перевод / Translate
  ID_STATUS_ON, ID_STATUS_OFF, ID_ERROR_WITH_LISTING_UPNP_PORTS,
  ID_ERROR_WITH_ADD_PORT, ID_ERROR_WITH_REM_PORT, ID_ENTER_APP_NAME,
  ID_ENTER_PORT_NUM, ID_CHOOSE_PROTOCOL, ID_ADDED_PORT, ID_INVALID_PORT: string;

  ID_LAST_UPDATE, ID_ABOUT_TITLE: string;

implementation

{$R *.dfm}

function GetLocalIP: string;
const
  WSVer = $101;
var
  wsaData: TWSAData;
  P: PHostEnt;
  Buf: array [0..127] of Char;
begin
  Result:='';
  if WSAStartup(WSVer, wsaData) = 0 then begin
    if GetHostName(@Buf, 128) = 0 then begin
      P := GetHostByName(@Buf);
      if P <> nil then
        Result:=iNet_ntoa(PInAddr(p^.h_addr_list^)^);
    end;
    WSACleanup;
  end;
end;

procedure ListUPnPEntry;
var
  Nat: Variant;
  Ports: Variant;
  Enum : IEnumVARIANT;
  MyPort: OLEVariant;
  I, IntPort, ExtPort : Integer;
  Desc, Protocol, IntClient, ExtIP: WideString;
  Enabled: Boolean;
  iValue: LongWord;
  Status: string;
  Item: TListItem;
begin
  Main.ListView.Clear;
  try
    Nat:=CreateOleObject('HNetCfg.NATUPnP');
    Ports:=Nat.StaticPortMappingCollection;

   if not VarIsClear(Ports) then begin
      Enum:=IUnknown(Ports._NewEnum) as IEnumVARIANT;
      while Enum.Next(1, MyPort, iValue) = S_OK do begin
        Desc:=MyPort.Description;
        Enabled:=MyPort.Enabled;
        ExtIP:=MyPort.ExternalIPAddress;
        ExtPort:=MyPort.ExternalPort;
        IntClient:=MyPort.InternalClient;
        IntPort:=MyPort.InternalPort;
        Protocol:=MyPort.Protocol;
        if Enabled then
          Status:=ID_STATUS_ON
        else
          Status:=ID_STATUS_OFF;
        Item:=Main.ListView.Items.Add;
        Item.Caption:=Desc;
        Item.SubItems.Add(Protocol);
        Item.SubItems.Add(IntToStr(ExtPort));
        Item.SubItems.Add(IntToStr(IntPort));
        Item.SubItems.Add(IntClient);
        Item.SubItems.Add(Status);
      end;
    end;

  except
    Application.MessageBox(PChar(ID_ERROR_WITH_LISTING_UPNP_PORTS), PChar(Main.Caption), MB_ICONINFORMATION);
  end;
end;


function AddUPnPPort(Port: Integer; const Name: ShortString; isTCP: boolean; LAN_IP: string): boolean;
var
  Nat: Variant;
  Ports: Variant;
begin
  if not (LAN_IP = '127.0.0.1') then
    try
      Nat:=CreateOleObject('HNetCfg.NATUPnP');
      Ports:=Nat.StaticPortMappingCollection;

      if not VarIsClear(Ports) then begin
        if isTCP then
          Ports.Add(Port, 'TCP', Port, LAN_IP, True, name)
        else
          Ports.Add(Port, 'UDP', Port, LAN_IP, True, name);
        Result:=true;
      end;
    except
      Result:=false;
    end;
end;

function RemoveUPnPPort(Port: Integer; isTCP: boolean): boolean;
var
  Nat: Variant;
  Ports: Variant;
begin
  try
    Nat:=CreateOleObject('HNetCfg.NATUPnP');
    Ports:=Nat.StaticPortMappingCollection;
    if isTCP then
      Ports.Remove(Port, 'TCP')
    else
      Ports.Remove(Port, 'UDP');
    Result:=true;
  except
    Result:=false;
  end;
end;

procedure TMain.RefreshBtnClick(Sender: TObject);
begin
  ListUPnPEntry;
end;

procedure TMain.AddBtnClick(Sender: TObject);
var
  Value, Value2: string;
  iValue, iCode: Integer;
  isTCP: boolean;
begin
  if InputQuery(Caption, ID_ENTER_APP_NAME, Value) and InputQuery(Caption, ID_ENTER_PORT_NUM, Value2) then
    Val(Value2, iValue, iCode);

  if (Trim(Value) = '') or (iCode <> 0) or (iValue = 80) then begin
    Application.MessageBox(PChar(ID_INVALID_PORT), PChar(Caption), MB_ICONINFORMATION);
    Exit;
  end;

  case MessageBox(Handle, PChar(ID_CHOOSE_PROTOCOL), PChar(Caption), MB_YESNO + MB_ICONQUESTION) of
    6: isTCP:=true;
    7: isTCP:=false;
  end;

  if AddUPnPPort(iValue, Value, isTCP, GetLocalIP) then begin
    Application.MessageBox(PChar(Format(ID_ADDED_PORT, [iValue, Value])), PChar(Caption), MB_ICONINFORMATION);
    ListUPnPEntry;
  end else
    Application.MessageBox(PChar(ID_ERROR_WITH_ADD_PORT), PChar(Caption), MB_ICONINFORMATION);
end;

procedure TMain.RemBtnClick(Sender: TObject);
var
  Item: TListItem; isTCP: boolean;
begin
  if ListView.Selected <> nil then begin
    Item:=ListView.Items.Item[ListView.Selected.Index];

    if Item.SubItems[0] = 'TCP' then
      isTCP:=true
    else
      isTCP:=false;

    if RemoveUPnPPort(StrToInt(Item.SubItems[1]), isTCP) then
      ListUPnPEntry
    else
      Application.MessageBox(PChar(ID_ERROR_WITH_REM_PORT), PChar(Caption), MB_ICONINFORMATION);
  end;
end;

function GetLocaleInformation(Flag: Integer): string;
var
  pcLCA: array [0..20] of Char;
begin
  if GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, Flag, pcLCA, 19) <= 0 then
    pcLCA[0]:=#0;
  Result:=pcLCA;
end;

procedure TMain.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
begin
  if (LowerCase(ParamStr(1))= '/add') and (ParamStr(2) <> '') and (ParamStr(3) <> '') and (ParamStr(4) <> '') then begin
    Application.ShowMainForm:=false;
    if LowerCase(ParamStr(4)) = 'tcp' then
      AddUPnPPort(StrToInt(ParamStr(3)), ParamStr(2), true, GetLocalIP)
    else
      AddUPnPPort(StrToInt(ParamStr(3)), ParamStr(2), false, GetLocalIP);
    Application.Terminate;
  end;

  if (LowerCase(ParamStr(1)) = '/remove') and (ParamStr(2) <> '') and (ParamStr(3) <> '') then begin
    Application.ShowMainForm:=false;
    if LowerCase(ParamStr(3)) = 'tcp' then
      RemoveUPnPPort(StrToInt(ParamStr(2)), true)
    else
      RemoveUPnPPort(StrToInt(ParamStr(2)), false);
    Application.Terminate;
  end;

  Application.Title:=Caption;

  //Перевод / Translate
  if FileExists(ExtractFilePath(ParamStr(0)) + 'Languages\' + GetLocaleInformation(LOCALE_SENGLANGUAGE) + '.ini') then
    Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Languages\' + GetLocaleInformation(LOCALE_SENGLANGUAGE) + '.ini')
  else
    Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Languages\English.ini');

  ListView.Columns[0].Caption:=Ini.ReadString('Main', 'ID_DESC_APP', '');
  ListView.Columns[1].Caption:=Ini.ReadString('Main', 'ID_PROTOCOL', '');
  ListView.Columns[2].Caption:=Ini.ReadString('Main', 'ID_EXTERNAL_PORT', '');
  ListView.Columns[3].Caption:=Ini.ReadString('Main', 'ID_INTERNAL_PORT', '');
  ListView.Columns[4].Caption:=Ini.ReadString('Main', 'ID_IP_ADDRESS', '');
  ListView.Columns[5].Caption:=Ini.ReadString('Main', 'ID_STATE', '');
  RefreshBtn.Caption:=Ini.ReadString('Main', 'ID_REFRESH', '');
  AddBtn.Caption:=Ini.ReadString('Main', 'ID_ADD_PORT', '');
  RemBtn.Caption:=Ini.ReadString('Main', 'ID_REM_PORT', '');

  ID_STATUS_ON:=Ini.ReadString('Main', 'ID_STATUS_ON', '');
  ID_STATUS_OFF:=Ini.ReadString('Main', 'ID_STATUS_OFF', '');
  ID_ERROR_WITH_LISTING_UPNP_PORTS:=Ini.ReadString('Main', 'ID_ERROR_WITH_LISTING_UPNP_PORTS', '');

  ID_ERROR_WITH_ADD_PORT:=Ini.ReadString('Main', 'ID_ERROR_WITH_ADD_PORT', '');
  ID_ERROR_WITH_REM_PORT:=Ini.ReadString('Main', 'ID_ERROR_WITH_REM_PORT', '');
  ID_ENTER_APP_NAME:=Ini.ReadString('Main', 'ID_ENTER_APP_NAME', '');
  ID_ENTER_PORT_NUM:=Ini.ReadString('Main', 'ID_ENTER_PORT_NUM', '');
  ID_CHOOSE_PROTOCOL:=Ini.ReadString('Main', 'ID_CHOOSE_PROTOCOL', '');
  ID_ADDED_PORT:=Ini.ReadString('Main', 'ID_ADDED_PORT', '');
  ID_INVALID_PORT:=Ini.ReadString('Main', 'ID_INVALID_PORT', '');

  ID_LAST_UPDATE:=Ini.ReadString('Main', 'ID_LAST_UPDATE', '');
  ID_ABOUT_TITLE:=Ini.ReadString('Main', 'ID_ABOUT_TITLE', '');

  Ini.Free;

  ListUPnPEntry;
end;

procedure TMain.AbtBtnClick(Sender: TObject);
begin
  Application.MessageBox(PChar(Caption + ' 0.3' + #13#10 +
  ID_LAST_UPDATE + ' 04.01.2018' + #13#10 +
  'https://r57zone.github.io' + #13#10 +
  'r57zone@gmail.com'), PChar(ID_ABOUT_TITLE), MB_ICONINFORMATION);
end;

end.

