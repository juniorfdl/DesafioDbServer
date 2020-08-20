unit uPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, Datasnap.DBClient, System.Rtti,
  FMX.Grid.Style, FMX.Grid, Generics.Collections, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, RestApi.Client.Impl, Utils.Constantes;

type
  TfPrincipal = class(TForm)
    ListViewRestaurantes: TListView;
    pTop: TPanel;
    lblTitle: TLabel;
    btnFavoritos: TSpeedButton;
    btnFavoritoDia: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure ListViewRestaurantesDblClick(Sender: TObject);
    procedure btnFavoritosClick(Sender: TObject);
    procedure btnFavoritoDiaClick(Sender: TObject);
  private
    { Private declarations }
    procedure MontarListaRestaurantes;
    procedure GravarRestauranteFavorito;
    procedure MostarListaFavoritos;
    procedure MostarFavoritoDia;
  public
    { Public declarations }
  end;

var
  fPrincipal: TfPrincipal;

implementation


uses REST.JSON, System.JSON, FMX.DialogService;

{$R *.fmx}

procedure TfPrincipal.btnFavoritoDiaClick(Sender: TObject);
begin
  MostarFavoritoDia;
end;

procedure TfPrincipal.btnFavoritosClick(Sender: TObject);
begin
  MostarListaFavoritos;
end;

procedure TfPrincipal.FormCreate(Sender: TObject);
begin
  MontarListaRestaurantes;
end;

procedure TfPrincipal.GravarRestauranteFavorito;
begin
  InputQuery( 'Favor informe seu E-mail?', ['E-mail:'], [''],
    procedure(const AResult: TModalResult; const AValues: array of string)
    var
      sRestaurante, sEmail: string;
    begin
      if (AResult = mrOk) and (AValues[0] <> EmptyStr) then
      begin
        sEmail := AValues[0];
        sRestaurante := ListViewRestaurantes.Items[ListViewRestaurantes.Selected.Index].Text.Replace(' ', '+', [rfReplaceAll]);
        TRestApiClientImpl.New(BaseURL)
         .SetResource(Format(EndPointGravar, [sEmail, sRestaurante]))
         .Get
      end;
      ShowMessage('Operação finalizada, Obrigado!');
    end);

end;

procedure TfPrincipal.ListViewRestaurantesDblClick(Sender: TObject);
begin
  GravarRestauranteFavorito;
end;

procedure TfPrincipal.MontarListaRestaurantes;
var
  oJson: TJSONArray;
  oJsonValue: TJSONValue;
  oItem: TJSONValue;
  sJsonRestaurantes: string;
begin
  sJsonRestaurantes := TRestApiClientImpl.New(BaseURL)
    .SetResource(EndPointRestaurante)
    .Get
    .GetRetornoArray.ToJSON;

  oJson := TJSONObject.ParseJSONValue
    (TEncoding.ASCII.GetBytes(sJsonRestaurantes), 0) as TJSONArray;
  try
    for oJsonValue in oJson do
    begin
      for oItem in TJSONArray(oJsonValue) do
      begin
        ListViewRestaurantes.Items.Add.Text := TJSONPair(oItem).JsonValue.Value;
      end;
    end;
  finally
    FreeAndNil(oJson);
  end;
end;

procedure TfPrincipal.MostarFavoritoDia;
var
  sRet: String;
begin
  sRet := TRestApiClientImpl.New(BaseURL)
    .SetResource(EndPointFavoritosdia)
    .Get
    .GetRetorno.GetValue(EndPointFavoritosdia).Value;

  ShowMessage(sRet);
end;

procedure TfPrincipal.MostarListaFavoritos;
Const
  sTAG_RESTAURANTE = 'nomeRestaurante';
  STAG_EMAIL = 'email';
var
  oJson: TJSONArray;
  oJsonValue: TJSONValue;
  oItem: TJSONValue;
  sEmail, sNome, sData, sMsg, sJsonFavoritos: string;
begin
  sJsonFavoritos := TRestApiClientImpl.New(BaseURL)
    .SetResource(EndPointFavoritos)
    .Get
    .GetRetornoArray.ToJSON;

  oJson := TJSONObject.ParseJSONValue
    (TEncoding.ASCII.GetBytes(sJsonFavoritos), 0) as TJSONArray;
  try
    for oJsonValue in oJson do
    begin
      for oItem in TJSONArray(oJsonValue) do
      begin
        if TJSONPair(oItem).JsonString.Value = sTAG_RESTAURANTE then
          sNome := TJSONPair(oItem).JsonValue.Value
        else
        if TJSONPair(oItem).JsonString.Value = STAG_EMAIL then
          sEmail := TJSONPair(oItem).JsonValue.Value
        else
          sData := TJSONPair(oItem).JsonValue.Value;
      end;
      sMsg := sMsg + sLineBreak + sNome + sEmail + sData;
    end;
  finally
    FreeAndNil(oJson);
  end;

  ShowMessage(sMsg);
end;

end.
