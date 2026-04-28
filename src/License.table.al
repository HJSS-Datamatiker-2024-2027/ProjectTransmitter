table 50200 License
{
    Caption = 'LicenseTable';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Tenant Id"; Guid)
        {
            Caption = 'Tenant Id';
        }
        field(2; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
        }
        field(3; "Extension Id"; Guid)
        {
            Caption = 'Extension Id';
        }
        field(4; "Date Created"; DateTime)
        {
            Caption = 'Date Created';
        }
        field(5; "Expiration Date"; DateTime)
        {
            Caption = 'Expiration Date';
        }
        field(6; Status; Text[20])
        {
            Caption = 'Status';
        }
        field(7; Signature; Text[64])
        {
            Caption = 'Signature';
        }
    }
    keys
    {
        key(PK; "Tenant Id", "Extension Id")
        {
            Clustered = true;
        }
    }
}
