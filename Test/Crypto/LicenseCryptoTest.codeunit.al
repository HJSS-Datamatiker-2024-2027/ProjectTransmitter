codeunit 50205 "License Crypto Test"
{
    Subtype = Test;

    var
        TestLibrary: Codeunit "License Test Library";
        LicenseCrypto: Codeunit "License Crypto";

    /// 
    /// VerifyHMaC
    /// 

    [Test]
    procedure "Given License Signature Is Valid_When VerifyHMAC Is Called_Then Returns True"()
    var
        LicenseRecord: Record License;
        Result: Boolean;
    begin
        // [GIVEN] Given License Signature Is Valid
        LicenseRecord := TestLibrary.CreateSignedLicenseRecord(LicenseCrypto);

        // [WHEN] When VerifyHMAC Is Called
        Result := LicenseCrypto.VerifyHMAC(LicenseRecord);

        // [THEN] Then Returns True
        if not Result then
            Error('Valid singature should return true');
    end;

    [Test]
    procedure "Given License Status Changed After Signing_When VerifyHMAC Is Called_Then Returns False"()
    var
        LicenseRecord: Record License;
        Result: Boolean;
    begin
        // [GIVEN] Given License Signature is Invalid 
        LicenseRecord := TestLibrary.CreateSignedLicenseRecord(LicenseCrypto);
        LicenseRecord.Status := 'Pending';

        // [WHEN] When VerifyHMAC Is Called
        Result := LicenseCrypto.VerifyHMAC(LicenseRecord);

        // [THEN] Then Returns False 
        if Result then
            Error('Invalid signature should return false');
    end;

    [Test]
    procedure "Given License Expiration Date Changed After Signing_When VerifyHMAC Is Called_Then Return False"()
    var
        LicenseRecord: Record License;
        Result: Boolean;
    begin
        // [GIVEN] Given License Expiration Date Changed After Signing 
        LicenseRecord := TestLibrary.CreateSignedLicenseRecord(LicenseCrypto);
        LicenseRecord."Expiration Date" := CurrentDateTime();

        // [WHEN] When VerifyHMAC Is Called
        Result := LicenseCrypto.VerifyHMAC(LicenseRecord);

        // [THEN] Then Return False 
        if Result then
            Error('Invalid signature should return false');
    end;

    [Test]
    procedure "Given License Has Empty Signature_When VerifyHMAC Is Called_Then Returns False"()
    var
        LicenseRecord: Record License;
        Result: Boolean;
    begin
        // [GIVEN] Given License Has Empty Signature 
        LicenseRecord := TestLibrary.CreateLicenseRecord();
        LicenseRecord.Signature := '';

        // [WHEN] When VerifyHMAC Is Called 
        Result := LicenseCrypto.VerifyHMAC(LicenseRecord);

        // [THEN] Then Returns False 
        if Result then
            Error('Empty signature should return false');
    end;

    /// 
    /// ComputeHMAC
    /// 

    [Test]
    procedure "Given Valid Inputs_When ComputeHMAC Is Called_Then Returns Non Empty Hash"()
    var
        LicenseRecord: Record License;
        Result: Text;
    begin
        // [GIVEN] Given Valid Inputs 
        LicenseRecord := TestLibrary.CreateLicenseRecord();

        // [WHEN] When ComputeHMAC Is Called
        Result := LicenseCrypto.ComputeHMAC(
            LicenseRecord."Tenant Id",
            LicenseRecord."Extension Id",
            LicenseRecord."Date Created",
            LicenseRecord."Expiration Date",
            LicenseRecord.Status
        );

        // [THEN] Then Returns Non Empty Hash 
        if Result = '' then
            Error('Hash should not be empty');
    end;

    [Test]
    procedure "Given Same Inputs_ComputeHMAC Is Called_Then Returns Same Hash"()
    var
        TenantId: Guid;
        ExtensionId: Guid;
        DateCreated: DateTime;
        ExpirationDate: DateTime;
        Status: Text;
        Result1: Text;
        Result2: Text;
    begin
        // [GIVEN] Given Same Inputs 
        TenantId := CreateGuid();
        ExtensionId := CreateGuid();
        DateCreated := CurrentDateTime();
        ExpirationDate := CreateDateTime(CalcDate('<+7D>', Today()), Time());
        Status := 'Active';

        // [WHEN] ComputeHMAC Is Called 
        Result1 := LicenseCrypto.ComputeHMAC(TenantId, ExtensionId, DateCreated, ExpirationDate, Status);
        Result2 := LicenseCrypto.ComputeHMAC(TenantId, ExtensionId, DateCreated, ExpirationDate, Status);

        // [THEN] Then Returns Same Hash 
        if Result1 <> Result2 then
            Error('Both Results should be equal');
    end;

    [Test]
    procedure "Given Different TenantId_When ComputeHMAC Is Called_Then Returns Different Hashes"()
    var
        ExtensionId: Guid;
        DateCreated: DateTime;
        ExpirationDate: DateTime;
        Status: Text;
        Result1: Text;
        Result2: Text;
    begin
        // [GIVEN] Given Different Input 
        ExtensionId := CreateGuid();
        DateCreated := CurrentDateTime();
        ExpirationDate := CreateDateTime(CalcDate('<+7D>', Today()), Time());

        // [WHEN] When ComputeHMAC Is Called 
        Result1 := LicenseCrypto.ComputeHMAC(CreateGuid(), ExtensionId, DateCreated, ExpirationDate, Status);
        Result2 := LicenseCrypto.ComputeHMAC(CreateGuid(), ExtensionId, DateCreated, ExpirationDate, Status);

        // [THEN] Then Returns Different Hash 
        if Result1 = Result2 then
            Error('The two results should not be the same');
    end;

    [Test]
    procedure "Given Different Status_When ComputeHMAC Is Called_Then Returns Different Hashes"()
    var
        TenantId: Guid;
        ExtensionId: Guid;
        DateCreated: DateTime;
        ExpirationDate: DateTime;
        Status1: Text;
        Status2: Text;
        Result1: Text;
        Result2: Text;
    begin
        // [GIVEN] Given Different Status 
        TenantId := CreateGuid();
        ExtensionId := CreateGuid();
        DateCreated := CurrentDateTime();
        ExpirationDate := CreateDateTime(CalcDate('<+7D>', Today()), Time());
        Status1 := 'Suspended';
        Status2 := 'Active';

        // [WHEN] When ComputeHMAC Is Called 
        Result1 := LicenseCrypto.ComputeHMAC(TenantId, ExtensionId, DateCreated, ExpirationDate, Status1);
        Result2 := LicenseCrypto.ComputeHMAC(TenantId, ExtensionId, DateCreated, ExpirationDate, Status2);

        // [THEN] Then Returns Different Hashes 
        if Result1 = Result2 then
            Error('The two results should not be the same');
    end;
}