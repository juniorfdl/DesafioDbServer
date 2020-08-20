unit RestApi.Client.Interfaces;

interface

uses
  System.JSON, REST.Types;

type
  IRestApiClientInterface = interface
    ['{E2092639-6264-4027-B4A3-E2AC8EEFED1B}']
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
  end;

implementation

end.
