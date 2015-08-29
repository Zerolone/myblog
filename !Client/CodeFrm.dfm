object CodeForm: TCodeForm
  Left = 250
  Top = 161
  Width = 520
  Height = 490
  Caption = #35831#36755#20837#20320#30340#20195#30721
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object mmo1: TMemo
    Left = 0
    Top = 0
    Width = 512
    Height = 388
    Align = alTop
    Lines.Strings = (
      '<? '
      
        '$url_begin    = "http://browse.deviantart.com/?catpath=designs/w' +
        'eb/&order=9&alltime=yes&offset="; '
      '$url_end        = ""; '
      '$url_step        = 24; '
      'for($i=0;$i<2090;$i++){ '
      '    echo $url_begin . $i*$url_step . $url_end; '
      '    echo "'#20013#25991'<br>echo("; '
      '    echo("asdf echo "); '
      '} '
      '                 /** '
      '         * '#20989#25968#35843#29992#38169#35823#25552#31034' '
      '         * '
      '         * @param '#26041#27861#21517' $n '
      '         * @param '#21442'  '#25968' $v '
      '         */ '
      '             function getCateTitle(){ '
      '        $CateTitle='#39#39'; '
      '        //-------------------0 '
      
        '        $SqlStr    = '#39'SELECT `title` FROM `'#39'.DB_TABLE_PRE.'#39'artic' +
        'le_cate`'#39'; '
      '        $SqlStr.= '#39' WHERE 1=1'#39'; '
      '                 '
      '        //'#26639#30446' '
      '        $SqlStr.=$this->SqlCateTitleId; '
      '         '
      '        $MyDatabase=new Database(); '
      '        $MyDatabase->SqlStr = $SqlStr; '
      '        if ($MyDatabase->Query ()) { '
      '            $DB_Record = $MyDatabase->ResultArr [0]; '
      '             '
      '            $CateTitle= $DB_Record[0]; '
      '        } '
      '        return $CateTitle; '
      '    } '
      '?>')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object btn1: TButton
    Left = 20
    Top = 405
    Width = 477
    Height = 47
    Caption = #28155#21152#20195#30721
    TabOrder = 1
    OnClick = btn1Click
  end
  object mmo2: TMemo
    Left = 0
    Top = 0
    Width = 459
    Height = 371
    Lines.Strings = (
      'mmo2')
    TabOrder = 2
  end
end
