unit Unit1;
                                //made by Sashuk, 2010, IMEI
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList, Menus, jpeg, mmsystem, Grids;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;                                                                                                                                                                                                                  //made by Sashuk, 2010, IMEI
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    ImageList1: TImageList;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    Timer1: TTimer;
    Timer2: TTimer;
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
    procedure Label1Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    procedure draw;
    procedure dedraw;
  public
    { Public declarations }
  end;

var

  Form1: TForm1;
  rec :TextFile;
  moved, soundon, endofgame, zz:boolean;
  c, i, randval, o, pos, ost0, ost1, ost2, ost3, ost4, ost5, ost6, ost7, ost8, ost9, p, col:integer;
  Pts, Step, XSub, YSub, counting, ColSub:integer; //Number of points, steps made, temporary parameters of the ball
  delx, delcol, dely:integer; //ints for selection of marked balls
  a:array[0..8,0..8] of integer; //cells
  b:array[0..8,0..8] of integer; //subcells
  sel:array[0..8,0..8] of integer; //selection check
  kx,ky,kcol:array[0..8] of integer;
  tx,ty,tcol:array[0..8] of integer; //for deleting control
  Clc, deleteline:boolean;
  pic:TBitmap;
  procedure newgame;
  procedure deleteselection;
  procedure randomfill;
  function delline:boolean;
  procedure findway(xx,yy:integer);
  procedure checkstep;

  implementation

uses Unit2;
{$R *.dfm}


procedure checkstep;
begin
If step>=79 then
begin
endofgame:=true;
Form2.Edit1.Visible:=true;
Form2.Button1.Visible:=true;
Form2.Showmodal;

end;
end;

procedure newgame; //NEWGAME
var
   i,j:integer;
begin
soundon := true;
step:=-1;
pts:=0;
moved:=false; endofgame:=false; pts:=0; xsub:=0; ysub:=0; counting:=0;
delx:=0; dely:=0; delcol:=0;
clc:=false; deleteline:=false;
Form1.Timer1.Enabled:=false;
Form1.Label2.caption:= floattostr(pts);
Form1.Label3.caption:= floattostr(step);
clc:=false;
Form1.Imagelist1.GetBitmap(0,pic);
For i:=0 to 8 do
  For j:=0 to 8 do
    begin
    a[i,j]:=0;
    b[i,j]:=0;
    Form1.Image1.Canvas.Draw(i*36,j*36,pic);
    end;
randomfill;
end;


procedure randomfill;
var
   i, x, y, colnum:integer;
begin
if delline = false then
begin
    i:=0;
    For x:=0 to 8 do
      For y:= 0 to 8 do
      begin
      b[x,y]:=0;
      end;
    repeat
    x:= random(9);
    y:= random(9);
    randval:= random(34)+1;
      case randval of
      1..5: col:= 1;
      6..10: col:=6;
      11..15: col:= 11;
      16..20: col:= 16;
      21..25: col:= 21;
      26..30: col:= 26;
      31..35: col:= 31;
      end;
    if a[x,y]= 0 then
    begin
    counting:=0;
    ost0:=0;
    ost1:=0;
    ost2:=0;
    a[x,y]:=col;
    kx[i]:=x;
    ky[i]:=y;
    kcol[i]:=col;
    i:=i+1;
    step:=step+1;
    checkstep;
    end;
    until (i=3);
    end;
    Form1.Timer1.Enabled:=true;
    delline;
end;


function delline: boolean; //watches the sequences of balls
var
  i,j,p:integer; //local counters
begin
delline:=false;
For i:=0 to 4 do  // horisontal
  For j:=0 to 8 do
     If (a[i,j]=a[i+1,j]) and (a[i+1,j]=a[i+2,j]) and (a[i+2,j]=a[i+3,j]) and (a[i+3,j]=a[i+4,j]) and (a[i,j]<>0) then
     For p:=i to (i+4) do
     begin
     b[p,j]:= -1;
     end;
For j:=0 to 4 do  // vertical
  For i:=0 to 8 do
     If (a[i,j]=a[i,j+1]) and (a[i,j+1]=a[i,j+2]) and (a[i,j+2]=a[i,j+3]) and (a[i,j+3]=a[i,j+4]) and (a[i,j]<>0) then
     For p:=j to (j+4) do
     begin
     b[i,p]:= -1;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  //made by Sashuk, 2010, IMEI
     end;

For i:=8 downto 4 do   //1st diagonal
  For j:=0 to 4 do
    If (a[i,j]=a[i-1,j+1]) and (a[i-1,j+1]=a[i-2,j+2]) and (a[i-2,j+2]=a[i-3,j+3]) and (a[i-3,j+3]=a[i-4,j+4]) and (a[i,j]<>0) then
    begin
    b[i,j]:= -1;
    b[i-1,j+1]:= -1;             //
    b[i-2,j+2]:= -1;             //
    b[i-3,j+3]:= -1;             //how to wrap in a cycle?
    b[i-4,j+4]:= -1;             //
    end;

For i:=0 to 4 do
  For j:=0 to 4 do
    If (a[i,j]=a[i+1,j+1]) and (a[i+1,j+1]=a[i+2,j+2]) and (a[i+2,j+2]=a[i+3,j+3]) and (a[i+3,j+3]=a[i+4,j+4]) and (a[i,j]<>0) then
    For p:=0 to 4 do
    b[i+p,j+p]:= -1;

For i:=0 to 8 do
  For j:=0 to 8 do
    If (b[i,j]=-1) then
      begin
      Form1.Imagelist1.GetBitmap(0, pic);
      Form1.Image1.Canvas.Draw(i*36, j*36, pic);
      delline:= true;
      pts:= pts+20;
      Form1.Label2.caption:= floattostr(pts);
      step:=step-1;
      Form1.Label3.caption:= floattostr(step-1);
      a[i,j]:=0;
      b[i,j]:=0;
      end;
      Form1.Label3.caption:= floattostr(step+1);


Form1.Label3.caption:= floattostr(step+1);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
pic:= TBitmap.Create;
Randomize;
newgame;
Form1.Label3.caption:= inttostr(3);
Doublebuffered:=true;
PlaySound('BEEP.wav', 0, SND_ASYNC);
end;

procedure TForm1.N3Click(Sender: TObject);  //CLOSE
var
   ch:integer;
begin
    ch:= MessageDlg('Вы действительно хотите выйти?', mtInformation, [mbYes, mbNo], 1);
    case ch of mrYes:
    begin
    Form1.Close;
    end;
end;
end;


procedure TForm1.N4Click(Sender: TObject);
begin
newgame;
end;

procedure deleteselection;
var i,j:integer;
begin
For i:=0 to 8 do
  For j:=0 to 8 do
      if sel[i,j]=36 then
        begin
        Form1.ImageList1.GetBitmap(1,pic);
        Form1.Image1.Canvas.Draw(i*36,j*36,pic);
        Messagedlg('OLOLOSHKI', mtInformation, [mbOK],1);
        end;
      if sel[i,j]=37 then
        begin
        Form1.ImageList1.GetBitmap(6,pic);
        Form1.Image1.Canvas.Draw(i*36,j*36,pic);
        end;
      if sel[i,j]=38 then
        begin
        Form1.ImageList1.GetBitmap(11,pic);
        Form1.Image1.Canvas.Draw(i*36,j*36,pic);
        end;
      if sel[i,j]=39 then
        begin
        Form1.ImageList1.GetBitmap(16,pic);
        Form1.Image1.Canvas.Draw(i*36,j*36,pic);
        end;
      if sel[i,j]=40 then
        begin
        Form1.ImageList1.GetBitmap(21,pic);
        Form1.Image1.Canvas.Draw(i*36,j*36,pic);
        end;
      if sel[i,j]=41 then
        begin
        Form1.ImageList1.GetBitmap(26,pic);
        Form1.Image1.Canvas.Draw(i*36,j*36,pic);
        end;
      if sel[i,j]=42 then
        begin
        Form1.ImageList1.GetBitmap(31,pic);
        Form1.Image1.Canvas.Draw(i*36,j*36,pic);
        end;
For i:=0 to 8 do
  For j:=0 to 8 do
  begin
  sel[i,j]:=0;
  end;
end;


procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i,j:integer;
  bee:integer;
begin
x:=x div 36;
y:=y div 36;
If a[x,y]>0 then
begin
For i:=0 to 8 do
  For j:=0 to 8 do
  begin
  b[i,j]:=0;
  end;

If (a[x,y]<>0) then
begin
  If a[delx,dely]=36 then
    begin
    delcol:= 1;
    end;
  If a[delx,dely]=37 then
    begin
    delcol:= 6;
    end;
  If a[delx,dely]=38 then
    begin
    delcol:= 11;
    end;
  If a[delx,dely]=39 then
    begin
    delcol:= 16;
    end;
  If a[delx,dely]=40 then
    begin
    delcol:= 21;
    end;
  If a[delx,dely]=41 then
    begin
    delcol:= 26;
    end;
  If a[delx,dely]=42 then
    begin
    delcol:= 31;
    end;
if moved=false then
begin
Form1.ImageList1.GetBitmap(delcol,pic);
Form1.Image1.Canvas.Draw(delx*36,dely*36,pic);
end
else
begin
Form1.ImageList1.GetBitmap(0,pic);
Form1.Image1.Canvas.Draw(delx*36,dely*36,pic);
end;

delx:=x;
dely:=y;
end;
moved:=false;
delcol:=a[x,y];
If a[x,y]=1 then
bee:= 36;
If a[x,y]=6 then
bee:= 37;
If a[x,y]=11 then
bee:= 38;
If a[x,y]=16 then
bee:= 39;
If a[x,y]=21 then
bee:= 40;
If a[x,y]=26 then
bee:= 41;
If a[x,y]=31 then
bee:= 42;


If a[x,y]<>0 then
begin
Form1.ImageList1.GetBitmap(bee,pic);
Form1.Image1.Canvas.Draw(delx*36,dely*36,pic);
end;

XSub:=x;
YSub:=y;
Colsub:=a[x,y];
Clc:= true;
findway(x,y);
end;

If  (clc=true) and (a[x,y]=0) and (b[x,y]=1) then
begin
Form1.ImageList1.GetBitmap(0,pic);
Form1.Image1.Canvas.Draw(XSub*36,YSub*36,pic);
Form1.ImageList1.GetBitmap(ColSub,pic);
Form1.Image1.Canvas.Draw(x*36,y*36, pic);
Clc:=false;
a[XSub,YSub]:=0;
a[x,y]:=ColSub;
Randomfill;
moved:=true;
end;
end;

procedure findway(xx,yy:integer);
var
  row,col:integer;
begin
checkstep;
For row:= xx-1 to xx+1 do
  For col:= yy-1 to yy+1 do
  begin
    If (col>=0) and (col<=9) and (row>=0) and (row<9) and (a[row,col]=0) and (b[row,col]=0) then
     begin
      If (col=xx-1) and (row=yy-1) then
        continue;
      If (col=xx+1) and (row=yy+1) then
        continue;                           //get rid of corner variants
      If (col=xx-1) and (row=yy+1) then
        continue;
      If (col=xx+1) and (row=yy-1) then
        continue;
      b[row,col]:=1;
      findway(row,col);
    end;
end;
end;


procedure TForm1.Label1Click(Sender: TObject);
begin
newgame;
end;

procedure TForm1.N5Click(Sender: TObject);
begin
Form2.Showmodal;
Form2.Button1.Visible:=false;
Form2.Edit1.Visible:=false;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
If soundon = true then
begin
Button1.caption:='Sound On';
PlaySound(0, 0, SND_ASYNC);
soundon:=false;
exit;
end;
If soundon = false then
begin
Button1.caption:='Sound On';
PlaySound('BEEP.wav', 0, SND_ASYNC);
soundon:=true;
exit;
end;
end;



procedure TForm1.draw;
begin
   Form1.Imagelist1.GetBitmap((kcol[pos]+ost0+ost1+ost2+ost3+ost4+ost5+ost6+ost7+ost8+ost9), pic);               //here goes the cycle
   Form1.Image1.Canvas.Draw(kx[pos]*36, ky[pos]*36, pic);
end;

procedure TForm1.dedraw;
begin
   Form1.Imagelist1.GetBitmap((tcol[pos]+ost0+ost1+ost2+ost3+ost4+ost5+ost6+ost7+ost8+ost9), pic);               //here goes the cycle
   Form1.Image1.Canvas.Draw(tx[pos]*36, ty[pos]*36, pic);
end;


procedure TForm1.Timer1Timer(Sender: TObject);
begin
Form1.Timer1.Interval:=1;
Form1.Image1.Enabled:=false;
  If counting<15 then
  begin
  If counting<5 then
    begin
    pos:=0;
    ost0:=4-(counting mod 5);
    draw;
    end;
  If (counting>4) and (counting<10) then
    begin
    pos:=1;
    ost0:=0;
    ost1:=4-(counting mod 5);
    draw;
  end;
  If counting>9 then
    begin
    pos:=2;
    ost0:=0;
    ost1:=0;
    ost2:=4-(counting mod 5);
    draw;
  end;
  counting:=counting+1;
  end
  else
  begin
  Form1.Timer1.Enabled:=false;
  Form1.Image1.Enabled:=true;
  exit;
  end;
end;



procedure TForm1.Timer2Timer(Sender: TObject);
begin
Form1.Timer1.Interval:=1;
Form1.Image1.Enabled:=false;
If (counting<((p+1)*5-3))=true then
begin
  If counting<5 then
    begin
    pos:=0;
    ost0:=counting mod 5;
    dedraw;
    end;
  If (counting>4) and (counting<10) then
    begin
    pos:=1;
    ost0:=0;
    ost1:=(counting mod 5);
    dedraw;
    end;
  If (counting>9) and (counting<15) then
  begin
    pos:=2;
    ost0:=0;
    ost1:=0;
    ost2:=(counting mod 5);
    dedraw;
  end;
  If (counting>14) and (counting<20) then
  begin
    pos:=3;
    ost0:=0;
    ost1:=0;
    ost2:=0;
    ost3:=(counting mod 5);
    dedraw;
  end;
  If (counting>19) and (counting<25) then
  begin
    pos:=4;
    ost0:=0;
    ost1:=0;
    ost2:=0;
    ost3:=0;
    ost4:=(counting mod 5);
    dedraw;
  end;
  If (counting>24) and (counting<30) then
  begin
    pos:=5;
    ost0:=0;
    ost1:=0;
    ost2:=0;
    ost3:=0;
    ost4:=0;
    ost5:=(counting mod 5);
    dedraw;
  end;
  If (counting>29) and (counting<35) then
  begin
    pos:=6;
    ost0:=0;
    ost1:=0;
    ost2:=0;
    ost3:=0;
    ost4:=0;
    ost5:=0;
    ost6:=(counting mod 5);
    dedraw;
  end;
  If (counting>34) and (counting<40) then
  begin
    pos:=7;
    ost0:=0;
    ost1:=0;
    ost2:=0;
    ost3:=0;
    ost4:=0;
    ost5:=0;
    ost6:=0;
    ost7:=(counting mod 5);
    dedraw;
  end;
  If (counting>39) and (counting<45) then
  begin
    pos:=8;
    ost0:=0;
    ost1:=0;
    ost2:=0;
    ost3:=0;
    ost4:=0;
    ost5:=0;
    ost6:=0;
    ost7:=0;
    ost8:=(counting mod 5);
    dedraw;
  end;
  If (counting>44) and (counting<50) then
  begin
    pos:=9;
    ost0:=0;
    ost1:=0;
    ost2:=0;
    ost3:=0;
    ost4:=0;
    ost5:=0;
    ost6:=0;
    ost7:=0;
    ost8:=0;
    ost9:=counting mod 5;
    dedraw;
  end;
  counting:=counting+1;
  end
else
  begin
  Form1.Timer2.Enabled:=false;
  Form1.Image1.Enabled:=true;
  exit;
  end;
end;


procedure TForm1.N7Click(Sender: TObject);
begin
Messagedlg('Игра Линии. Выполнил: Шумилов Александр, гр. 2231, а также помогали на паре Гюнаюшка и Женька:))', mtInformation, [mbOK],1);
end;

procedure TForm1.N6Click(Sender: TObject);
begin
Messagedlg('Удачной игры!', mtInformation, [mbOK],1);
end;

procedure TForm1.Image1Click(Sender: TObject);
begin
//Messagedlg('Удачной игры!', mtInformation, [mbOK],1);
end;

end.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               //made by Sashuk, 2010, IMEI
