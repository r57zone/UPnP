object Main: TMain
  Left = 192
  Top = 124
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'UPnP'
  ClientHeight = 200
  ClientWidth = 480
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object RefreshBtn: TButton
    Left = 8
    Top = 168
    Width = 73
    Height = 25
    Caption = #1054#1073#1085#1086#1074#1080#1090#1100
    TabOrder = 0
    OnClick = RefreshBtnClick
  end
  object AddBtn: TButton
    Left = 88
    Top = 168
    Width = 73
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 1
    OnClick = AddBtnClick
  end
  object RemBtn: TButton
    Left = 168
    Top = 168
    Width = 73
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 2
    OnClick = RemBtnClick
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
        Caption = #1055#1088#1086#1090#1086#1082#1086#1083
        Width = 62
      end
      item
        Caption = #1042#1085#1077#1096'. '#1087#1086#1088#1090
        Width = 70
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
    ReadOnly = True
    RowSelect = True
    TabOrder = 3
    ViewStyle = vsReport
  end
  object AbtBtn: TButton
    Left = 448
    Top = 168
    Width = 25
    Height = 25
    Caption = '?'
    TabOrder = 4
    OnClick = AbtBtnClick
  end
  object XPManifest: TXPManifest
    Left = 16
    Top = 16
  end
end
