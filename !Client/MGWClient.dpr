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
    Application.Title := 'Monolith Groupware Client | 磐石群件客户端';
    Application.CreateForm(TMainForm, MainForm);
    Application.Run;
  }
  begin
    try
      splashForm := TsplashForm.Create(Application);
      splashForm.Show;
      splashForm.Update;

      Application.Initialize;
      Application.Title := 'Monolith Blog Client | 磐石博客客户端';
      Application.UpdateFormatSettings := FALSE;

      Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TCodeForm, CodeForm);
  splashForm.Label1.Caption := '主程序载入中...';
      splashForm.ProgressBar_Splash.Position := 10;
      splashForm.Update;

      Application.CreateForm(TBlogForm, BlogForm);
      splashForm.Label1.Caption := 'Blog显示页面载入中...';
      splashForm.ProgressBar_Splash.Position := 20;
      splashForm.Update;

      Application.CreateForm(TAddBlogForm, AddBlogForm);
      splashForm.Label1.Caption := 'Blog添加页面载入中...';
      splashForm.ProgressBar_Splash.Position := 40;
      splashForm.Update;

      Application.CreateForm(TInsertTableForm, InsertTableForm);
      splashForm.Label1.Caption := 'Blog表格页面载入中...';
      splashForm.ProgressBar_Splash.Position := 60;
      splashForm.Update;

      Application.CreateForm(TBlogCateForm, BlogCateForm);
      splashForm.Label1.Caption := 'Blog分类显示页面载入中...';
      splashForm.ProgressBar_Splash.Position := 80;
      splashForm.Update;

      Application.CreateForm(TAddBlogCateForm, AddBlogCateForm);
      splashForm.Label1.Caption := 'Blog分类添加、修改显示页面载入中...';
      splashForm.ProgressBar_Splash.Position := 90;
      splashForm.Update;

      splashForm.Label1.Caption:='欢迎使用磐石博客客户端';
      splashForm.ProgressBar_Splash.Position := 100;
      splashForm.Update;

      Application.Run;
    finally

      splashForm.Close;
      splashForm.Free;
    end;
  end;
end.

