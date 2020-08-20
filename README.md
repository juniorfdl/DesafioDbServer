# Desafio DbServer Elvio.Junior


## Ambiente Linux

Entrar na pasta docker e rodar o comando: docker-compose up -d
Esse comando vai diponibilizar dois serviços.

Para testar basta entrar nos links abaixo:
 http://localhost:9000/restaurantes
 http://localhost:3000
 
## Ambiente Windows

Nesse ambiente é preciso executar manualmente os serviços nas seguintes pastas
\WebApi\Win32\Debug\DesafioDbServerWebApi.exe
\FrontEnd\Delphi\Win64\Debug\DesafioDbServer.exe
\FrontEnd\React - executar via cmd o comando: yarn start

## Ambiente de Desenvolvimento

## Compilar aplicação no delphi

Via gerenciador de pacotes https://github.com/HashLoad/boss
Executar comando: boss dependencies

Sem gerenciador de pacotes:
Basta colocar o caminho \WebApi\Horse\src no library path do delphi.

## Utilização do Sistema

Executar o serviço client pelo app DesafioDbServer.exe 
Ao entrar no app clicando duas vezes na lista de restaurante será solicitado seu e-mail e antes do meio dia você ira receber um e-mail com o restaurante escolhido.

O ambiente web basta acessar o link: http://localhost:2999/

## Destaques do sistema

O sistema pode ser disponibilizado em multiplos os dispositivos.
DesafioDbServer.dpr - Windowns, Linux
FrontEnd\React -Web

O sistema esta estruturado para receber qualquer tipo de evolução

### TODOS - Evoluções e melhorias
1. [ ] Gravar dados no banco de dados
2. [ ] Melhorar UI e UX
3. [ ] Finalizar app React - o mesmo foi feito apenas para ilustrar
4. [ ] Aumentar cobertura de testes
5. [ ] Configurar CI/CD

