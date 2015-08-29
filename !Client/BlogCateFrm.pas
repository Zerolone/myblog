unit BlogCateFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TBlogCateForm = class(TForm)
    imgEdit: TImage;
    btnPrev: TSpeedButton;
    btnNext: TSpeedButton;
    imgDel: TImage;
    lblcurr: TLabel;
    lbl1: TLabel;
    btnFrist: TSpeedButton;
    btnLast: TSpeedButton;
    lblRsCount: TLabel;
    btnViewAll: TButton;
    btnInit: TButton;
    procedure btnInitClick(Sender: TObject);
    procedure btnViewAllClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnFristClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnLastClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowBlogCate(Sender: TObject);
    procedure EditBlogCate(Sender: TObject);
    procedure DelBlogCate(Sender: TObject);
    procedure RefreshBlogCate();

    procedure EnterBlogCate(Sender: TObject);
    procedure LeaveBlogCate(Sender: TObject);

    //分页
    procedure SplitPage(int_pagenum: Integer);
  end;

var
  BlogCateForm: TBlogCateForm;

  //Label，Image控件数组
  img_edit, img_del: array[1..10] of TImage;
  lbl_title: array[1..10] of TLabel;

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

uses MainFrm, AddBlogCateFrm, ClientFunction;

{$R *.dfm}

procedure TBlogCateForm.btnInitClick(Sender: TObject);
var
  i: integer;
begin
  //初始化数组位置
  //将label对象付给label数组
  for i := 1 to 10 do
  begin
    lbl_title[i] := TLabel.Create(BlogCateForm);
    lbl_title[i].Parent := BlogCateForm;
    lbl_title[i].AutoSize := False;
    lbl_title[i].Top := int_Title_Top + i * 30;
    lbl_title[i].Left := int_Title_Left;
    lbl_title[i].Caption := 'MyBLogCate init ' + IntToStr(i);

    lbl_title[i].Width := int_Title_Width;
    lbl_title[i].Height := int_Title_Height;
    lbl_title[i].Font.Size := int_Title_FontSize;
    lbl_title[i].Font.Color := int_Title_FontColor;

    //    lbl_title[i].Transparent := True;
    lbl_title[i].Layout := tlCenter;
    //lbl_title[i].Alignment := taCenter;
    lbl_title[i].Show;
    lbl_title[i].OnClick := ShowBlogCate;
    lbl_title[i].OnMouseEnter := EnterBlogCate;
    lbl_title[i].OnMouseLeave := LeaveBlogCate;

    //初始化图片按钮
    img_edit[i] := TImage.Create(BlogCateForm);
    img_edit[i].Parent := BlogCateForm;
    img_edit[i].Top := lbl_title[i].Top;
    img_edit[i].Left := lbl_title[i].Left + lbl_title[i].width + 10;
    img_edit[i].Picture := imgEdit.Picture;
    img_edit[i].AutoSize := True;
    img_edit[i].Transparent := True;
    img_edit[i].Cursor := crHandPoint;
    img_edit[i].Show;
    img_edit[i].OnClick := EditBlogCate;

    img_del[i] := TImage.Create(BlogCateForm);
    img_del[i].Parent := BlogCateForm;
    img_del[i].Top := lbl_title[i].Top;
    img_del[i].Left := img_edit[i].Left + img_edit[i].width + 10;
    img_del[i].Picture := imgDel.Picture;
    img_del[i].AutoSize := True;
    img_del[i].Transparent := True;
    img_del[i].Cursor := crHandPoint;
    img_del[i].Show;
    img_del[i].OnClick := DelBlogCate;
  end;
end;

procedure TBlogCateForm.ShowBlogCate(Sender: TObject);
//var
//  int_tag: Integer;
begin
  //  int_tag := TLabel(Sender).Tag;

  //  ShowMessage(TLabel(Sender).Caption);
end;

procedure TBlogCateForm.EditBlogCate(Sender: TObject);
var
  int_tag: Integer;

  str_SQL: string;
  i: Integer;
begin
  int_tag := TImage(Sender).Tag;

  //ShowMessage('你打算编辑编号为：'+ IntToStr(int_tag) +'的记录， 不过还没有做出来。');

  //--------------------0--------1--------2
  str_SQL := 'SELECT `title`, `order`, `update` FROM `mb_cate` WHERE `id`=' + IntToStr(int_tag);

  //查询
  MainForm.Dataset.SQL.Text := str_SQL;
  MainForm.Dataset.Open;

  AddBlogCateForm.cbb_order.Clear;

  AddBlogCateForm.Edt_title.Text := UTF8Decode(MainForm.Dataset.Fields[0].AsString);
  AddBlogCateForm.cbb_order.Items.Add(MainForm.Dataset.Fields[1].AsString);
  AddBlogCateForm.lbl_update.Caption := MainForm.Dataset.Fields[2].AsString;

  for i := 1 to 99 do
  begin
    AddBlogCateForm.cbb_order.Items.Add(IntToStr(i));
  end;
  AddBlogCateForm.cbb_order.ItemIndex := 0;

  AddBlogCateForm.lbl_id.Caption := IntToStr(int_tag);
  AddBlogCateForm.btn_edt.Show;
  AddBlogCateForm.btn_add.Hide;
  AddBlogCateForm.Caption := ' BLog分类管理 >> 修改 ';
  AddBlogCateForm.ShowModal;
end;

procedure TBlogCateForm.DelBlogCate(Sender: TObject);
var
  int_tag: Integer;
begin
  int_tag := TImage(Sender).Tag;
  if Application.MessageBox(PAnsiChar('你打算删除编号为：' + IntToStr(int_tag) + '的分类，并且该分类下面的所有Blog也将一起删除，确定么？'), 'Blog分类删除', mb_IconInformation + mb_YesNo) = mrYes then
  begin
    try
      //删除Blog
      strSql := 'UPDATE `mb_cate` SET `update` = 4 WHERE `id` =' + IntToStr(int_tag);
      Log(strSQL);
      MainForm.DatasetUpdate.SQL.Text := strSql;
      MainForm.DatasetUpdate.ExecSQL;

      strSql := 'UPDATE `mb_blog` SET `update` = 4 WHERE `cateid` =' + IntToStr(int_tag);
      Log(strSQL);
      MainForm.DatasetUpdate.SQL.Text := strSql;
      MainForm.DatasetUpdate.ExecSQL;

    except
      Application.MessageBox('提交数据到本地失败，请检查你的本地设置！', '更新本地数据', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
    end;

    btnViewAll.Click;
  end;

end;

procedure TBlogCateForm.RefreshBlogCate();
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
      img_edit[i].Hide;
      img_del[i].Hide;
    end;
end;

procedure TBlogCateForm.EnterBlogCate(Sender: TObject);
begin
  with Sender as TLabel do
  begin
    Color := clSkyBlue;
  end;
end;

procedure TBlogCateForm.LeaveBlogCate(Sender: TObject);
begin
  with Sender as TLabel do
  begin
    Color := clWhite;
  end;
end;

procedure TBlogCateForm.SplitPage(int_pagenum: Integer);
begin
  strSQL := 'SELECT `id`, `title` FROM `mb_cate`';
  strSQL := strSQL + ' WHERE `update` < 4';
  strSQL := strSQL + ' ORDER BY `order` ASC';
  strSQL := strSQL + ' LIMIT ' + IntToStr((int_pagenum - 1) * int_pagesize) + ', ' + str_pagesize + ';';
  Log(strSQL);
  BlogCateForm.Caption := ' BLog分类管理 >> 查看 >> 第' + IntToStr(int_pagenum) + '页 ';

  lblcurr.Caption := IntToStr(int_pagenum);

  BlogCateForm.Caption := ' BLog分类管理 >> 查看 >> 第' + lblcurr.Caption + '页 ';

  RefreshBlogCate();
end;

procedure TBlogCateForm.btnViewAllClick(Sender: TObject);
begin
  //计算总记录数
  strSql := 'SELECT COUNT(*) FROM `mb_cate`';
  strSQL := strSQL + ' WHERE `update` < 4;';

  MainForm.Dataset.SQL.Text := strSQL;
  MainForm.Dataset.Open;

  int_rscount := MainForm.Dataset.Fields[0].AsInteger;
  if (int_rscount mod int_pagesize = 0) then
    int_pagecount := int_rscount div int_pagesize
  else
    int_pagecount := int_rscount div int_pagesize + 1;

  lblRsCount.Caption := '总页数：' + IntToStr(int_pagecount) + '　';

  strSql := 'SELECT `id`, `title` FROM `mb_cate`';
  strSQL := strSQL + ' WHERE `update` < 4';
  strSQL := strSQL + ' ORDER BY `order` ASC LIMIT ' + str_pagesize + ';';
  BlogCateForm.Caption := ' BLog分类管理 >> 查看 ';

  RefreshBlogCate();
end;

procedure TBlogCateForm.FormCreate(Sender: TObject);
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

procedure TBlogCateForm.btnFristClick(Sender: TObject);
begin
  SplitPage(1);
end;

procedure TBlogCateForm.btnPrevClick(Sender: TObject);
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

procedure TBlogCateForm.btnNextClick(Sender: TObject);
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

procedure TBlogCateForm.btnLastClick(Sender: TObject);
begin
  SplitPage(int_pagecount);
end;

end.

