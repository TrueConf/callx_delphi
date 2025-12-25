object frmConfigurator: TfrmConfigurator
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  ClientHeight = 553
  ClientWidth = 689
  Color = clBtnFace
  Constraints.MinHeight = 600
  Constraints.MinWidth = 500
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    689
    553)
  PixelsPerInch = 120
  TextHeight = 16
  object btnOk: TButton
    Left = 552
    Top = 510
    Width = 129
    Height = 35
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 0
    OnClick = actOKExecute
  end
  object btnCancel: TButton
    Left = 417
    Top = 510
    Width = 129
    Height = 35
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object btnHardware: TButton
    Left = 12
    Top = 510
    Width = 129
    Height = 35
    Action = actHardware
    Anchors = [akLeft, akBottom]
    TabOrder = 2
  end
  object PageControl: TPageControl
    Left = 7
    Top = 8
    Width = 677
    Height = 481
    ActivePage = TabSheet2
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 3
    object TabSheet2: TTabSheet
      Caption = 'Server and Authorization'
      ImageIndex = 2
      DesignSize = (
        669
        450)
      object Label8: TLabel
        Left = 32
        Top = 35
        Width = 130
        Height = 16
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Server'
      end
      object Label9: TLabel
        Left = 32
        Top = 99
        Width = 130
        Height = 16
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'User ID'
      end
      object Label10: TLabel
        Left = 32
        Top = 139
        Width = 130
        Height = 16
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Password'
      end
      object Label11: TLabel
        Left = 32
        Top = 179
        Width = 130
        Height = 16
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Confirm password'
      end
      object edServer: TEdit
        Left = 168
        Top = 32
        Width = 294
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
      end
      object edUser: TEdit
        Left = 168
        Top = 96
        Width = 294
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
      end
      object edPassword: TEdit
        Left = 168
        Top = 136
        Width = 294
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        PasswordChar = '*'
        TabOrder = 2
      end
      object edConfirmPassword: TEdit
        Left = 168
        Top = 176
        Width = 294
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        PasswordChar = '*'
        TabOrder = 3
      end
      object chbWriteLog: TCheckBox
        Left = 168
        Top = 422
        Width = 353
        Height = 17
        Anchors = [akLeft, akBottom]
        Caption = 'Keep log file'
        TabOrder = 4
      end
      object btnShowLogFile: TButton
        Left = 56
        Top = 418
        Width = 94
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Show...'
        TabOrder = 5
        OnClick = btnShowLogFileClick
      end
    end
  end
  object OpenPictureDialog: TOpenPictureDialog
    Filter = 'Portable Network Graphics (*.png)|*.png'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 272
    Top = 64
  end
  object OpenDialog: TOpenDialog
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 216
    Top = 88
  end
  object ActionList: TActionList
    Left = 387
    Top = 411
    object actHardware: TAction
      Caption = 'Hardware'
      OnExecute = actHardwareExecute
      OnUpdate = actHardwareUpdate
    end
  end
  object OpenVideoDialog: TOpenDialog
    Filter = 'Audio Video Interleave files (*.avi)|*.avi'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Promo video'
    Left = 352
    Top = 56
  end
end
