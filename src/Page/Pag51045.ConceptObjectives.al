page 51045 "Concept Objectives"
{
    PageType = ListPart;
    SourceTable = "Concept Strategic Objective";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Objective Code"; Rec."Objective Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Planned Budget"; Rec."Planned Budget")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Outcomes)
            {
                Image = AllLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Concept Note Outcomes";
                RunPageLink = Objective = FIELD("Objective Code"),
                              "Concept Code" = FIELD("Concept Note");
            }
        }
    }
}
