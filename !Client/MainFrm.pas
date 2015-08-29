unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, DateUtils, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZConnection, ComCtrls, ZSqlMonitor,
  Menus, Buttons, ExtCtrls, jpeg, ShellAPI, ImgList;

//托盘用
const mousemsg = wm_user + 1; //自定义消息，用于处理用户在图标上点击鼠标的事件
const iid = 100; //用户自定义数值，在TnotifyIconDataA类型全局变量ntida中使用

type
  TMainForm = class(TForm)
    btnConnectServer: TButton;
    mmo1: TMemo;
    IdHTTP1: TIdHTTP;
    Button3: TButton;
    stat1: TStatusBar;
    ZSQLMonitor1: TZSQLMonitor;
    mm1: TMainMenu;
    btn_connect: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    btn_about: TMenuItem;
    pnl1: TPanel;
    btnViewBlog: TSpeedButton;
    btnAddBlog: TSpeedButton;
    btnQuick: TSpeedButton;
    btnViewmmo1: TMenuItem;
    btnViewCate: TSpeedButton;
    btnAddCate: TSpeedButton;
    pm1: TPopupMenu;
    btnClose: TMenuItem;
    btnConnectLocal: TButton;
    N1: TMenuItem;
    mniViewBlog: TMenuItem;
    N6: TMenuItem;
    il1: TImageList;
    mniAddBlog: TMenuItem;
    mniSync: TMenuItem;
    mniN5: TMenuItem;
    mniViewCate: TMenuItem;
    mniAddCate: TMenuItem;
    mniN6: TMenuItem;
    btnSyncBlog: TSpeedButton;
    btnSyncCate: TSpeedButton;
    btnSync: TSpeedButton;
    edtQuick: TEdit;
    btnViewmmo: TSpeedButton;
    mniExit: TMenuItem;
    mnit1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure btnConnectServerClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ZSQLMonitor1LogTrace(Sender: TObject; Event: TZLoggingEvent);
    procedure btn_aboutClick(Sender: TObject);
    procedure btn_connectClick(Sender: TObject);
    procedure btnViewBogClick(Sender: TObject);
    procedure btnAddBlogClick(Sender: TObject);
    procedure btnSyncBlogClick(Sender: TObject);
    procedure btnQuickClick(Sender: TObject);
    procedure btnViewmmo1Click(Sender: TObject);
    procedure btnViewCateClick(Sender: TObject);
    procedure btnAddCateClick(Sender: TObject);
    procedure btnSyncCateClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure btnConnectLocalClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure mniViewBlogClick(Sender: TObject);
    procedure mniAddBlogClick(Sender: TObject);
    procedure mniSyncClick(Sender: TObject);
    procedure mniViewCateClick(Sender: TObject);
    procedure mniAddCateClick(Sender: TObject);
    procedure mniSyncCateClick(Sender: TObject);
    procedure btnSyncClick(Sender: TObject);
    procedure edtQuickClick(Sender: TObject);
    procedure edtQuickKeyPress(Sender: TObject; var Key: Char);
    procedure btnViewmmoClick(Sender: TObject);
    procedure mniExitClick(Sender: TObject);
    procedure mnit1Click(Sender: TObject);
  private
    { 私有定义 }
    FConnection: TZConnection;
    FDataset: TZQuery;
    FDatasetUpdate: TZQuery;

    //自定义消息处理函数，处理鼠标点击图标事件
    procedure mousemessage(var message: tmessage); message mousemsg;

  public
    { 公用定义 }
    property Connection: TZConnection read FConnection write FConnection;
    property Dataset: TZQuery read FDataset write FDataset;
    property DatasetUpdate: TZQuery read FDatasetUpdate write FDatasetUpdate;
  end;

var
  MainForm: TMainForm;

  //服务端路径
  str_server_url: string;

  //获取服务端内容
  str_get_url: string;

  //是否写入日志
  ischkLog: string;

  //字符串连接语句
  strConnStr: string;

  //数据库变量
  ReCount: Integer;

  //
  str_Content: string;

  //最大的SID
  Max_SID: Integer;

  //ProgressBar Position
  int_position: Integer;

  //Sql查询字符串
  strSQLR, strSQLL, strSQL: string;

  //客户端的sid， 客户端的modifytime, 服务端的modifytime
  str_client_id, str_client_modifytime, str_server_modifytime: string;


  //同步ID
  //客户端同步到服务端的id
  str_client_server: string;
  //服务端同步到客户端的id
  str_server_client: string;

  //
  int_CompareDateTime: Integer;
  str_CompareDateTime: string;

  //sql字符串
  strlst_sql: TStringList;


  //托盘
  ntida: TNotifyIcondataA; //用于增加和删除系统状态图标

implementation

uses ClientFunction, AddBlogFrm, BlogFrm, splashFrm,
  BlogCateFrm, AddBlogCateFrm, Unit1;

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  //系统启动的默认设置
  //初始化控件
  mmo1.Clear;

  btnConnectServer.Hide;
  btnConnectLocal.Hide;

  Button3.Hide;

  mmo1.Left := pnl1.Width;
  mmo1.Hide;

  ClientHeight := pnl1.Height + stat1.Height;
  ClientWidth := pnl1.Width + btnViewmmo.Width;

  stat1.Panels[0].Text := '请先登录菜单';

  pnl1.Enabled := False;

  //默认禁用按钮
  btnSync.Enabled := False;
  btnSyncBlog.Hide;
  btnSyncCate.Hide;

  mniViewBlog.Enabled := False;
  mniAddBlog.Enabled := False;

  mniViewCate.Enabled := False;
  mniAddCate.Enabled := False;

  mniSync.Enabled := False;

  edtQuick.Text := '一句话快速发布';

  //托盘图标//
  ntida.cbSize := sizeof(tnotifyicondataa); //指定ntida的长度
  ntida.Wnd := handle; //取应用程序主窗体的句柄
  ntida.uID := iid; //用户自定义的一个数值，在uCallbackMessage参数指定的消息中使
  ntida.uFlags := nif_icon + nif_tip + nif_message; //指定在该结构中uCallbackMessage、hIcon和szTip参数都有效
  ntida.uCallbackMessage := mousemsg;
  //指定的窗口消息
  ntida.hIcon := Application.Icon.handle;
  //指定系统状态栏显示应用程序的图标句柄
//  ntida.szTip := '实现系统托盘图标!';
  //当鼠标停留在系统状态栏该图标上时，出现该提示信息
  shell_notifyicona(NIM_ADD, @ntida);
  //在系统状态栏增加一个新图标

end;

procedure TMainForm.btnConnectServerClick(Sender: TObject);
var
  //获取内容
  str_Content: string;
begin
  //连接服务端接口
  //测试为：http://localhost/Blog/client.php
  str_server_url := GetIni('ServerUrl');

  //获取服务端内容
  try
    str_Content := IdHTTP1.Get(str_server_url + '?checkconnect=true');
    mmo1.Clear;
    mmo1.Text := str_Content;

    if (str_Content = 'true') then
    begin
      stat1.Panels[1].Text := '服务器连接成功';
      btnConnectServer.Enabled := False;
    end
    else
    begin
      stat1.Panels[1].Text := '服务器连接失败';
    end;

  except
    Application.MessageBox('服务端文件不存在，请检测设置！', '连接服务器', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
    stat1.Panels[1].Text := '服务器文件不存在';
  end;
end;

procedure TMainForm.Button3Click(Sender: TObject);
begin
  //
//  ProgressForm.Show;

  //  ShowProgress(10);
end;

procedure TMainForm.ZSQLMonitor1LogTrace(Sender: TObject;
  Event: TZLoggingEvent);
begin
  //  mmo1.Lines.Add(Event.AsString);
  Log(Event.AsString);
end;

procedure TMainForm.btn_aboutClick(Sender: TObject);
begin
  splashForm.ShowModal;
end;

procedure TMainForm.btn_connectClick(Sender: TObject);
begin
  //连接服务端
  btnConnectServer.Click;

  //连接客户端
//  btnConnectLocal.Click;

  if (stat1.Panels[1].Text = '服务器连接成功') then
  begin
    //    pnl1.Enabled := True;
    //    pnl2.Hide;

    btnSync.Enabled := True;

    mniSync.Enabled := True;

  end;
end;

procedure TMainForm.btnViewBogClick(Sender: TObject);
begin
  BlogForm.btnViewAll.Click;
  BlogForm.ShowModal;
end;

procedure TMainForm.btnAddBlogClick(Sender: TObject);
var
  str_SQL: string;
  int_count, i: Integer;
begin
  //加载BLog栏目
  str_SQL := 'SELECT `id`, `title` FROM `mb_cate` ORDER BY `order` ASC;';
  Dataset.SQL.Text := str_SQL;
  Dataset.Open;
  int_count := Dataset.RecordCount;

  AddBlogForm.cbb_title.Clear;
  AddBlogForm.cbb_id.Clear;
  for i := 1 to int_count do
  begin
    AddBlogForm.cbb_title.Items.Add(UTF8Decode(Dataset.FieldByName('title').AsString));
    AddBlogForm.cbb_id.Items.Add(Dataset.FieldByName('id').AsString);
    Dataset.Next;
  end;
  AddBlogForm.cbb_title.ItemIndex := 0;
  AddBlogForm.cbb_id.ItemIndex := 0;

  AddBlogForm.btn_add.Show;
  AddBlogForm.btn_edt.Hide;
  AddBlogForm.Caption := ' BLog管理 >> 添加 ';
  AddBlogForm.Edt_title.Text := '';
  AddBlogForm.Memo1.Clear;
  AddBlogForm.Timer1.Enabled := True;
  AddBlogForm.ShowModal;
end;

procedure TMainForm.btnSyncBlogClick(Sender: TObject);
var
  i: Integer;
  tstrSql: TStrings;
begin
  // Update  为 0 的为新记录，为 1 的为修改过的记录 ， 2 的为更新完成的记录

  //提交本地增加的记录
  //------------------0-------1--------2---------3----------4
  strSQL := 'SELECT `id`, `cateid`, `title`, `content`, `posttime` FROM `mb_blog` WHERE `update`=0;';
  Dataset.SQL.Text := strSql;
  Dataset.Open;
  if ((not Dataset.Eof) or (not Dataset.Bof)) then
  begin
    ReCount := Dataset.RecordCount;
    for i := 1 to ReCount do
    begin
      //每行提交
      tstrSql := TStringlist.Create;
      tstrSql.Add('mode=add');
      tstrSql.Add('id=' + Dataset.Fields[0].AsString);
      tstrSql.Add('cateid=' + Dataset.Fields[1].AsString);
      tstrSql.Add('title=' + Dataset.Fields[2].AsString);
      tstrSql.Add('content=' + Dataset.Fields[3].AsString);
      tstrSql.Add('posttime=' + Dataset.Fields[4].AsString);
      tstrSql.Add('update=2');

      try
        str_Content := IdHTTP1.Post(str_server_url, tstrSql);
        if (str_Content = 'true') then
        begin
          //同步本地的状态
          strSql := 'UPDATE `mb_blog` SET `update` = 2 WHERE `id` =' + Dataset.Fields[0].AsString;
          DatasetUpdate.SQL.Text := strSql;
          DatasetUpdate.ExecSQL;

          mmo1.Lines.Add(UTF8Decode(Dataset.Fields[2].AsString) + '：添加成功！');
          Log('提交到' + str_server_url + '内容成功！');
        end
        else
        begin
          mmo1.Lines.Add(str_Content);
        end;
      except
        Log('提交到' + str_server_url + '内容失败！');
        Application.MessageBox('提交数据到服务端失败，请检查你的网络设置！', '获取服务端数据', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
      end;

      Dataset.Next;
      Application.ProcessMessages;
    end;
  end;

  //修改提交本地的记录
  //------------------0-------1--------2---------3
  strSQL := 'SELECT `id`, `cateid`, `title`, `content` FROM `mb_blog` WHERE `update`=1;';
  Dataset.SQL.Text := strSql;
  Dataset.Open;
  if ((not Dataset.Eof) or (not Dataset.Bof)) then
  begin
    ReCount := Dataset.RecordCount;
    for i := 1 to ReCount do
    begin
      //每行提交
      tstrSql := TStringlist.Create;
      tstrSql.Add('mode=edit');
      tstrSql.Add('id=' + Dataset.Fields[0].AsString);
      tstrSql.Add('cateid=' + Dataset.Fields[1].AsString);
      tstrSql.Add('title=' + Dataset.Fields[2].AsString);
      tstrSql.Add('content=' + Dataset.Fields[3].AsString);
      tstrSql.Add('update=2');

 //     ShowMessage(Dataset.Fields[3].AsString);

      try
        str_Content := IdHTTP1.Post(str_server_url, tstrSql);
        if (str_Content = 'true') then
        begin
          //同步本地的状态
          strSql := 'UPDATE `mb_blog` SET `update` = 2 WHERE `id` =' + Dataset.Fields[0].AsString;
          DatasetUpdate.SQL.Text := strSql;
          DatasetUpdate.ExecSQL;

          mmo1.Lines.Add(UTF8Decode(Dataset.Fields[2].AsString) + '：修改成功！');
          Log('提交到' + str_server_url + '内容成功！');
        end
        else
        begin
          mmo1.Lines.Add(str_Content);
        end;
      except
        Log('提交到' + str_server_url + '内容失败！');
        Application.MessageBox('提交数据到服务端失败，请检查你的网络设置！', '获取服务端数据', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
      end;

      Dataset.Next;
      Application.ProcessMessages;
    end;
  end;

  //删除需要删除的记录
  //------------------0-------1
  strSQL := 'SELECT `id`, `title` FROM `mb_blog` WHERE `update`=4;';
  Dataset.SQL.Text := strSql;
  Dataset.Open;
  if ((not Dataset.Eof) or (not Dataset.Bof)) then
  begin
    ReCount := Dataset.RecordCount;
    for i := 1 to ReCount do
    begin
      //每行提交
      tstrSql := TStringlist.Create;
      tstrSql.Add('mode=del');
      tstrSql.Add('id=' + Dataset.Fields[0].AsString);
      try
        str_Content := IdHTTP1.Post(str_server_url, tstrSql);
        if (str_Content = 'true') then
        begin
          //删除掉本地的状态
          strSql := 'DELETE FROM `mb_blog` WHERE `id` = ' + Dataset.Fields[0].AsString;
          DatasetUpdate.SQL.Text := strSql;
          DatasetUpdate.ExecSQL;

          mmo1.Lines.Add(UTF8Decode(Dataset.Fields[1].AsString) + '：删除成功！');
          Log('提交到' + str_server_url + '内容成功！');
        end
        else
        begin
          mmo1.Lines.Add(str_Content);
        end;
      except
        Log('提交到' + str_server_url + '内容失败！');
        Application.MessageBox('提交数据到服务端失败，请检查你的网络设置！', '获取服务端数据', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
      end;

      Dataset.Next;
      Application.ProcessMessages;
    end;
  end;

  stat1.Panels[0].Text := '同步完毕';
end;

procedure TMainForm.btnQuickClick(Sender: TObject);
var
  tstrSql: TStrings;
begin
  //必须连上服务端才可以使用
  if (btnSync.Enabled) then
  begin
    tstrSql := TStringlist.Create;
    tstrSql.Add('mode=quick');
    tstrSql.Add('title=' + UTF8Encode(edtQuick.Text));
    //    tstrSql.Add('title=' + mmoQuick.Text);

    try
      str_Content := IdHTTP1.Post(str_server_url, tstrSql);
      if (str_Content = 'true') then
      begin
        Log('提交到' + str_server_url + '内容成功！');

        mmo1.Lines.Add('添加成功！');

        Application.MessageBox('发布成功！', '发布快速内容', MB_OK + MB_ICONASTERISK + MB_DEFBUTTON1 + MB_APPLMODAL);
        edtQuick.Clear;
      end
      else
      begin
        Log('提交的内容：' + tstrSql.Text);
        mmo1.Lines.Add(str_Content);
      end;
    except
      Log('提交到' + str_server_url + '内容失败！');
      Application.MessageBox('提交数据到服务端失败，请检查你的网络设置！', '获取服务端数据', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
    end;
  end
  else
  begin
    Application.MessageBox('必须要连接服务端才可以使用该功能！', '请先连接服务端', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);

  end;
end;

procedure TMainForm.btnViewmmo1Click(Sender: TObject);
begin
  if (mmo1.Visible = False) then
  begin
    mmo1.Show;
    btnViewmmo1.Caption := '隐藏调试信息';
    btnViewmmo.Caption := '<';
    ClientWidth := ClientWidth + mmo1.Width;
  end
  else
  begin
    mmo1.Hide;
    btnViewmmo1.Caption := '显示调试信息';
    btnViewmmo.Caption := '>';
    ClientWidth := ClientWidth - mmo1.Width;
  end;
end;

procedure TMainForm.btnViewCateClick(Sender: TObject);
begin
  BlogCateForm.btnViewAll.Click;
  BlogCateForm.ShowModal;
end;

procedure TMainForm.btnAddCateClick(Sender: TObject);
var
  i: Integer;
begin
  AddBlogCateForm.cbb_order.Clear;
  for i := 1 to 99 do
  begin
    AddBlogCateForm.cbb_order.Items.Add(IntToStr(i));
  end;
  AddBlogCateForm.cbb_order.ItemIndex := 0;

  AddBlogCateForm.btn_add.Show;
  AddBlogCateForm.btn_edt.Hide;
  AddBlogCateForm.Caption := ' BLog分类管理 >> 添加 ';
  AddBlogCateForm.Edt_title.Text := '';
  AddBlogCateForm.ShowModal;
end;

procedure TMainForm.btnSyncCateClick(Sender: TObject);
var
  i: Integer;
  tstrSql: TStrings;
begin
  // Update  为 0 的为新记录，为 1 的为修改过的记录 ， 2 的为更新完成的记录

  //提交本地增加的记录
  //------------------0-------1--------2
  strSQL := 'SELECT `id`,  `title`, `order` FROM `mb_cate` WHERE `update`=0;';
  Dataset.SQL.Text := strSql;
  Dataset.Open;
  if ((not Dataset.Eof) or (not Dataset.Bof)) then
  begin
    ReCount := Dataset.RecordCount;
    for i := 1 to ReCount do
    begin
      //每行提交
      tstrSql := TStringlist.Create;
      tstrSql.Add('mode=addcate');
      tstrSql.Add('id=' + Dataset.Fields[0].AsString);
      tstrSql.Add('title=' + Dataset.Fields[1].AsString);
      tstrSql.Add('order=' + Dataset.Fields[2].AsString);
      tstrSql.Add('update=2');

      try
        str_Content := IdHTTP1.Post(str_server_url, tstrSql);
        if (str_Content = 'true') then
        begin
          Log('提交到' + str_server_url + '内容成功！');

          //同步本地的状态
          strSql := 'UPDATE `mb_cate` SET `update` = 2 WHERE `id` =' + Dataset.Fields[0].AsString;
          DatasetUpdate.SQL.Text := strSql;
          DatasetUpdate.ExecSQL;

          mmo1.Lines.Add(UTF8Decode(Dataset.Fields[1].AsString) + '：添加成功！');
        end
        else
        begin
          mmo1.Lines.Add(str_Content);
        end;
      except
        Log('提交到' + str_server_url + '内容失败！');
        Application.MessageBox('提交数据到服务端失败，请检查你的网络设置！', '获取服务端数据', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
      end;

      Dataset.Next;
      Application.ProcessMessages;
    end;
  end;

  //修改提交本地的记录
  //------------------0-------1--------2
  strSQL := 'SELECT `id`,  `title`, `order` FROM `mb_cate` WHERE `update`=1;';
  Dataset.SQL.Text := strSql;
  Dataset.Open;
  if ((not Dataset.Eof) or (not Dataset.Bof)) then
  begin
    ReCount := Dataset.RecordCount;
    for i := 1 to ReCount do
    begin
      //每行提交
      tstrSql := TStringlist.Create;
      tstrSql.Add('mode=editcate');
      tstrSql.Add('id=' + Dataset.Fields[0].AsString);
      tstrSql.Add('title=' + Dataset.Fields[1].AsString);
      tstrSql.Add('order=' + Dataset.Fields[2].AsString);
      tstrSql.Add('update=2');

      try
        str_Content := IdHTTP1.Post(str_server_url, tstrSql);
        if (str_Content = 'true') then
        begin
          Log('提交到' + str_server_url + '内容成功！');

          //同步本地的状态
          strSql := 'UPDATE `mb_cate` SET `update` = 2 WHERE `id` =' + Dataset.Fields[0].AsString;
          DatasetUpdate.SQL.Text := strSql;
          DatasetUpdate.ExecSQL;

          mmo1.Lines.Add(UTF8Decode(Dataset.Fields[1].AsString) + '：修改成功！');
        end
        else
        begin
          mmo1.Lines.Add(str_Content);
        end;
      except
        Log('提交到' + str_server_url + '内容失败！');
        Application.MessageBox('提交数据到服务端失败，请检查你的网络设置！', '获取服务端数据', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
      end;

      Dataset.Next;
      Application.ProcessMessages;
    end;
  end;

  //删除需要删除的记录
  //------------------0------1
  strSQL := 'SELECT `id`, `title` FROM `mb_cate` WHERE `update`=4;';
  Dataset.SQL.Text := strSql;
  Dataset.Open;
  if ((not Dataset.Eof) or (not Dataset.Bof)) then
  begin
    ReCount := Dataset.RecordCount;
    for i := 1 to ReCount do
    begin
      //每行提交
      tstrSql := TStringlist.Create;
      tstrSql.Add('mode=delcate');
      tstrSql.Add('id=' + Dataset.Fields[0].AsString);
      try
        str_Content := IdHTTP1.Post(str_server_url, tstrSql);
        if (str_Content = 'true') then
        begin
          Log('提交到' + str_server_url + '内容成功！');

          //删除掉本地的状态
          strSql := 'DELETE FROM `mb_cate` WHERE `id` = ' + Dataset.Fields[0].AsString;
          DatasetUpdate.SQL.Text := strSql;
          DatasetUpdate.ExecSQL;

          strSql := 'DELETE FROM `mb_blog` WHERE `cateid` = ' + Dataset.Fields[0].AsString;
          DatasetUpdate.SQL.Text := strSql;
          DatasetUpdate.ExecSQL;

          mmo1.Lines.Add(UTF8Decode(Dataset.Fields[1].AsString) + '：删除成功！');
        end
        else
        begin
          mmo1.Lines.Add(str_Content);
        end;
      except
        Log('提交到' + str_server_url + '内容失败！');
        Application.MessageBox('提交数据到服务端失败，请检查你的网络设置！', '获取服务端数据', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
      end;

      Dataset.Next;
      Application.ProcessMessages;
    end;
  end;

  stat1.Panels[0].Text := '同步完毕';

end;

procedure TMainForm.mousemessage(var message: tmessage);
var
  mousept: TPoint; //鼠标点击位置
begin
  inherited;
  if message.LParam = wm_rbuttonup then begin //用鼠标右键点击图标
    getcursorpos(mousept); //获取光标位置
    pm1.popup(mousept.x, mousept.y);
    //在光标位置弹出选单
  end;
  if message.LParam = wm_lbuttonup then begin //用鼠标左键点击图标
    //显示应用程序窗口
    ShowWindow(Handle, SW_SHOW);
    //在任务栏上显示应用程序窗口
    ShowWindow(Application.handle, SW_SHOW);
    SetWindowLong(Application.Handle, GWL_EXSTYLE,
      not (GetWindowLong(Application.handle, GWL_EXSTYLE)
      or WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW));
  end;
  message.Result := 0;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caNone; //不对窗体进行任何操作
  ShowWindow(Handle, SW_HIDE); //隐藏主窗体
  //隐藏应用程序窗口在任务栏上的显示
  ShowWindow(Application.Handle, SW_HIDE);
  SetWindowLong(Application.Handle, GWL_EXSTYLE,
    GetWindowLong(Application.handle, GWL_EXSTYLE)
    or WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW);
end;

procedure TMainForm.btnCloseClick(Sender: TObject);
begin
  //为ntida赋值，指定各项参数
  ntida.cbSize := sizeof(tnotifyicondataa);
  ntida.wnd := handle;
  ntida.uID := iid;
  ntida.uFlags := nif_icon + nif_tip + nif_message;
  ntida.uCallbackMessage := mousemsg;
  ntida.hIcon := Application.Icon.handle;
  ntida.szTip := 'Icon';
  shell_notifyicona(NIM_DELETE, @ntida);
  //删除已有的应用程序图标
  Application.Terminate;
  //中断应用程序运行，退出应用程序
end;

procedure TMainForm.btnConnectLocalClick(Sender: TObject);
begin
  stat1.Panels[0].Text := '数据库连接中';
  //0、连接数据库 -- 执行一次后按钮变灰
  try
    Connection := TZConnection.Create(Self);

    Dataset := TZQuery.Create(Self);
    Dataset.Connection := Connection;
    Dataset.ReadOnly := False;

    DatasetUpdate := TZQuery.Create(Self);
    DatasetUpdate.Connection := Connection;
    DatasetUpdate.ReadOnly := False;

    Connection.Protocol := GetIni('Connection.Protocol');
    Connection.HostName := GetIni('Connection.HostName');
    Connection.Port := StrToInt(GetIni('Connection.Port'));
    Connection.Database := GetIni('Connection.Database');
    Connection.User := GetIni('Connection.User');
    Connection.Password := GetIni('Connection.Password');

    //默认的就不放入INI文件了。
    Connection.Properties.Values['codepage'] := 'utf8';
    Connection.Properties.Values['client_encoding'] := 'utf8';

    if not Connection.Connected then Connection.Connect;

    Log('数据库连接成功！');

    mmo1.Lines.Add('客户端版本：' + Connection.ClientVersionStr + '-服务端版本：' + Connection.ServerVersionStr);

    stat1.Panels[0].Text := '本地数据库连接成功';
  except
    Log('数据库连接失败！');
    stat1.Panels[0].Text := '本地数据库连接失败';
    Application.MessageBox('数据库连接失败！请检测数据库服务是否启动！', '数据库连接', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
  end;

  btnConnectLocal.Enabled := False;
end;

procedure TMainForm.N1Click(Sender: TObject);
begin
  //连接客户端
  btnConnectLocal.Click;

  //连接客户端
//  btnConnectLocal.Click;

  if (stat1.Panels[0].Text = '本地数据库连接成功') then
  begin
    pnl1.Enabled := True;

    mniViewBlog.Enabled := True;
    mniAddBlog.Enabled := True;

    mniViewCate.Enabled := True;
    mniAddCate.Enabled := True;
  end;
end;

procedure TMainForm.mniViewBlogClick(Sender: TObject);
begin
  btnViewBlog.Click;
end;

procedure TMainForm.mniAddBlogClick(Sender: TObject);
begin
  btnAddBlog.Click;
end;

procedure TMainForm.mniSyncClick(Sender: TObject);
begin
  btnSyncBlog.Click;
end;

procedure TMainForm.mniViewCateClick(Sender: TObject);
begin
  btnViewCate.Click;
end;

procedure TMainForm.mniAddCateClick(Sender: TObject);
begin
  btnAddCate.Click;
end;

procedure TMainForm.mniSyncCateClick(Sender: TObject);
begin
  btnSyncCate.Click;
end;

procedure TMainForm.btnSyncClick(Sender: TObject);
begin
  //连接客户端、服务端
  btnConnectLocal.Click;
  btnConnectServer.Click;

  //同步内容和分类
  btnSyncBlog.Click;
  btnSyncCate.Click;
end;

procedure TMainForm.edtQuickClick(Sender: TObject);
begin
  if (edtQuick.Text = '一句话快速发布') then edtQuick.Text := '';

end;

procedure TMainForm.edtQuickKeyPress(Sender: TObject; var Key: Char);
begin
  if (key = #13) then btnQuick.Click;

end;

procedure TMainForm.btnViewmmoClick(Sender: TObject);
begin
  btnViewmmo1.Click;
end;

procedure TMainForm.mniExitClick(Sender: TObject);
begin
  btnClose.Click;
end;

procedure TMainForm.mnit1Click(Sender: TObject);
begin
Form1.Show;
end;

end.

