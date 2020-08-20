unit Services.Favoritos.Interfaces;

interface

type
  IServicesFavoritosInterfaces = interface
    ['{F9A713B0-2D92-43C3-985F-8985F28FD37B}']
    function GetAllToJson: string;
    function Gravar(const psEmail, psRestaurante: string): IServicesFavoritosInterfaces;
  end;

implementation

end.
