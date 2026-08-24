page 51046 "Concept Note Outcomes"
{
    PageType = List;
    SourceTable = "Concept Outcomes";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Outcome; Rec.Outcome)
                {
                }
                field("Outcome Name"; Rec."Outcome Name")
                {
                }
                field("Budget Planned"; Rec."Budget Planned")
                {
                }

            }
        }
    }

    actions
    {
    }
}
