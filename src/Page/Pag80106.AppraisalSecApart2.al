namespace TISolution.TISolution;

page 80106 AppraisalSecApart2
{
    ApplicationArea = All;
    Caption = 'SECTION A - Part 2';

    PageType = ListPart;
    SourceTable = "Appraisal Sec A(Second Part 2)";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("What capacity need? "; Rec."What capacity need? ")
                {
                    ToolTip = 'Specifies the value of the What capacity needs do you need to support your current objectives and growth? field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Why prioritized this year?"; Rec."Why prioritized this year?")
                {
                    ToolTip = 'Specifies the value of the Why should they be prioritized this year? field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Comments by the supervisor"; Rec."Comments by the supervisor")
                {
                    ToolTip = 'Specifies the value of the Comments by the supervisor field.', Comment = '%';
                    ApplicationArea = all;
                }
            }
        }
    }
}
