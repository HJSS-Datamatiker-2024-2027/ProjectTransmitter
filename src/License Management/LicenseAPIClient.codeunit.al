codeunit 50201 "License API Client"
{
    procedure GetLicenseStatus(): Boolean
    var
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
        RequestMessage.SetRequestUri('http://host.docker.internal:8080/api/Licenses');
        //RequestMessage.SetRequestUri('https://jsonplaceholder.typicode.com/todos');

        requestMessage.getHeaders(RequestHeaders);

        RequestHeaders.Add('Accept', 'application/json');

        if not Client.Send(RequestMessage, ResponseMessage) then
            Error('HttpRequest was not succesful');

        ResponseContent := ResponseMessage.Content;
        if not ResponseContent.ReadAs(ResponseText) then
            Error('Could not read response content');

        if not JsonObj.ReadFrom(ResponseText) then
            Error('Invalid JSON response');

        if JsonObj.Get('Status', JsonToken) then
            LicenseStatus := JsonToken.AsValue().AsText()
        else
            Error('Field "Status" not found');

        Message('License Status: %1', LicenseStatus);

        if LicenseStatus = 'Active' then
            exit(true)
        else
            exit(false);
    end;
}