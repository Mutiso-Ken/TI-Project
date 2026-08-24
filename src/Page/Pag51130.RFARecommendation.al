page 51130 "RFA Recommendation"
{
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "RFA Recommendations";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Stage; Rec.Stage)
                {
                    Editable = false;
                }
                field(Recommendation; Rec.Recommendation)
                {
                }
            }
        }
    }

    actions
    {
    }
}
