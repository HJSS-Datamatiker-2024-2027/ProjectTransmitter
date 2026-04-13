codeunit 50200 "License Manager"
{
    SingleInstance = true;

    var
        LicenseValid: Boolean;
        LastCheck: DateTime;
        LicenseAPIClient: Codeunit "License API Client";

    //[EventSubscriber(ObjectType::Codeunit, Codeunit::"System Initialization", 'OnAfterLogin', '', false, false)]
    [EventSubscriber(ObjectType::Page, Page::"Customer List", 'OnOpenPageEvent', '', false, false)]
    local procedure OnLogin()
    begin
        Message('Status %1', LicenseValid); //temp notification
        LicenseValid := CheckLicense();
    end;

    procedure CheckLicense(): Boolean
    begin
        if IsOlderThan24Hours(LastCheck) or not LicenseValid then begin
            LicenseValid := LicenseAPIClient.GetLicenseStatus();
            LastCheck := CurrentDateTime();
        end;

        exit(LicenseValid);
    end;

    local procedure IsOlderThan24Hours(LastCheck: DateTime): Boolean
    var
        OneDay: Duration;
    begin
        OneDay := 24 * 60 * 60 * 1000;

        if LastCheck = 0DT then
            LastCheck := CurrentDateTime();

        exit((CurrentDateTime() - LastCheck) > OneDay);
    end;
}