page 50200 LicenseStatusPage
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    //SourceTable = Integer; // hack til UI

    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

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
            // if LicenseManager.IsLicenseValid() then
            LicenseStatusTxt := 'Valid'
        else
            LicenseStatusTxt := 'Invalid';
    end;
}