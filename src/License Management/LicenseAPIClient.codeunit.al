codeunit 50201 "License API Client"
{
    procedure GetLicenseStatus(TenantId: Guid; ExtensionId: Guid): Text
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
        Url := StrSubstNo('https://projectdummysatellite-production.up.railway.app/api/licenses/%1?tenantId=%2', ExtensionId, TenantId);
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

        exit(LicenseStatus);
    end;

    procedure GetAllLicenses(TenantId: Guid)
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
        ExtensionId: Guid;
        DateCreated: DateTime;
        ExpirationDate: DateTime;
        Status: Text;

    begin
        RequestMessage.Method := 'GET';
        Url := StrSubstNo('https://projectdummysatellite-production.up.railway.app/api/licenses?tenantId=%1', TenantId);
        RequestMessage.SetRequestUri(Url);

        if not Client.Send(RequestMessage, ResponseMessage) then
            Error('HttpRequest was not succesful');

        ResponseContent := ResponseMessage.Content;
        if not ResponseContent.ReadAs(ResponseText) then
            Error('Could not read response content');

        JArray.ReadFrom(ResponseText);
        foreach JToken in JArray do begin
            JObject := JToken.AsObject();

            ReturnedTenantId := JObject.SelectToken('tenantId', JToken) ? JToken.AsValue.AsText() : '';
            CustomerName := JObject.SelectToken('customerName', JToken) ? JToken.AsValue.AsText() : '';
            ExtensionId := JObject.SelectToken('extensionId', JToken) ? JToken.AsValue.AsText() : '';
            DateCreated := JObject.SelectToken('dateCreated', JToken) ? JToken.AsValue.AsDateTime() : CurrentDateTime();
            ExpirationDate := JObject.SelectToken('expirationDate', JToken) ? JTOken.AsValue.AsDateTime() : CurrentDateTime();
            Status := JObject.SelectToken('status', JToken) ? JToken.AsValue.AsText() : '';

            InsertLicense(ReturnedTenantId, CustomerName, ExtensionId, DateCreated, ExpirationDate, Status);
        end;
    end;

    local procedure InsertLicense(TenantId: Guid; CustomerName: Text; ExtensionId: Guid; DateCreated: DateTime; ExpirationDate: DateTime; Status: Text)
    var
        License: Record "License";
        LicenseCrypto: Codeunit "License Crypto";
    begin
        License.Init();
        License."Tenant Id" := TenantId;
        License."Customer Name" := CustomerName;
        License."Extension Id" := ExtensionId;
        License."Date Created" := DateCreated;
        License."Expiration Date" := ExpirationDate;
        License.Status := Status;
        License.Signature := LicenseCrypto.ComputeHMAC(TenantId, ExtensionId, DateCreated, ExpirationDate, Status);

        if not License.Get(TenantId, ExtensionId) then
            License.Insert(true)
        else
            License.Modify(true);
    end;
}