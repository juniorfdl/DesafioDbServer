unit Services.Restaurantes.Fakes;

interface

uses Repositories.Interfaces, Repositories, Domain.Restaurantes, SysUtils,
  Domain.Restaurantes.Interfaces, Generics.Collections;

type
  TServicesRestaurantesFakes = class
  public
    class function GetRestaurantes: TList<IDomainRestaurantesInterfaces>;
  end;

implementation

{ TServicesRestaurantesFakes }

class function TServicesRestaurantesFakes.GetRestaurantes: TList<IDomainRestaurantesInterfaces>;
const
  NOME_RESTAURANTE_FAKE = 'Pizza Hut ';
var
  I: Integer;
begin
  Result := TRepositories.New.Restaurantes;

  for I := 1 to 20 do
  begin
    Result.Add(
      TDomainRestaurantes.New(NOME_RESTAURANTE_FAKE + I.ToString)
    );
  end;

end;

end.
