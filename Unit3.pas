unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TForm3 = class(TForm)
    Image1: TImage;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses Unit1, Unit4, Unit5, Unit7;

{$R *.DFM}

procedure TForm3.FormShow(Sender: TObject);
begin
Image1.Picture.LoadFromFile(FullPath+'menu.bmp');
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
Form4.Image1.Picture.LoadFromFile(FullPath+'schema.bmp');
Form4.Width:=800;
Form4.Height:=560;
Form4.Caption:='Блок схема системы  РОС-ППбл';
Form4.Visible:=True;
Form3.Visible:=False;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
FullPath:=ExtractFilePath(application.ExeName);
end;

procedure TForm3.Button3Click(Sender: TObject);
begin
Form3.Visible:=False;
Form1.Visible:=True;
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
Form4.Image1.Picture.LoadFromFile(FullPath+'cel.bmp');
Form4.Width:=669;
Form4.Height:=533;
Form4.Caption:='Цель работы:';
Form4.Visible:=True;
Form3.Visible:=False;
end;

procedure TForm3.Button4Click(Sender: TObject);
begin
Form5.Image1.Picture.LoadFromFile(FullPath+'SpaceMind.bmp');
Form5.Width:=669;
Form5.Height:=533;
Form5.Caption:='Об авторах и разработчиках: ';
Form5.Visible:=True;
Form3.Visible:=False;
end;

procedure TForm3.Button5Click(Sender: TObject);
begin
Form7.Image1.Picture.LoadFromFile(FullPath+'poryadok.bmp');
//Form3.Visible:=False;
Form7.Visible:=True;
end;

end.
