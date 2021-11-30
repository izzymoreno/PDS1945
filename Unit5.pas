unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TForm5 = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

uses Unit4, Unit3;

{$R *.DFM}

procedure TForm5.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
Form4.Caption:='';
end;

procedure TForm5.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Form3.Visible:=True;
end;

end.
