unit Services.Restaurantes.Favorito.Utilizado;

interface

type
  TServicesRestaurantesFavoritoUtilizado = class
  public
    class function TestarRestauranteUtilizadoSemana(
      const psRestaurante: string; const pdData: TDate): boolean;
  end;

implementation

uses DateUtils, SysUtils, Services.Restaurantes.Favorito;

{ TServicesRestaurantesFavoritoUtilizado }

class function TServicesRestaurantesFavoritoUtilizado.TestarRestauranteUtilizadoSemana(
  const psRestaurante: string; const pdData: TDate): boolean;
var
  I: Integer;
  sRestauranteDia: string;
begin
  if dayofweek(pdData) = 1 then
    Exit(False);

  for I := 1 to DayOfWeek(now) do
  begin
    sRestauranteDia := TServicesRestaurantesFavorito.GetRestauranteFavorito(IncDay(pdData, -I));

    if SameText(sRestauranteDia, psRestaurante) then
      Exit(True);
  end;

  Result := False;
end;

end.
