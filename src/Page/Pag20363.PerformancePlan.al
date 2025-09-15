#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 20363 "Performance Plan"
{
    PageType = ListPart;
    SourceTable = "Performance Plan";

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
                field("Review Period"; Rec."Review Period")
                {
                    ApplicationArea = Basic;
                }
                field("KEY RESULT AREAS"; Rec."KEY RESULT AREAS")
                {
                    ApplicationArea = Basic;
                }
                field("PERFORMANCE MEASURES"; Rec."PERFORMANCE MEASURES")
                {
                    ApplicationArea = Basic;
                }
                field(TARGET; Rec.TARGET)
                {
                    ApplicationArea = Basic;
                }
                field(DIRECTION; Rec.DIRECTION)
                {
                    ApplicationArea = Basic;
                }
                field("Actual Achieved"; Rec."Actual Achieved")
                {
                    ApplicationArea = Basic;
                }
                field("% of target"; Rec."% of target")
                {
                    ApplicationArea = Basic;
                }
                field(Rating; Rec.Rating)
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

