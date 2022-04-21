unit uPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView,System.JSON,FMX.TextLayout;

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
    imgPerfil: TImage;
    imgAoVivo: TImage;
    imgCheckIn: TImage;
    imgFoto: TImage;
    imgSeparadorHori: TImage;
    ListView: TListView;
    layStory: TLayout;
    hsStory: THorzScrollBox;
    ImgStory: TImage;
    imgFriend: TImage;
    img_comentar: TImage;
    img_compartilhar: TImage;
    img_curtir: TImage;
    procedure imgBuscaClick(Sender: TObject);
    procedure lblCacelarBuscaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListViewUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure ListViewScrollViewChange(Sender: TObject);
  private
    procedure OpenSearch;
    procedure CloseSearch;
    procedure MontaLista;
    procedure SetupItem(AItem:TListViewItem);
    procedure SetupStory(AItem:TListViewItem);
    procedure SetupPostText(AItem:TListViewItem);
    procedure AddStory(ANome:string);
    function GetTextHeight(const D: TListItemText; const Width: single;
      const Text: string): Integer;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.AddStory(ANome:string);
var
  LRec:TRectangle;
  LLabel:TLabel;
  LCircle:TCircle;
begin

  LLabel := TLabel.Create(hsStory);
  LLabel.Text := ANome;
  LLabel.StyledSettings := LLabel.StyledSettings - [TStyledSetting.FontColor];
  LLabel.FontColor := $FFFFFFFF;
  LLabel.Font.Size := 15;
  LLabel.TextAlign := TTextAlign.Center;
  LLabel.VertTextAlign := TTextAlign.Center;
  LLabel.Height := 30;
  LLabel.Align := TAlignLayout.Bottom;


  LRec := TRectangle.Create(hsStory);
  LRec.Align := TAlignLayout.Left;
  LRec.Margins.Left := 5;
  LRec.Margins.Right := 5;
  LRec.Width := 140;
  LRec.Fill.Kind := TBrushKind.Bitmap;
  LRec.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
  LRec.Stroke.Kind := TBrushKind.None;
  LRec.XRadius := 10;
  LRec.YRadius := 10;
  LRec.Fill.Bitmap.Bitmap := ImgStory.Bitmap;
  LRec.AddObject(LLabel);

  LCircle := TCircle.Create(hsStory);
  LCircle.Width := 40;
  LCircle.Height := 40;
  LCircle.Fill.Kind := TBrushKind.Bitmap;
  LCircle.Fill.Bitmap.Bitmap := imgFriend.Bitmap;
  LCircle.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
  LCircle.Position.X := 5;
  LCircle.Position.Y := 5;
  LCircle.Stroke.Kind := TBrushKind.Solid;
  LCircle.Stroke.Color := $FF3875E9;
  LCircle.Stroke.Thickness := 4;
  LCircle.HitTest := False;
  LRec.AddObject(LCircle);

  hsStory.AddObject(LRec);
end;

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

procedure TForm1.SetupItem(AItem: TListViewItem);
var
  LImage:TListItemImage;
  LText:TListItemText;
begin
  AItem.Height := 120;
  LImage := AItem.Objects.FindDrawable('img_perfil_usuario') as TListItemImage;
  if LImage = nil then
    LImage := TListItemImage.Create(AItem);

  LImage.Bitmap := imgPerfil.Bitmap;
  LImage.Width := 50;
  LImage.Height := 50;
  LImage.PlaceOffset.X := 10;
  LImage.PlaceOffset.Y := 10;
  LImage.Name := 'img_perfil_usuario';

  LText := AItem.Objects.FindDrawable('txt_post') as TListItemText;
  if LText = nil then
    LText := TListItemText.Create(AItem);

  LText.Name := 'txt_post';
  LText.Text := 'No que você esta pensando?';
  LText.Font.Size := 13;
  LText.PlaceOffset.X := 65;
  LText.PlaceOffset.Y := 25;

  LImage := AItem.Objects.FindDrawable('img_separador_h') as TListItemImage;
  if LImage = nil then
    LImage := TListItemImage.Create(AItem);

  LImage.Bitmap := imgSeparadorHori.Bitmap;
  LImage.Opacity := 0.7;
  LImage.Width := ListView.Width;
  LImage.ScalingMode := TImageScalingMode.Stretch;
  LImage.Height := 1;
  LImage.PlaceOffset.X := 0;
  LImage.PlaceOffset.Y := 70;
  LImage.Name := 'img_separador_h';

  LImage := AItem.Objects.FindDrawable('img_aovivo') as TListItemImage;
  if LImage = nil then
    LImage := TListItemImage.Create(AItem);

  LImage.Bitmap := imgAoVivo.Bitmap;
  LImage.Width := Trunc((Self.Width - 20) /3 );
  LImage.ScalingMode := TImageScalingMode.StretchWithAspect;
  LImage.Height := 19;
  LImage.PlaceOffset.X := 0;
  LImage.PlaceOffset.Y := 82;
  LImage.Name := 'img_aovivo';

  LImage := AItem.Objects.FindDrawable('img_foto') as TListItemImage;
  if LImage = nil then
    LImage := TListItemImage.Create(AItem);

  LImage.Bitmap := imgFoto.Bitmap;
  LImage.Width := Trunc((Self.Width - 20) /3 );
  LImage.ScalingMode := TImageScalingMode.StretchWithAspect;
  LImage.Height := 19;
  LImage.PlaceOffset.X := Trunc((Self.Width / 2) - (LImage.Width/2) - 17);
  LImage.PlaceOffset.Y := 82;
  LImage.Name := 'img_foto';

  LImage := AItem.Objects.FindDrawable('img_checkin') as TListItemImage;
  if LImage = nil then
    LImage := TListItemImage.Create(AItem);

  LImage.Bitmap := imgCheckIn.Bitmap;
  LImage.Width := Trunc((Self.Width - 20) /3 );
  LImage.ScalingMode := TImageScalingMode.StretchWithAspect;
  LImage.Height := 19;
  LImage.PlaceOffset.X := Trunc(Self.Width - LImage.Width  - 20);
  LImage.PlaceOffset.Y := 82;
  LImage.Name := 'img_checkin';

  LImage := AItem.Objects.FindDrawable('img_sep') as TListItemImage;
  if LImage = nil then
    LImage := TListItemImage.Create(AItem);

  LImage.Bitmap := imgSeparadorHori.Bitmap;
  LImage.Width := Self.Width;
  LImage.ScalingMode := TImageScalingMode.Stretch;
  LImage.Height := 8;
  LImage.PlaceOffset.X := 0;
  LImage.PlaceOffset.Y := AItem.Height - LImage.Height;
  LImage.Name := 'img_sep';

end;

procedure TForm1.SetupPostText(AItem: TListViewItem);
var
  LImage:TListItemImage;
  LText:TListItemText;
  LJSON:TJSONObject;
begin
  AItem.Height := 120;
  LImage := AItem.Objects.FindDrawable('img_perfil_usuario') as TListItemImage;
  if LImage = nil then
    LImage := TListItemImage.Create(AItem);

  LImage.Bitmap := imgPerfil.Bitmap;
  LImage.Width := 35;
  LImage.Height := 35;
  LImage.PlaceOffset.X := 10;
  LImage.PlaceOffset.Y := 10;
  LImage.Name := 'img_perfil_usuario';

  LText := AItem.Objects.FindDrawable('txt_nome') as TListItemText;
  if LText = nil then
    LText := TListItemText.Create(AItem);
  LJSON := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(AItem.TagString),0) AS TJSONObject;
  LText.Name := 'txt_nome';
  LText.Text := LJSON.GetValue<string>('nome');
  LText.Font.Size := 13;
  LText.PlaceOffset.X := 53;
  LText.PlaceOffset.Y := 13;

  LText := AItem.Objects.FindDrawable('txt_hora') as TListItemText;
  if LText = nil then
    LText := TListItemText.Create(AItem);
  LJSON := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(AItem.TagString),0) AS TJSONObject;
  LText.Name := 'txt_hora';
  LText.Text := LJSON.GetValue<string>('hora');
  LText.TextColor := $FF999999;
  LText.Font.Size := 11;
  LText.PlaceOffset.X := 53;
  LText.PlaceOffset.Y := 28;

  LText := AItem.Objects.FindDrawable('txt_texto') as TListItemText;
  if LText = nil then
    LText := TListItemText.Create(AItem);
  LJSON := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(AItem.TagString),0) AS TJSONObject;
  LText.Name := 'txt_texto';
  LText.Text := LJSON.GetValue<string>('texto');
  LText.Font.Size := 13;
  LText.WordWrap := True;
  LText.Width := (self.Width - 25);
  LText.PlaceOffset.X := 10;
  LText.PlaceOffset.Y := 50;
  LText.Height := GetTextHeight(LText,LText.Width,LText.Text) + 5;

  AItem.Height := Trunc(LText.PlaceOffset.Y + LText.Height + 45);


  LImage := AItem.Objects.FindDrawable('img_curtir') as TListItemImage;
  if LImage = nil then
    LImage := TListItemImage.Create(AItem);

  LImage.Bitmap := img_curtir.Bitmap;
  LImage.Width := Trunc((Self.Width - 20) /3 );
  LImage.ScalingMode := TImageScalingMode.StretchWithAspect;
  LImage.Height := 19;
  LImage.PlaceOffset.X := 0;
  LImage.PlaceOffset.Y := LText.PlaceOffset.Y + LText.Height + 5;
  LImage.Name := 'img_curtir';

  LImage := AItem.Objects.FindDrawable('img_comentar') as TListItemImage;
  if LImage = nil then
    LImage := TListItemImage.Create(AItem);

  LImage.Bitmap := img_comentar.Bitmap;
  LImage.Width := Trunc((Self.Width - 20) /3 );
  LImage.ScalingMode := TImageScalingMode.StretchWithAspect;
  LImage.Height := 19;
  LImage.PlaceOffset.X := Trunc((Self.Width / 2) - (LImage.Width/2) - 17);
  LImage.PlaceOffset.Y := LText.PlaceOffset.Y + LText.Height + 5;
  LImage.Name := 'img_comentar';

  LImage := AItem.Objects.FindDrawable('img_compartilhar') as TListItemImage;
  if LImage = nil then
    LImage := TListItemImage.Create(AItem);

  LImage.Bitmap := img_compartilhar.Bitmap;
  LImage.Width := Trunc((Self.Width - 20) /3 );
  LImage.ScalingMode := TImageScalingMode.StretchWithAspect;
  LImage.Height := 19;
  LImage.PlaceOffset.X := Trunc(Self.Width - LImage.Width  - 20);
  LImage.PlaceOffset.Y := LText.PlaceOffset.Y + LText.Height + 5;
  LImage.Name := 'img_compartilhar';



  LImage := AItem.Objects.FindDrawable('img_sep') as TListItemImage;
  if LImage = nil then
    LImage := TListItemImage.Create(AItem);

  LImage.Bitmap := imgSeparadorHori.Bitmap;
  LImage.Width := Self.Width;
  LImage.ScalingMode := TImageScalingMode.Stretch;
  LImage.Height := 8;
  LImage.PlaceOffset.X := 0;
  LImage.PlaceOffset.Y := AItem.Height - LImage.Height;
  LImage.Name := 'img_sep';
end;

procedure TForm1.SetupStory(AItem: TListViewItem);
begin
  AItem.Height := 200;
  layStory.Width := Self.Width;
  layStory.Position.X := 0;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  imgPerfil.Visible := false;
  imgSeparadorHori.Visible := false;
  imgAoVivo.Visible := false;
  imgFoto.Visible := false;
  imgCheckIn.Visible := false;
  ImgStory.Visible := false;
  img_comentar.Visible := false;
  img_compartilhar.Visible := false;
  img_curtir.Visible := false;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  MontaLista();
end;

procedure TForm1.imgBuscaClick(Sender: TObject);
begin
  OpenSearch();
end;

procedure TForm1.lblCacelarBuscaClick(Sender: TObject);
begin
  CloseSearch;
end;

procedure TForm1.ListViewScrollViewChange(Sender: TObject);
begin
  if ListView.Items.Count >= 2 then
  begin
    layStory.Position.Y := ListView.GetItemRect(1).Top + 10;
  end;
end;

procedure TForm1.ListViewUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
begin
  case AItem.Tag of
    1:SetupItem(AItem);
    2:SetupStory(AItem);
    3:SetupPostText(AItem);
  end;
end;

procedure TForm1.MontaLista;
var
  LItem:TListViewItem;
begin
  ListView.BeginUpdate;

  LItem := ListView.Items.AddItem(0);
  LItem.Tag := 1;
  LItem.Objects.Clear;

  LItem := ListView.Items.Add;
  LItem.Tag := 2;
  LItem.Objects.Clear;

  AddStory('Gabriel Vieira dos Santos');
  AddStory('Gabriel Vieira dos Santos');
  AddStory('Gabriel Vieira dos Santos');
  AddStory('Gabriel Vieira dos Santos');
  AddStory('Gabriel Vieira dos Santos');
  AddStory('Gabriel Vieira dos Santos');

  LItem := ListView.Items.Add;
  LItem.Tag := 3;
  LItem.TagString := '{"nome":"Gabriel Vieira", "hora":"4h","texto":"Isso é um teste para o nosso aplicativo do face .djvbjdbvhdfsvbhfsbvhfsbvhdsfbvsdhbvhdsbvdhsbvhdsbvhdsvbdhsvbdvbdshvbdshvb"}';
  LItem.Objects.Clear;

  LItem := ListView.Items.Add;
  LItem.Tag := 3;
  LItem.TagString := '{"nome":"Gabriel Vieira", "hora":"4h","texto":"Isso é um teste para o nosso aplicativo do face"}';
  LItem.Objects.Clear;

  LItem := ListView.Items.Add;
  LItem.Tag := 3;
  LItem.TagString := '{"nome":"Gabriel Vieira", "hora":"4h","texto":"Isso é um teste para o nosso aplicativo do face"}';
  LItem.Objects.Clear;

  LItem := ListView.Items.Add;
  LItem.Tag := 3;
  LItem.TagString := '{"nome":"Gabriel Vieira", "hora":"4h","texto":"Isso é um teste para o nosso aplicativo do face"}';
  LItem.Objects.Clear;

  ListView.EndUpdate;
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
function TForm1.GetTextHeight(const D: TListItemText; const Width: single; const Text: string): Integer;
var
  Layout: TTextLayout;
begin
  // Create a TTextLayout to measure text dimensions
  Layout := TTextLayoutManager.DefaultTextLayout.Create;
  try
    Layout.BeginUpdate;
    try
      // Initialize layout parameters with those of the drawable
      Layout.Font.Assign(D.Font);
      Layout.VerticalAlign := D.TextVertAlign;
      Layout.HorizontalAlign := D.TextAlign;
      Layout.WordWrap := D.WordWrap;
      Layout.Trimming := D.Trimming;
      Layout.MaxSize := TPointF.Create(Width, TTextLayout.MaxLayoutSize.Y);
      Layout.Text := Text;
    finally
      Layout.EndUpdate;
    end;
    // Get layout height
    Result := Round(Layout.Height);
    // Add one em to the height
    Layout.Text := 'm';
    Result := Result + Round(Layout.Height);
  finally
    Layout.Free;
  end;
end;

end.
