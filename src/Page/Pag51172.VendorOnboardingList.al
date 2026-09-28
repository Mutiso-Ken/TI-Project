namespace TISolution.TISolution;

using Microsoft.Purchases.Vendor;

page 51172 "Vendor Onboarding List"
{
    PageType = List;
    SourceTable = Vendor;
    ApplicationArea = All;
    Caption = 'Vendor Onboarding';
    CardPageId = "Vendor Onboarding";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Number';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name of Business';
                }
                field(Contact; Rec.Contact)
                {
                    ApplicationArea = All;
                    Caption = 'Contact Person Name';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                    Caption = 'Email Address';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    Caption = 'Telephone Number';
                }
                field("Certificate of Incorporation"; Rec."Certificate of Incorporation")
                {
                    ApplicationArea = All;
                    Caption = 'Certificate of Registration Number';
                }
                field("PIN No."; Rec."PIN No.")
                {
                    ApplicationArea = All;
                    Caption = 'KRA PIN Number';
                }
                field("Supplier Category"; Rec."Supplier Category")
                {
                    ApplicationArea = All;
                    Caption = 'Supplier Category';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(NewVendor)
            {
                ApplicationArea = All;
                Caption = 'New Vendor';
                ToolTip = 'Onboard a new vendor for e-Procurement portal access.';
                Image = New;
                RunObject = page "Vendor Onboarding";
                RunPageMode = Create;
            }
        }
    }
}
