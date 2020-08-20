unit Services.Favoritos.Existe;

interface

uses Repositories, Domain.Favoritos.Interfaces, SysUtils;

type
  TServicesFavoritosExiste = class
  public
    class function GetExistente(const psEmail: string): IDomainFavoritosInterfaces;
  end;

implementation

{ TServicesFavoritosExiste }

class function TServicesFavoritosExiste.GetExistente(const psEmail: string): IDomainFavoritosInterfaces;
var
  oItem: IDomainFavoritosInterfaces;
begin
  Result := nil;

  if psEmail = EmptyStr then
    Exit;

  for oItem in TRepositories.New.Favoritos do
  begin
    if SameText(oItem.Email, psEmail) and (oItem.Data = Trunc(Now)) then
      Exit(oItem);
  end;
end;

end.
