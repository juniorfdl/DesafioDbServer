unit Horse.Router;

interface

uses Web.HTTPApp, Horse.HTTP, System.SysUtils, System.Generics.Collections;

type
  THorseCallback = reference to procedure(ARequest: THorseRequest; AResponse: THorseResponse; ANext: TProc);

  THorseRouterTree = class
  strict private
    FPrefix: string;
    FIsInitialized: Boolean;
    function GetQueuePath(APath: string; AUsePrefix: Boolean = True): TQueue<String>;
    function ForcePath(APath: String): THorseRouterTree;
  private
    FPart: String;
    FTag: String;
    FIsRegex: Boolean;
    FMiddleware: TList<THorseCallback>;
    FRegexedKeys: TList<String>;
    FCallBack: TObjectDictionary<TMethodType, TList<THorseCallback>>;
    FRoute: TDictionary<string, THorseRouterTree>;
    procedure RegisterInternal(AHTTPType: TMethodType; var APath: TQueue<string>; ACallback: THorseCallback);
    procedure RegisterMiddlewareInternal(var APath: TQueue<string>; AMiddleware: THorseCallback);
    function ExecuteInternal(APath: TQueue<string>; AHTTPType: TMethodType; ARequest: THorseRequest; AResponse: THorseResponse; AIsGroup: Boolean = False): Boolean;
    function CallNextPath(var APath: TQueue<string>; AHTTPType: TMethodType; ARequest: THorseRequest; AResponse: THorseResponse): Boolean;
    function HasNext(AMethod: TMethodType; APaths: TArray<String>; AIndex: Integer = 0): Boolean;
  public
    function CreateRouter(APath: String): THorseRouterTree;
    function GetPrefix(): string;
    procedure Prefix(APrefix: string);
    procedure RegisterRoute(AHTTPType: TMethodType; APath: string; ACallback: THorseCallback);
    procedure RegisterMiddleware(APath: string; AMiddleware: THorseCallback); overload;
    procedure RegisterMiddleware(AMiddleware: THorseCallback); overload;
    function Execute(ARequest: THorseRequest; AResponse: THorseResponse): Boolean;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ THorseRouterTree }

uses Horse.Commons, Horse.Exception;

procedure THorseRouterTree.RegisterRoute(AHTTPType: TMethodType; APath: string; ACallback: THorseCallback);
var
  LPathChain: TQueue<string>;
begin
  LPathChain := GetQueuePath(APath);
  try
    RegisterInternal(AHTTPType, LPathChain, ACallback);
  finally
    LPathChain.Free;
  end;
end;

function THorseRouterTree.CallNextPath(var APath: TQueue<string>; AHTTPType: TMethodType; ARequest: THorseRequest;
  AResponse: THorseResponse): Boolean;
var
  LCurrent: string;
  LAcceptable: THorseRouterTree;
  LFound: Boolean;
  LKey: String;
  LPathOrigin: TQueue<string>;
  LIsGroup: Boolean;
begin
  LIsGroup := False;
  LPathOrigin := APath;
  LCurrent := APath.Peek;
  LFound := FRoute.TryGetValue(LCurrent, LAcceptable);
  if (not LFound) then
  begin
    LFound := FRoute.TryGetValue(EmptyStr, LAcceptable);
    if (LFound) then
      APath := LPathOrigin;
    LIsGroup := LFound;
  end;
  if (not LFound) and (FRegexedKeys.Count > 0) then
  begin
    for LKey in FRegexedKeys do
    begin
      FRoute.TryGetValue(LKey, LAcceptable);
      if LAcceptable.HasNext(AHTTPType, APath.ToArray) then
      begin
        LFound := LAcceptable.ExecuteInternal(APath, AHTTPType, ARequest, AResponse);
        Break;
      end;
    end;
  end
  else if LFound then
    LFound := LAcceptable.ExecuteInternal(APath, AHTTPType, ARequest, AResponse, LIsGroup);
  Result := LFound;
end;

constructor THorseRouterTree.Create;
begin
  FMiddleware := TList<THorseCallback>.Create;
  FRoute := TObjectDictionary<string, THorseRouterTree>.Create([doOwnsValues]);
  FRegexedKeys := TList<String>.Create;
  FCallBack := TObjectDictionary < TMethodType, TList < THorseCallback >>.Create([doOwnsValues]);
  FPrefix := '';
end;

destructor THorseRouterTree.Destroy;
begin
  FMiddleware.Free;
  FreeAndNil(FRoute);
  FRegexedKeys.Clear;
  FRegexedKeys.Free;
  FCallBack.Free;
  inherited;
end;

function THorseRouterTree.Execute(ARequest: THorseRequest; AResponse: THorseResponse): Boolean;
var
  LQueue: TQueue<string>;
begin
  LQueue := GetQueuePath(THorseHackRequest(ARequest).GetWebRequest.PathInfo, False);
  try
    Result := ExecuteInternal(LQueue, THorseHackRequest(ARequest).GetWebRequest.MethodType, ARequest,
      AResponse);
  finally
    LQueue.Free;
  end;
end;

function THorseRouterTree.ExecuteInternal(APath: TQueue<string>; AHTTPType: TMethodType; ARequest: THorseRequest;
  AResponse: THorseResponse; AIsGroup: Boolean = False): Boolean;
var
  LCurrent: string;
  LIndex, LIndexCallback: Integer;
  LNext: TProc;
  LCallback: TList<THorseCallback>;
  LFound: Boolean;
begin
  if not AIsGroup then
    LCurrent := APath.Dequeue;

  LIndex := -1;
  LIndexCallback := -1;
  if Self.FIsRegex then
    ARequest.Params.Add(FTag, LCurrent);

  LNext := procedure
    begin
      inc(LIndex);
      if (FMiddleware.Count > LIndex) then
      begin
        LFound := True;
        Self.FMiddleware.Items[LIndex](ARequest, AResponse, LNext);
        if (FMiddleware.Count > LIndex) then
          LNext;
      end
      else if (APath.Count = 0) and assigned(FCallBack) then
      begin
        inc(LIndexCallback);
        if FCallBack.TryGetValue(AHTTPType, LCallback) then
        begin
          if (LCallback.Count > LIndexCallback) then
          begin
            if AResponse.Status = THTTPStatus.NotFound.ToInteger then
              AResponse.Send('');
            try
              LFound := True;
              LCallback.Items[LIndexCallback](ARequest, AResponse, LNext);
            except
              on E: Exception do
              begin
                if (not(E is EHorseCallbackInterrupted)) and (not(E is EHorseException)) then
                  AResponse.Send('Internal Application Error').Status(THTTPStatus.InternalServerError);
                raise;
              end;
            end;
            if (LCallback.Count > LIndexCallback) then
              LNext;
          end;
        end
        else if FCallBack.Count > 0 then
          AResponse.Send('Method Not Allowed').Status(THTTPStatus.MethodNotAllowed)
        else
          AResponse.Send('Not Found').Status(THTTPStatus.NotFound)
      end
      else
        LFound := CallNextPath(APath, AHTTPType, ARequest, AResponse);
    end;
  try
    LNext;
  finally
    LNext := nil;
    Result := LFound;
  end;
end;

function THorseRouterTree.ForcePath(APath: String): THorseRouterTree;
begin
  if not FRoute.TryGetValue(APath, Result) then
  begin
    Result := THorseRouterTree.Create;
    FRoute.Add(APath, Result);
  end;
end;

function THorseRouterTree.CreateRouter(APath: String): THorseRouterTree;
begin
  Result := ForcePath(APath);
end;

procedure THorseRouterTree.Prefix(APrefix: string);
begin
  FPrefix := '/' + APrefix.Trim(['/']);
end;

function THorseRouterTree.GetPrefix(): string;
begin
  Result := FPrefix;
end;

function THorseRouterTree.GetQueuePath(APath: string; AUsePrefix: Boolean = True): TQueue<String>;
var
  LPart: String;
  LSplitedPath: TArray<string>;
begin
  Result := TQueue<string>.Create;
  if AUsePrefix then
    APath := FPrefix + APath;
  LSplitedPath := APath.Split(['/']);
  for LPart in LSplitedPath do
  begin
    if (Result.Count > 0) and LPart.IsEmpty then
      Continue;
    Result.Enqueue(LPart);
  end;
end;

function THorseRouterTree.HasNext(AMethod: TMethodType; APaths: TArray<String>; AIndex: Integer = 0): Boolean;
var
  LNext: string;
  LNextRoute: THorseRouterTree;
  LKey: String;
begin
  Result := False;
  if (Length(APaths) <= AIndex) then
    Exit(False);
  if (Length(APaths) - 1 = AIndex) and ((APaths[AIndex] = FPart) or (FIsRegex)) then
    Exit(FCallBack.ContainsKey(AMethod) or (AMethod = mtAny));

  LNext := APaths[AIndex + 1];
  inc(AIndex);

  if FRoute.TryGetValue(LNext, LNextRoute) then
    Result := LNextRoute.HasNext(AMethod, APaths, AIndex)
  else
  begin
    for LKey in FRegexedKeys do
    begin
      if FRoute.Items[LKey].HasNext(AMethod, APaths, AIndex) then
        Exit(True);
    end;
  end;
end;

procedure THorseRouterTree.RegisterInternal(AHTTPType: TMethodType; var APath: TQueue<string>; ACallback: THorseCallback);
var
  LNextPart: String;
  LCallbacks: TList<THorseCallback>;
begin
  if not FIsInitialized then
  begin
    FPart := APath.Dequeue;
    FIsRegex := FPart.StartsWith(':');
    FTag := FPart.Substring(1, Length(FPart) - 1);
    FIsInitialized := True;
  end
  else
    APath.Dequeue;

  if APath.Count = 0 then
  begin
    if not FCallBack.TryGetValue(AHTTPType, LCallbacks) then
    begin
      LCallbacks := TList<THorseCallback>.Create;
      FCallBack.Add(AHTTPType, LCallbacks);
    end;
    LCallbacks.Add(ACallback)
  end;

  if APath.Count > 0 then
  begin
    LNextPart := APath.Peek;
    ForcePath(LNextPart).RegisterInternal(AHTTPType, APath, ACallback);
    if ForcePath(LNextPart).FIsRegex then
      FRegexedKeys.Add(LNextPart);
  end;
end;

procedure THorseRouterTree.RegisterMiddleware(AMiddleware: THorseCallback);
begin
  FMiddleware.Add(AMiddleware);
end;

procedure THorseRouterTree.RegisterMiddleware(APath: string; AMiddleware: THorseCallback);
var
  LPathChain: TQueue<String>;
begin
  LPathChain := GetQueuePath(APath);
  try
    RegisterMiddlewareInternal(LPathChain, AMiddleware);
  finally
    LPathChain.Free;
  end;
end;

procedure THorseRouterTree.RegisterMiddlewareInternal(var APath: TQueue<string>; AMiddleware: THorseCallback);
var
  FCurrent: string;
begin
  FCurrent := APath.Dequeue;
  if APath.Count = 0 then
    FMiddleware.Add(AMiddleware)
  else
    ForcePath(APath.Peek).RegisterMiddlewareInternal(APath, AMiddleware);
end;

end.
