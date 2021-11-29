unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, unit2, unit3, ExtCtrls, Math, Grids;

type
   TMass = array[0..15] of real;
type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit3: TEdit;
    Edit1: TEdit;
    Edit2: TEdit;
    Memo1: TMemo;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    Label3: TLabel;
    RadioGroup1: TRadioGroup;
    Edit4: TEdit;
    Image1: TImage;
    Button3: TButton;
    StringGrid1: TStringGrid;
    RadioGroup2: TRadioGroup;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    Function ImgXToRealX(ImgX:integer):real;
    Function ImgYToRealY(ImgY:integer):real;
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure LINE(DestCanvas:TCanvas;x1,y1,x2,y2:integer;color:TColor);
    procedure FormDestroy(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  VirtCanvas: TBitMap;
  Massn: array [0..7] of real = (15,31,63,127,255,511,1023,2047);
  Massk: array [0..15] of real = (11,5,26,16,57,45,120,106,247,231,502,484,1013,993,2036,2014);
  Massd: array [0..1] of real = (3,7);
  Col: array [0..8] of TColor = (clFuchsia,clGreen,clYellow,clNavy,clSilver,clAqua,clBlue,clLime,clRed);
  Fun: array [0..12] of string = ('n=15','n=31','n=63','n=127','n=255','n=511','n=1023','n=2047','P допустимое',
                                  'k/n','r','r/(2-r)','R');
  Masskn, MassR1, MassR2, MassR3, MassR4, MassPnfe: TMass;

  P1,A,H,P2: real;
  gridX,gridY: word;          {Количество квадратов}
  imgshagX,imgshagY: integer; {Количество пикселей в одной клетке}
  realshagX,realshagY: real;  {Это длина одного квадрата в реальных координатах}
  MinX,MaxX,MinY,MaxY:real;
  ffx,ffy,FullPath: string;   {формат вывода числовых данных по осям и полный путь к exe}
  BorderX,BorderY: word;      {Отступ по от края формы по осям}
implementation

{$R *.DFM}

{Function NormFormSch(osn:real):string;
var
pok:integer;
s1,s2:string;
begin
pok:=0;
osn:=StrToFloat(s1);
If (osn>0) and (osn<1) then
   begin
      Repeat
      osn:=osn*10;
      pok:=pok-1;
      Until (osn>=1) and (osn<10)
   end;
If (osn>-1) and (osn<0) then
   begin
      Repeat
      osn:=osn*10;
      pok:=pok-1;
      Until (osn>-10) and (osn<=-1)
   end;
If (osn>10) then
begin
   Repeat
   osn:=osn/10;
   pok:=pok+1;
   until (osn>=1) and (osn<10)
end;
If (osn<-10) then
begin
   Repeat
   osn:=osn/10;
   pok:=pok+1;
   until (osn>-10) and (osn<=-1)
end;
s1:=FloatToStr(osn);
s2:=IntToStr(pok);
result:=s1+'*10^'+s2;
end;}

Procedure ResetMass(var Mass:TMass);
var
i:word;
begin
   For i:=0 to 15 Do
   begin
   Mass[i]:=0;
   end;
end;

Procedure MaxMass(var Mass:TMass;c:string;max:word); {Здесь
                                                      строка с определяет
                                                      какая координата
                                                      передаётся в процедуру}
var
i:word;
j:real;
begin
j:=Mass[0];
If c = 'X' then
   begin
   If j>MaxX then MaxX:=j;
   end;
If c = 'Y' then
   begin
   If j>MaxY then MaxY:=j;
   end;
For i:=1 to max Do
   begin
   If j<Mass[i] then j:=Mass[i];
   end;
If c = 'X' then
   begin
   If j>MaxX then MaxX:=j;
   end;
If c = 'Y' then
   begin
   If j>MaxY then MaxY:=j;
   end;
end;

Procedure MinMass(var Mass:TMass;c:string;max:word);
var
i:word;
j:real;
begin
j:=Mass[0];
If c = 'X' then
   begin
   If j<MinX then MinX:=j;
   end;
If c = 'Y' then
   begin
   If j<MinY then MinY:=j;
   end;
For i:=1 to max Do
   begin
   If j>Mass[i] then j:=Mass[i];
   end;
If c = 'X' then
   begin
   If j<MinX then MinX:=j;
   end;
If c = 'Y' then
   begin
   If j<MinY then MinY:=j;
   end;
end;

Function RealXToImgX(realX:real):integer;
begin
result:=round(imgshagX*(realX-MinX)/realshagX)+BorderX;
end;

Function RealYToImgY(realY:real):integer;
begin
result:=Form2.Image1.Height-round(imgshagY*(realY-MinY)/realshagY)-BorderY;
end;

Function TForm1.ImgXToRealX(ImgX:integer):real;
begin
result:=((imgX-BorderX)*realshagX/imgshagX+MinX);
end;

Function TForm1.ImgYToRealY(ImgY:integer):real;
begin
ImgY:=Form2.Image1.Height-ImgY;
result:=((imgY-BorderY)*realshagY/imgshagY+MinY);
end;

Procedure ClsCanvas;
begin
{Form2.Image1}VirtCanvas.Canvas.Brush.Color:=clwhite;
{Form2.Image1}VirtCanvas.Canvas.FillRect(Rect(0,0,
{Form2.Image1}VirtCanvas.Width,Form2.Image1.Height));
end;

Procedure TForm1.LINE(DestCanvas:TCanvas;x1,y1,x2,y2:integer;color:TColor);
begin
{Form2.Image1}DestCanvas.Pen.Color:=color;
{Form2.Image1}DestCanvas.MoveTo(x1,y1);
{Form2.Image1}DestCanvas.LineTo(x2,y2);
end;

Procedure DrawGraph(var Mass1,Mass2:TMass;i,j,m,n,k:integer;color:TColor);
begin
Repeat
   begin
   Form1.Line(VirtCanvas.Canvas,RealXToImgX(Mass1[i]),RealYToImgY(Mass2[j]),
   RealXToImgX(Mass1[i+m]),RealYToImgY(Mass2[j+n]),Color);
   i:=i+m;
   j:=j+n
   end;
Until j>=k
{DrawGraph(Masskn,MassPnfe,0,0,2,2,2,Col[0]);}
end;

Function Stepen(osn,pok: real): real;
begin
result:=0;
If osn > 0 then result:=exp(pok*ln(osn)) else
   If osn < 0 then result:=exp(pok*ln(abs(osn)));
end;

Function Pokshag(k:real):real;
begin
result:=Stepen(2,k);
result:=result-1;
end;

Function Logshag(k:real):real;
begin
result:=Stepen(10,k);
end;

Procedure XYDEKART(x1,y1,x2,y2,dx,dy:integer;scalex,scaley:word;axisx,axisy:string;
                  Color:TColor;MinX,MinY,MaxX,MaxY:real);
var
r:real;
buf,k,th,tw:integer;
LogType:string;
begin
If Form1.RadioGroup1.ItemIndex = 0 then LogType:='2';
If Form1.RadioGroup1.ItemIndex = 1 then LogType:='10';
If Form1.RadioGroup1.ItemIndex = 2 then LogType:='.';
VirtCanvas.Canvas.Font.Name:='Arial';
{Стрелки осей и надписи}
{по X}
Form1.LINE(VirtCanvas.Canvas,x2,y2,x2+dx,y2,Color);
Form1.LINE(VirtCanvas.Canvas,x2+dx,y2,x2+dx-5,y2+5,Color);
Form1.LINE(VirtCanvas.Canvas,x2+dx,y2,x2+dx-5,y2-5,Color);
{Form2.Image1}VirtCanvas.Canvas.TextOut(x2+dx-{Form2.Image1}VirtCanvas.Canvas.TextWidth(axisx),
                            y2+{Form2.Image1}VirtCanvas.Canvas.TextHeight(axisx),
                            axisx);
{Стрелки осей и надписи}
{по Y}
Form1.LINE(VirtCanvas.Canvas,x1,y1,x1,y1+dy,color);
Form1.LINE(VirtCanvas.Canvas,x1,y1+dy,x1-5,y1+dy+5,Color);
Form1.LINE(VirtCanvas.Canvas,x1,y1+dy,x1+5,y1+dy+5,Color);
{Form2.Image1}VirtCanvas.Canvas.TextOut(x1,y1+dy-{Form2.Image1}VirtCanvas.Canvas.TextHeight(axisx),
                            axisy);
case scalex of
0:
   {разметка сетки по оси Х для линейного масштаба}
   begin
   buf:=0;
   r:=MinX;
   While buf<=gridX Do
      begin
      {Form2.Image1}VirtCanvas.Canvas.TextOut(RealXToImgX(r),
                                  y2+1,FormatFloat(ffx,r));
      r:=r+realshagX;
      inc(buf);
      end;
   {построение координатной сетки по оси X для линейного масштаба}
   x1:=RealXToImgX(MinX);
   x2:=RealXToImgX(MaxX);
   y1:=RealYToImgY(trunc(MaxY));
   y2:=RealYToImgY(MinY);
   Repeat
      begin
      Form1.LINE(VirtCanvas.Canvas,x1,y1,x1,y2,Color);
      x1:=x1+dx;
      end;
   until x1>x2;
   end;
1:
   {разметка сетки по оси Х для логарифмического масштаба по основанию 2}
   begin
   x1:=RealXToImgX(MinX);
   x2:=RealXToImgX(MaxX);
   y1:=RealYToImgY(MaxY);
   y2:=RealYToImgY(MinY);
   buf:=0;
   r:=trunc(MinX);
   k:=6;
   While buf<=gridX Do
      begin
//      r:=Pokshag(k);
      If Form1.RadioGroup1.ItemIndex <> 2 then
        begin
        VirtCanvas.Canvas.Font.Size:=7;
        tw:=VirtCanvas.Canvas.TextWidth(FormatFloat(ffx,r));
        th:=VirtCanvas.Canvas.TextHeight(FormatFloat(ffx,r));
        VirtCanvas.Canvas.TextOut(RealXToImgX(r),
                                  y2+1,FormatFloat(ffx,r));
        VirtCanvas.Canvas.Font.Size:=8;
        VirtCanvas.Canvas.TextOut(RealXToImgX(r)+tw-VirtCanvas.Canvas.TextWidth(LogType)-tw,
                                  y2+th-3,LogType);
        inc(buf);
        r:=r+1;
        end
      else
        begin
        r:=Pokshag(k);
        VirtCanvas.Canvas.TextOut(RealXToImgX(r),
                                  y2+1,FormatFloat(ffx,r));
        inc(buf);
        k:=k+1;
        end;
      end;
   {построение координатной сетки по оси X для логарифмического масштаба по основанию 2}
//   k:=5;
{   x1:=RealXToImgX(MinX);
   x2:=RealXToImgX(MaxX);
   y1:=RealYToImgY(MaxY);
   y2:=RealYToImgY(MinY);}
   Form1.LINE(VirtCanvas.Canvas,RealXToImgX(MinX),y1,
                                RealXToImgX(MinX),y2,Color);
   r:=trunc(MinX);
   k:=5;
   Repeat
      begin
      If Form1.RadioGroup1.ItemIndex <> 2 then
        begin
        Form1.LINE(VirtCanvas.Canvas,RealXToImgX(r),y1,RealXToImgX(r),y2,Color);
        //dx:=RealXToImgX(r);
        r:=r+1;
        x1:=x1+dx;
        end
      else
        begin
        Form1.LINE(VirtCanvas.Canvas,x1,y1,x1,y2,Color);
        dx:=RealXToImgX(Pokshag(k));
        x1:=dx;
        k:=k+1;
        end;
      end;
   until x1>x2;
   end;
end;

case scaley of
0:
   {разметка сетки по оси Y для линейного масштаба}
   begin
   x1:=RealXToImgX(MinX);
   x2:=RealXToImgX(MaxX);
   y1:=RealYToImgY(MaxY);
   y2:=RealYToImgY(MinY);
   buf:=0;
   r:=MinY;
   While buf<=gridY Do
      begin
      {Form2.Image1}VirtCanvas.Canvas.TextOut(x1-5-{Form2.Image1}VirtCanvas.Canvas.TextWidth(FormatFloat(ffy,r)),
                                  RealYToImgY(r),
                                  FormatFloat(ffy,r));
      r:=r+realshagY;
      inc(buf);
      end;
   {построение координатной сетки по оси Y для линейного масштаба}
   Repeat
      begin
      Form1.LINE(VirtCanvas.Canvas,x1,y2,x2,y2,Color);
//      Form1.LINE(VirtCanvas.Canvas,x1,RealYToImgY(r),x2,RealYToImgY(r),Color);
      y2:=y2+dy;
      end;
   until y2<y1;
   end;
1:
   {разметка сетки по оси Y для масштаба 10 в степени k}
   begin
   x1:=RealXToImgX(MinX);
   x2:=RealXToImgX(MaxX);
   y1:=RealYToImgY(MaxY);
   y2:=RealYToImgY(MinY);
   buf:=0;
   r:=MinY;
//   r:=MinY;
   While buf<=gridY Do
      begin
      VirtCanvas.Canvas.Font.Size:=7;
      tw:=VirtCanvas.Canvas.TextWidth(FormatFloat(ffy,r));
      th:=VirtCanvas.Canvas.TextHeight(FormatFloat(ffy,r));
      VirtCanvas.Canvas.TextOut(x1-5-tw,
                                  RealYToImgY(r),
                                  FormatFloat(ffy,r));
      VirtCanvas.Canvas.Font.Size:=8;
      VirtCanvas.Canvas.TextOut(x1-3-VirtCanvas.Canvas.TextWidth('10')-tw,
                                  RealYToImgY(r)+th-3,'10');
      r:=r+1;
//      r:=r+realshagY;
      inc(buf);
      end;
   {построение координатной сетки по оси Y для линейного масштаба}
   r:=MinY;
   Repeat
      begin
//      Form1.LINE(VirtCanvas.Canvas,x1,y2,x2,y2,Color);
//      y2:=y2+dy;
      Form1.LINE(VirtCanvas.Canvas,x1,RealYToImgY(r),x2,RealYToImgY(r),Color);
      r:=r+1;
      y2:=y2+dy; {если это заремарить то ничего не работает}
      end;
   until y2<y1;
   end;
end;{end of case}
end;

Procedure SystemInfo;
var
s:string;
begin
Form1.Memo1.Lines.Add('MinX:=');
s := s + FloatToStr(MinX) + ' ';
Form1.Memo1.Lines.Add(s);
s:='';
Form1.Memo1.Lines.Add('MinY:=');
s := s + FloatToStr(MinY) + ' ';
Form1.Memo1.Lines.Add(s);
s:='';
Form1.Memo1.Lines.Add('MaxX:=');
s := s + FloatToStr(MaxX) + ' ';
Form1.Memo1.Lines.Add(s);
s:='';
Form1.Memo1.Lines.Add('MaxY:=');
s := s + FloatToStr(MaxY) + ' ';
Form1.Memo1.Lines.Add(s);
s:='';
end;

Procedure MassInfo(var Mass:TMass;j:word;name:string);
var
s:string;
i:word;
begin
Form1.Memo1.Lines.Add(name);
For i:=0 to j Do
   begin
   s := s + FloatToStr(Mass[i]) + ' ';
   end;
Form1.Memo1.Lines.Add(s);
s:='';
end;

Procedure Legend(x,y,dx:integer;n,m,k:word);
var
j,tx,ty:word;
begin
Form2.Image2.Canvas.Brush.Color:=clwhite;
Form2.Image2.Canvas.FillRect(Rect(0,0,
Form2.Image2.Width,Form2.Image2.Height));
Form2.Image2.Canvas.TextOut(10,0,'Цветом на координатной плоскости обозначены:');
ty:=Form2.Image2.Canvas.TextHeight('Цветом на координатной плоскости обозначены:');
//k:=0;
For j:=n to m Do
   begin
   Form2.Image2.Canvas.Brush.Color:=Col[k];
   Form2.Image2.Canvas.TextOut(x,y+ty,Fun[j]);
   tx:=Form2.Image2.Canvas.TextWidth(Fun[j]);
   x:=x+tx+dx;
   k:=k+1;
   end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
i,n,d:word;
k,b:real;
fileImage1:string;
fileLegend1:string;
begin
fileImage1:='Отчёт1.bmp';
fileLegend1:='Легенда1.bmp';
ClsCanvas;
Form1.Memo1.Lines.Clear;
ffx:='0.00';
ffy:='0';
gridX:=20;
gridY:=20;
BorderX:=40;
BorderY:=40;
Form2.Visible:=true;
{Ввод данных}
//try
P1:=StrToFloat(Form1.Edit1.Text);
A:=StrToFloat(Form1.Edit2.Text);
H:=StrToFloat(Form1.Edit3.Text);
P2:=Log10(StrToFloat(Form1.Edit4.Text)); {Допустимую погрешность на выходе
                                         сразу преобразуем в логорифмическое значение}
{except
on EConvertError Do
   ShowMessage('Введите пожалуйста число.');
   end;}
{}
i:=0;
For n:=0 to 7 Do
   begin
   d:=0;
   Repeat
   Masskn[i]:=Massk[i]/Massn[n];
   MassPnfe[i]:=Log10(P1*(Stepen(Massn[n]/Massd[d],1-A))/
              Stepen(2,Massn[n]-Massk[i]));
   i:=i+1;
   d:=d+1;
   Until d>=2;
   end;
i:=0;
For n:=0 to 7 Do
   begin
   k:=(MassPnfe[i]-MassPnfe[i+1])/(Masskn[i]-Masskn[i+1]);
   b:=((MassPnfe[i+1]*Masskn[i])-(MassPnfe[i]*Masskn[i+1]))/(Masskn[i]-Masskn[i+1]);
   MassR1[n]:=(P2-b)/k;
   i:=i+2;
   end;
//   s:=FloatToStr(MassPnfe[0]);
//   MessageBox(0,PChar(''),PChar(s),MB_OK);
MinX:=Masskn[0];
MaxX:=Masskn[0];
MinY:=MassPnfe[0];
MaxY:=MassPnfe[0];
MassInfo(Masskn,15,'Значения k/n:');
MassInfo(MassPnfe,15,'Значения вероятности необнаружения ошибки P:');
MassInfo(MassR1,15,'Значения k/n при пересечении с P допустимым:');
MinMass(Masskn,'X',15);
MaxMass(Masskn,'X',15);
MinMass(MassPnfe,'Y',15);
MaxMass(MassPnfe,'Y',15);
{Количество пикселей в imgshagX и imgshagY соответствует количеству
пикселей в реальном мире}
SystemInfo;
realshagX:=(MaxX-MinX)/gridX;
realshagY:=(MaxY-MinY)/gridY;
imgshagX:=round((Form2.Image1.Width-BorderX*2)/gridX);
imgshagY:=round((Form2.Image1.Height-BorderY*2)/gridY);
XYDEKART(BorderX,BorderY,
        Form2.Image1.Width-BorderX,
        Form2.Image1.Height-BorderY,
        imgshagX,-imgshagY,0,1,'k/n','P необнаруживаемых ошибок',
        clBlack,MinX,MinY,MaxX,MaxY);
DrawGraph(Masskn,MassPnfe,0,0,1,1,1,Col[0]);
DrawGraph(Masskn,MassPnfe,2,2,1,1,3,Col[1]);
DrawGraph(Masskn,MassPnfe,4,4,1,1,5,Col[2]);
DrawGraph(Masskn,MassPnfe,6,6,1,1,7,Col[3]);
DrawGraph(Masskn,MassPnfe,8,8,1,1,9,Col[4]);
DrawGraph(Masskn,MassPnfe,10,10,1,1,11,Col[5]);
DrawGraph(Masskn,MassPnfe,12,12,1,1,13,Col[6]);
DrawGraph(Masskn,MassPnfe,14,14,1,1,15,Col[7]);
//MessageBox(0,PChar(FloatToStr(MinX)),PChar(FloatToStr(P2)),MB_OK);
Form1.Line(VirtCanvas.Canvas,RealXToImgX(MinX),RealYToImgY(P2),RealXToImgX(MaxX),RealYToImgY(P2),Col[8]);
Legend(10,5,20,0,8,0);
Form2.Image1.Canvas.Draw(0,0,VirtCanvas);
//ResetMass(MassPnfe);
//ResetMass(Masskn);
Form1.Button2.Enabled:=true;
//Запись отчёта в файл
Form2.Image1.Picture.SaveToFile(fileImage1);
Form2.Image2.Picture.SaveToFile(fileLegend1);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
n:word;
fileImage2,fileLegend2:string;
begin
fileImage2:='Отчёт2.bmp';
fileLegend2:='Легенда2.bmp';
ClsCanvas;
Form1.Memo1.Lines.Clear;
ffx:='0';
ffy:='0.00';
gridX:=8;
gridY:=20;
BorderX:=45;
BorderY:=35;
Form2.Visible:=true;
{Ввод данных}
//try
P1:=StrToFloat(Form1.Edit1.Text);
A:=StrToFloat(Form1.Edit2.Text);
H:=StrToFloat(Form1.Edit3.Text);
{except
on EСonvertError Do
   ShowMessage('Введите пожалуйста число.');
   end;}
{}
//i:=0;
For n:=0 to 7 Do
   begin
//   d:=0;
   MassPnfe[n]:=Massn[n];
   MassR2[n]:=1-P1*Stepen((Massn[n]*(H+1)),1-A);
   MassR3[n]:=MassR2[n]/(2-MassR2[n]);
   MassR4[n]:=MassR1[n]*MassR3[n];
   If RadioGroup1.ItemIndex = 0 then MassPnfe[n]:=Log2(Massn[n]);
   If RadioGroup1.ItemIndex = 1 then MassPnfe[n]:=Log10(Massn[n]);
   If RadioGroup1.ItemIndex = 2 then MassPnfe[n]:=Massn[n];
//   Repeat
//   If RadioGroup1.ItemIndex = 0 then MassPnfe[n]:=Log2(Massn[n]);
//   If RadioGroup1.ItemIndex = 1 then MassPnfe[n]:=Log10(Massn[n]);
//   If RadioGroup1.ItemIndex = 2 then MassPnfe[n]:=Massn[n];
//   Masskn[i]:=Massk[i]/Massn[n];
//   MassRs[i]:=MassR1[i]*MassR2[n];
//   MassRd[i]:=MassR1[i]*MassR3[n];
//   i:=i+1;
//   d:=d+1;
//   Until d>=2;
   end;
MinX:=MassPnfe[0];
MaxX:=MassPnfe[0];
MinY:=Masskn[0];
MaxY:=Masskn[0];
MassInfo(MassPnfe,15,'Значения n:');
MassInfo(MassR1,15,'Значения k/n:');
MassInfo(MassR2,15,'Значения r:');
MassInfo(MassR3,15,'Значения r/2-r:');
MassInfo(MassR4,15,'Значения R:');
//MassInfo(MassRs,15,'Значения R симплексное:');
//MassInfo(MassRd,15,'Значения R дуплексное:');
MinMass(MassR1,'Y',7);
MaxMass(MassR1,'Y',7);
MinMass(MassR2,'Y',7);
MaxMass(MassR2,'Y',7);
MinMass(MassR3,'Y',7);
MaxMass(MassR3,'Y',7);
MinMass(MassR4,'Y',7);
MaxMass(MassR4,'Y',7);
MinMass(MassPnfe,'X',7);
MaxMass(MassPnfe,'X',7);
{}
SystemInfo;
realshagX:=(MaxX-MinX)/gridX;
realshagY:=(MaxY-MinY)/gridY;
imgshagX:=round((Form2.Image1.Width-BorderX*2)/gridX);
imgshagY:=round((Form2.Image1.Height-BorderY*2)/gridY);
XYDEKART(BorderX,BorderY,
        Form2.Image1.Width-BorderX*2,
        Form2.Image1.Height-BorderY,
        imgshagX,-imgshagY,1,0,'n','R1, R2, R3, R4',
        clBlack,MinX,MinY,MaxX,MaxY);
DrawGraph(MassPnfe,MassR1,0,0,1,1,7,Col[5]);
DrawGraph(MassPnfe,MassR2,0,0,1,1,7,Col[6]);
DrawGraph(MassPnfe,MassR3,0,0,1,1,7,Col[7]);
DrawGraph(MassPnfe,MassR4,0,0,1,1,7,Col[8]);
//DrawGraph(MassP3,MassRs,0,1,2,2,15,Col[4]);
//DrawGraph(MassP3,MassRs,1,2,2,2,15,Col[5]);
//DrawGraph(MassP3,MassRd,0,1,2,2,15,Col[6]);
//DrawGraph(MassP3,MassRd,1,2,2,2,15,Col[7]);

Legend(10,5,20,9,12,5);
Form2.Image1.Canvas.Draw(0,0,VirtCanvas);
//ResetMass(MassPnfe);
//ResetMass(MassR1);
//ResetMass(MassR2);
//ResetMass(MassR3);
//ResetMass(MassR4);
//Запись отчёта в файл
Form2.Image1.Picture.SaveToFile(fileImage2);
Form2.Image2.Picture.SaveToFile(fileLegend2);
Form1.Button3.Enabled:=true;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
If Form1.CheckBox1.State = cbChecked then
   begin
   Form1.Memo1.Visible:=true;
   Form1.Width:=600;
   Form1.Position:=poScreenCenter;
   end
else
   begin
   Form1.Width:=261;
   Form1.Memo1.Visible:=false;
   Form1.Position:=poScreenCenter;
   end;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
Form1.Visible:=false;
Form3.Visible:=True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
VirtCanvas:=TBitMap.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
VirtCanvas.Free;
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
If not (Key in [',','0','1','2','3','4','5','6','7','8','9',#8]) then Key:=#0;
end;

procedure TForm1.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
If not (Key in [',','0','1','2','3','4','5','6','7','8','9',#8]) then Key:=#0;
end;

procedure TForm1.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
If not (Key in [',','0','1','2','3','4','5','6','7','8','9',#8]) then Key:=#0;
end;

procedure TForm1.Edit4KeyPress(Sender: TObject; var Key: Char);
begin
If not (Key in [',','0','1','2','3','4','5','6','7','8','9',#8]) then Key:=#0;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
i,j:integer;
//x: real;
begin
//x:=3.14159;
If RadioGroup2.ItemIndex = 0 then
   begin
   j:=1;
   For i:=1 to 8 Do
      begin
      Form1.StringGrid1.Cells[j,i]:=FloatToStr(Masskn[i]);
      Form1.StringGrid1.Cells[0,i]:=IntToStr(i);
      end;
   end;
If RadioGroup2.ItemIndex = 1 then
   begin
   j:=1;
   For i:=1 to 8 Do
      begin
      Form1.StringGrid1.Cells[j,i]:=FloatToStr(MassR1[i]);
      Form1.StringGrid1.Cells[0,i]:=IntToStr(i);
      end;
   end;
If RadioGroup2.ItemIndex = 2 then
   begin
   j:=1;
   For i:=1 to 8 Do
      begin
      Form1.StringGrid1.Cells[j,i]:=FloatToStr(MassR2[i]);
      Form1.StringGrid1.Cells[0,i]:=IntToStr(i);
      end;
   end;
If RadioGroup2.ItemIndex = 3 then
   begin
   j:=1;
   For i:=1 to 8 Do
      begin
      Form1.StringGrid1.Cells[j,i]:=FloatToStr(MassR3[i]);
      Form1.StringGrid1.Cells[0,i]:=IntToStr(i);
      end;
   end;
If RadioGroup2.ItemIndex = 4 then
   begin
   j:=1;
   For i:=1 to 8 Do
      begin
      Form1.StringGrid1.Cells[j,i]:=FloatToStr(MassR4[i]);
      Form1.StringGrid1.Cells[0,i]:=IntToStr(i);
      end;
   end;
If RadioGroup2.ItemIndex = 5 then
   begin
   j:=1;
   For i:=1 to 8 Do
      begin
      Form1.StringGrid1.Cells[j,i]:=FloatToStr(MassPnfe[i]);
      Form1.StringGrid1.Cells[0,i]:=IntToStr(i);
      end;
   end;
Form1.StringGrid1.Visible:=true;
Form1.StringGrid1.Color:=clWhite;
Form1.StringGrid1.Cells[0,0]:='N';
Form1.StringGrid1.Cells[1,0]:='Значение';
//Form1.StringGrid1.ColCount:=8;
//For i:=0 to 1 Do
//   begin
//   For j:=0 to 15 Do
//      begin
      //FloatToStr(x);
//      end;
//   end;
end;
end.
