unit Utils.Email;

interface

uses
  System.SysUtils, IdSMTP, IdSSLOpenSSL, IdMessage, IdText, IdExplicitTLSClientServerBase,
  Utils.Constantes;

type
  TUtilsEmail = class
  private
  public
    class procedure EnviarEmail(const psEmail, psConteudo: string);
  end;

implementation


{ TUtilsEmail }

class procedure TUtilsEmail.EnviarEmail(const psEmail, psConteudo: string);
var
  lSSL: TIdSSLIOHandlerSocketOpenSSL;
  lSMTP: TIdSMTP;
  lMessage: TIdMessage;
  lText: TIdText;
begin
  lSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  try
    lSMTP := TIdSMTP.Create(nil);
    try
      lMessage := TIdMessage.Create(nil);
      try
        lSSL.SSLOptions.Method := sslvSSLv23;
        lSSL.SSLOptions.Mode := sslmClient;
        lSMTP.IOHandler := lSSL;
        lSMTP.AuthType := satDefault;
        lSMTP.UseTLS := utUseRequireTLS;
        lSMTP.Host := HOST;
        lSMTP.Port := PORT;
        lSMTP.Username := USERNAME;
        lSMTP.Password := PASSWORD;
        lMessage.From.Address := EMAILORIGEM;
        lMessage.From.Name := 'Deafio DbServer';
        lMessage.ReplyTo.EMailAddresses := lMessage.From.Address;
        lMessage.Recipients.Add.Text := psEmail;
        lMessage.Subject := ASSUNTO;
        lMessage.Encoding := meMIME;
        lText := TIdText.Create(lMessage.MessageParts);
        lText.Body.Add(psConteudo);
        lText.ContentType := 'text/plain; charset=iso-8859-1';

        try
          lSMTP.Connect;
          lSMTP.Authenticate;
        except
          on E:Exception do begin
            // E.Message;
            Exit;
          end;
        end;
        try
          lSMTP.Send(lMessage);
        except
          On E:Exception do begin
            exit;
          end;
        end;
      finally
        lMessage.Free;
      end;
    finally
      lSMTP.Free;
    end;
  finally
    lSSL.Free;
    UnLoadOpenSSLLibrary;
  end;
end;

end.
