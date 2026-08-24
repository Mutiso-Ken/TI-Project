page 51166 "Vendor Registration Card"
{
    PageType = Card;
    SourceTable = "Vendor Registration Details";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Vendor ID"; Rec."Vendor ID")
                {
                }
                field("Business Name"; Rec."Business Name")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Vendor Status"; Rec."Vendor Status")
                {
                }
                field("Suppliying Categories"; Rec."Suppliying Categories")
                {
                }
                field("Nature Of Business"; Rec."Nature Of Business")
                {
                }
                field("Founded On"; Rec."Founded On")
                {
                }
                field("Max Business Value"; Rec."Max Business Value")
                {
                }
                field("Public Company"; Rec."Public Company")
                {
                }
                field("Private Company"; Rec."Private Company")
                {
                }
                field("Nominal Capital"; Rec."Nominal Capital")
                {
                }
                field("Issued Capital"; Rec."Issued Capital")
                {
                }
                field("Credit Period"; Rec."Credit Period")
                {
                }
                field("Financial Capability"; Rec."Financial Capability")
                {
                }
            }
            group(Address)
            {
                Caption = 'Address';
                field("Postal Address"; Rec."Postal Address")
                {
                }
                field(Town; Rec.Town)
                {
                }
                field(Street; Rec.Street)
                {
                }
                field("Buiding Name"; Rec."Buiding Name")
                {
                }
                field("Office/Room Number"; Rec."Office/Room Number")
                {
                }
                field("Floor Number"; Rec."Floor Number")
                {
                }
                field("Business Premises"; Rec."Business Premises")
                {
                }
                field("Plot Number"; Rec."Plot Number")
                {
                }
                field("Street Road"; Rec."Street Road")
                {
                }
            }
            group(Contact)
            {
                Caption = 'Contact';
                field("Telephone Number"; Rec."Telephone Number")
                {
                }
                field("Email Address"; Rec."Email Address")
                {
                }
                field("Probity Postal Address"; Rec."Probity Postal Address")
                {
                }
                field("Probity Telephone"; Rec."Probity Telephone")
                {
                }
                field("Probity Email"; Rec."Probity Email")
                {
                }
            }
            group("Licensing & Compliance")
            {
                Caption = 'Licensing & Compliance';
                field("Trade License Number"; Rec."Trade License Number")
                {
                }
                field("Trade License Expiry Date"; Rec."Trade License Expiry Date")
                {
                }
                field("Code of Conduct"; Rec."Code of Conduct")
                {
                }
                field("Sworn Statement"; Rec."Sworn Statement")
                {
                }
                field("Sworn Date"; Rec."Sworn Date")
                {
                }
            }
            group("Bank Details")
            {
                Caption = 'Bank Details';
                field("Bank Name"; Rec."Bank Name")
                {
                }
                field("Account Name"; Rec."Account Name")
                {
                }
                field("Account Number"; Rec."Account Number")
                {
                }
                field("Bank Branch"; Rec."Bank Branch")
                {
                }
                field("Swift Code"; Rec."Swift Code")
                {
                }
                field("Branch Code"; Rec."Branch Code")
                {
                }
                field("Bank Currency"; Rec."Bank Currency")
                {
                }
            }
            group(Documents)
            {
                Caption = 'Documents (submitted)';
                field("Doc Certificate Registration"; Rec."Doc Certificate Registration")
                {
                }
                field("Doc company Profile"; Rec."Doc company Profile")
                {
                }
                field("Doc Trade License"; Rec."Doc Trade License")
                {
                }
                field("Doc Tax Compliance"; Rec."Doc Tax Compliance")
                {
                }
                field("Doc NCA Certificate"; Rec."Doc NCA Certificate")
                {
                }
                field("Doc Bank Statements"; Rec."Doc Bank Statements")
                {
                }
                field("Doc Audited Accounts"; Rec."Doc Audited Accounts")
                {
                }
                field("Doc Regulatory Certificates"; Rec."Doc Regulatory Certificates")
                {
                }
                field("Doc Recommendation Letters"; Rec."Doc Recommendation Letters")
                {
                }
                field("Doc Organizational Chart"; Rec."Doc Organizational Chart")
                {
                }
            }
            group(Declaration)
            {
                Caption = 'Declaration';
                field("Declarant Name"; Rec."Declarant Name")
                {
                }
                field("Declarant Position"; Rec."Declarant Position")
                {
                }
                field("Declaration Date"; Rec."Declaration Date")
                {
                }
                field("Applicant Name"; Rec."Applicant Name")
                {
                }
                field("Represented By"; Rec."Represented By")
                {
                }
            }
            part(Personnel; "Vendor Personnel Part")
            {
                Caption = 'Management Personnel';
                SubPageLink = VendorID = FIELD("Vendor ID");
            }
            part(Directors; "Vendor Company Directors Part")
            {
                Caption = 'Company Directors';
                SubPageLink = VendorID = FIELD("Vendor ID");
            }
            part(Clients; "Vendor Clients Details Part")
            {
                Caption = 'Client References';
                SubPageLink = VendorID = FIELD("Vendor ID");
            }
        }
    }

    actions
    {
    }
}
