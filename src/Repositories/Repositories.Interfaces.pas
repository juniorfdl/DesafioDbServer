unit Repositories.Interfaces;

interface

uses Domain.Favoritos.Interfaces, Domain.Restaurantes.Interfaces, Generics.Collections;

Type
  IRepositoriesInterfaces = interface
    ['{45FB1195-9BC3-439E-8CB6-AEABDBF3A452}']
    function Restaurantes: TList<IDomainRestaurantesInterfaces>;
    function Favoritos: TList<IDomainFavoritosInterfaces>;
  end;

implementation

end.
