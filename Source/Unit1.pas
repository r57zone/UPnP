unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComObj, StdCtrls, XPMan, ActiveX, ComCtrls, IniFiles;

type
  TMain = class(TForm)
    RefreshBtn: TButton;
    AddBtn: TButton;
    XPManifest: TXPManifest;
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
    procedure ListUPnPEntry;
    function AddUPnPPort(ExternalPort, InternalPort: integer; const Name: ShortString; IsTCP: boolean; LAN_IP: string): boolean;
    { Public declarations }
  end;

var
  Main: TMain;
  
  //Перевод / Translate
  ID_STATUS_ON, ID_STATUS_OFF, ID_ERROR_WITH_LISTING_UPNP_PORTS,
  ID_ERROR_WITH_ADD_PORT, ID_ERROR_WITH_REM_PORT, ID_ENTER_APP_NAME,
  ID_ENTER_EXTERNAL_PORT_NUM, ID_ENTER_INTERNAL_PORT_NUM, ID_ENTER_IP_ADDRESS,
  ID_CHOOSE_PROTOCOL, ID_INVALID_PORT, ID_INVALID_IP: string;

  ID_ADD_PORT, ID_CANCEL, ID_PROFILES, ID_SELECT_PROFILE: string;

  ID_LAST_UPDATE, ID_ABOUT_TITLE: string;

  IPAddressSelectedValue: string;

  MsgAppName, MsgIntPort: string;

implementation

uses Unit2;

{$R *.dfm}

procedure TMain.ListUPnPEntry;
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

function TMain.AddUPnPPort(ExternalPort, InternalPort: integer; const Name: ShortString; IsTCP: boolean; LAN_IP: string): boolean;
var
  Nat: Variant;
  Ports: Variant;
begin
  if not (LAN_IP = '127.0.0.1') then
    try
      Nat:=CreateOleObject('HNetCfg.NATUPnP');
      Ports:=Nat.StaticPortMappingCollection;

      if not VarIsClear(Ports) then begin
        if IsTCP then
          Ports.Add(ExternalPort, 'TCP', InternalPort, LAN_IP, True, Name)
        else
          Ports.Add(ExternalPort, 'UDP', InternalPort, LAN_IP, True, Name);
        Result:=true;
      end;
        //ShowMessage(IntToStr(Ports.Count));
    except
      Result:=false;
    end;
end;

function RemoveUPnPPort(Port: Integer; IsTCP: boolean): boolean;
var
  Nat: Variant;
  Ports: Variant;
begin
  try
    Nat:=CreateOleObject('HNetCfg.NATUPnP');
    Ports:=Nat.StaticPortMappingCollection;
    if IsTCP then
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
begin
  AddPortForm.ShowModal;
end;

procedure TMain.RemBtnClick(Sender: TObject);
var
  Item: TListItem; IsTCP: boolean;
begin
  if ListView.Selected <> nil then begin
    Item:=ListView.Items.Item[ListView.Selected.Index];

    if Item.SubItems[0] = 'TCP' then
      IsTCP:=true
    else
      IsTCP:=false;

    if RemoveUPnPPort(StrToInt(Item.SubItems[1]), IsTCP) then
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
  i: integer;
  IsTCP: boolean;
  AppName, ActionValue, IPAddressValue: shortstring;
  InternalPortValue, ExternalPortValue: word;
begin
  IsTCP:=true;
  for i:=1 to ParamCount do begin
    if LowerCase(ParamStr(i)) = '-add' then ActionValue:='add';
    if LowerCase(ParamStr(i)) = '-rem' then ActionValue:='rem';
    if LowerCase(ParamStr(i)) = '-i' then InternalPortValue:=StrToIntDef(ParamStr(i + 1), 0);
    if LowerCase(ParamStr(i)) = '-e' then ExternalPortValue:=StrToIntDef(ParamStr(i + 1), 0);
    if LowerCase(ParamStr(i)) = '-ip' then IPAddressValue:=ParamStr(i + 1);
    if LowerCase(ParamStr(i)) = '-n' then AppName:=ParamStr(i + 1);
    if LowerCase(ParamStr(i)) = '-udp' then IsTCP:=false;
  end;

  if ParamCount > 0 then begin
    if (ActionValue = 'add') and (InternalPortValue <> 0) and (ExternalPortValue <> 0) and
      (Trim(AppName) <> '') and (Trim(IPAddressValue) <> '') then begin
      Application.ShowMainForm:=false;
      AddUPnPPort(ExternalPortValue, InternalPortValue, AppName, IsTCP, IPAddressValue);
      Application.Terminate;
    end;

    if (ActionValue = 'rem') and (ExternalPortValue <> 0) then begin
      Application.ShowMainForm:=false;
      RemoveUPnPPort(ExternalPortValue, IsTCP);
      Application.Terminate;
    end;
  end;

  Application.Title:=Caption;

  // Перевод / Translate
  if FileExists(ExtractFilePath(ParamStr(0)) + 'Languages\' + GetLocaleInformation(LOCALE_SENGLANGUAGE) + '.ini') then
    Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Languages\' + GetLocaleInformation(LOCALE_SENGLANGUAGE) + '.ini')
  else
    Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Languages\English.ini');

  ListView.Columns[0].Caption:=Ini.ReadString('Main', 'ID_APP_NAME', '');
  ListView.Columns[1].Caption:=Ini.ReadString('Main', 'ID_PROTOCOL', '');
  ListView.Columns[2].Caption:=Ini.ReadString('Main', 'ID_EXTERNAL_PORT', '');
  ListView.Columns[3].Caption:=Ini.ReadString('Main', 'ID_INTERNAL_PORT', '');
  ListView.Columns[4].Caption:=Ini.ReadString('Main', 'ID_IP_ADDRESS', '');
  ListView.Columns[5].Caption:=Ini.ReadString('Main', 'ID_STATE', '');
  RefreshBtn.Caption:=Ini.ReadString('Main', 'ID_REFRESH', '');
  AddBtn.Caption:=Ini.ReadString('Main', 'ID_ADD', '');
  RemBtn.Caption:=Ini.ReadString('Main', 'ID_REMOVE', '');

  ID_STATUS_ON:=Ini.ReadString('Main', 'ID_STATUS_ON', '');
  ID_STATUS_OFF:=Ini.ReadString('Main', 'ID_STATUS_OFF', '');
  ID_ERROR_WITH_LISTING_UPNP_PORTS:=Ini.ReadString('Main', 'ID_ERROR_WITH_LISTING_UPNP_PORTS', '');

  ID_ERROR_WITH_ADD_PORT:=Ini.ReadString('Main', 'ID_ERROR_WITH_ADD_PORT', '');
  ID_ERROR_WITH_REM_PORT:=Ini.ReadString('Main', 'ID_ERROR_WITH_REM_PORT', '');
  ID_ENTER_APP_NAME:=Ini.ReadString('Main', 'ID_ENTER_APP_NAME', '');
  ID_ENTER_EXTERNAL_PORT_NUM:=Ini.ReadString('Main', 'ID_ENTER_EXTERNAL_PORT_NUM', '');
  ID_ENTER_INTERNAL_PORT_NUM:=Ini.ReadString('Main', 'ID_ENTER_INTERNAL_PORT_NUM', '');
  ID_ENTER_IP_ADDRESS:=Ini.ReadString('Main', 'ID_ENTER_IP_ADDRESS', '');
  ID_CHOOSE_PROTOCOL:=Ini.ReadString('Main', 'ID_CHOOSE_PROTOCOL', '');
  //ID_ADDED_PORT:=Ini.ReadString('Main', 'ID_ADDED_PORT', '');
  ID_INVALID_PORT:=Ini.ReadString('Main', 'ID_INVALID_PORT', '');
  ID_INVALID_IP:=Ini.ReadString('Main', 'ID_INVALID_IP', '');

  ID_ADD_PORT:=Ini.ReadString('Main', 'ID_ADD_PORT', '');
  ID_CANCEL:=Ini.ReadString('Main', 'ID_CANCEL', '');
  ID_PROFILES:=Ini.ReadString('Main', 'ID_PROFILES', '');
  ID_SELECT_PROFILE:=Ini.ReadString('Main', 'ID_SELECT_PROFILE', '');

  ID_LAST_UPDATE:=Ini.ReadString('Main', 'ID_LAST_UPDATE', '');
  ID_ABOUT_TITLE:=Ini.ReadString('Main', 'ID_ABOUT_TITLE', '');

  Ini.Free;

  ListUPnPEntry;
end;

procedure TMain.AbtBtnClick(Sender: TObject);
begin
  Application.MessageBox(PChar(Caption + ' 0.5' + #13#10 +
  ID_LAST_UPDATE + ' 24.08.2023' + #13#10 +
  'https://r57zone.github.io' + #13#10 +
  'r57zone@gmail.com'), PChar(ID_ABOUT_TITLE), MB_ICONINFORMATION);
end;

end.

