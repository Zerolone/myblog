unit CodeFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TCodeForm = class(TForm)
    mmo1: TMemo;
    btn1: TButton;
    mmo2: TMemo;
    procedure btn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CodeForm: TCodeForm;

implementation

uses AddBlogFrm, ClientFunction;

{$R *.dfm}

procedure TCodeForm.btn1Click(Sender: TObject);
var
  i: Integer;
begin
  mmo2.Clear;
  for i := 0 to mmo1.Lines.Count do
  begin
    //    mmo2.Lines.Add('µÚ'+ IntToStr(i)+'ÐÐ');
    mmo2.Lines.Add(Highlight(mmo1.Lines.Strings[i], i));
    //mmo2.Lines.Add('<li><div>' + Highlight(mmo1.Lines.Strings[i], i) + '</div></li>');
  end;

  AddBlogForm.mmo1.Text := mmo2.Text;
  Close;
  AddBlogForm.btn1.click;
  mmo1.Clear;
end;

procedure TCodeForm.FormCreate(Sender: TObject);
begin
  mmo1.Clear;
  mmo2.Hide;
end;

end.

