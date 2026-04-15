table 50200 LicenseTable
{
    Caption = 'LicenseTable';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; id; Integer)
        {
            Caption = 'id';
        }
        field(2; tenantId; Guid)
        {
            Caption = 'tenantId';
        }
        field(3; extensionId; Integer)
        {
            Caption = 'extensionId';
        }
        field(4; extensionName; Text[50])
        {
            Caption = 'extensionName';
        }
        field(5; status; Text[15])
        {
            Caption = 'status';
        }
    }
    keys
    {
        key(PK; id)
        {
            Clustered = true;
        }
    }
}
