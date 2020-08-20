unit Repositories.Favoritos.Singleton;

interface

uses Domain.Favoritos.Interfaces, Generics.Collections, SysUtils;

type
  TRepositoriesFavoritosSingleton = class
  private
    fFavoritos: TList<IDomainFavoritosInterfaces>;
    constructor Create;
  public
    class function ObterInstancia: TRepositoriesFavoritosSingleton;
    function Favoritos: TList<IDomainFavoritosInterfaces>;
  end;

var
  InstanciaFavoritos: TRepositoriesFavoritosSingleton;

implementation

{ TRepositoriesFavoritosSingleton }

constructor TRepositoriesFavoritosSingleton.Create;
begin
  fFavoritos := TList<IDomainFavoritosInterfaces>.Create;
end;

function TRepositoriesFavoritosSingleton.Favoritos: TList<IDomainFavoritosInterfaces>;
begin
  Result := fFavoritos;
end;

class function TRepositoriesFavoritosSingleton.ObterInstancia: TRepositoriesFavoritosSingleton;
begin
  if not Assigned(InstanciaFavoritos) then
  begin
    InstanciaFavoritos := TRepositoriesFavoritosSingleton.Create;
  end;

  result := InstanciaFavoritos;
end;

initialization

finalization
  FreeAndNil(InstanciaFavoritos);

end.
