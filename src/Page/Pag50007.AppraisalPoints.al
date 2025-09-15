#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50007 "Appraisal Points"
{
    PageType = List;
    SourceTable = "Purchase Line";
    SourceTableView = where("Line Type" = const(Sections));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(appraisalType; Rec.appraisalType)
                {
                    ApplicationArea = Basic;
                }
                field(appraisalDescription; Rec.appraisalDescription)
                {
                    ApplicationArea = Basic;
                }
                field(staffRating; Rec.staffRating)
                {
                    ApplicationArea = Basic;
                }
                field(supervisorRating; Rec.supervisorRating)
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

