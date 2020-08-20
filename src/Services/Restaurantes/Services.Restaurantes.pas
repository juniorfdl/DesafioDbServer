unit Services.Restaurantes;

interface

uses Services.Restaurantes.Interfaces, Services.Restaurantes.Fakes,
  Domain.Restaurantes.Interfaces, Services.Restaurantes.Favorito,
  Services.Restaurantes.Favorito.Email;

type
  TServicesRestaurantes = class(TInterfacedObject,
    IServicesRestaurantesInterfaces)
  private
    function GetAllToJson: string;
    function GetFavoritoDia: string;
    procedure EnviarFavoritosEmail;
  public
    class function New: IServicesRestaurantesInterfaces;
  end;

implementation

uses System.JSON, SysUtils;

{ TServicesRestaurantes }

procedure TServicesRestaurantes.EnviarFavoritosEmail;
begin
  TServicesRestaurantesFavoritoEmail.EnviarFavoritosEmail(Now);
end;

function TServicesRestaurantes.GetAllToJson: string;
var
  oArrayJson: TJSONArray;
  Restourantes: IDomainRestaurantesInterfaces;
begin
  oArrayJson := TJSONArray.Create;
  try
    for Restourantes in TServicesRestaurantesFakes.GetRestaurantes do
    begin
      oArrayJson.AddElement(Restourantes.ToJson);
    end;

    Result := oArrayJson.ToString;
  finally
    FreeAndNil(oArrayJson);
  end;
end;

function TServicesRestaurantes.GetFavoritoDia: string;
begin
  Result := TServicesRestaurantesFavorito.GetRestauranteFavorito(Now);
end;

class function TServicesRestaurantes.New: IServicesRestaurantesInterfaces;
begin
  Result := Self.Create;
end;

end.
