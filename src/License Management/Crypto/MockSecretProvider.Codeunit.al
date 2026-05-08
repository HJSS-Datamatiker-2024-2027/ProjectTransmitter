Codeunit 50206 "Mock Secret Provider" implements "Secret Provider"
{
    var
        MockSecret: Text;

    procedure GetSecret(): Text
    begin
        exit(MockSecret);
    end;

    procedure SetSecret(Secret: Text)
    begin
        MockSecret := Secret;
    end;
}