table 50200 License
{
    Caption = 'LicenseTable';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Id; Integer)
        {
            Caption = 'Id';
        }
        field(2; "Tenant Id"; Guid)
        {
            Caption = 'Tenant Id';
        }
        field(3; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
        }
        field(4; "Extension Id"; Integer)
        {
            Caption = 'Extension Id';
        }
        field(5; "Date Created"; DateTime)
        {
            Caption = 'Date Created';
        }
        field(6; "Expiration Date"; DateTime)
        {
            Caption = 'Expiration Date';
        }
        field(7; Status; Text[100])
        {
            Caption = 'Status';
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
