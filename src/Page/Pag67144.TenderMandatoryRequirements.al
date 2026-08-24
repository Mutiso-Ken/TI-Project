#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
page 67144 "Tender Mandatory Requirements"
{
    PageType = List;
    SourceTable = "Tender Mandatory Requirements";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Mandatory Code"; Rec."Mandatory Code")
                {
                }
                field("Requirement Description"; Rec."Requirement Description")
                {
                }
            }
        }
    }

    actions
    {
    }
}
