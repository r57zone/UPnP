unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WinSock, ComObj, StdCtrls, XPMan, ActiveX, ComCtrls;

type
  TMain = class(TForm)
    Button1: TButton;
    Button2: TButton;
    XPManifest1: TXPManifest;
    Button3: TButton;
    ListView: TListView;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Main: TMain;

implementation

{$R *.dfm}

function GetLocalIP: String;
const WSVer = $101;
var
  wsaData: TWSAData;
  P: PHostEnt;
  Buf: array [0..127] of Char;
begin
  Result := '';
  if WSAStartup(WSVer, wsaData) = 0 then begin
    if GetHostName(@Buf, 128) = 0 then begin
      P := GetHostByName(@Buf);
      if P <> nil then Result := iNet_ntoa(PInAddr(p^.h_addr_list^)^);
    end;
    WSACleanup;
  end;
end;

procedure ListUPnPEntry;
var
  Nat: Variant;
  Ports: Variant;
  Enum : IEnumVARIANT;
  MyPort : OLEVariant;
  I, IntPort, ExtPort : Integer;
  Desc, Protocol, IntClient, ExtIP : WideString;
  Enabled: Boolean;
  iValue: LongWord;
  Status: string;
  Item: TListItem;
begin
  try
    Nat := CreateOleObject('HNetCfg.NATUPnP');
    Ports := Nat.StaticPortMappingCollection;

   if not VarIsClear(Ports) then begin
      Enum := IUnknown(Ports._NewEnum) as IEnumVARIANT;
      while Enum.Next(1, MyPort, iValue) = S_OK do begin
        Desc := MyPort.Description;
        Enabled := MyPort.Enabled;
        ExtIP := MyPort.ExternalIPAddress;
        ExtPort := MyPort.ExternalPort;
        IntClient := MyPort.InternalClient;
        IntPort := MyPort.InternalPort;
        Protocol := MyPort.Protocol;
        if Enabled then Status := 'Включено' else Status := 'Выключено';
        Item := Main.ListView.Items.Add;
        Item.Caption := Desc;
        Item.SubItems.Add(IntToStr(ExtPort));
        Item.SubItems.Add(Protocol);
        Item.SubItems.Add(IntToStr(IntPort));
        Item.SubItems.Add(IntClient);
        Item.SubItems.Add(Status);
      end;
    end;

  except
    ShowMessage('An Error occured with listing UPnP Ports.Please check to see if your router supports UPnP and has UPnP enabled.');
  end;
end;


procedure AddUPnPEntry(Port: Integer; const Name: ShortString; LAN_IP: string);
var
  Nat: Variant;
  Ports: Variant;
begin
  if not (LAN_IP = '127.0.0.1') then begin
    try
      Nat := CreateOleObject('HNetCfg.NATUPnP');
      Ports := Nat.StaticPortMappingCollection;

      if not VarIsClear(Ports) then
        Ports.Add(Port, 'TCP', Port, LAN_IP, True, name);
    except on e:Exception do
      ShowMessage('An Error occured with adding UPnP Ports. '+e.Message);
    end;
  end;
end;

procedure RemoveUPnPEntry(Port: Integer);
var
  Nat: Variant;
  Ports: Variant;
begin
  try
    Nat := CreateOleObject('HNetCfg.NATUPnP');
    Ports := Nat.StaticPortMappingCollection;
    Ports.Remove(Port, 'TCP');
  except
    ShowMessage('An Error occured with removing UPnP Ports. ' +
      'Please check to see if your router supports UPnP and ' +
      'has it enabled or disable UPnP.');
  end;
end;

procedure TMain.Button1Click(Sender: TObject);
begin
  ListUPnPEntry;
end;

procedure TMain.Button2Click(Sender: TObject);
var
  Value, Value2: string;
  iValue, iCode: Integer;
begin
  if InputQuery(Caption, 'Введите название приложения', Value) then
   if InputQuery(Caption, 'Введите номер порта', Value2) then
    Val(Value2, iValue, iCode);
   if (iCode = 0) and (Trim(Value)<>'') and (iValue<>80) then begin
      AddUPnPEntry(iValue, Value, GetLocalIP);
      ShowMessage('Порт ' + IntToStr(iValue) + ' для приложения "' + Value + '" добавлен.');
      ListUPnPEntry;
   end else ShowMessage('Введите корректно название приложения и порт (кроме 80 и уже добавленных)');
end;

procedure TMain.Button3Click(Sender: TObject);
var
  Value: string;
  iValue, iCode: Integer;
begin
  if InputQuery(Caption, 'Введите номер порта', Value) then
    Val(Value, iValue, iCode);
    if (iCode = 0) then begin
      RemoveUPnPEntry(iValue);
      ListUPnPEntry;
    end else ShowMessage('Введите корректно порт одного из добавленных приложений');
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  if (ParamStr(1)='/add') and (ParamStr(2)<>'') and (ParamStr(3)<>'') then begin
    Application.ShowMainForm:=false;
    AddUPnPEntry(StrToInt(ParamStr(3)), ParamStr(2), GetLocalIP);
    Application.Terminate;
  end;

  if (ParamStr(1)='/remove') and (ParamStr(2)<>'') then begin
    Application.ShowMainForm:=false;
    RemoveUPnPEntry(StrToInt(ParamStr(2)));
    Application.Terminate;
  end;

  Application.Title:=Caption;
end;

procedure TMain.Button4Click(Sender: TObject);
begin
  Application.MessageBox('UPnP 0.1'+#13#10+'https://github.com/r57zone'+#13#10+'Последнее обновление: 04.01.2017','О программе...',0);
end;

end.

