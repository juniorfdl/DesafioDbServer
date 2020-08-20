unit RestApi.Client.Impl;

interface

uses
   RestApi.Client.Interfaces, REST.Client, System.JSON, REST.Types, SysUtils, IPPeerClient;

type
  TRestApiClientImpl = class(TInterfacedObject, IRestApiClientInterface)
  Strict private
    fBaseURL:String;
    fResource:String;

    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    procedure CriarObjetosRest;
  public
    function Get: IRestApiClientInterface;
    function Post: IRestApiClientInterface;
    function Put: IRestApiClientInterface;
    function SetResource(const value:String): IRestApiClientInterface;
    function GetRetorno: TJSONObject;
    function GetRetornoArray: TJSONArray;
    function AddBody(poBody: TJSONObject; const psContentType: String): IRestApiClientInterface; overload;
    function AddBody(const psBody: String; const psContentType: String): IRestApiClientInterface; overload;
    function AddParameter(const AName, AValue: string):IRestApiClientInterface; overload;
    function AddParameter(const AName, AValue: string; const AKind: TRESTRequestParameterKind; const AOptions: TRESTRequestParameterOptions = []):IRestApiClientInterface; overload;
    function ContentTypeClient(const Value: String):IRestApiClientInterface;
    function ContentTypeResponse(const Value: String):IRestApiClientInterface;

    function StatusCode(out Value: SmallInt):IRestApiClientInterface;
    function StatusText(out Value: String):IRestApiClientInterface;

    constructor create(const pBaseURL:String);
    destructor Destroy; override;

    class function New(const pBaseURL:String):IRestApiClientInterface;

  end;

implementation

{ TRestApiClientImpl }

function TRestApiClientImpl.AddBody(const psBody,
  psContentType: String): IRestApiClientInterface;
begin
  Result := Self;
  RESTRequest.AddBody(psBody, ContentTypeFromString(psContentType));
end;

function TRestApiClientImpl.AddParameter(const AName, AValue: string;
  const AKind: TRESTRequestParameterKind;
  const AOptions: TRESTRequestParameterOptions = []): IRestApiClientInterface;
begin
  Result := Self;
  RESTRequest.AddAuthParameter(AName, AValue, AKind, AOptions);
end;

function TRestApiClientImpl.ContentTypeClient(const Value: String): IRestApiClientInterface;
begin
  Result := Self;
  RESTClient.ContentType := Value;
end;

function TRestApiClientImpl.ContentTypeResponse(
  const Value: String): IRestApiClientInterface;
begin
  Result := Self;
  RESTResponse.ContentType := Value;
end;

function TRestApiClientImpl.AddParameter(const AName,
  AValue: string): IRestApiClientInterface;
begin
  Result := Self;
  Self.AddParameter(AName, AValue, pkGETorPOST);
end;

function TRestApiClientImpl.AddBody(poBody: TJSONObject;
  const psContentType: String): IRestApiClientInterface;
begin
  Result := Self;
  Self.AddBody(poBody.ToJSON, psContentType);
end;

constructor TRestApiClientImpl.create(const pBaseURL: String);
begin
  fBaseURL := pBaseURL;
  CriarObjetosRest;
end;

procedure TRestApiClientImpl.CriarObjetosRest;
begin
  RESTClient := TRESTClient.create(fBaseURL);
  RESTClient.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  RESTClient.AcceptCharset := 'UTF-8, *;q=0.8';
  RESTClient.ContentType := 'application/json';//'application/x-www-form-urlencoded';
  //RESTClient.HandleRedirects := True;
  //RESTClient.RaiseExceptionOn500 := False;

  RESTResponse := TRESTResponse.create(nil);
  RESTResponse.ContentType := 'application/json';

  RESTRequest := TRESTRequest.create(nil);
  RESTRequest.Client := RESTClient;
  RESTRequest.Response := RESTResponse;
//  RESTRequest.SynchronizedEvents := False;

  //RESTRequest.Charset             := 'UFT-8';
  //AddParameter('cache-control', 'no-cache', pkHTTPHEADER, [poDoNotEncode]);

  RESTClient.Authenticator := nil;
end;

destructor TRestApiClientImpl.destroy;
begin
  FreeAndNil(RESTClient);
  FreeAndNil(RESTRequest);
  FreeAndNil(RESTResponse);
  inherited;
end;

function TRestApiClientImpl.Get: IRestApiClientInterface;
begin
  Result := Self;
  RESTRequest.Method := rmGET;
  RESTRequest.Resource := fResource;
  RESTRequest.Execute;
end;

function TRestApiClientImpl.GetRetorno: TJSONObject;
begin
  if RESTRequest.Response <> nil then
  begin
    Result := RESTRequest.Response.JSONValue as TJSONObject;
  end
  else
    Result := nil;
end;

function TRestApiClientImpl.GetRetornoArray: TJSONArray;
begin
  if RESTRequest.Response <> nil then
  begin
    Result := RESTRequest.Response.JSONValue as TJSONArray;
  end
  else
    Result := nil;
end;

class function TRestApiClientImpl.New(
 const pBaseURL: String): IRestApiClientInterface;
begin
  Result := Self.create(pBaseURL);
end;

function TRestApiClientImpl.Post: IRestApiClientInterface;
begin
  Result := Self;
  RESTRequest.Method := rmPOST;
  RESTRequest.Execute;
  GetRetorno;
end;

function TRestApiClientImpl.Put: IRestApiClientInterface;
begin
  Result := Self;
  RESTRequest.Method := rmPUT;
  RESTRequest.Execute;
  GetRetorno;
end;

function TRestApiClientImpl.SetResource(
  const value: String): IRestApiClientInterface;
begin
  Result := Self;
  fResource := Value;
  RESTRequest.Resource := Value;
end;

function TRestApiClientImpl.StatusCode(out Value: SmallInt): IRestApiClientInterface;
begin
  Result := Self;

  if RESTRequest.Response <> nil then
  begin
    Value := RESTRequest.Response.StatusCode;
  end
  else
    Value := 0;
end;

function TRestApiClientImpl.StatusText(out Value: String): IRestApiClientInterface;
begin
  Result := Self;

  if RESTRequest.Response <> nil then
  begin
    Value := RESTRequest.Response.StatusText;
  end
  else
    Value := '';
end;

end.
