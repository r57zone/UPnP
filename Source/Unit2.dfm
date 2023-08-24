object AddPortForm: TAddPortForm
  Left = 192
  Top = 125
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086#1088#1090
  ClientHeight = 227
  ClientWidth = 311
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ProfileBtn: TLabel
    Left = 160
    Top = 8
    Width = 49
    Height = 13
    Caption = #1055#1088#1086#1092#1080#1083#1080':'
  end
  object AppNameLbl: TLabel
    Left = 8
    Top = 8
    Width = 121
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1103'::'
  end
  object IPAddressLbl: TLabel
    Left = 8
    Top = 140
    Width = 46
    Height = 13
    Caption = 'IP '#1072#1076#1088#1077#1089':'
  end
  object IntPortLbl: TLabel
    Left = 88
    Top = 96
    Width = 61
    Height = 13
    Caption = #1042#1085#1091#1090#1088'. '#1087#1086#1088#1090':'
  end
  object ExtPortLbl: TLabel
    Left = 8
    Top = 96
    Width = 59
    Height = 13
    Caption = #1042#1085#1077#1096'. '#1087#1086#1088#1090':'
  end
  object ProtocolLbl: TLabel
    Left = 8
    Top = 56
    Width = 52
    Height = 13
    Caption = #1055#1088#1086#1090#1086#1082#1086#1083':'
  end
  object ProfileCB: TComboBox
    Left = 160
    Top = 24
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
    OnChange = ProfileCBChange
  end
  object IPAddressCB: TComboBox
    Left = 8
    Top = 156
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 5
  end
  object ExtPortEdt: TEdit
    Left = 8
    Top = 112
    Width = 65
    Height = 21
    TabOrder = 3
  end
  object IntPortEdt: TEdit
    Left = 88
    Top = 112
    Width = 65
    Height = 21
    TabOrder = 4
  end
  object TCPRB: TRadioButton
    Left = 8
    Top = 72
    Width = 49
    Height = 17
    Caption = 'TCP'
    Checked = True
    TabOrder = 1
    TabStop = True
  end
  object UDPRB: TRadioButton
    Left = 64
    Top = 72
    Width = 57
    Height = 17
    Caption = 'UDP'
    TabOrder = 2
  end
  object NameAppEdt: TEdit
    Left = 8
    Top = 24
    Width = 145
    Height = 21
    TabOrder = 0
    OnKeyDown = NameAppEdtKeyDown
  end
  object ButtonsPanel: TPanel
    Left = 0
    Top = 186
    Width = 311
    Height = 41
    Align = alBottom
    TabOrder = 9
    object AddBtn: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 0
      OnClick = AddBtnClick
    end
    object CancelBtn: TButton
      Left = 88
      Top = 8
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 1
      OnClick = CancelBtnClick
    end
  end
  object AddProfileBtn: TButton
    Left = 159
    Top = 48
    Width = 25
    Height = 25
    Caption = '+'
    TabOrder = 7
    OnClick = AddProfileBtnClick
  end
  object RemProfileBtn: TButton
    Left = 186
    Top = 48
    Width = 25
    Height = 25
    Caption = '-'
    TabOrder = 8
    OnClick = RemProfileBtnClick
  end
end
