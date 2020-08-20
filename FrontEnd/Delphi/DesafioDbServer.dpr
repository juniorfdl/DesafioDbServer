program DesafioDbServer;

uses
  System.StartUpCopy,
  FMX.Forms,
  uPrincipal in 'uPrincipal.pas' {fPrincipal},
  RestApi.Client.Interfaces in '..\..\src\Utils\RestApi\Client\RestApi.Client.Interfaces.pas',
  RestApi.Client.Impl in '..\..\src\Utils\RestApi\Client\RestApi.Client.Impl.pas' {$R *.res},
  Utils.Constantes in '..\..\src\Utils\Constantes\Utils.Constantes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfPrincipal, fPrincipal);
  Application.Run;
end.
