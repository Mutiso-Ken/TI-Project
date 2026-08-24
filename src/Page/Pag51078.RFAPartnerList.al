page 51078 "RFA Partner List"
{
    CardPageID = "Partner Bids Card";
    PageType = List;
    SourceTable = "Partner Bids";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(RFA; Rec.RFA)
                {
                }
                field("RFA Description"; Rec."RFA Description")
                {
                }
                field(Partner; Rec.Partner)
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(Email; Rec.Email)
                {
                }
                field(Phone; Rec.Phone)
                {
                }
                field(State; Rec.State)
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
                field("Approved Amount(LCY)"; Rec."Approved Amount(LCY)")
                {
                }
                field("Approval Status"; Rec."Approval Status")
                {
                }
            }
        }
    }

    actions
    {
    }
}
