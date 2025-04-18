object Form1: TForm1
  Left = 199
  Height = 240
  Top = 101
  Width = 320
  Caption = 'Form1'
  ClientHeight = 240
  ClientWidth = 320
  DesignTimePPI = 102
  LCLVersion = '8.6'
  OnClose = FormClose
  OnCreate = FormCreate
  object LabelTemp: TLabel
    Left = 48
    Height = 23
    Top = 56
    Width = 41
    Caption = 'Label'
  end
  object LabelHum: TLabel
    Left = 48
    Height = 23
    Top = 88
    Width = 41
    Caption = 'Label'
  end
  object LabelPres: TLabel
    Left = 48
    Height = 23
    Top = 120
    Width = 41
    Caption = 'Label'
  end
  object LabelDew: TLabel
    Left = 48
    Height = 23
    Top = 152
    Width = 41
    Caption = 'Label'
  end
  object Labelupdate: TLabel
    Left = 48
    Height = 23
    Top = 184
    Width = 41
    Caption = 'Label'
  end
  object SpinEditaltitude: TSpinEdit
    Left = 48
    Height = 32
    Top = 16
    Width = 64
    TabOrder = 0
  end
  object Label1: TLabel
    Left = 120
    Height = 23
    Top = 24
    Width = 75
    Caption = 'm altitude'
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 269
    Top = 112
  end
end
