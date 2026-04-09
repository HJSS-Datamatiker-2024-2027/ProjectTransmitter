codeunit 50201 "License API Client"
{
    procedure GetLicenseStatus()
    var
        Client: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestContent: HttpContent;
        ResponseContent: HttpContent;
        ResponseText: Text;
        ContentHeaders: HttpHeaders;
        RequestHeaders: HttpHeaders;
    begin
        RequestMessage.Method := 'GET';
        RequestMessage.SetRequestUri('http://localhost:8080/api/Licenses');

        if not Client.Send(RequestMessage, ResponseMessage) then
            Error('HttpRequest was not succesful');

        ResponseContent := ResponseMessage.Content;
        if not ResponseContent.ReadAs(ResponseText) then
            Error('Could not read response content');


    end;
}