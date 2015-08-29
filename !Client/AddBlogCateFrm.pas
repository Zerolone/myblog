unit AddBlogCateFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, Buttons, ExtCtrls;

type
  TAddBlogCateForm = class(TForm)
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    Panel3: TPanel;
    btn_add: TSpeedButton;
    btn_edt: TSpeedButton;
    Btn_Close: TSpeedButton;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    lbl_id: TLabel;
    Edt_title: TEdit;
    cbb_order: TComboBox;
    lbl_update: TLabel;
    procedure btn_edtClick(Sender: TObject);
    procedure btn_addClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Btn_CloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddBlogCateForm: TAddBlogCateForm;

implementation

uses MainFrm, ClientFunction, BlogCateFrm;

{$R *.dfm}

procedure TAddBlogCateForm.btn_edtClick(Sender: TObject);
var
  SqlL: string;

  //可否提交
  CanInsert: boolean;
begin
  CanInsert := true;

  if CanInsert then
  begin
    //编辑一个Blog分类
    SqlL := 'UPDATE `mb_cate` SET';

    //标题
    SqlL := SqlL + '`title`=';
    SqlL := SqlL + '''' + UTF8Encode(Edt_title.Text) + ''',';

    if (lbl_update.Caption <> '0') then
      //状态
      SqlL := SqlL + '`update`=1,';

    //顺序状态
    SqlL := SqlL + '`order`=';
    SqlL := SqlL + '''' + cbb_order.Items.Strings[cbb_order.itemIndex] + '''';

    //id
    SqlL := SqlL + ' WHERE `id`=' + lbl_id.caption;

    Log('Blog分类管理 >> 修改提交SQL语句：' + SqlL);
    try
      MainForm.btnConnectLocal.Click;

      MainForm.Dataset.SQL.Text := SqlL;
      MainForm.Dataset.ExecSQL;
      Log('Blog提交成功！提交的SQL语句为：' + SqlL);
      MessageBox(handle, 'Blog分类管理 >> 修改提交成功！', pchar(caption), mb_IconInformation);
      BlogCateForm.btnFrist.Click;
      AddBlogCateForm.Close;

    except
      Log('Blog分类管理 >> 修改提交失败！');
    end;

  end;
end;

procedure TAddBlogCateForm.btn_addClick(Sender: TObject);
var
  SqlL, SqlR: string;

  //可否提交
  CanInsert: boolean;
begin
  CanInsert := true;

  if CanInsert then
  begin
    //添加一个Blog分类
    SqlL := 'insert into `mb_cate` (';
    SqlR := 'values (';

    //标题
    SqlL := SqlL + '`title`,';
    SqlR := SqlR + '''' + UTF8Encode(Edt_title.Text) + ''',';

    //顺序
    SqlL := SqlL + '`order`)';
    SqlR := SqlR + '''' + cbb_order.Items.Strings[cbb_order.itemIndex] + ''');';

    Log('Blog分类管理 >> 添加提交SQL语句：' + SqlL + SqlR);
    try
      MainForm.btnConnectLocal.Click;

      MainForm.Dataset.SQL.Text := SqlL + SqlR;
      MainForm.Dataset.ExecSQL;
      Log('Blog分类提交成功！提交的SQL语句为：' + SqlL + SqlR);
      MessageBox(handle, 'Blog分类管理 >> 添加提交成功！', pchar(caption), mb_IconInformation);
      BlogCateForm.btnFrist.Click;
      AddBlogCateForm.Close;

    except
      Log('Blog分类管理 >> 添加失败！');
    end;
  end;
end;

procedure TAddBlogCateForm.FormCreate(Sender: TObject);
begin
  lbl_id.Hide;
  lbl_update.Hide;

  //显示
  Position := poDesktopCenter;
  Color := clWhite;
  BorderStyle := bsSingle;
  BorderIcons := [biSystemMenu, biMinimize];
end;

procedure TAddBlogCateForm.Btn_CloseClick(Sender: TObject);
begin
  Close;
end;

end.

