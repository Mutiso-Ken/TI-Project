#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50008 "Personal Qualities"
{
    PageType = List;
    SourceTable = "Purchase Line";
    SourceTableView = where("Line Type" = const(PersonalQualities));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(personalDescription; Rec.personalDescription)
                {
                    ApplicationArea = Basic;
                }
                field(score; Rec.score)
                {
                    ApplicationArea = Basic;
                }
                field(comments; Rec.comments)
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

