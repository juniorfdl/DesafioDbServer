unit Services.Restaurantes.Favorito.Email;

interface

uses Domain.Favoritos.Interfaces, Repositories, SysUtils, Generics.Collections, Utils.Email,
  Services.Restaurantes.Favorito;

type
  TServicesRestaurantesFavoritoEmail = class
  public
    class procedure EnviarFavoritosEmail(pdData: TDate);
  end;

implementation

class procedure TServicesRestaurantesFavoritoEmail.EnviarFavoritosEmail
  (pdData: TDate);
var
  oItem: IDomainFavoritosInterfaces;
  sRestauranteFavorito: string;
begin
  sRestauranteFavorito := TServicesRestaurantesFavorito.GetRestauranteFavorito(pdData);

  for oItem in TRepositories.New.Favoritos do
  begin
    if (oItem.Data <> Trunc(Now)) then
      Break;

    TUtilsEmail.EnviarEmail(oItem.Email, sRestauranteFavorito);
  end;

end;

end.
