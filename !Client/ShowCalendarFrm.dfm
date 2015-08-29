object ShowCalendarForm: TShowCalendarForm
  Left = 218
  Top = 168
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = ' '#24037#20316#35745#21010#31649#29702' >> '#24037#20316#35745#21010#26174#31034
  ClientHeight = 471
  ClientWidth = 686
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 60
    Height = 13
    Caption = #32534#12288#12288#21495#65306
  end
  object lbl_id: TLabel
    Left = 80
    Top = 8
    Width = 24
    Height = 13
    Caption = 'lbl_id'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 26
    Width = 673
    Height = 1
    Shape = bsTopLine
  end
  object Bevel2: TBevel
    Left = 8
    Top = 50
    Width = 673
    Height = 1
    Shape = bsTopLine
  end
  object Label7: TLabel
    Left = 8
    Top = 56
    Width = 63
    Height = 13
    Caption = #20851'   '#38190'  '#24230#65306
  end
  object lbl_import: TLabel
    Left = 80
    Top = 56
    Width = 24
    Height = 13
    Caption = 'lbl_id'
  end
  object Bevel5: TBevel
    Left = 8
    Top = 74
    Width = 673
    Height = 1
    Shape = bsTopLine
  end
  object Label9: TLabel
    Left = 8
    Top = 80
    Width = 60
    Height = 13
    Caption = #21019#24314#26102#38388#65306
  end
  object lbl_createtime: TLabel
    Left = 80
    Top = 80
    Width = 24
    Height = 13
    Caption = 'lbl_id'
  end
  object Bevel6: TBevel
    Left = 8
    Top = 98
    Width = 673
    Height = 1
    Shape = bsTopLine
  end
  object Label2: TLabel
    Left = 8
    Top = 32
    Width = 60
    Height = 13
    Caption = #26631#12288#12288#39064#65306
  end
  object lbl_title: TLabel
    Left = 80
    Top = 32
    Width = 601
    Height = 13
    AutoSize = False
    Caption = 'lbl_id'
  end
  object Label3: TLabel
    Left = 8
    Top = 104
    Width = 60
    Height = 13
    Caption = #20462#25913#26102#38388#65306
  end
  object lbl_modifytime: TLabel
    Left = 80
    Top = 104
    Width = 24
    Height = 13
    Caption = 'lbl_id'
  end
  object Bevel3: TBevel
    Left = 7
    Top = 122
    Width = 673
    Height = 1
    Shape = bsTopLine
  end
  object Memo1: TMemo
    Left = 311
    Top = 64
    Width = 274
    Height = 57
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object DHTMLSafe1: TDHTMLSafe
    Left = 0
    Top = 136
    Width = 686
    Height = 335
    Align = alBottom
    TabOrder = 1
    ControlData = {
      02020000E6460000A02200000B0000000B0000000B00FFFF0B0000000B000000
      0300010000000B00FFFF0300010000000B00FFFF0B0000000B00000003003200
      00000300320000000B000000}
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 264
    Top = 64
  end
end
