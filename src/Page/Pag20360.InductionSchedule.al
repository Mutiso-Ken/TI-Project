#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 20360 "Induction Schedule"
{
    PageType = List;
    SourceTable = "Induction Schedule";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No"; Rec."Employee No")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field("Inducting Employee No"; Rec."Inducting Employee No")
                {
                    ApplicationArea = Basic;
                }
                field("Inducting Employee Name"; Rec."Inducting Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field(Inducted; Rec.Inducted)
                {
                    ApplicationArea = Basic;
                }
                field("Date Inducted"; Rec."Date Inducted")
                {
                    ApplicationArea = Basic;
                }
                field("Time Inducted"; Rec."Time Inducted")
                {
                    ApplicationArea = Basic;
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

