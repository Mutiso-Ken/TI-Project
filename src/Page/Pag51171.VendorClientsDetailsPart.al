page 51171 "Vendor Clients Details Part"
{
    PageType = ListPart;
    SourceTable = "Vendor Clients Details";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Client Organization"; Rec."Client Organization")
                {
                }
                field("Contact Person"; Rec."Contact Person")
                {
                }
                field(Telephone; Rec.Telephone)
                {
                }
                field("Value of Contract"; Rec."Value of Contract")
                {
                }
                field("Contract Duration"; Rec."Contract Duration")
                {
                }
                field("Doc Contract Evidence"; Rec."Doc Contract Evidence")
                {
                }
            }
        }
    }

    actions
    {
    }
}
