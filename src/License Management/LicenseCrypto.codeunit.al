codeunit 50202 "License Crypto"
{
    Access = Internal;

    procedure ComputeHMAC(TenantId: Guid; ExtensionId: Guid; DateCreated: DateTime; ExpirationDate: DateTime; Status: Text): Text
    var
        CryptoManagement: Codeunit "Cryptography Management";
        Data: Text;
    begin
        Data := Format(TenantId) + Format(ExtensionId) + Format(DateCreated) + Format(ExpirationDate) + Status;

        exit(CryptoManagement.GenerateHash(Data + GetSecret(), 2)); // 2 betyder SHA256 hash
    end;

    procedure VerifyHMAC(LicenseRecord: Record "License"): Boolean
    var
        Expected: Text;
    begin
        Expected := ComputeHMAC(
            LicenseRecord."Tenant Id",
            LicenseRecord."Extension Id",
            LicenseRecord."Date Created",
            LicenseRecord."Expiration Date",
            LicenseRecord.Status
        );

        exit(Expected = LicenseRecord.Signature);
    end;

    local procedure GetSecret(): Text
    begin
        // Den her metode skal hente secret fra API'et!
        exit('1234');
    end;
}