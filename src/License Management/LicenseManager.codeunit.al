codeunit 50200 "License Manager"
{
    SingleInstance = true;

    var
        LicenseValid: Boolean;
        LastCheck: DateTime;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"System Initialization", 'OnAfterLogin', '', false, false)]
    local procedure OnLogin()
    begin
        Message('Status %1', LicenseValid); //temp notification!

    end;
}