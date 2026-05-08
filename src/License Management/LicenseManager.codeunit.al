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
    end;

    procedure CheckLicense(TenantId: Guid; ExtensionId: Guid): Boolean
    var
        License: Record "License";
        LicenseCrypto: Codeunit "License Crypto";
        APISecretProvider: Codeunit "API Secret Provider";
        LicenseStatus: Text;
    begin
        //Her mangler alle grace-checks!
        License.Get(TenantId, ExtensionId);

        if not LicenseCrypto.VerifyHMAC(License, APISecretProvider) then begin
            Message('Signature not matching');
            exit(false);
        end;

        if TryGetLicenseStatus(TenantId, ExtensionId, LicenseStatus) then begin
            if LicenseStatus = 'Active' then
                exit(true)
        end;
        // Nested if-statement for at undgå crash ved compare "Expiration Date", når den er == 0DT
        if License.Status = 'Active' then
            if IsWithinGracePeriod(License."Expiration Date") then
                exit(true);

        Message('låst');
        exit(false);
    end;

    local procedure IsWithinGracePeriod(ExpirationDate: DateTime): Boolean
    var
        GracePeriodInDays: Integer;
    begin
        GracePeriodInDays := 7;
        exit(CurrentDateTime() <= (ExpirationDate + (GracePeriodInDays * 24 * 60 * 60 * 1000)));
    end;

    [TryFunction]
    local procedure TryGetLicenseStatus(TenantId: Guid; ExtensionId: Guid; var Status: Text)
    begin
        Status := LicenseAPIClient.GetLicenseStatus(TenantId, ExtensionId);
    end;
}