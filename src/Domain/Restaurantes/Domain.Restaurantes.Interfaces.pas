unit Domain.Restaurantes.Interfaces;

interface

uses System.JSON;

type
  IDomainRestaurantesInterfaces = interface
    ['{8FFA11BB-586F-4F45-8D11-840B15E79DC0}']

    function GetNome: string;
    function SetNome(const value: string): IDomainRestaurantesInterfaces;

    property Nome: string read GetNome;

    function ToJson: TJSONObject;
  end;


implementation

end.
