unit InsertTableFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtCtrls, Buttons, DHTMLEDLib_TLB, ComObj;

type
  TInsertTableForm = class(TForm)
    GroupBox1: TGroupBox;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    Label21: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    Edit23: TEdit;
    Label1: TLabel;
    ColorDialog1: TColorDialog;
    procedure SpeedButton8Click(Sender: TObject);
    procedure Tableinsert(INRows, INCells: Integer; Tabelatr: string);
    procedure Tabeldesignerinfo;
    procedure SpinEdit3Change(Sender: TObject);
    procedure Edit20Change(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  InsertTableForm: TInsertTableForm;

implementation

uses AddBlogFrm;


{$R *.dfm}

procedure TInsertTableForm.SpeedButton8Click(Sender: TObject);
begin
  Tabeldesignerinfo;
  Tableinsert(Spinedit1.Value, Spinedit2.Value, Edit23.Text);
end;

procedure TInsertTableForm.Tableinsert(INRows, INCells: Integer; Tabelatr:
  string);
var
  insertTableParam: DEInsertTableParam;
  ovInsertTableParam: OleVariant;

begin
  insertTableParam := CreateComObject(Class_DEInsertTableParam) as
    IDEInsertTableParam;

  insertTableParam.NumRows := INRows;
  insertTableParam.NumCols := INCells;
  insertTableParam.TableAttrs := Tabelatr;
  insertTableParam.CellAttrs := '';
  ovInsertTableParam := OleVariant(insertTableParam);
  AddBlogForm.DHTML_content.ExecCommand(DECMD_INSERTTABLE,
    OLECMDEXECOPT_DODEFAULT,
    ovInsertTableParam);
  Close;
end;

procedure TInsertTableForm.Tabeldesignerinfo;
var
  S1, S2, S3, S4, S5: string;

begin
  if Spinedit3.Value >= 0 then
    S1 := 'width="' + Spinedit3.Text + '%" ';
  if Spinedit4.Value >= 0 then
    S2 := 'border="' + Spinedit4.Text + '" ';
  if copy(Edit20.text, 1, 1) = '#' then
    S3 := 'bordercolor="' + Edit20.Text + '" ';
  if copy(Edit21.text, 1, 1) = '#' then
    S4 := 'bordercolorlight="' + Edit21.Text + '" ';
  if copy(Edit22.text, 1, 1) = '#' then
    S5 := 'bordercolordark="' + Edit22.Text + '" ';

  Edit23.Text := S1 + S2 + S3 + S4 + S5;

end;

procedure TInsertTableForm.SpinEdit3Change(Sender: TObject);
begin
  Tabeldesignerinfo;
end;

procedure TInsertTableForm.Edit20Change(Sender: TObject);
begin
  Tabeldesignerinfo;
end;

procedure TInsertTableForm.SpeedButton5Click(Sender: TObject);
var
  Result: string;
begin

  if Colordialog1.Execute then
    begin

      Result :=
        IntToHex(GetRValue(Colordialog1.Color), 2) +
        IntToHex(GetGValue(Colordialog1.Color), 2) +
        IntToHex(GetBValue(Colordialog1.Color), 2);
      Edit20.Text := ('#' + Result);
    end;
end;

procedure TInsertTableForm.SpeedButton6Click(Sender: TObject);
var
  Result: string;
begin

  if Colordialog1.Execute then
    begin

      Result :=
        IntToHex(GetRValue(Colordialog1.Color), 2) +
        IntToHex(GetGValue(Colordialog1.Color), 2) +
        IntToHex(GetBValue(Colordialog1.Color), 2);
      Edit21.Text := ('#' + Result);
    end;
end;

procedure TInsertTableForm.SpeedButton7Click(Sender: TObject);
var
  Result: string;
begin

  if Colordialog1.Execute then
    begin

      Result :=
        IntToHex(GetRValue(Colordialog1.Color), 2) +
        IntToHex(GetGValue(Colordialog1.Color), 2) +
        IntToHex(GetBValue(Colordialog1.Color), 2);
      Edit22.Text := ('#' + Result);
    end;
end;

end.

