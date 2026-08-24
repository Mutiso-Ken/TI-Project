page 51165 "Vendor Registration Review"
{
    PageType = List;
    SourceTable = "Vendor Registration Details";
    CardPageID = "Vendor Registration Card";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
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
                field("Max Business Value"; Rec."Max Business Value")
                {
                }
                field("Telephone Number"; Rec."Telephone Number")
                {
                }
                field("Email Address"; Rec."Email Address")
                {
                }
                field("Applicant Name"; Rec."Applicant Name")
                {
                }
                field("Declaration Date"; Rec."Declaration Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}
