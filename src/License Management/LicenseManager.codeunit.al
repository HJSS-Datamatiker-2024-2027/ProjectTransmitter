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
        LicenseAPIClient.GetLicenseStatus('1b81cb10-2baf-4ee4-a63e-f1603c774587', 2);

        //LicenseAPIClient.GetAllLicenses('1b81cb10-2baf-4ee4-a63e-f1603c774587');
    end;

    procedure CheckLicense(): Boolean
    begin
        if IsOlderThan24Hours(LastCheck) or not LicenseValid then begin
            //LicenseValid := LicenseAPIClient.GetLicenseStatus();
            LicenseValid := true;
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

// codeunit 50200 "License Manager"
// {
//     SingleInstance = true;

//     var
//         LicenseValid: Boolean;
//         LastCheck: DateTime;

//     procedure IsLicenseValid(): Boolean
//     begin
//         exit(LicenseValid);
//     end;

//     procedure SetLicenseStatus(NewStatus: Boolean)
//     begin
//         LicenseValid := NewStatus;
//         LastCheck := CurrentDateTime;
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"System Initialization", 'OnAfterLogin', '', false, false)]
//     local procedure OnLogin()
//     begin
//         LicenseValid := true; // test
//     end;
// }