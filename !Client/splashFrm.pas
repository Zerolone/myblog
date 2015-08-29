unit splashFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, jpeg, ExtCtrls;

type
  TsplashForm = class(TForm)
    ProgressBar_Splash: TProgressBar;
    Label1: TLabel;
    img_splash: TImage;
    procedure FormClick(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure img_splashClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ReshowSplash;

  end;

var
  splashForm: TsplashForm;


  //
  SplayDelay: REAL;

implementation

{$R *.dfm}

procedure TsplashForm.FormClick(Sender: TObject);
begin
  splashForm.Deactivate;
end;

procedure TsplashForm.FormDeactivate(Sender: TObject);
var
  SplashTime: REAL;
begin
  if (SplayDelay > 200) then
  begin
    SplashTime := GetTickCount;
    repeat
      Application.ProcessMessages;
    until ((GetTickCount - SplashTime) > SplayDelay);
  end;
  splashForm.Close;
end;

procedure TsplashForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  splashForm.Close;
end;

procedure TsplashForm.FormCreate(Sender: TObject);
begin
  Label1.Caption := '';
end;

procedure TsplashForm.ReshowSplash;
begin
  ProgressBar_Splash.Visible := FALSE;
  SplayDelay := 0;
  splashForm.Show;
end;

procedure TsplashForm.img_splashClick(Sender: TObject);
begin
  Close;
end;

INITIALIZATION
  SplayDelay := 0;

end.

