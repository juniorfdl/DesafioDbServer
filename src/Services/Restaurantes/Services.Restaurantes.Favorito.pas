unit Services.Restaurantes.Favorito;

interface

uses Domain.Favoritos.Interfaces, Repositories, SysUtils, Generics.Collections,
  Services.Restaurantes.Favorito.Utilizado;

type
  TServicesRestaurantesFavorito = class
  private
  public
    class function GetRestauranteFavorito(pdData: TDate): String;
  end;

implementation

class function TServicesRestaurantesFavorito.GetRestauranteFavorito
  (pdData: TDate): String;
var
  oItem: IDomainFavoritosInterfaces;
  Dictionary: TDictionary<String, Integer>;
  Contador: Integer;
  sNomeRestaurante: String;
begin
  Result := EmptyStr;

  Dictionary := TDictionary<String, Integer>.create;
  try
    for oItem in TRepositories.New.Favoritos do
    begin
      if (oItem.Data <> Trunc(pdData)) then
        Break;

      if Dictionary.TryGetValue(oItem.NomeRestaurante, Contador) then
        Inc(Contador, 1)
      else
        Contador := 1;

      Dictionary.AddOrSetValue(oItem.NomeRestaurante, Contador);
    end;

    Contador := 0;
    for sNomeRestaurante in Dictionary.Keys do
    begin
      if (Dictionary.Items[sNomeRestaurante] > Contador) and
        (not TServicesRestaurantesFavoritoUtilizado.TestarRestauranteUtilizadoSemana(sNomeRestaurante, pdData)) then
      begin
        Result := sNomeRestaurante;
        Contador := Dictionary.Items[sNomeRestaurante];
      end;
    end;

  finally
    FreeAndNil(Dictionary);
  end;
end;

end.
