unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, PerlRegEx;

type
  TForm1 = class(TForm)
    redt1: TRichEdit;
    btn1: TButton;
    mmo1: TMemo;
    btn11: TButton;
    procedure btn1Click(Sender: TObject);
    procedure btn11Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure CodeColors(Form: TForm; Style: string; RichE: TRichedit;
      InVisible: Boolean);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.CodeColors(Form: TForm; Style: string; RichE: TRichedit;
  InVisible: Boolean);
const
  //   符号...
  CodeC1: array[0..20] of string = ('#', '$', '(', ')', '*', ',',
    '.', '/', ':', ';', '[', ']', '{', '}', '<', '>',
    '-', '=', '+', '''', '@');
  //   保留字...
  CodeC2: array[0..44] of string = ('and', 'as', 'begin',
    'case', 'char', 'class', 'const', 'downto',
    'else', 'end', 'except', 'finally', 'for',
    'forward', 'function', 'if', 'implementation', 'interface',
    'is', 'nil', 'or', 'private', 'procedure', 'public', 'raise',
    'repeat', 'string', 'to', 'try', 'type', 'unit', 'uses', 'var',
    'while', 'external', 'stdcall', 'do', 'until', 'array', 'of',
    'in', 'shr', 'shl', 'cos', 'div');
var
  FoundAt: LongInt;
  StartPos, ToEnd, i: integer;
  OldCap, T: string;
  FontC, BackC, C1, C2, C3, strC, strC1: TColor;
begin
  OldCap := Form.Caption;
  with RichE do
  begin
    Font.Name := 'Courier   New';
    Font.Size := 10;
    if WordWrap then WordWrap := false;
    SelectAll;
    SelAttributes.color := clBlack;
    SelAttributes.Style := [];
    SelStart := 0;
    if InVisible then
    begin
      Visible := False;
      Form.Caption := 'Executing   Code   Coloring...';
    end;
  end;

  BackC := clWhite; FontC := clBlack;
  C1 := clBlack; C2 := clBlack; C3 := clBlack;
  strC := clBlue; strC1 := clSilver;

  if Style = 'Twilight' then
  begin
    BackC := clBlack; FontC := clWhite;
    C1 := clLime; C2 := clSilver; C3 := clAqua;
    strC := clYellow; strC1 := clRed;
  end
  else
    if Style = 'Default' then
    begin
      BackC := clWhite; FontC := clBlack;
      C1 := clTeal; C2 := clMaroon; C3 := clBlue;
      strC := clMaroon; strC1 := clSilver;
    end
    else
      if Style = 'Ocean' then
      begin
        BackC := $00FFFF80; FontC := clBlack;
        C1 := clMaroon; C2 := clBlack; C3 := clBlue;
        strC := clTeal; strC1 := clBlack;
      end
      else
        if Style = 'Classic' then
        begin
          BackC := clNavy; FontC := clYellow;
          C1 := clLime; C2 := clSilver; C3 := clWhite;
          strC := clAqua; strC1 := clSilver;
        end
        else
        begin
          with RichE do
          begin
            T := '{' + Style + '   =   Invalid   Style   [Default,Classic,Twilight,Ocean]   ONLY!   }';
            Lines.Insert(0, T);
            StartPos := 0;
            ToEnd := Length(Text) - StartPos;
            FoundAt := FindText(T, StartPos, ToEnd, [stWholeWord]);
            SelStart := FoundAt;
            SelLength := Length(T);
            SelAttributes.Color := clRed;
            SelAttributes.Style := [fsBold];
            StartPos := 0;
            ToEnd := Length(Text) - StartPos;
            FoundAt := FindText('ONLY!', StartPos, ToEnd, [stWholeWord]);
            SelStart := FoundAt;
            SelLength := 4;
            SelAttributes.Color := clRed;
            SelAttributes.Style := [fsBold, fsUnderLine];
          end;
        end;

  RichE.SelectAll;
  RichE.color := BackC;
  RichE.SelAttributes.color := FontC;

  for i := 0 to 100 do
  begin
    with RichE do
    begin
      StartPos := 0;
      ToEnd := Length(Text) - StartPos;
      FoundAt := FindText(IntToStr(i), StartPos, ToEnd, [stWholeWord]);
      while (FoundAt <> -1) do
      begin
        SelStart := FoundAt;
        SelLength := Length(IntToStr(i));
        SelAttributes.Color := C1;
        SelAttributes.Style := [];
        StartPos := FoundAt + Length(IntToStr(i));
        FoundAt := FindText(IntToStr(i), StartPos, ToEnd, [stWholeWord]);
      end;
    end;
  end;
  for i := 0 to 20 do
  begin
    with RichE do
    begin
      StartPos := 0;
      ToEnd := Length(Text) - StartPos;
      FoundAt := FindText(CodeC1[i], StartPos, ToEnd, []);
      while (FoundAt <> -1) do
      begin
        SelStart := FoundAt;
        SelLength := Length(CodeC1[i]);
        SelAttributes.Color := C2;
        StartPos := FoundAt + Length(CodeC1[i]);
        FoundAt := FindText(CodeC1[i], StartPos, ToEnd, []);
      end;
    end;
  end;
  for i := 0 to 44 do
  begin
    with RichE do
    begin
      StartPos := 0;
      ToEnd := Length(Text) - StartPos;
      FoundAt := FindText(CodeC2[i], StartPos, ToEnd, [stWholeWord]);
      while (FoundAt <> -1) do
      begin
        SelStart := FoundAt;
        SelLength := Length(CodeC2[i]);
        SelAttributes.Color := C3;
        SelAttributes.Style := [fsBold];
        StartPos := FoundAt + Length(CodeC2[i]);
        FoundAt := FindText(CodeC2[i], StartPos, ToEnd, [stWholeWord]);
      end;
    end;
  end;
  Startpos := 0;
  with RichE do
  begin
    FoundAt := FindText('''', StartPos, Length(Text), []);
    while FoundAt <> -1 do
    begin
      SelStart := FoundAt;
      Startpos := FoundAt + 1;
      FoundAt := FindText('''', StartPos, Length(Text), []);
      if FoundAt <> -1 then
      begin
        SelLength := (FoundAt - selstart) + 1;
        SelAttributes.Style := [];
        SelAttributes.Color := strC;
        StartPos := FoundAt + 1;
        FoundAt := FindText('''', StartPos, Length(Text), []);
      end;
    end;
  end;

  Startpos := 0;
  with RichE do
  begin
    FoundAt := FindText('{', StartPos, Length(Text), []);
    while FoundAt <> -1 do
    begin
      SelStart := FoundAt;
      Startpos := FoundAt + 1;
      FoundAt := FindText('}', StartPos, Length(Text), []);
      if FoundAt <> -1 then
      begin
        SelLength := (FoundAt - selstart) + 1;
        SelAttributes.Style := [];
        SelAttributes.Color := strC1;
        StartPos := FoundAt + 1;
        FoundAt := FindText('{', StartPos, Length(Text), []);
      end;
    end;
  end;

  if InVisible then
  begin
    RichE.Visible := True;
    Form.Caption := OldCap;
  end;
  RichE.SelStart := 0;
end;

procedure TForm1.btn1Click(Sender: TObject);
begin
  CodeColors(Form1, 'Default', redt1, True);
end;

procedure TForm1.btn11Click(Sender: TObject);
var
  reg: TPerlRegEx;
begin
  reg := TPerlRegEx.Create(nil);
  reg.Subject := 'echo "中文12321312<br>asdfdsa 12321321 echo(";';
  reg.RegEx := '[\w_]+';
  reg.Replacement:='111111' + reg.MatchedExpression + '2222222';
  reg.ReplaceAll;

  mmo1.Text:=reg.Subject;

  {
  while reg.MatchAgain do //很明显: 本例只能找到一个结果
  begin
    ShowMessage(reg.MatchedExpression); //找到的字符串: Delphi
    reg.Replacement:='aaaaa';

//    ShowMessage(IntToStr(reg.MatchedExpressionOffset)); //它所在的位置: 10
//    ShowMessage(IntToStr(reg.MatchedExpressionLength)); //它的长度: 6

    
  end;
  }
  FreeAndNil(reg);


end;

end.

