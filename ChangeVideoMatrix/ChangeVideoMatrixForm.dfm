object frmChangeVideoMatrix: TfrmChangeVideoMatrix
  Left = 0
  Top = 0
  Caption = 'ChangeVideoMatrix'
  ClientHeight = 427
  ClientWidth = 734
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 16
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 734
    Height = 427
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'TrueConf SDK for Windows aka CallX'
      ExplicitWidth = 691
      ExplicitHeight = 375
      object Splitter1: TSplitter
        Left = 442
        Top = 0
        Width = 5
        Height = 396
        Align = alRight
        ExplicitLeft = 567
        ExplicitHeight = 375
      end
      object CallX: TTrueConfCallX
        Left = 0
        Top = 0
        Width = 442
        Height = 396
        Align = alClient
        TabOrder = 0
        OnXAfterStart = CallXXAfterStart
        OnXChangeState = CallXXChangeState
        OnChangeVideoMatrixReport = CallXChangeVideoMatrixReport
        OnInviteReceived = CallXInviteReceived
        OnServerConnected = CallXServerConnected
        OnUpdateParticipantList = CallXUpdateParticipantList
        OnXError = CallXXError
        ExplicitLeft = 208
        ExplicitTop = 112
        ExplicitWidth = 240
        ExplicitHeight = 240
        ControlData = {000E00008C240000BE200000}
      end
      object Panel1: TPanel
        Left = 447
        Top = 0
        Width = 279
        Height = 396
        Align = alRight
        BevelOuter = bvNone
        Constraints.MinHeight = 200
        Constraints.MinWidth = 200
        TabOrder = 1
        object lbParticipants: TListBox
          Left = 0
          Top = 193
          Width = 279
          Height = 203
          Align = alClient
          TabOrder = 0
          ExplicitLeft = 1
          ExplicitTop = 41
          ExplicitWidth = 275
          ExplicitHeight = 334
        end
        object Panel2: TPanel
          Left = 0
          Top = 0
          Width = 279
          Height = 193
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          ExplicitWidth = 275
          DesignSize = (
            279
            193)
          object Button1: TButton
            Left = 132
            Top = 159
            Width = 137
            Height = 25
            Action = actShakeUp
            Anchors = [akTop, akRight]
            TabOrder = 0
            ExplicitLeft = 128
          end
          object rgMatrixType: TRadioGroup
            Left = 6
            Top = 0
            Width = 266
            Height = 153
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Matrix Type'
            ItemIndex = 2
            Items.Strings = (
              
                '* 0 - '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1086#1076#1085#1086' '#1086#1082#1085#1086'. '#1055#1088#1080' '#1101#1090#1086#1084' '#1077#1089#1083#1080' '#1074' '#1089#1087#1080#1089#1082#1077' '#1086#1082#1086#1085' '#1073 +
                #1086#1083#1100#1096#1077' - '#1073#1091#1076#1077#1090' '#1087#1086#1082#1072#1079#1072#1085#1086' '#1087#1077#1088#1074#1086#1077'.'
              '* 1 - '#1073#1086#1083#1100#1096#1086#1077' '#1086#1082#1085#1086' '#1089#1086#1073#1077#1089#1077#1076#1085#1080#1082#1072', '#1080' '#1084#1072#1083#1077#1085#1100#1082#1086#1077' '#1074' '#1091#1075#1083#1091
              '* 2 - '#1074#1089#1077' '#1086#1082#1085#1072' '#1086#1076#1080#1085#1072#1082#1086#1074#1099#1077
              
                '* 3 - '#1086#1076#1085#1086' '#1086#1082#1085#1086' '#1073#1086#1083#1100#1096#1086#1077' ('#1074' '#1083#1077#1074#1086#1084' '#1074#1077#1088#1093#1085#1077#1084' '#1091#1075#1083#1091'), '#1086#1089#1090#1072#1083#1100#1085#1099#1077' '#1084#1072#1083#1077#1085#1100 +
                #1082#1080#1077' '#1074#1086#1082#1088#1091#1075' '#1085#1077#1075#1086
              
                '* 4 - '#1086#1076#1085#1086' '#1086#1082#1085#1086' '#1073#1086#1083#1100#1096#1086#1077' ('#1087#1086' '#1094#1077#1085#1090#1088#1091' '#1089#1074#1077#1088#1093#1091'), '#1086#1089#1090#1072#1083#1100#1085#1099#1077' '#1084#1072#1083#1077#1085#1100#1082#1080#1077' ' +
                #1089#1085#1080#1079#1091
              
                '* 5 - '#1086#1076#1085#1086' '#1086#1082#1085#1086' '#1073#1086#1083#1100#1096#1086#1077' ('#1074' '#1083#1077#1074#1086#1084' '#1091#1075#1083#1091'), '#1086#1089#1090#1072#1083#1100#1085#1099#1077' '#1084#1072#1083#1077#1085#1100#1082#1080#1077' '#1089#1087#1088#1072 +
                #1074#1072' '#1086#1090' '#1085#1077#1075#1086
              
                '* 6 - '#1086#1076#1085#1086' '#1086#1082#1085#1086' '#1073#1086#1083#1100#1096#1086#1077' ('#1087#1086' '#1094#1077#1085#1090#1088#1091' '#1089#1074#1077#1088#1093#1091'), '#1086#1089#1090#1072#1083#1100#1085#1099#1077' '#1084#1072#1083#1077#1085#1100#1082#1080#1077' ' +
                #1089#1085#1080#1079#1091', '#1082#1086#1090#1086#1088#1099#1077' '#1084#1086#1075#1091#1090' "'#1085#1072#1087#1086#1083#1079#1072#1090#1100'" '#1085#1072' '#1085#1077#1075#1086' '#1074' '#1088#1072#1079#1091#1084#1085#1099#1093' '#1087#1088#1077#1076#1077#1083#1072#1093)
            TabOrder = 1
            ExplicitWidth = 267
          end
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Log'
      ImageIndex = 1
      ExplicitWidth = 691
      ExplicitHeight = 375
      object memoLog: TMemo
        Left = 0
        Top = 0
        Width = 726
        Height = 396
        Align = alClient
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
        ExplicitWidth = 691
        ExplicitHeight = 375
      end
    end
  end
  object MainMenu: TMainMenu
    Left = 40
    Top = 160
    object File1: TMenuItem
      Caption = 'File'
      object miExit: TMenuItem
        Caption = 'Exit'
        ShortCut = 32883
        OnClick = miExitClick
      end
    end
    object miTools: TMenuItem
      Caption = 'Tools'
      object miConnectionSetting: TMenuItem
        Caption = 'Connection'
        Enabled = False
        OnClick = miConnectionSettingClick
      end
      object miHardwareSetting: TMenuItem
        Caption = 'Hardware'
        Enabled = False
        OnClick = miHardwareSettingClick
      end
    end
  end
  object ActionList: TActionList
    Left = 152
    Top = 160
    object actCall: TAction
      Caption = 'Call'
    end
    object actHangUp: TAction
      Caption = 'Hang Up'
    end
    object actShakeUp: TAction
      Category = 'Matrix'
      Caption = 'Shake Up'
      OnExecute = actShakeUpExecute
      OnUpdate = actShakeUpUpdate
    end
  end
end
