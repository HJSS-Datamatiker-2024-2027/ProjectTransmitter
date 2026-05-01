codeunit 50200 "License Manager"
{
    SingleInstance = true;

    var
        LicenseAPIClient: Codeunit "License API Client";

    //[EventSubscriber(ObjectType::Codeunit, Codeunit::"System Initialization", 'OnAfterLogin', '', false, false)]
    [EventSubscriber(ObjectType::Page, Page::"Customer List", 'OnOpenPageEvent', '', false, false)]
    local procedure OnLogin()
    var
        AzureAdTenant: Codeunit "Azure AD Tenant";
        ModuleInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(ModuleInfo);

        //LicenseAPIClient.GetAllLicenses('44833fc5-b393-4b9f-897a-1f876412ddb1');
        CheckLicense(AzureAdTenant.GetAadTenantId(), DelChr(ModuleInfo.Id(), '=', '{}').ToLower());

        //Message(DelChr(ModuleInfo.Id(), '=', '{}').ToLower());
        //Message(ModuleInfo.Id());
        //Message(AzureAdTenant.GetAadTenantId());
    end;

    procedure CheckLicense(TenantId: Guid; ExtensionId: Guid): Boolean
    var
        License: Record "License";
        LicenseCrypto: Codeunit "License Crypto";
    begin
        //Her mangler alle grace-checks!
        License.Get(TenantId, ExtensionId);

        if not LicenseCrypto.VerifyHMAC(License) then begin
            Message('Signature not matching');
            exit(false);
        end;

        if LicenseAPIClient.GetLicenseStatus(TenantId, ExtensionId) = 'Active' then
            exit(true);

        if (License.Status = 'Active') and IsWithinGracePeriod(License."Expiration Date") then
            exit(true);

        exit(false);
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

    local procedure IsWithinGracePeriod(ExpirationDate: DateTime): Boolean
    var
        GracePeriodInDays: Integer;
    begin
        GracePeriodInDays := 7;
        exit(CurrentDateTime() <= (ExpirationDate + (GracePeriodInDays * 24 * 60 * 60 * 1000)));
    end;
}