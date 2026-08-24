page 51080 "Partenr Activities Schedule"
{
    Caption = 'Implementation Schedule';
    PageType = ListPart;
    SourceTable = "Partner Implem. Activitie";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Activity; Rec.Activity)
                {
                }
                field("From Date"; Rec."From Date")
                {
                }
                field("To Date"; Rec."To Date")
                {
                }
                field(Duration; Rec.Duration)
                {
                    Caption = 'Duration(In Days)';
                    Editable = false;
                }
                field(Budget; Rec.Budget)
                {
                }
            }
        }
    }

    actions
    {
    }
}
