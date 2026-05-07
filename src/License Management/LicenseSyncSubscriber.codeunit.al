codeunit 50203 "License Sync Subscriber"
{
    [EventSubscriber(ObjectType::Page, Page::"License List", 'OnOpenPageEvent', '', false, false)]
    local procedure OnLicenseListOpen()
    var
        LicenseAPIClient: Codeunit "License API Client";
        AzureAdTenant: Codeunit "Azure AD Tenant";
    begin
        Message('Page opened!');
        LicenseAPIClient.GetAllLicenses(AzureAdTenant.GetAadTenantId());
        Message('after');
    end;
}