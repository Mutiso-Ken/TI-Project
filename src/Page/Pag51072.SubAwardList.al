page 51072 "Sub Award List"
{
    CardPageID = "Sub Award Card";
    PageType = List;
    SourceTable = RFA;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec.No)
                {
                }
                field(Title; Rec.Title)
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("Awarded Amount"; Rec."Awarded Amount")
                {
                }
                field("Awarded Amount(LCY)"; Rec."Awarded Amount(LCY)")
                {
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                }
                field("Approved Amount (LCY)"; Rec."Approved Amount (LCY)")
                {
                }
            }
        }
    }

    actions
    {
    }
}
