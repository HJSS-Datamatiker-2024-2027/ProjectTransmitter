codeunit 50201 "License API Client"
{
    procedure GetLicenseStatus(tenantId: Guid; extensionId: Integer): Boolean
    var
        Url: Text;
        Client: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestContent: HttpContent;
        RequestHeaders: HttpHeaders;
        ResponseContent: HttpContent;
        ResponseText: Text;
        ContentHeaders: HttpHeaders;
        JsonObj: JsonObject;
        JsonToken: JsonToken;

        LicenseStatus: Text;
    begin
        RequestMessage.Method := 'GET';
        Url := StrSubstNo('https://projectdummysatellite-production.up.railway.app/api/licenses/%1?tenantId=%2', extensionId, tenantId);
        RequestMessage.SetRequestUri(Url);

        if not Client.Send(RequestMessage, ResponseMessage) then
            Error('HttpRequest was not succesful');

        ResponseContent := ResponseMessage.Content;
        if not ResponseContent.ReadAs(ResponseText) then
            Error('Could not read response content');

        if not JsonObj.ReadFrom(ResponseText) then
            Error('Invalid JSON response');

        if JsonObj.Get('status', JsonToken) then
            LicenseStatus := JsonToken.AsValue().AsText()
        else
            Error('Field "status" not found');

        Message(LicenseStatus);

        if LicenseStatus = 'Active' then
            exit(true)
        else
            exit(false);
    end;

    procedure GetAllLicenses(tenantId: Guid)
    var
        Url: Text;
        Client: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        ResponseContent: HttpContent;
        ResponseText: Text;
        JArray: JsonArray;
        JToken: JsonToken;
        JObject: JsonObject;

        Id: Integer;
        ReturnedTenantId: Guid; //Skal være Guid!!!
        CustomerName: Text;
        ExtensionId: Integer;
        DateCreated: DateTime;
        ExpirationDate: DateTime;
        Status: Text;

    begin
        RequestMessage.Method := 'GET';
        Url := StrSubstNo('https://projectdummysatellite-production.up.railway.app/api/licenses?tenantId=%1', tenantId);
        RequestMessage.SetRequestUri(Url);

        if not Client.Send(RequestMessage, ResponseMessage) then
            Error('HttpRequest was not succesful');

        ResponseContent := ResponseMessage.Content;
        if not ResponseContent.ReadAs(ResponseText) then
            Error('Could not read response content');

        JArray.ReadFrom(ResponseText);
        foreach JToken in JArray do begin
            JObject := JToken.AsObject();

            Id := JObject.SelectToken('id', JToken) ? JToken.AsValue().AsInteger() : -1;
            ReturnedTenantId := JObject.SelectToken('tenantId', JToken) ? JToken.AsValue.AsText() : '';
            CustomerName := JObject.SelectToken('customerName', JToken) ? JToken.AsValue.AsText() : '';
            ExtensionId := JObject.SelectToken('extensionId', JToken) ? JToken.AsValue.AsInteger() : -1;
            DateCreated := JObject.SelectToken('dateCreated', JToken) ? JToken.AsValue.AsDateTime() : CurrentDateTime();
            ExpirationDate := JObject.SelectToken('expirationDate', JToken) ? JTOken.AsValue.AsDateTime() : CurrentDateTime();
            Status := JObject.SelectToken('status', JToken) ? JToken.AsValue.AsText() : '';

            InsertLicense(Id, ReturnedTenantId, CustomerName, ExtensionId, DateCreated, ExpirationDate, Status);
        end;
    end;

    local procedure InsertLicense(id: Integer; TenantId: Guid; CustomerName: Text; ExtensionId: Integer; DateCreated: DateTime; ExpirationDate: DateTime; Status: Text)
    var
        License: Record "License";
    begin
        License.Init();
        License.Id := Id;
        License."Tenant Id" := TenantId;
        License."Customer Name" := CustomerName;
        License."Extension Id" := ExtensionId;
        License."Date Created" := DateCreated;
        License."Expiration Date" := ExpirationDate;
        License.Status := Status;

        License.Insert(true);
    end;
}