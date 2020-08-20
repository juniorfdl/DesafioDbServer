unit Services.Favoritos;

interface

uses Services.Favoritos.Interfaces, Domain.Favoritos.Interfaces, Repositories, Domain.Favoritos,
  Services.Favoritos.Existe;

type
  TServicesFavoritos = class(TInterfacedObject,
    IServicesFavoritosInterfaces)
  private
    function GetAllToJson: string;
    function Gravar(const psEmail, psRestaurante: string): IServicesFavoritosInterfaces;
  public
    class function New: IServicesFavoritosInterfaces;
  end;

implementation

uses System.JSON, SysUtils;

{ TServicesRestaurantes }

function TServicesFavoritos.GetAllToJson: string;
var
  oArrayJson: TJSONArray;
  Restourantes: IDomainFavoritosInterfaces;
begin
  oArrayJson := TJSONArray.Create;
  try
    for Restourantes in TRepositories.New.Favoritos do
    begin
      oArrayJson.AddElement(Restourantes.ToJson);
    end;

    Result := oArrayJson.ToString;
  finally
    FreeAndNil(oArrayJson);
  end;
end;

function TServicesFavoritos.Gravar(const psEmail,
  psRestaurante: string): IServicesFavoritosInterfaces;
var
  oItemExiste: IDomainFavoritosInterfaces;
begin
  Result := Self;

  if (psEmail = EmptyStr) or (psRestaurante = EmptyStr) then
    Exit;

  oItemExiste := TServicesFavoritosExiste.GetExistente(psEmail);

  if Assigned(oItemExiste) then
    oItemExiste.SetNomeRestaurante(psRestaurante)
  else
    TRepositories.New.Favoritos.Add(TDomainFavoritos.New(psRestaurante, psEmail));
end;

class function TServicesFavoritos.New: IServicesFavoritosInterfaces;
begin
  Result := Self.Create;
end;

end.
