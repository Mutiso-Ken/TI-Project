page 51161 "Procurement Request List"
{
    PageType = List;
    SourceTable = "Procurement Request";
    CardPageID = "Procurement Request Card";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field(Title; Rec.Title)
                {
                }
                field("Procurement Method"; Rec."Procurement Method")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Requisiton No"; Rec."Requisiton No")
                {
                }
                field("Current Budget"; Rec."Current Budget")
                {
                }
                field("Vendor No"; Rec."Vendor No")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field("Total Amount"; Rec."Total Amount")
                {
                }
                field("Tender Status"; Rec."Tender Status")
                {
                }
                field("Quotation Status"; Rec."Quotation Status")
                {
                }
                field("Tender Opening Date"; Rec."Tender Opening Date")
                {
                }
                field("Tender Closing Date"; Rec."Tender Closing Date")
                {
                }
                field("Created By"; Rec."Created By")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}
