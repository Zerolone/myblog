unit ClientFunction;

interface

uses IniFiles, SysUtils, StrUtils, Classes, Windows, ShlObj, Forms;

procedure SaveIni(Datatext, header: string);
function GetIni(header: string): string;
procedure Log(LogStr: string);

//检测字符串长度
function CheckString(CheckStr: string; MaxLen: Integer): string;

//Highlight 代码加亮
function Highlight(str_code: string; int_line: Integer): string;

//////////////////////////////////
//作用：显示一个进度窗口        //
//参数：Title      标题         //
//参数：Position   进度值       //
//参数：Count      数据值       //
//作者：Zerolone                //
//制作时间：2008-05-25          //
//////////////////////////////////
procedure ShowProgress(Title: string; Position: Integer; Count: Integer);

implementation

uses MainFrm, ProgressFrm, ShowCalendarFrm, AddBlogFrm,

  //ShowMessage用的
  Dialogs;

{
var
  FPath: string;
}

procedure SaveIni(Datatext, header: string);
var
  ServerIni: TIniFile;
begin
  ServerIni := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'setting.ini');
  ServerIni.WriteString('Catch', header, Datatext);
  ServerIni.UpdateFile;
  ServerIni.Free;
end;

function GetIni(header: string): string;
var
  ServerName: string;
  ServerIni: TIniFile;
begin
  ServerIni := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'setting.ini');
  ServerName := ServerIni.ReadString('Catch', header, header);

  ServerIni.Free;
  result := ServerName;
end;

procedure Log(LogStr: string);
var
  F: textfile;
  FileName: string;
begin
  //  if (MainForm.chkLog.Checked) then
  //  begin
  FileName := 'Log.log';

  assignfile(F, FileName);
  //    if FileExists(FileName) then
  Append(F);
  //    else
  //      ReWrite(F);

  Writeln(F, FormatDateTime('yyyy-mm-dd hh:mm:ss', now) + '|' + LogStr);
  closefile(F);
  //  end;
end;

function CheckString(CheckStr: string; MaxLen: Integer): string;
var CheckStrLen: Integer;
begin
  CheckStrLen := Length(CheckStr);
  if CheckStrLen > MaxLen then
    result := LeftStr(CheckStr, MaxLen)
  else
    result := CheckStr;
end;

function Highlight(str_code: string; int_line: Integer): string;
const
  PerLineCss = 'cb';
  PerLine = 5;
var
  str_perline: string;
begin
  if (int_line + 1) mod PerLine = 0 then str_perline := 'class=' + PerLineCss;

  str_code := StringReplace(str_code, '<', '&lt;', [rfReplaceAll]);
  str_code := StringReplace(str_code, '>', '&gt;', [rfReplaceAll]);

  //替换1个Tab为2个空格
  str_code := StringReplace(str_code, #9, '&nbsp;&nbsp;', [rfReplaceAll]);

  //替换1个空格
  str_code := StringReplace(str_code, ' ', '&nbsp;', [rfReplaceAll]);

  {
    //正则替换
    RegexReplace := TPerlRegEx.Create(nil);
    RegexReplace.Subject := str_code;
    RegexReplace.Regex := 'echo[\(]';
    RegexReplace.Replacement := '<font color=red>echo</font>';
    RegexReplace.ReplaceAll;
    str_code := RegexReplace.Subject;
  }
  result := '<li ' + str_perline + '><div><span style="color: #0000BB">' + str_code + '</span></div></li>';
end;

procedure ShowProgress(Title: string; Position: Integer; Count: Integer);
var
  str_msg: string;
begin
  if (Title <> '') then
    ProgressForm.Caption := Title;

  ProgressForm.Show;
  ProgressForm.ProgressBar1.Position := ProgressForm.ProgressBar1.Position + Position;
  ProgressForm.Label1.Caption := IntToStr(ProgressForm.ProgressBar1.Position);

  if (Position = 100) then
  begin
    str_msg := '获取服务端数据成功！共' + PAnsiChar(IntToStr(Count)) + '条记录。';
    Application.MessageBox(PChar(str_msg), 'MGW更新成功！', MB_OK + MB_ICONASTERISK + MB_DEFBUTTON1 + MB_APPLMODAL);
    ProgressForm.Hide;
  end;
end;


end.

