program DesafioDbServerWebApi;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Horse,
  System.JSON,
  Horse.Jhonson,
  Horse.CORS,
  Domain.Favoritos.Interfaces in '..\src\Domain\Favoritos\Domain.Favoritos.Interfaces.pas',
  Domain.Favoritos in '..\src\Domain\Favoritos\Domain.Favoritos.pas',
  Domain.Restaurantes.Interfaces in '..\src\Domain\Restaurantes\Domain.Restaurantes.Interfaces.pas',
  Domain.Restaurantes in '..\src\Domain\Restaurantes\Domain.Restaurantes.pas',
  Repositories.Favoritos.Singleton in '..\src\Repositories\Repositories.Favoritos.Singleton.pas',
  Repositories.Interfaces in '..\src\Repositories\Repositories.Interfaces.pas',
  Repositories in '..\src\Repositories\Repositories.pas',
  Services.Favoritos.Existe in '..\src\Services\Favoritos\Services.Favoritos.Existe.pas',
  Services.Favoritos.Interfaces in '..\src\Services\Favoritos\Services.Favoritos.Interfaces.pas',
  Services.Favoritos in '..\src\Services\Favoritos\Services.Favoritos.pas',
  Services.Notificacoes.Favorito in '..\src\Services\Notificacoes\Services.Notificacoes.Favorito.pas',
  Services.Restaurantes.Fakes in '..\src\Services\Restaurantes\Services.Restaurantes.Fakes.pas',
  Services.Restaurantes.Favorito.Email in '..\src\Services\Restaurantes\Services.Restaurantes.Favorito.Email.pas',
  Services.Restaurantes.Favorito in '..\src\Services\Restaurantes\Services.Restaurantes.Favorito.pas',
  Services.Restaurantes.Interfaces in '..\src\Services\Restaurantes\Services.Restaurantes.Interfaces.pas',
  Services.Restaurantes in '..\src\Services\Restaurantes\Services.Restaurantes.pas',
  Utils.Email in '..\src\Utils\Email\Utils.Email.pas',
  Utils.Constantes in '..\src\Utils\Constantes\Utils.Constantes.pas',
  Services.Restaurantes.Favorito.Utilizado in '..\src\Services\Restaurantes\Services.Restaurantes.Favorito.Utilizado.pas';

var
  App: THorse;

begin
  App := THorse.Create(9000);

  App.Use(CORS);
  App.Use(Jhonson);

  App.Get('/restaurantes',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      oJson: TJSONArray;
    begin
      try
        oJson := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes
          (TServicesRestaurantes.New.GetAllToJson), 0) as TJSONArray;

        Res.Send<TJSONArray>(oJson);
        Writeln('restaurantes=OK');
      except
        on E: Exception do
        begin
          Writeln('Erro metodo restaurantes: ' + E.Message);
        end;
      end;
    end);

  App.Get('/gravar',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      sEmail, sRestaurante: string;
    begin
      try
        Req.Query.TryGetValue('email', sEmail);
        Req.Query.TryGetValue('restaurante', sRestaurante);

        TServicesFavoritos.New.Gravar(sEmail, sRestaurante);

        Res.Send<TJSONObject>(TJSONObject.Create.AddPair('Gravar', 'OK'));
        Write(' gravar=OK');
        Write(' Email: ', sEmail);
        Writeln(' Rest.: ', sRestaurante);

      except
        on E: Exception do
        begin
          Writeln('Erro metodo gravar: ' + E.Message);
        end;
      end;
    end);

  App.Get('/favoritos',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      oJson: TJSONArray;
    begin
      try
        oJson := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes
          (TServicesFavoritos.New.GetAllToJson), 0) as TJSONArray;

        Res.Send<TJSONArray>(oJson);
        Writeln('favoritos=OK');
      except
        on E: Exception do
        begin
          Writeln('Erro metodo favoritos: ' + E.Message);
        end;
      end;
    end);

  App.Get('/favoritosdia',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    begin
      try
        Res.Send<TJSONObject>(TJSONObject.Create.AddPair('favoritosdia',
          TServicesRestaurantes.New.GetFavoritoDia));

        Writeln('favoritosdia=OK');
      except
        on E: Exception do
        begin
          Writeln('Erro metodo favoritosdia: ' + E.Message);
        end;
      end;
    end);

  App.Start;

end.
