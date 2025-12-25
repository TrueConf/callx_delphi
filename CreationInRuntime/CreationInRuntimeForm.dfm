object frmCreationInRuntime: TfrmCreationInRuntime
  Left = 0
  Top = 0
  Caption = 'Creation In Runtime'
  ClientHeight = 553
  ClientWidth = 688
  Color = clBtnFace
  Constraints.MinHeight = 600
  Constraints.MinWidth = 320
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnClose = FormClose
  PixelsPerInch = 120
  TextHeight = 16
  object Splitter1: TSplitter
    Left = 411
    Top = 0
    Width = 5
    Height = 553
    Align = alRight
    ExplicitLeft = 185
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 411
    Height = 553
    Align = alClient
    Constraints.MinHeight = 200
    Constraints.MinWidth = 200
    TabOrder = 0
    object FlowPanel: TFlowPanel
      Left = -1
      Top = -1
      Width = 362
      Height = 242
      AutoSize = True
      TabOrder = 0
      object CallX: TTrueConfCallX
        Left = 1
        Top = 1
        Width = 360
        Height = 240
        Align = alClient
        TabOrder = 0
        OnXAfterStart = CallXXAfterStart
        ControlData = {000E0000C41D0000D8130000}
      end
    end
  end
  object GroupBox1: TGroupBox
    Left = 416
    Top = 0
    Width = 272
    Height = 553
    Align = alRight
    Caption = 'Camera List'
    TabOrder = 1
    object memoCameras: TMemo
      Left = 2
      Top = 18
      Width = 268
      Height = 533
      Align = alClient
      Lines.Strings = (
        'Starting...')
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
end
