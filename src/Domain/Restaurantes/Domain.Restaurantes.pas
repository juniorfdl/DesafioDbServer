unit Domain.Restaurantes;

interface

uses Domain.Restaurantes.Interfaces, REST.JSON, System.JSON;

type
  {$M+}
  TDomainRestaurantes = class(TInterfacedObject, IDomainRestaurantesInterfaces)
  private
    FNome: string;
    function GetNome: string;

    function SetNome(const value: string): IDomainRestaurantesInterfaces;

    property Nome: string read GetNome write fNome;
    function ToJson: TJSONObject;
  public
    class function New(const psRestaurante: string): IDomainRestaurantesInterfaces;
  end;

implementation

{ TDomainRestaurantes }

function TDomainRestaurantes.GetNome: string;
begin
  Result := FNome;
end;

class function TDomainRestaurantes.New(const psRestaurante: string): IDomainRestaurantesInterfaces;
begin
  result := Self.Create;
  result.SetNome(psRestaurante);
end;

function TDomainRestaurantes.SetNome(const value: string): IDomainRestaurantesInterfaces;
begin
  Nome := value;
  Result := Self;
end;

function TDomainRestaurantes.ToJson: TJSONObject;
begin
  Result := TJson.ObjectToJsonObject(Self);
end;

end.

