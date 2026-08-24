page 90207 "SpeedKey Setup"
{
    PageType = List;
    SourceTable = "SpeedKey Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(SpeedKey; Rec.SpeedKey)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Grant No"; Rec."Grant No")
                {
                }
                field("Objective Code"; Rec."Objective Code")
                {
                }
                field("Outcome Code"; Rec."Outcome Code")
                {
                }
                field("Output Code"; Rec."Output Code")
                {
                }
                field("Activity Code"; Rec."Activity Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}
