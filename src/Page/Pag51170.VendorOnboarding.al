namespace TISolution.TISolution;

using Microsoft.Purchases.Vendor;

page 51170 "Vendor Onboarding"
{
    PageType = Card;
    SourceTable = Vendor;
    ApplicationArea = All;
    Caption = 'Vendor Onboarding';
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Vendor Details';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Number';
                    ToolTip = 'Specifies the vendor number. Assigned automatically when the vendor is saved.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name of Business';
                    ToolTip = 'Specifies the registered name of the vendor''s business.';
                }
                field(Contact; Rec.Contact)
                {
                    ApplicationArea = All;
                    Caption = 'Contact Person Name';
                    ToolTip = 'Specifies the name of the vendor''s primary contact person.';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                    Caption = 'Email Address';
                    ToolTip = 'Specifies the email address the vendor will use to activate their e-Procurement portal account.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    Caption = 'P.O. Box';
                    ToolTip = 'Specifies the vendor''s postal address.';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    Caption = 'Telephone Number';
                    ToolTip = 'Specifies the vendor''s telephone number.';
                }
                field("Certificate of Incorporation"; Rec."Certificate of Incorporation")
                {
                    ApplicationArea = All;
                    Caption = 'Certificate of Registration Number';
                    ToolTip = 'Specifies the vendor''s certificate of registration/incorporation number.';
                }
                field("PIN No."; Rec."PIN No.")
                {
                    ApplicationArea = All;
                    Caption = 'KRA PIN Number';
                    ToolTip = 'Specifies the vendor''s KRA PIN number.';
                }
                field("Supplier Category"; Rec."Supplier Category")
                {
                    ApplicationArea = All;
                    Caption = 'Supplier Category';
                    ToolTip = 'Specifies the supplier category assigned to this vendor for procurement opportunities.';
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Reg Status" := Rec."Reg Status"::Approved;
        exit(true);
    end;
}
