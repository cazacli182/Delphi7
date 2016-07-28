object Form1: TForm1
  Left = 477
  Top = 256
  Width = 524
  Height = 337
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 264
    Width = 516
    Height = 42
    Align = alBottom
    BorderStyle = bsSingle
    TabOrder = 0
    object Button1: TButton
      Left = 176
      Top = 7
      Width = 75
      Height = 25
      Caption = 'Carregar'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 261
      Top = 7
      Width = 75
      Height = 25
      Caption = 'Clipboard'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 516
    Height = 264
    Align = alClient
    BorderStyle = bsSingle
    TabOrder = 1
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 510
      Height = 258
      Align = alClient
      DataSource = DTS
      Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'nome'
          Title.Caption = 'Nome'
          Width = 159
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'idade'
          Title.Caption = 'Idade'
          Width = 102
          Visible = True
        end>
    end
  end
  object DTS: TDataSource
    DataSet = CDS
    Left = 8
    Top = 144
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 8
    Top = 184
    object CDSnome: TStringField
      FieldName = 'nome'
      Size = 60
    end
    object CDSidade: TIntegerField
      FieldName = 'idade'
    end
  end
end
