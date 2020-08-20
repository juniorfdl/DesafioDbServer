unit Services.Notificacoes.Favorito;

interface

uses SysUtils, Services.Restaurantes, System.Threading;

type
  TServicesNotificacoesFavorito = class
    class procedure NewInstancia;
  end;

implementation

{ TServicesNotificacoesFavorito }

class procedure TServicesNotificacoesFavorito.NewInstancia;
const
  TEMPO_EMAIL = 60000;
var
  Task: ITask;
begin
  Task := TTask.Create(
    procedure begin
      while true do
      begin
        Sleep(TEMPO_EMAIL);
        TServicesRestaurantes.New.EnviarFavoritosEmail;
      end;
    end
  );
  Task.Start;
end;

initialization
  TServicesNotificacoesFavorito.NewInstancia;

end.
