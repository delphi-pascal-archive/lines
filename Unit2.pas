unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ComCtrls, mmsystem, ExtCtrls, jpeg;

type

  TForm2 = class(TForm)
    StringGrid1: TStringGrid;
    Button1: TButton;
    Edit1: TEdit;
    Button2: TButton;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  Y1,Y2,ptsnew:integer;
  Z1,Z2,hero:string;
  n:array[0..6] of string;
  s:array[0..6] of integer;
  procedure loadfile;
  procedure storedata;
  procedure storerecord;

  implementation

uses Unit1;

{$R *.dfm}
procedure storedata;         //good
var
  i,j:integer;
begin
For i:=0 to 4 do
begin
n[i]:=(Form2.StringGrid1.Cells[0,i]);
end;
For i:=0 to 4 do
begin
s[i]:=strtoint(Form2.StringGrid1.Cells[1,i]);
end;
//MessageDlg(n[0]+inttostr(s[4]), mtInformation, [mbYes, mbNo], 1);
end;



procedure loadfile;
var
  f: textfile;
  temp, x, y: integer;
  tempstr: string;
begin
  assignfile(f, 'record.dat');
  reset(f);
  readln(f, temp);
  Form2.stringgrid1.colcount := temp;
  readln(f, temp);
  Form2.stringgrid1.rowcount := temp;
  for x := 0 to Form2.stringgrid1.colcount - 1 do
    for y := 0 to Form2.stringgrid1.rowcount - 1 do
    begin
      readln(F, tempstr);
      Form2.stringgrid1.cells[x, y] := tempstr;
    end;
  closefile(f);
end;



procedure TForm2.FormCreate(Sender: TObject);
begin
  loadfile;
end;

procedure TForm2.FormActivate(Sender: TObject);
begin
ptsnew:=pts;
storedata;
if endofgame=true then
begin
newgame;
end;
//MessageDlg(inttostr(s[3]), mtInformation, [mbYes, mbNo], 1);
end;


procedure storerecord;
var
  f: textfile;
  o, l, x, i, j, y: integer;
begin
For j:=1 to 5 do
  For i:=0 to 5-j do
        If s[i] > s[i+1] then
          begin
          Z1:=n[i];
          Z2:=n[i+1];
          n[i]:=Z2; n[i+1]:=Z1;
          Y1:=s[i];
          Y2:=s[i+1];
          s[i]:=Y2; s[i+1]:=Y1;
          end;

i:=6;
For i:=6 downto 2 do
begin
Form2.StringGrid1.Cells[0,(6-i)]:=n[i-1];
end;
For j:=6 downto 2 do
begin
Form2.StringGrid1.Cells[1,(6-j)]:=inttostr(s[j-1]);
end;
  assignfile(f, 'record.dat');
  rewrite(f);
  writeln(f, Form2.stringgrid1.colcount);
  writeln(f, Form2.stringgrid1.rowcount);
  for X := 0 to Form2.stringgrid1.colcount - 1 do
    for y := 0 to Form2.stringgrid1.rowcount - 1 do
      writeln(F, Form2.stringgrid1.cells[x, y]);
  closefile(f);
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
hero:=Form2.Edit1.Text;
n[5]:=hero;
s[5]:=ptsnew;
storerecord;
loadfile;
end;


end.


