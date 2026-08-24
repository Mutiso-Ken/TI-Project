page 51164 "Quotation Bidders Part"
{
    PageType = ListPart;
    SourceTable = "Quotation Bidders";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field("Vendor Category"; Rec."Vendor Category")
                {
                }
                field("E-mail Address"; Rec."E-mail Address")
                {
                }
                field("Phone No"; Rec."Phone No")
                {
                }
                field("Total Quoted Amount"; Rec."Total Quoted Amount")
                {
                }
                field("Email Sent"; Rec."Email Sent")
                {
                }
                field("Award Vendor"; Rec."Award Vendor")
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Compare Bids")
            {
                Caption = 'Compare Bids';
                ApplicationArea = All;
                Image = CompareCOA;
                RunObject = page "Vendor Quoted Amount Per Item";
                RunPageLink = "Quote No" = FIELD("Reference No");
            }
        }
    }
}
