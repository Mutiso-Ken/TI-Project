#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50003 "Performance Subform"
{
    PageType = List;
    SourceTable = "Purchase Line";
    SourceTableView = where("Line Type" = const(Performance));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(keyResultAreas; Rec.keyResultAreas)
                {
                    ApplicationArea = Basic;
                }
                field(keyActivities; Rec.keyActivities)
                {
                    ApplicationArea = Basic;
                }
                field(performanceMeasures; Rec.performanceMeasures)
                {
                    ApplicationArea = Basic;
                }
                field(target; Rec.target)
                {
                    ApplicationArea = Basic;
                }
                field(weighting; Rec.weighting)
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

