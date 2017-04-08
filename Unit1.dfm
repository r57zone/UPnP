object Main: TMain
  Left = 192
  Top = 124
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'UPnP '#1087#1077#1088#1077#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1087#1086#1088#1090#1086#1074
  ClientHeight = 200
  ClientWidth = 480
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 168
    Width = 73
    Height = 25
    Caption = #1054#1073#1085#1086#1074#1080#1090#1100
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 88
    Top = 168
    Width = 89
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086#1088#1090
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 184
    Top = 168
    Width = 89
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100' '#1087#1086#1088#1090
    TabOrder = 2
    OnClick = Button3Click
  end
  object ListView: TListView
    Left = 8
    Top = 8
    Width = 465
    Height = 150
    Columns = <
      item
        Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1103
        Width = 110
      end
      item
        Caption = #1042#1085#1077#1096'. '#1087#1086#1088#1090
        Width = 70
      end
      item
        Caption = #1055#1088#1086#1090#1086#1082#1086#1083
        Width = 62
      end
      item
        Caption = #1042#1085#1091#1090#1088'. '#1087#1086#1088#1090
        Width = 70
      end
      item
        Caption = 'IP-'#1072#1076#1088#1077#1089
        Width = 86
      end
      item
        Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
        Width = 60
      end>
    RowSelect = True
    TabOrder = 3
    ViewStyle = vsReport
  end
  object Button4: TButton
    Left = 440
    Top = 168
    Width = 35
    Height = 25
    Caption = '?'
    TabOrder = 4
    OnClick = Button4Click
  end
  object XPManifest1: TXPManifest
    Left = 16
    Top = 16
  end
end
