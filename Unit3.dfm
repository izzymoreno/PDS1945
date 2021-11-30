object Form3: TForm3
  Left = 199
  Top = 111
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #1043#1083#1072#1074#1085#1086#1077' '#1084#1077#1085#1102
  ClientHeight = 480
  ClientWidth = 640
  Color = clBtnFace
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 640
    Height = 480
    Align = alClient
  end
  object Button1: TButton
    Left = 376
    Top = 432
    Width = 81
    Height = 41
    Cursor = crHandPoint
    Caption = #1062#1077#1083#1100' '#1088#1072#1073#1086#1090#1099
    DragCursor = crHandPoint
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 464
    Top = 432
    Width = 81
    Height = 41
    Cursor = crHandPoint
    Caption = #1041#1083#1086#1082' '#1089#1093#1077#1084#1072
    DragCursor = crHandPoint
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 552
    Top = 432
    Width = 81
    Height = 41
    Cursor = crHandPoint
    Caption = #1042#1099#1087#1086#1083#1085#1077#1085#1080#1077
    DragCursor = crHandPoint
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 288
    Top = 432
    Width = 81
    Height = 41
    Cursor = crHandPoint
    Caption = #1054#1073' '#1072#1074#1090#1086#1088#1072#1093
    TabOrder = 0
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 121
    Top = 432
    Width = 161
    Height = 40
    Caption = #1055#1086#1088#1103#1076#1086#1082' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103' '#1088#1072#1073#1086#1090#1099
    TabOrder = 4
    OnClick = Button5Click
  end
end
