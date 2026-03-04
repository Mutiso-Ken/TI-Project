//APPRAISAL SECTION B PAGES

page 20378 "Appraisal Section D Part 1"
{
    ApplicationArea = All;
    Caption = 'Commitment to the Job';
    PageType = ListPart;
    SourceTable = "Appraisal Lines Section D";
    SourceTableView = where(Part = const("Part 1"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Question Description"; Rec."Question")
                {
                    ApplicationArea = Basic;
                }
                field("Self-appraisal (Comments)"; Rec."Supervisor Rating")
                {
                    ApplicationArea = Basic;
                }
                field("Comments by the supervisor"; Rec."Supervisor Comment")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Part := Rec.Part::"Part 1";
    end;
}

page 20379 "Appraisal Section D Part 2"
{
    ApplicationArea = All;
    Caption = 'Integrity';
    PageType = ListPart;
    SourceTable = "Appraisal Lines Section D";
    SourceTableView = where(Part = const("Part 2"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Question Description"; Rec."Question")
                {
                    ApplicationArea = Basic;
                }
                field("Self-appraisal (Comments)"; Rec."Supervisor Rating")
                {
                    ApplicationArea = Basic;
                }
                field("Comments by the supervisor"; Rec."Supervisor Comment")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Part := Rec.Part::"Part 2";
    end;
}

page 20380 "Appraisal Section D Part 3"
{
    ApplicationArea = All;
    Caption = 'Resource Management';
    PageType = ListPart;
    SourceTable = "Appraisal Lines Section D";
    SourceTableView = where(Part = const("Part 3"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Question Description"; Rec."Question")
                {
                    ApplicationArea = Basic;
                }
                field("Self-appraisal (Comments)"; Rec."Supervisor Rating")
                {
                    ApplicationArea = Basic;
                }
                field("Comments by the supervisor"; Rec."Supervisor Comment")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Part := Rec.Part::"Part 3";
    end;
}

page 20381 "Appraisal Section D Part 4"
{
    ApplicationArea = All;
    Caption = 'Punctuality';
    PageType = ListPart;
    SourceTable = "Appraisal Lines Section D";
    SourceTableView = where(Part = const("Part 4"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Question Description"; Rec."Question")
                {
                    ApplicationArea = Basic;
                }
                field("Self-appraisal (Comments)"; Rec."Supervisor Rating")
                {
                    ApplicationArea = Basic;
                }
                field("Comments by the supervisor"; Rec."Supervisor Comment")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Part := Rec.Part::"Part 4";
    end;
}

page 20382 "Appraisal Section D Part 5"
{
    ApplicationArea = All;
    Caption = 'Team Work';
    PageType = ListPart;
    SourceTable = "Appraisal Lines Section D";
    SourceTableView = where(Part = const("Part 5"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Question Description"; Rec."Question")
                {
                    ApplicationArea = Basic;
                }
                field("Self-appraisal (Comments)"; Rec."Supervisor Rating")
                {
                    ApplicationArea = Basic;
                }
                field("Comments by the supervisor"; Rec."Supervisor Comment")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Part := Rec.Part::"Part 5";
    end;
}

