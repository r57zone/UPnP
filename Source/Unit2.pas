unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, WinSock;

type
  TAddPortForm = class(TForm)
    ProfileCB: TComboBox;
    ProfileBtn: TLabel;
    AppNameLbl: TLabel;
    IPAddressCB: TComboBox;
    IPAddressLbl: TLabel;
    ExtPortEdt: TEdit;
    IntPortEdt: TEdit;
    IntPortLbl: TLabel;
    ExtPortLbl: TLabel;
    TCPRB: TRadioButton;
    UDPRB: TRadioButton;
    ProtocolLbl: TLabel;
    NameAppEdt: TEdit;
    ButtonsPanel: TPanel;
    AddBtn: TButton;
    CancelBtn: TButton;
    AddProfileBtn: TButton;
    RemProfileBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure ProfileCBChange(Sender: TObject);
    procedure RemProfileBtnClick(Sender: TObject);
    procedure AddProfileBtnClick(Sender: TObject);
    procedure NameAppEdtKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure UpdateProfiles;
    procedure LoadProfile(FileName: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddPortForm: TAddPortForm;

implementation

uses Unit1;

{$R *.dfm}

function GetIP: string;
type
  TaPInAddr = array[0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe: PHostEnt;
  pPtr: PaPInAddr;
  GInitData: TWSAData;
  Buffer: array[0..63] of Char;
  i: Integer;
begin
  Result:='';
  if WSAStartup($101, GInitData) <> 0 then Exit;
  GetHostName(Buffer, SizeOf(Buffer));
  phe := GetHostByName(Buffer);
  if phe = nil then Exit;
  pPtr := PaPInAddr(phe^.h_addr_list);
  i:=0;
  while pPtr^[I] <> nil do begin
    Result:=Result + inet_ntoa(pPtr^[I]^) + #13#10;
    Inc(I);
  end;
  Result:=Trim(Result);
  WSACleanup;
end;

procedure TAddPortForm.FormCreate(Sender: TObject);
begin
  SetWindowLong(ExtPortEdt.Handle, GWL_STYLE, GetWindowLong(ExtPortEdt.Handle, GWL_STYLE) or ES_NUMBER);
  SetWindowLong(IntPortEdt.Handle, GWL_STYLE, GetWindowLong(IntPortEdt.Handle, GWL_STYLE) or ES_NUMBER);

  AppNameLbl.Caption:=Main.ListView.Columns[0].Caption + ':';
  ProtocolLbl.Caption:=Main.ListView.Columns[1].Caption + ':';
  ExtPortLbl.Caption:=Main.ListView.Columns[2].Caption + ':';
  IntPortLbl.Caption:=Main.ListView.Columns[3].Caption + ':';
  IPAddressLbl.Caption:=Main.ListView.Columns[4].Caption + ':';
  AddBtn.Caption:=Main.AddBtn.Caption;

  Caption:=ID_ADD_PORT;
  CancelBtn.Caption:=ID_CANCEL;
  ProfileBtn.Caption:=ID_PROFILES + ':';
end;

procedure TAddPortForm.CancelBtnClick(Sender: TObject);
begin
  NameAppEdt.Clear;
  ProfileCB.ItemIndex:=0;
  ExtPortEdt.Clear;
  IntPortEdt.Clear;
  Close;
end;

procedure TAddPortForm.FormShow(Sender: TObject);
var
  TempIPs: string; i: integer; FoundIP: boolean;
begin
  // Профили
  UpdateProfiles;

  // IP
  TempIPs:=GetIP;
  if TempIPs <> IPAddressCB.Text then begin // Если новых адресов нет, то не сбрысываем прошлый выбор
    IPAddressCB.Items.Text:=GetIP;
    if IPAddressCB.Items.Count > 0 then IPAddressCB.ItemIndex:=0;
  end;

  // Выбранный IP
  if IPAddressSelectedValue = '' then Exit; // Если не выбран или пустой, то не выполняем дальнейший код
  FoundIP:=false;
  for i:=0 to IPAddressCB.Items.Count - 1 do
    if IPAddressSelectedValue = IPAddressCB.Items.Strings[i] then begin
      IPAddressCB.ItemIndex:=i;
      FoundIP:=true;
      break;
    end;
  if FoundIP = false then begin
    IPAddressCB.Items.Add(IPAddressSelectedValue);
    IPAddressCB.ItemIndex:=IPAddressCB.Items.Count - 1;
  end;
end;

procedure TAddPortForm.AddBtnClick(Sender: TObject);
var
  AppName, IPAddressValue: string;
begin
  AppName:=NameAppEdt.Text;
  if (Trim(AppName) = '') then AppName:='Unknown';

  if (StrToIntDef(ExtPortEdt.Text, 0) = 0) or (StrToIntDef(IntPortEdt.Text, 0) = 0) then begin
    Application.MessageBox(PChar(ID_INVALID_PORT), PChar(Caption), MB_ICONINFORMATION);
    Exit;
  end;

  if Trim(IPAddressCB.Text) = '' then begin
    Application.MessageBox(PChar(ID_INVALID_IP), PChar(Caption), MB_ICONINFORMATION);
    Exit;
  end;

  if Main.AddUPnPPort(StrToInt(ExtPortEdt.Text), StrToInt(IntPortEdt.Text), AppName, TCPRB.Checked, IPAddressCB.Text) then begin
    Main.ListUPnPEntry;
    CancelBtn.Click; // Очищаем и закрываем окно
  end else
    Application.MessageBox(PChar(ID_ERROR_WITH_ADD_PORT), PChar(Caption), MB_ICONINFORMATION);
end;

procedure TAddPortForm.ProfileCBChange(Sender: TObject);
begin
  if ProfileCB.ItemIndex <> 0 then
    LoadProfile(ProfileCB.Items.Strings[ProfileCB.ItemIndex] + '.pup')
  else begin
    NameAppEdt.Clear;
    ExtPortEdt.Clear;
    IntPortEdt.Clear;
  end;
end;

procedure TAddPortForm.LoadProfile(FileName: string);
var
  FileList: TStringList;
begin
  if not FileExists(ExtractFilePath(ParamStr(0)) + 'Profiles\' + FileName) then Exit;
  FileList:=TStringList.Create;
  FileList.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Profiles\' + FileName);
  FileList.Text:=StringReplace(FileList.Text, #9, #13#10, [rfReplaceAll]);
  NameAppEdt.Text:=FileList.Strings[0];
  ExtPortEdt.Text:=FileList.Strings[1];
  IntPortEdt.Text:=FileList.Strings[2];
  FileList.Free;
end;

procedure TAddPortForm.RemProfileBtnClick(Sender: TObject);
begin
  if ProfileCB.ItemIndex = 0 then Exit;
  if FileExists(ExtractFilePath(ParamStr(0)) + 'Profiles\' + ProfileCB.Items.Strings[ProfileCB.ItemIndex]) then
    DeleteFile(ExtractFilePath(ParamStr(0)) + 'Profiles\' + ProfileCB.Items.Strings[ProfileCB.ItemIndex]);
  UpdateProfiles;
end;

procedure TAddPortForm.AddProfileBtnClick(Sender: TObject);
var
  AppName, ExternalPortValue, InternalPortValue, IPAddressValue: string;
  FileList: TStringList;
begin
  if InputQuery(Caption, ID_ENTER_APP_NAME, AppName) then begin//Не вызываем дальнейшие диалоги в случае отмены
  if InputQuery(Caption, ID_ENTER_INTERNAL_PORT_NUM, InternalPortValue) then
    InputQuery(Caption, ID_ENTER_EXTERNAL_PORT_NUM, ExternalPortValue);
  end else
    Exit;

  if (Trim(AppName) = '') then AppName:='Unknown';

  if (StrToIntDef(InternalPortValue, 0) = 0) or (StrToIntDef(ExternalPortValue, 0) = 0) then begin
    Application.MessageBox(PChar(ID_INVALID_PORT), PChar(Caption), MB_ICONINFORMATION);
    Exit;
  end;

  if (Trim(AppName) = '') then AppName:='Unknown';

  FileList:=TStringList.Create;
  FileList.Text:=AppName + #9 + ExternalPortValue + #9 + InternalPortValue;
  FileList.SaveToFile(ExtractFilePath(ParamStr(0)) + 'Profiles\' + AppName + '.pup');
  FileList.Free;

  UpdateProfiles;
end;

procedure TAddPortForm.UpdateProfiles;
var
  SR: TSearchRec;
begin
  ProfileCB.Clear;
  ProfileCB.Items.Add(ID_SELECT_PROFILE);
  ProfileCB.ItemIndex:=0;
  if FindFirst(ExtractFilePath(ParamStr(0)) + 'Profiles\*.pup', faAnyFile, SR) = 0 then begin
     repeat
       if (SR.Attr <> faDirectory) then
         ProfileCB.Items.Add(Copy(SR.Name, 1, Length(SR.Name) - 4));
     until FindNext(SR) <> 0;
     FindClose(SR);
   end;
end;

procedure TAddPortForm.NameAppEdtKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //Убираем баг скрытия контролов
  if Key = VK_MENU then
    Key:=0;
end;

end.
