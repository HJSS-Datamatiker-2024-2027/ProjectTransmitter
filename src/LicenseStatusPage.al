page 50200 LicenseStatusPage
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Integer; // hack til UI

    layout
    {
        area(Content)
        {
            group(Status)
            {
                field(LicenseStatus; LicenseStatusTxt)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    var
        LicenseManager: Codeunit "License Manager";
        LicenseStatusTxt: Text;

    trigger OnOpenPage()
    begin
        if LicenseManager.CheckLicense() then
            LicenseStatusTxt := 'Valid'
        else
            LicenseStatusTxt := 'Invalid';
    end;
}