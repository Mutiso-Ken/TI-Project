//APPRAISAL SECTION B PAGES

page 20369 "Appraisal Section B Part 1"
{
    ApplicationArea = All;
    Caption = 'What did you do well in relation to your objectives?';
    PageType = ListPart;
    SourceTable = "Appraisal Lines Section B";
    SourceTableView = where(Section = const("Section 1"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Question Description"; Rec."Question Description")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Answer"; Rec."Employee Answer")
                {
                    ApplicationArea = Basic;
                }
                field("Self-appraisal (Comments)"; Rec."Self-appraisal (Comments)")
                {
                    ApplicationArea = Basic;
                }
                field("Comments by the supervisor"; Rec."Comments by the supervisor")
                {
                    Caption = 'Supervisor`s Feedback';
                    ApplicationArea = Basic;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Section := Rec.Section::"Section 1";
    end;
}
page 20370 "Appraisal Section B Part 2"
{
    ApplicationArea = All;
    Caption = 'What enabled you to perform well?';
    PageType = ListPart;
    SourceTable = "Appraisal Lines Section B";
    SourceTableView = where(Section = const("Section 2"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Question Description"; Rec."Question Description")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Answer"; Rec."Employee Answer")
                {
                    ApplicationArea = Basic;
                }
                field("Self-appraisal (Comments)"; Rec."Self-appraisal (Comments)")
                {
                    ApplicationArea = Basic;
                }
                field("Comments by the supervisor"; Rec."Comments by the supervisor")
                {
                    Caption = 'Supervisor`s Feedback';
                    ApplicationArea = Basic;
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Section := Rec.Section::"Section 2";
    end;
}
page 20371 "Appraisal Section B Part 3"
{
    ApplicationArea = All;
    Caption = 'What didn’t you do well?';
    PageType = ListPart;
    SourceTable = "Appraisal Lines Section B";
    SourceTableView = where(Section = const("Section 3"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Question Description"; Rec."Question Description")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Answer"; Rec."Employee Answer")
                {
                    ApplicationArea = Basic;
                }
                field("Self-appraisal (Comments)"; Rec."Self-appraisal (Comments)")
                {
                    ApplicationArea = Basic;
                }
                field("Comments by the supervisor"; Rec."Comments by the supervisor")
                {
                    Caption = 'Supervisor`s Feedback';
                    ApplicationArea = Basic;
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Section := Rec.Section::"Section 3";
    end;
}
page 20372 "Appraisal Section B Part 4"
{
    ApplicationArea = All;
    Caption = 'What are some of the problems encountered and how were they handled?';
    PageType = ListPart;
    SourceTable = "Appraisal Lines Section B";
    SourceTableView = where(Section = const("Section 4"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Question Description"; Rec."Question Description")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Answer"; Rec."Employee Answer")
                {
                    ApplicationArea = Basic;
                }
                field("Self-appraisal (Comments)"; Rec."Self-appraisal (Comments)")
                {
                    ApplicationArea = Basic;
                }
                field("Comments by the supervisor"; Rec."Comments by the supervisor")
                {
                    Caption = 'Supervisor`s Feedback';
                    ApplicationArea = Basic;
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Section := Rec.Section::"Section 4";
    end;
}
