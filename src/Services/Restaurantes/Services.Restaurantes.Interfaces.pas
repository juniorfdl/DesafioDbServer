unit Services.Restaurantes.Interfaces;

interface

type
  IServicesRestaurantesInterfaces = interface
    ['{87C5553E-8D46-494A-95C8-C840923D3D99}']
    function GetAllToJson: string;
    function GetFavoritoDia: string;
    procedure EnviarFavoritosEmail;
  end;

implementation

end.
