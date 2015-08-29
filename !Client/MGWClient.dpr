program MGWClient;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {MainForm},
  splashFrm in 'splashFrm.pas' {splashForm},
  ClientFunction in 'ClientFunction.pas',
  BlogFrm in 'BlogFrm.pas' {BlogForm},
  ShowCalendarFrm in 'ShowCalendarFrm.pas' {ShowCalendarForm},
  AddBlogFrm in 'AddBlogFrm.pas' {AddBlogForm},
  InsertTableFrm in 'InsertTableFrm.pas' {InsertTableForm},
  BlogCateFrm in 'BlogCateFrm.pas' {BlogCateForm},
  AddBlogCateFrm in 'AddBlogCateFrm.pas' {AddBlogCateForm},
  CodeFrm in 'CodeFrm.pas' {CodeForm};

{$R *.res}

begin
  {
    Application.Initialize;
    Application.Title := 'Monolith Groupware Client | ��ʯȺ���ͻ���';
    Application.CreateForm(TMainForm, MainForm);
    Application.Run;
  }
  begin
    try
      splashForm := TsplashForm.Create(Application);
      splashForm.Show;
      splashForm.Update;

      Application.Initialize;
      Application.Title := 'Monolith Blog Client | ��ʯ���Ϳͻ���';
      Application.UpdateFormatSettings := FALSE;

      Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TCodeForm, CodeForm);
  splashForm.Label1.Caption := '������������...';
      splashForm.ProgressBar_Splash.Position := 10;
      splashForm.Update;

      Application.CreateForm(TBlogForm, BlogForm);
      splashForm.Label1.Caption := 'Blog��ʾҳ��������...';
      splashForm.ProgressBar_Splash.Position := 20;
      splashForm.Update;

      Application.CreateForm(TAddBlogForm, AddBlogForm);
      splashForm.Label1.Caption := 'Blog���ҳ��������...';
      splashForm.ProgressBar_Splash.Position := 40;
      splashForm.Update;

      Application.CreateForm(TInsertTableForm, InsertTableForm);
      splashForm.Label1.Caption := 'Blog���ҳ��������...';
      splashForm.ProgressBar_Splash.Position := 60;
      splashForm.Update;

      Application.CreateForm(TBlogCateForm, BlogCateForm);
      splashForm.Label1.Caption := 'Blog������ʾҳ��������...';
      splashForm.ProgressBar_Splash.Position := 80;
      splashForm.Update;

      Application.CreateForm(TAddBlogCateForm, AddBlogCateForm);
      splashForm.Label1.Caption := 'Blog������ӡ��޸���ʾҳ��������...';
      splashForm.ProgressBar_Splash.Position := 90;
      splashForm.Update;

      splashForm.Label1.Caption:='��ӭʹ����ʯ���Ϳͻ���';
      splashForm.ProgressBar_Splash.Position := 100;
      splashForm.Update;

      Application.Run;
    finally

      splashForm.Close;
      splashForm.Free;
    end;
  end;
end.

