unit Repositories;

interface

uses Repositories.Interfaces, Domain.Favoritos.Interfaces,
  Domain.Restaurantes.Interfaces, Generics.Collections, Repositories.Favoritos.Singleton;

type
  TRepositories = class(TInterfacedObject, IRepositoriesInterfaces)
  private
    function Restaurantes: TList<IDomainRestaurantesInterfaces>;
    function Favoritos: TList<IDomainFavoritosInterfaces>;
  public
    class function New: IRepositoriesInterfaces;
  end;

implementation

{ TRepositories }

function TRepositories.Favoritos: TList<IDomainFavoritosInterfaces>;
begin
  Result := TRepositoriesFavoritosSingleton.ObterInstancia.Favoritos;
end;

class function TRepositories.New: IRepositoriesInterfaces;
begin
  Result := Self.Create;
end;

function TRepositories.Restaurantes: TList<IDomainRestaurantesInterfaces>;
begin
  Result := TList<IDomainRestaurantesInterfaces>.Create;
end;

end.
