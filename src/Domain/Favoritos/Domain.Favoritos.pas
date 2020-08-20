unit Domain.Favoritos;

interface

uses REST.JSON, System.JSON, Domain.Favoritos.Interfaces;

type
{$M+}
  TDomainFavoritos = class(TInterfacedObject, IDomainFavoritosInterfaces)
  private
    FEmail: string;
    FData: Tdate;
    FNomeRestaurante: string;

    function GetNomeRestaurante: string;
    function SetNomeRestaurante(const value: string): IDomainFavoritosInterfaces;

    function GetEmail: string;
    function SetEmail(const value: string): IDomainFavoritosInterfaces;

    function GetData: Tdate;
    function SetData(const value: Tdate): IDomainFavoritosInterfaces;

    property NomeRestaurante: string read GetNomeRestaurante write FNomeRestaurante;
    property Email: string read GetEmail write FEmail;
    property Data: Tdate read GetData write FData;

    function ToJson: TJSONObject;
  public
    class function New(const psNomeRestaurante, psEmail: string): IDomainFavoritosInterfaces;
  end;

implementation

uses SysUtils;

{ TDomainFavoritos }

function TDomainFavoritos.GetData: Tdate;
begin
  result := FData;
end;

function TDomainFavoritos.GetEmail: string;
begin
  result := FEmail;
end;

function TDomainFavoritos.GetNomeRestaurante: string;
begin
  result := FNomeRestaurante;
end;

class function TDomainFavoritos.New(const psNomeRestaurante, psEmail: string): IDomainFavoritosInterfaces;
begin
  result := Self.Create;
  result.setNomeRestaurante(psNomeRestaurante)
   .SetEmail(psEmail)
   .SetData(Now);
end;

function TDomainFavoritos.SetData(const value: Tdate): IDomainFavoritosInterfaces;
begin
  Data := Trunc(value);
  result := Self;
end;

function TDomainFavoritos.SetEmail(const value: string): IDomainFavoritosInterfaces;
begin
  Email := value;
  result := Self;
end;

function TDomainFavoritos.SetNomeRestaurante(const value: string)
  : IDomainFavoritosInterfaces;
begin
  NomeRestaurante := value;
  result := Self;
end;

function TDomainFavoritos.ToJson: TJSONObject;
begin
  result := TJson.ObjectToJsonObject(Self);
end;

end.
