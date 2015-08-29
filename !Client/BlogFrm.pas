unit BlogFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, jpeg, Buttons;

type
  TBlogForm = class(TForm)
    imgEdit: TImage;
    btnViewAll: TButton;
    btnPrev: TSpeedButton;
    btnNext: TSpeedButton;
    imgDel: TImage;
    btnInit: TButton;
    lblcurr: TLabel;
    lbl1: TLabel;
    btnFrist: TSpeedButton;
    btnLast: TSpeedButton;
    lblRsCount: TLabel;
    procedure btnViewAllClick(Sender: TObject);
    procedure btnInitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnFristClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnLastClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowBlog(Sender: TObject);
    //修改日志
    procedure EditBlog(Sender: TObject);
    procedure DelBlog(Sender: TObject);
    procedure RefreshBlog();

    procedure EnterBlog(Sender: TObject);
    procedure LeaveBlog(Sender: TObject);

    //分页
    procedure SplitPage(int_pagenum: Integer);

  end;

var
  BlogForm: TBlogForm;

  //Label，Image控件数组
  img_edit, img_del: array[1..10] of TImage;
  lbl_title, lbl_catetitle: array[1..10] of TLabel;

  //查询字符串
  strSQL: string;

  //数据库记录数
  ReCount: Integer;

  //总记录数
  int_rscount: Integer;

  //总页数
  int_pagecount: Integer;

  //默认数据
const int_Title_Top = -20;
const int_Title_Left = 10;
const int_Title_Width = 300;
const int_CateTitle_Width = 160;
const int_Title_Height = 26;
const int_Title_FontSize = 14;
const int_Title_FontColor = $00011425;

  //数据库用的
const int_pagesize = 10;
const str_pagesize = '10';

implementation

uses MainFrm, ClientFunction, AddBlogFrm;

{$R *.dfm}

procedure TBlogForm.btnViewAllClick(Sender: TObject);
begin
  //计算总记录数
  strSql := 'SELECT COUNT(*) FROM `mb_blog`;';
  MainForm.Dataset.SQL.Text := strSQL;
  MainForm.Dataset.Open;

  int_rscount := MainForm.Dataset.Fields[0].AsInteger;
  if (int_rscount mod int_pagesize = 0) then
    int_pagecount := int_rscount div int_pagesize
  else
    int_pagecount := int_rscount div int_pagesize + 1;

  lblRsCount.Caption := '总页数：' + IntToStr(int_pagecount) + '　';

  strSql := 'SELECT `id`, `title`, `catetitle` FROM `mb_view_blog` ORDER BY `id` DESC LIMIT ' + str_pagesize + ';';
  BlogForm.Caption := ' BLog管理 >> 查看 ';

  RefreshBlog();
end;

procedure TBlogForm.btnInitClick(Sender: TObject);
var
  i: integer;
begin
  //初始化数组位置
  //将label对象付给label数组
  for i := 1 to 10 do
  begin
    lbl_title[i] := TLabel.Create(BlogForm);
    lbl_title[i].Parent := BlogForm;
    lbl_title[i].AutoSize := False;
    lbl_title[i].Top := int_Title_Top + i * 30;
    lbl_title[i].Left := int_Title_Left;
    lbl_title[i].Caption := 'MyBLog init ' + IntToStr(i);

    lbl_title[i].Width := int_Title_Width;
    lbl_title[i].Height := int_Title_Height;
    lbl_title[i].Font.Size := int_Title_FontSize;
    lbl_title[i].Font.Color := int_Title_FontColor;

    //    lbl_title[i].Transparent := True;
    lbl_title[i].Layout := tlCenter;
    //lbl_title[i].Alignment := taCenter;
    lbl_title[i].Show;
    lbl_title[i].OnClick := ShowBlog;
    lbl_title[i].OnMouseEnter := EnterBlog;
    lbl_title[i].OnMouseLeave := LeaveBlog;

    //初始化图片按钮
    img_edit[i] := TImage.Create(BlogForm);
    img_edit[i].Parent := BlogForm;
    img_edit[i].Top := lbl_title[i].Top;
    img_edit[i].Left := lbl_title[i].Left + lbl_title[i].width + 10;
    img_edit[i].Picture := imgEdit.Picture;
    img_edit[i].AutoSize := True;
    img_edit[i].Transparent := True;
    img_edit[i].Cursor := crHandPoint;
    img_edit[i].Show;
    img_edit[i].OnClick := EditBlog;

    img_del[i] := TImage.Create(BlogForm);
    img_del[i].Parent := BlogForm;
    img_del[i].Top := lbl_title[i].Top;
    img_del[i].Left := img_edit[i].Left + img_edit[i].width + 10;
    img_del[i].Picture := imgDel.Picture;
    img_del[i].AutoSize := True;
    img_del[i].Transparent := True;
    img_del[i].Cursor := crHandPoint;
    img_del[i].Show;
    img_del[i].OnClick := DelBlog;

    lbl_catetitle[i] := TLabel.Create(BlogForm);
    lbl_catetitle[i].Parent := BlogForm;
    lbl_catetitle[i].AutoSize := False;
    lbl_catetitle[i].Top := lbl_title[i].Top;
    lbl_catetitle[i].Left := img_del[i].Left + img_del[i].width + 10;
    lbl_catetitle[i].Caption := '栏目初始化 ' + IntToStr(i);

    lbl_catetitle[i].Width := int_CateTitle_Width;
    lbl_catetitle[i].Height := int_Title_Height;
    lbl_catetitle[i].Font.Size := int_Title_FontSize;
    lbl_catetitle[i].Font.Color := int_Title_FontColor;

    lbl_catetitle[i].Transparent := True;
    lbl_catetitle[i].Layout := tlCenter;
    //lbl_title[i].Alignment := taCenter;
    lbl_catetitle[i].Show;
    //    lbl_catetitle[i].OnClick := ShowBlogCate;

  end;
end;

procedure TBlogForm.ShowBlog(Sender: TObject);
//var
//  int_tag: Integer;
begin
  //  int_tag := TLabel(Sender).Tag;

  //  ShowMessage(TLabel(Sender).Caption);
end;

procedure TBlogForm.EditBlog(Sender: TObject);
var
  int_tag: Integer;

  str_SQL: string;
  int_count, i: Integer;
begin
  int_tag := TImage(Sender).Tag;

  //选择对应ID的内容----0---------1----------2----------3-----------4
  str_SQL := 'SELECT `title`, `content`, `cateid`, `catetitle`, `update`  FROM `mb_view_blog` WHERE `id`=' + IntToStr(int_tag);

  //查询
  MainForm.Dataset.SQL.Text := str_SQL;
  MainForm.Dataset.Open;

  AddBlogForm.cbb_title.Clear;
  AddBlogForm.cbb_id.Clear;

  AddBlogForm.Edt_title.Text := UTF8Decode(MainForm.Dataset.Fields[0].AsString);
  AddBlogForm.Memo1.Text := UTF8Decode(MainForm.Dataset.Fields[1].AsString);
  //替换&


  AddBlogForm.Memo1.Text := StringReplace(AddBlogForm.Memo1.Text, '{html_and}', '&', [rfReplaceAll]);


  AddBlogForm.Timer1.Enabled := True;
  AddBlogForm.cbb_id.Items.Add(MainForm.Dataset.Fields[2].AsString);
  AddBlogForm.cbb_title.Items.Add(UTF8Decode(MainForm.Dataset.Fields[3].AsString));
  AddBlogForm.lbl_update.Caption:=MainForm.Dataset.Fields[4].AsString;

  //查询所有的Cate-----0------1
  str_SQL := 'SELECT `id`, `title` FROM `mb_cate` ORDER BY `order` ASC;';

  //查询分类
  MainForm.Dataset.SQL.Text := str_SQL;
  MainForm.Dataset.Open;
  int_count := MainForm.Dataset.RecordCount;

  for i := 1 to int_count do
  begin
    AddBlogForm.cbb_id.Items.Add(MainForm.Dataset.Fields[0].AsString);
    AddBlogForm.cbb_title.Items.Add(UTF8Decode(MainForm.Dataset.Fields[1].AsString));
    MainForm.Dataset.Next;
  end;
  AddBlogForm.cbb_title.ItemIndex := 0;
  AddBlogForm.cbb_id.ItemIndex := 0;

  AddBlogForm.lbl_id.Caption := IntToStr(int_tag);
  AddBlogForm.btn_edt.Show;
  AddBlogForm.btn_add.Hide;
  AddBlogForm.Caption := ' BLog管理 >> 修改 ';
  AddBlogForm.ShowModal;
end;

procedure TBlogForm.DelBlog(Sender: TObject);
var
  int_tag: Integer;
begin
  int_tag := TImage(Sender).Tag;
  if Application.MessageBox(PAnsiChar('你打算删除编号为：' + IntToStr(int_tag) + '的记录，确定么？'), 'Blog文章删除', mb_IconInformation + mb_YesNo) = mrYes then
  begin
    strSql := 'UPDATE `mb_blog` SET `update` = 4 WHERE `id` =' + IntToStr(int_tag);
    Log(strSQL);
    MainForm.DatasetUpdate.SQL.Text := strSql;

    try
      MainForm.DatasetUpdate.ExecSQL;
    except
      Application.MessageBox('提交数据到本地失败，请检查你的本地设置！', '更新本地数据', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
    end;

    btnFrist.Click;
  end;

end;

procedure TBlogForm.RefreshBlog();
var
  int_count, i: integer;
begin

  //查询
  MainForm.Dataset.SQL.Text := strSQL;
  MainForm.Dataset.Open;
  int_count := MainForm.Dataset.RecordCount;

  for i := 1 to int_count do
  begin
    lbl_title[i].Caption := UTF8Decode(MainForm.Dataset.FieldByName('title').AsString);
    lbl_title[i].Show;

    lbl_catetitle[i].Caption := UTF8Decode(MainForm.Dataset.FieldByName('catetitle').AsString);
    lbl_catetitle[i].Show;

    img_edit[i].Tag := MainForm.Dataset.FieldByName('id').AsInteger;
    img_edit[i].Show;

    img_del[i].Tag := MainForm.Dataset.FieldByName('id').AsInteger;
    img_del[i].Show;

    MainForm.Dataset.Next;
  end;

  if (int_count < 10) then
    for i := int_count + 1 to 10 do
    begin
      lbl_title[i].Hide;
      lbl_catetitle[i].Hide;
      img_edit[i].Hide;
      img_del[i].Hide;
    end;
end;

procedure TBlogForm.FormCreate(Sender: TObject);
begin
  lblcurr.Caption := '1';

  btnInit.Hide;
  btnInit.Click;

  btnViewAll.Hide;

  imgEdit.Hide;
  imgDel.Hide;

  //显示
  Position:= poDesktopCenter;
  Color := clWhite;
  BorderStyle:=bsSingle;
  BorderIcons:=[biSystemMenu,biMinimize];

end;

procedure TBlogForm.btnFristClick(Sender: TObject);
begin
  SplitPage(1);
end;

procedure TBlogForm.btnNextClick(Sender: TObject);
var
  int_curr: integer;
begin
  int_curr := StrToInt(lblcurr.Caption) + 1;

  if (int_curr > int_pagecount) then
    Application.MessageBox('已经到了最后页', '翻页显示', MB_OK + MB_ICONASTERISK + MB_DEFBUTTON1 + MB_APPLMODAL)
  else
  begin
    SplitPage(int_curr);
  end;
end;

procedure TBlogForm.btnPrevClick(Sender: TObject);
var
  int_curr: integer;
begin
  if (lblcurr.Caption > '1') then
  begin
    int_curr := StrToInt(lblcurr.Caption) - 1;
    SplitPage(int_curr);
  end
  else
    Application.MessageBox('已经到了第1页', '翻页显示', MB_OK + MB_ICONASTERISK + MB_DEFBUTTON1 + MB_APPLMODAL);
end;


procedure TBlogForm.EnterBlog(Sender: TObject);
begin
  with Sender as TLabel do
  begin
    Color := clSkyBlue;
  end;
end;

procedure TBlogForm.LeaveBlog(Sender: TObject);
begin
  with Sender as TLabel do
  begin
    Color := clWhite;
  end;
end;

procedure TBlogForm.btnLastClick(Sender: TObject);
begin
  SplitPage(int_pagecount);
end;

procedure TBlogForm.SplitPage(int_pagenum: Integer);
begin
  strSQL := 'SELECT `id`, `title`, `catetitle` FROM `mb_view_blog`';
  strSQL := strSQL + ' WHERE `update` < 4';
  strSQL := strSQL + ' ORDER BY `id` DESC';
  strSQL := strSQL + ' LIMIT ' + IntToStr((int_pagenum - 1) * int_pagesize) + ', ' + str_pagesize + ';';
  Log(strSQL);
  BlogForm.Caption := ' BLog管理 >> 查看 >> 第' + IntToStr(int_pagenum) + '页 ';

  lblcurr.Caption := IntToStr(int_pagenum);

  BlogForm.Caption := ' BLog管理 >> 查看 >> 第' + lblcurr.Caption + '页 ';

  RefreshBlog();
end;

end.

