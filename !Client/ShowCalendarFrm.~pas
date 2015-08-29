unit ShowCalendarFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, OleCtrls, DHTMLEDLib_TLB;

type
  TShowCalendarForm = class(TForm)
    Label1: TLabel;
    lbl_id: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label7: TLabel;
    lbl_import: TLabel;
    Bevel5: TBevel;
    Label9: TLabel;
    lbl_createtime: TLabel;
    Bevel6: TBevel;
    Label2: TLabel;
    lbl_title: TLabel;
    Label3: TLabel;
    lbl_modifytime: TLabel;
    Bevel3: TBevel;
    Timer1: TTimer;
    Memo1: TMemo;
    DHTMLSafe1: TDHTMLSafe;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ShowCalendarForm: TShowCalendarForm;

implementation

{$R *.dfm}

procedure TShowCalendarForm.Timer1Timer(Sender: TObject);
begin
  DHTMLSafe1.DOM.body.innerHTML:=Memo1.Text;
  Timer1.Enabled:=False;
end;

procedure TShowCalendarForm.FormCreate(Sender: TObject);
begin
  Memo1.Hide;
end;

procedure TShowCalendarForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  DHTMLSafe1.DOM.body.innerHTML:='';
end;

end.
