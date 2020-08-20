unit Domain.Favoritos.Interfaces;

interface

uses System.JSON;

type
  IDomainFavoritosInterfaces = interface
    ['{8FFA11BB-586F-4F45-8D11-840B15E79DC0}']

    function GetNomeRestaurante: string;
    function SetNomeRestaurante(const value: string): IDomainFavoritosInterfaces;

    function GetEmail: string;
    function SetEmail(const value: string): IDomainFavoritosInterfaces;

    function GetData: TDate;
    function SetData(const value: TDate): IDomainFavoritosInterfaces;

    property NomeRestaurante: string read GetNomeRestaurante;
    property Email: string read GetEmail;
    property Data: TDate read GetData;

    function ToJson: TJSONObject;
  end;

implementation

end.
