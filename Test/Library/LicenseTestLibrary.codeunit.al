codeunit 50204 "License Test Library"
{
    Access = Internal;

    procedure CreateLicenseRecord(): Record License
    var
        LicenseRecord: Record License;
    begin
        LicenseRecord."Tenant Id" := CreateGuid();
        LicenseRecord."Customer Name" := 'This license is for test purposes';
        LicenseRecord."Extension Id" := CreateGuid();
        LicenseRecord."Date Created" := CurrentDateTime();
        LicenseRecord."Expiration Date" := CreateDateTime(CalcDate('<+7D>', Today()), Time());
        LicenseRecord.Status := 'Active';

        exit(LicenseRecord);
    end;

    procedure CreateLicenseRecordWithStatus(Status: Text): Record License
    var
        LicenseRecord: Record License;
    begin
        LicenseRecord := CreateLicenseRecord();
        LicenseRecord.Status := Status;

        exit(LicenseRecord);
    end;

    procedure CreateSignedLicenseRecord(LicenseCrypto: Codeunit "License Crypto"): Record License
    var
        LicenseRecord: Record License;
    begin
        LicenseRecord := CreateLicenseRecord();
        LicenseRecord.Signature := LicenseCrypto.ComputeHMAC(
            LicenseRecord."Tenant Id",
            LicenseRecord."Extension Id",
            LicenseREcord."Date Created",
            LicenseRecord."Expiration Date",
            LicenseRecord.Status
        );

        exit(LicenseRecord);
    end;
}