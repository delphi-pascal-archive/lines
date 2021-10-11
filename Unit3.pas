unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids;

type
  TForm3 = class(TForm)
    StringGrid1: TStringGrid;
    procedure FormCreate(Sender: TObject);
  private
    procedure LoadFile;
  public
    { Public declarations }
  end;

var
  Form3: TForm3;


implementation

{$R *.dfm}

procedure TForm3.LoadFile;
var
  f: textfile;
  temp, x, y: integer;
  tempstr: string;
begin
  assignfile(f, 'record.dat');
  reset(f);
  readln(f, temp);
  stringgrid1.colcount := temp;
  readln(f, temp);
  stringgrid1.rowcount := temp;
  for x := 0 to stringgrid1.colcount - 1 do
    for y := 0 to stringgrid1.rowcount - 1 do
    begin
      readln(F, tempstr);
      stringgrid1.cells[x, y] := tempstr;
    end;
  closefile(f);
end;




procedure TForm3.FormCreate(Sender: TObject);
begin
loadfile;
end;

end.
