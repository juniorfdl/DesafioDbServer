program DesafioDbServerTests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  Services.Favoritos.Existe.Test in 'Services.Favoritos.Existe.Test.pas',
  Services.Favoritos.Existe in '..\src\Services\Favoritos\Services.Favoritos.Existe.pas',
  Services.Favoritos.Interfaces in '..\src\Services\Favoritos\Services.Favoritos.Interfaces.pas',
  Services.Favoritos in '..\src\Services\Favoritos\Services.Favoritos.pas',
  Services.Restaurantes.Fakes in '..\src\Services\Restaurantes\Services.Restaurantes.Fakes.pas',
  Services.Restaurantes.Favorito.Email in '..\src\Services\Restaurantes\Services.Restaurantes.Favorito.Email.pas',
  Services.Restaurantes.Favorito in '..\src\Services\Restaurantes\Services.Restaurantes.Favorito.pas',
  Services.Restaurantes.Interfaces in '..\src\Services\Restaurantes\Services.Restaurantes.Interfaces.pas',
  Services.Restaurantes in '..\src\Services\Restaurantes\Services.Restaurantes.pas',
  Domain.Favoritos.Interfaces in '..\src\Domain\Favoritos\Domain.Favoritos.Interfaces.pas',
  Domain.Favoritos in '..\src\Domain\Favoritos\Domain.Favoritos.pas',
  Domain.Restaurantes.Interfaces in '..\src\Domain\Restaurantes\Domain.Restaurantes.Interfaces.pas',
  Domain.Restaurantes in '..\src\Domain\Restaurantes\Domain.Restaurantes.pas',
  Repositories.Favoritos.Singleton in '..\src\Repositories\Repositories.Favoritos.Singleton.pas',
  Repositories.Interfaces in '..\src\Repositories\Repositories.Interfaces.pas',
  Repositories in '..\src\Repositories\Repositories.pas',
  Utils.Constantes in '..\src\Utils\Constantes\Utils.Constantes.pas',
  Utils.Email in '..\src\Utils\Email\Utils.Email.pas',
  Services.Restaurantes.Favorito.Utilizado in '..\src\Services\Restaurantes\Services.Restaurantes.Favorito.Utilizado.pas',
  Services.Restaurantes.Favorito.Test in 'Services.Restaurantes.Favorito.Test.pas';

{R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

