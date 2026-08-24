page 51076 "RFA Outcomes"
{
    PageType = ListPart;
    SourceTable = "RFA Outcomes";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Outcome Code"; Rec."Outcome Code")
                {
                    Editable = false;
                }
                field(Outcome; Rec.Outcome)
                {
                }
            }
        }
    }

    actions
    {
    }
}
