

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
                    Caption = 'What have you done to contribute to the department`s / programme`s objectives? What are the other performance objectives?';
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
                field("Capacity Needed"; Rec."Capacity Needed")
                {
                    ApplicationArea = Basic;
                }
                field("Comments by the supervisor"; Rec."Comments by the supervisor")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
}
