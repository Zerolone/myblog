unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, DateUtils, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZConnection, ComCtrls, ZSqlMonitor,
  Menus, Buttons, ExtCtrls, jpeg, ShellAPI, ImgList;

//������
const mousemsg = wm_user + 1; //�Զ�����Ϣ�����ڴ����û���ͼ���ϵ�������¼�
const iid = 100; //�û��Զ�����ֵ����TnotifyIconDataA����ȫ�ֱ���ntida��ʹ��

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
    { ˽�ж��� }
    FConnection: TZConnection;
    FDataset: TZQuery;
    FDatasetUpdate: TZQuery;

    //�Զ�����Ϣ�����������������ͼ���¼�
    procedure mousemessage(var message: tmessage); message mousemsg;

  public
    { ���ö��� }
    property Connection: TZConnection read FConnection write FConnection;
    property Dataset: TZQuery read FDataset write FDataset;
    property DatasetUpdate: TZQuery read FDatasetUpdate write FDatasetUpdate;
  end;

var
  MainForm: TMainForm;

  //�����·��
  str_server_url: string;

  //��ȡ���������
  str_get_url: string;

  //�Ƿ�д����־
  ischkLog: string;

  //�ַ����������
  strConnStr: string;

  //���ݿ����
  ReCount: Integer;

  //
  str_Content: string;

  //����SID
  Max_SID: Integer;

  //ProgressBar Position
  int_position: Integer;

  //Sql��ѯ�ַ���
  strSQLR, strSQLL, strSQL: string;

  //�ͻ��˵�sid�� �ͻ��˵�modifytime, ����˵�modifytime
  str_client_id, str_client_modifytime, str_server_modifytime: string;


  //ͬ��ID
  //�ͻ���ͬ��������˵�id
  str_client_server: string;
  //�����ͬ�����ͻ��˵�id
  str_server_client: string;

  //
  int_CompareDateTime: Integer;
  str_CompareDateTime: string;

  //sql�ַ���
  strlst_sql: TStringList;


  //����
  ntida: TNotifyIcondataA; //�������Ӻ�ɾ��ϵͳ״̬ͼ��

implementation

uses ClientFunction, AddBlogFrm, BlogFrm, splashFrm,
  BlogCateFrm, AddBlogCateFrm, Unit1;

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  //ϵͳ������Ĭ������
  //��ʼ���ؼ�
  mmo1.Clear;

  btnConnectServer.Hide;
  btnConnectLocal.Hide;

  Button3.Hide;

  mmo1.Left := pnl1.Width;
  mmo1.Hide;

  ClientHeight := pnl1.Height + stat1.Height;
  ClientWidth := pnl1.Width + btnViewmmo.Width;

  stat1.Panels[0].Text := '���ȵ�¼�˵�';

  pnl1.Enabled := False;

  //Ĭ�Ͻ��ð�ť
  btnSync.Enabled := False;
  btnSyncBlog.Hide;
  btnSyncCate.Hide;

  mniViewBlog.Enabled := False;
  mniAddBlog.Enabled := False;

  mniViewCate.Enabled := False;
  mniAddCate.Enabled := False;

  mniSync.Enabled := False;

  edtQuick.Text := 'һ�仰���ٷ���';

  //����ͼ��//
  ntida.cbSize := sizeof(tnotifyicondataa); //ָ��ntida�ĳ���
  ntida.Wnd := handle; //ȡӦ�ó���������ľ��
  ntida.uID := iid; //�û��Զ����һ����ֵ����uCallbackMessage����ָ������Ϣ��ʹ
  ntida.uFlags := nif_icon + nif_tip + nif_message; //ָ���ڸýṹ��uCallbackMessage��hIcon��szTip��������Ч
  ntida.uCallbackMessage := mousemsg;
  //ָ���Ĵ�����Ϣ
  ntida.hIcon := Application.Icon.handle;
  //ָ��ϵͳ״̬����ʾӦ�ó����ͼ����
//  ntida.szTip := 'ʵ��ϵͳ����ͼ��!';
  //�����ͣ����ϵͳ״̬����ͼ����ʱ�����ָ���ʾ��Ϣ
  shell_notifyicona(NIM_ADD, @ntida);
  //��ϵͳ״̬������һ����ͼ��

end;

procedure TMainForm.btnConnectServerClick(Sender: TObject);
var
  //��ȡ����
  str_Content: string;
begin
  //���ӷ���˽ӿ�
  //����Ϊ��http://localhost/Blog/client.php
  str_server_url := GetIni('ServerUrl');

  //��ȡ���������
  try
    str_Content := IdHTTP1.Get(str_server_url + '?checkconnect=true');
    mmo1.Clear;
    mmo1.Text := str_Content;

    if (str_Content = 'true') then
    begin
      stat1.Panels[1].Text := '���������ӳɹ�';
      btnConnectServer.Enabled := False;
    end
    else
    begin
      stat1.Panels[1].Text := '����������ʧ��';
    end;

  except
    Application.MessageBox('������ļ������ڣ��������ã�', '���ӷ�����', MB_OK + MB_ICONEXCLAMATION + MB_APPLMODAL);
    stat1.Panels[1].Text := '�������ļ�������';
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
  //���ӷ����
  btnConnectServer.Click;

  //���ӿͻ���
//  btnConnectLocal.Click;

  if (stat1.Panels[1].Text = '���������ӳɹ�') then
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
  //����BLog��Ŀ
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
  AddBlogForm.Caption := ' BLog���� >> ��� ';
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
  // Update  Ϊ 0 ��Ϊ�¼�¼��Ϊ 1 ��Ϊ�޸Ĺ��ļ�¼ �� 2 ��Ϊ������ɵļ�¼

  //�ύ�������ӵļ�¼
  //------------------0-------1--------2---------3----------4
  strSQL := 'SELECT `id`, `cateid`, `title`, `content`, `posttime` FROM `mb_blog` WHERE `update`=0;';
  Dataset.SQL.Text := strSql;
  Dataset.Open;
  if ((not Dataset.Eof) or (not Dataset.Bof)) then
  begin
    ReCount := Dataset.RecordCount;
    for i := 1 to ReCount do
    begin
      //ÿ���ύ
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
          //ͬ�����ص�״̬
          strSql := 'UPDATE `mb_blog` SET `update` = 2 WHERE `id` =' + Dataset.Fields[0].AsString;
          DatasetUpdate.SQL.Text := strSql;
          DatasetUpdate.ExecSQL;

          mmo1.Lines.Add(UTF8Decode(Dataset.Fields[2].AsString) + '����ӳɹ���');
          Log('�ύ��' + str_server_url + '���ݳɹ���');
        end
        else
        begin
          mmo1.Lines.Add(str_Content);
        end;
      except
        Log('�ύ��' + str_server_url + '����ʧ�ܣ�');
        Application.MessageBox('�ύ���ݵ������ʧ�ܣ���������������ã�', '��ȡ���������', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
      end;

      Dataset.Next;
      Application.ProcessMessages;
    end;
  end;

  //�޸��ύ���صļ�¼
  //------------------0-------1--------2---------3
  strSQL := 'SELECT `id`, `cateid`, `title`, `content` FROM `mb_blog` WHERE `update`=1;';
  Dataset.SQL.Text := strSql;
  Dataset.Open;
  if ((not Dataset.Eof) or (not Dataset.Bof)) then
  begin
    ReCount := Dataset.RecordCount;
    for i := 1 to ReCount do
    begin
      //ÿ���ύ
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
          //ͬ�����ص�״̬
          strSql := 'UPDATE `mb_blog` SET `update` = 2 WHERE `id` =' + Dataset.Fields[0].AsString;
          DatasetUpdate.SQL.Text := strSql;
          DatasetUpdate.ExecSQL;

          mmo1.Lines.Add(UTF8Decode(Dataset.Fields[2].AsString) + '���޸ĳɹ���');
          Log('�ύ��' + str_server_url + '���ݳɹ���');
        end
        else
        begin
          mmo1.Lines.Add(str_Content);
        end;
      except
        Log('�ύ��' + str_server_url + '����ʧ�ܣ�');
        Application.MessageBox('�ύ���ݵ������ʧ�ܣ���������������ã�', '��ȡ���������', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
      end;

      Dataset.Next;
      Application.ProcessMessages;
    end;
  end;

  //ɾ����Ҫɾ���ļ�¼
  //------------------0-------1
  strSQL := 'SELECT `id`, `title` FROM `mb_blog` WHERE `update`=4;';
  Dataset.SQL.Text := strSql;
  Dataset.Open;
  if ((not Dataset.Eof) or (not Dataset.Bof)) then
  begin
    ReCount := Dataset.RecordCount;
    for i := 1 to ReCount do
    begin
      //ÿ���ύ
      tstrSql := TStringlist.Create;
      tstrSql.Add('mode=del');
      tstrSql.Add('id=' + Dataset.Fields[0].AsString);
      try
        str_Content := IdHTTP1.Post(str_server_url, tstrSql);
        if (str_Content = 'true') then
        begin
          //ɾ�������ص�״̬
          strSql := 'DELETE FROM `mb_blog` WHERE `id` = ' + Dataset.Fields[0].AsString;
          DatasetUpdate.SQL.Text := strSql;
          DatasetUpdate.ExecSQL;

          mmo1.Lines.Add(UTF8Decode(Dataset.Fields[1].AsString) + '��ɾ���ɹ���');
          Log('�ύ��' + str_server_url + '���ݳɹ���');
        end
        else
        begin
          mmo1.Lines.Add(str_Content);
        end;
      except
        Log('�ύ��' + str_server_url + '����ʧ�ܣ�');
        Application.MessageBox('�ύ���ݵ������ʧ�ܣ���������������ã�', '��ȡ���������', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
      end;

      Dataset.Next;
      Application.ProcessMessages;
    end;
  end;

  stat1.Panels[0].Text := 'ͬ�����';
end;

procedure TMainForm.btnQuickClick(Sender: TObject);
var
  tstrSql: TStrings;
begin
  //�������Ϸ���˲ſ���ʹ��
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
        Log('�ύ��' + str_server_url + '���ݳɹ���');

        mmo1.Lines.Add('��ӳɹ���');

        Application.MessageBox('�����ɹ���', '������������', MB_OK + MB_ICONASTERISK + MB_DEFBUTTON1 + MB_APPLMODAL);
        edtQuick.Clear;
      end
      else
      begin
        Log('�ύ�����ݣ�' + tstrSql.Text);
        mmo1.Lines.Add(str_Content);
      end;
    except
      Log('�ύ��' + str_server_url + '����ʧ�ܣ�');
      Application.MessageBox('�ύ���ݵ������ʧ�ܣ���������������ã�', '��ȡ���������', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
    end;
  end
  else
  begin
    Application.MessageBox('����Ҫ���ӷ���˲ſ���ʹ�øù��ܣ�', '�������ӷ����', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);

  end;
end;

procedure TMainForm.btnViewmmo1Click(Sender: TObject);
begin
  if (mmo1.Visible = False) then
  begin
    mmo1.Show;
    btnViewmmo1.Caption := '���ص�����Ϣ';
    btnViewmmo.Caption := '<';
    ClientWidth := ClientWidth + mmo1.Width;
  end
  else
  begin
    mmo1.Hide;
    btnViewmmo1.Caption := '��ʾ������Ϣ';
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
  AddBlogCateForm.Caption := ' BLog������� >> ��� ';
  AddBlogCateForm.Edt_title.Text := '';
  AddBlogCateForm.ShowModal;
end;

procedure TMainForm.btnSyncCateClick(Sender: TObject);
var
  i: Integer;
  tstrSql: TStrings;
begin
  // Update  Ϊ 0 ��Ϊ�¼�¼��Ϊ 1 ��Ϊ�޸Ĺ��ļ�¼ �� 2 ��Ϊ������ɵļ�¼

  //�ύ�������ӵļ�¼
  //------------------0-------1--------2
  strSQL := 'SELECT `id`,  `title`, `order` FROM `mb_cate` WHERE `update`=0;';
  Dataset.SQL.Text := strSql;
  Dataset.Open;
  if ((not Dataset.Eof) or (not Dataset.Bof)) then
  begin
    ReCount := Dataset.RecordCount;
    for i := 1 to ReCount do
    begin
      //ÿ���ύ
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
          Log('�ύ��' + str_server_url + '���ݳɹ���');

          //ͬ�����ص�״̬
          strSql := 'UPDATE `mb_cate` SET `update` = 2 WHERE `id` =' + Dataset.Fields[0].AsString;
          DatasetUpdate.SQL.Text := strSql;
          DatasetUpdate.ExecSQL;

          mmo1.Lines.Add(UTF8Decode(Dataset.Fields[1].AsString) + '����ӳɹ���');
        end
        else
        begin
          mmo1.Lines.Add(str_Content);
        end;
      except
        Log('�ύ��' + str_server_url + '����ʧ�ܣ�');
        Application.MessageBox('�ύ���ݵ������ʧ�ܣ���������������ã�', '��ȡ���������', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
      end;

      Dataset.Next;
      Application.ProcessMessages;
    end;
  end;

  //�޸��ύ���صļ�¼
  //------------------0-------1--------2
  strSQL := 'SELECT `id`,  `title`, `order` FROM `mb_cate` WHERE `update`=1;';
  Dataset.SQL.Text := strSql;
  Dataset.Open;
  if ((not Dataset.Eof) or (not Dataset.Bof)) then
  begin
    ReCount := Dataset.RecordCount;
    for i := 1 to ReCount do
    begin
      //ÿ���ύ
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
          Log('�ύ��' + str_server_url + '���ݳɹ���');

          //ͬ�����ص�״̬
          strSql := 'UPDATE `mb_cate` SET `update` = 2 WHERE `id` =' + Dataset.Fields[0].AsString;
          DatasetUpdate.SQL.Text := strSql;
          DatasetUpdate.ExecSQL;

          mmo1.Lines.Add(UTF8Decode(Dataset.Fields[1].AsString) + '���޸ĳɹ���');
        end
        else
        begin
          mmo1.Lines.Add(str_Content);
        end;
      except
        Log('�ύ��' + str_server_url + '����ʧ�ܣ�');
        Application.MessageBox('�ύ���ݵ������ʧ�ܣ���������������ã�', '��ȡ���������', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
      end;

      Dataset.Next;
      Application.ProcessMessages;
    end;
  end;

  //ɾ����Ҫɾ���ļ�¼
  //------------------0------1
  strSQL := 'SELECT `id`, `title` FROM `mb_cate` WHERE `update`=4;';
  Dataset.SQL.Text := strSql;
  Dataset.Open;
  if ((not Dataset.Eof) or (not Dataset.Bof)) then
  begin
    ReCount := Dataset.RecordCount;
    for i := 1 to ReCount do
    begin
      //ÿ���ύ
      tstrSql := TStringlist.Create;
      tstrSql.Add('mode=delcate');
      tstrSql.Add('id=' + Dataset.Fields[0].AsString);
      try
        str_Content := IdHTTP1.Post(str_server_url, tstrSql);
        if (str_Content = 'true') then
        begin
          Log('�ύ��' + str_server_url + '���ݳɹ���');

          //ɾ�������ص�״̬
          strSql := 'DELETE FROM `mb_cate` WHERE `id` = ' + Dataset.Fields[0].AsString;
          DatasetUpdate.SQL.Text := strSql;
          DatasetUpdate.ExecSQL;

          strSql := 'DELETE FROM `mb_blog` WHERE `cateid` = ' + Dataset.Fields[0].AsString;
          DatasetUpdate.SQL.Text := strSql;
          DatasetUpdate.ExecSQL;

          mmo1.Lines.Add(UTF8Decode(Dataset.Fields[1].AsString) + '��ɾ���ɹ���');
        end
        else
        begin
          mmo1.Lines.Add(str_Content);
        end;
      except
        Log('�ύ��' + str_server_url + '����ʧ�ܣ�');
        Application.MessageBox('�ύ���ݵ������ʧ�ܣ���������������ã�', '��ȡ���������', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
      end;

      Dataset.Next;
      Application.ProcessMessages;
    end;
  end;

  stat1.Panels[0].Text := 'ͬ�����';

end;

procedure TMainForm.mousemessage(var message: tmessage);
var
  mousept: TPoint; //�����λ��
begin
  inherited;
  if message.LParam = wm_rbuttonup then begin //������Ҽ����ͼ��
    getcursorpos(mousept); //��ȡ���λ��
    pm1.popup(mousept.x, mousept.y);
    //�ڹ��λ�õ���ѡ��
  end;
  if message.LParam = wm_lbuttonup then begin //�����������ͼ��
    //��ʾӦ�ó��򴰿�
    ShowWindow(Handle, SW_SHOW);
    //������������ʾӦ�ó��򴰿�
    ShowWindow(Application.handle, SW_SHOW);
    SetWindowLong(Application.Handle, GWL_EXSTYLE,
      not (GetWindowLong(Application.handle, GWL_EXSTYLE)
      or WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW));
  end;
  message.Result := 0;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caNone; //���Դ�������κβ���
  ShowWindow(Handle, SW_HIDE); //����������
  //����Ӧ�ó��򴰿����������ϵ���ʾ
  ShowWindow(Application.Handle, SW_HIDE);
  SetWindowLong(Application.Handle, GWL_EXSTYLE,
    GetWindowLong(Application.handle, GWL_EXSTYLE)
    or WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW);
end;

procedure TMainForm.btnCloseClick(Sender: TObject);
begin
  //Ϊntida��ֵ��ָ���������
  ntida.cbSize := sizeof(tnotifyicondataa);
  ntida.wnd := handle;
  ntida.uID := iid;
  ntida.uFlags := nif_icon + nif_tip + nif_message;
  ntida.uCallbackMessage := mousemsg;
  ntida.hIcon := Application.Icon.handle;
  ntida.szTip := 'Icon';
  shell_notifyicona(NIM_DELETE, @ntida);
  //ɾ�����е�Ӧ�ó���ͼ��
  Application.Terminate;
  //�ж�Ӧ�ó������У��˳�Ӧ�ó���
end;

procedure TMainForm.btnConnectLocalClick(Sender: TObject);
begin
  stat1.Panels[0].Text := '���ݿ�������';
  //0���������ݿ� -- ִ��һ�κ�ť���
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

    //Ĭ�ϵľͲ�����INI�ļ��ˡ�
    Connection.Properties.Values['codepage'] := 'utf8';
    Connection.Properties.Values['client_encoding'] := 'utf8';

    if not Connection.Connected then Connection.Connect;

    Log('���ݿ����ӳɹ���');

    mmo1.Lines.Add('�ͻ��˰汾��' + Connection.ClientVersionStr + '-����˰汾��' + Connection.ServerVersionStr);

    stat1.Panels[0].Text := '�������ݿ����ӳɹ�';
  except
    Log('���ݿ�����ʧ�ܣ�');
    stat1.Panels[0].Text := '�������ݿ�����ʧ��';
    Application.MessageBox('���ݿ�����ʧ�ܣ��������ݿ�����Ƿ�������', '���ݿ�����', MB_OK + MB_ICONHAND + MB_DEFBUTTON1 + MB_APPLMODAL);
  end;

  btnConnectLocal.Enabled := False;
end;

procedure TMainForm.N1Click(Sender: TObject);
begin
  //���ӿͻ���
  btnConnectLocal.Click;

  //���ӿͻ���
//  btnConnectLocal.Click;

  if (stat1.Panels[0].Text = '�������ݿ����ӳɹ�') then
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
  //���ӿͻ��ˡ������
  btnConnectLocal.Click;
  btnConnectServer.Click;

  //ͬ�����ݺͷ���
  btnSyncBlog.Click;
  btnSyncCate.Click;
end;

procedure TMainForm.edtQuickClick(Sender: TObject);
begin
  if (edtQuick.Text = 'һ�仰���ٷ���') then edtQuick.Text := '';

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

