

page 20367 "Appraisal Section A Part 1"
{
    ApplicationArea = All;
    Caption = 'PART 1';
    PageType = ListPart;
    SourceTable = "Appraisal Lines Section A";
    SourceTableView = where(Section = const("Part A"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("What have you done"; Rec."What have you done")
                {
                    ApplicationArea = Basic;
                }
                field("When?"; Rec."When?")
                {
                    ApplicationArea = Basic;
                }
                field("Expected Results"; Rec."Expected Results")
                {
                    ApplicationArea = Basic;
                }
                field("What was Achieved?"; Rec."What was Achieved?")
                {
                    ApplicationArea = Basic;
                }
                field("Supervisor Rating"; Rec."Supervisor Rating")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
}
