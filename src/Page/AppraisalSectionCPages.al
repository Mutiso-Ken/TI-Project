//APPRAISAL SECTION B PAGES

page 20373 "Appraisal Section C Part 1"
{
    ApplicationArea = All;
    Caption = 'Technical Skills';
    PageType = ListPart;
    SourceTable = "Appraisal Lines Section C";
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
                field("Employee Answer"; Rec."Self Rating")
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
page 20374 "Appraisal Section C Part 2"
{
    ApplicationArea = All;
    Caption = 'General Organisation Skills';
    PageType = ListPart;
    SourceTable = "Appraisal Lines Section C";
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
                field("Employee Answer"; Rec."Self Rating")
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
page 20375 "Appraisal Section C Part 3"
{
    ApplicationArea = All;
    Caption = 'Self Management & Flexibility';
    PageType = ListPart;
    SourceTable = "Appraisal Lines Section C";
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
                field("Employee Answer"; Rec."Self Rating")
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
page 20376 "Appraisal Section C Part 4"
{
    ApplicationArea = All;
    Caption = 'Communication';
    PageType = ListPart;
    SourceTable = "Appraisal Lines Section C";
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
                field("Employee Answer"; Rec."Self Rating")
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
page 20377 "Appraisal Section C Part 5"
{
    ApplicationArea = All;
    Caption = 'Leadership';
    PageType = ListPart;
    SourceTable = "Appraisal Lines Section C";
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
                field("Employee Answer"; Rec."Self Rating")
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
