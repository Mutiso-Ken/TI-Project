page 90203 "Grant Detail Lines"
{
    PageType = List;
    SourceTable = "Grant Detail Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line Type"; Rec."Line Type")
                {
                }
                field("G/L Account No"; Rec."G/L Account No")
                {
                    Style = Subordinate;
                    StyleExpr = Rec.IsTransferred;
                }
                field(Code; Rec.Code)
                {
                }
                field("Partner Code"; Rec."Partner Code")
                {

                }
                field("Activity Description"; Rec."Activity Description")
                {
                }
                field("Proposed Start Date"; Rec."Proposed Start Date")
                {
                    Style = Subordinate;
                    StyleExpr = Rec.IsTransferred;
                }
                field("Proposed End Date"; Rec."Proposed End Date")
                {
                    Style = Subordinate;
                    StyleExpr = Rec.IsTransferred;
                }
                field("External Partner Code"; Rec."External Partner Code")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                    Style = Subordinate;
                    StyleExpr = Rec.IsTransferred;
                }
                field(Frequency; Rec.Frequency)
                {
                    Style = Subordinate;
                    StyleExpr = Rec.IsTransferred;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    Style = Subordinate;
                    StyleExpr = Rec.IsTransferred;
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    Style = Subordinate;
                    StyleExpr = Rec.IsTransferred;
                }
                field(Expenditure; Rec.Expenditure)
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("G/L Account Name"; Rec."G/L Account Name")
                {
                    Style = Subordinate;
                    StyleExpr = Rec.IsTransferred;
                }
                field("Transfered To Budget"; Rec."Transfered To Budget")
                {
                }
                field("Amount Transfered"; Rec."Amount Transfered")
                {
                    Style = Strong;
                    StyleExpr = Rec.IsTransferred;
                }
                field("Grant Code"; Rec."Grant Code")
                {
                }

            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        Rec.IsTransferred := FALSE;
        IF Rec."Transfered To Budget" THEN
            Rec.IsTransferred := TRUE;
    end;

    var
        IsTransferred: Boolean;
}
