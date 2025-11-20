

page 20368 "Appraisal Section B"
{
    ApplicationArea = All;
    Caption = 'What did you do well in relation to your objectives?';
    PageType = ListPart;
    SourceTable = "Appraisal Lines Section B";
    // SourceTableView = where(Question = const("What did you do well in relation to your objectives?"));


    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Question Description"; Rec."Question Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Employee Answer"; Rec."Employee Answer")
                {
                    ApplicationArea = Basic;
                }
                field("Self-appraisal (Comments)2"; Rec."Self-appraisal (Comments)")
                {
                    Caption = 'Self-appraisal (Comments)';
                    ApplicationArea = Basic;
                }
                field("Comments by the supervisor2"; Rec."Comments by the supervisor")
                {
                    Caption = 'Supervisor`s Feedback';
                    ApplicationArea = Basic;
                }
            }

        }

    }

}
