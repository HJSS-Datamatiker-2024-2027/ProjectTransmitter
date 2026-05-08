codeunit 50207 "API Secret Provider" implements "Secret Provider"
{
    procedure GetSecret(): Text
    begin
        //Her skal være API kald
        exit('1234'); //Den her metode skal implemeteres rigtigt!!! 
    end;
}