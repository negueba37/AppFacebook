unit uPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TForm1 = class(TForm)
    lay_toolbar: TLayout;
    imgLogo: TImage;
    layBotoom: TLayout;
    imgBusca: TImage;
    Image2: TImage;
    layBusca: TLayout;
    lblCacelarBusca: TLabel;
    recBusca: TRectangle;
    edtBusca: TEdit;
    StyleBook1: TStyleBook;
    procedure imgBuscaClick(Sender: TObject);
    procedure lblCacelarBuscaClick(Sender: TObject);
  private
    procedure OpenSearch;
    procedure CloseSearch;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.CloseSearch;
var
  LLargura:Integer;
begin
  recBusca.AnimateFloat('Width',50,0.5,TAnimationType.InOut,TInterpolationType.Circular);
  imgLogo.AnimateFloatDelay('Opacity',1,0.5,0.2,TAnimationType.InOut,TInterpolationType.Circular);
  TThread.CreateAnonymousThread(
  procedure
  begin
    Sleep(400);
    TThread.Synchronize(nil,
    procedure
    begin
      layBotoom.Visible := True;
      layBusca.Visible := False;
    end);
  end).Start;
  edtBusca.SetFocus;
end;

procedure TForm1.imgBuscaClick(Sender: TObject);
begin
  OpenSearch();
end;

procedure TForm1.lblCacelarBuscaClick(Sender: TObject);
begin
  CloseSearch;
end;

procedure TForm1.OpenSearch;
var
  LLargura:Integer;
begin
  layBotoom.Visible := False;
  layBusca.Visible := True;
  LLargura := Trunc(layBusca.Width - lblCacelarBusca.Width - 15);
  recBusca.Width := 50;
  recBusca.AnimateFloat('Width',LLargura,0.5,TAnimationType.InOut,TInterpolationType.Circular);
  imgLogo.AnimateFloat('Opacity',0,0.5,TAnimationType.InOut,TInterpolationType.Circular);
  edtBusca.SetFocus;
end;

end.
