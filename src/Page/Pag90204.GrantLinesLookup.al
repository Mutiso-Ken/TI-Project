page 90204 "Grant Lines Lookup"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Grant Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                IndentationColumn = LineIndent;
                IndentationControls = "Code", "External Partner Code", Description;
                field("Line Type"; Rec."Line Type")
                {
                    Style = Strong;
                    StyleExpr = isHeading;
                }
                field(Code; Rec.Code)
                {
                    Style = Strong;
                    StyleExpr = isHeading;
                }
                field("External Partner Code"; Rec."External Partner Code")
                {
                    Style = Strong;
                    StyleExpr = isHeading;
                }
                field(Description; Rec.Description)
                {
                    Style = Strong;
                    StyleExpr = isHeading;
                }
                field(Budgeted; Rec.Budgeted)
                {
                    Style = Unfavorable;
                    StyleExpr = IsNotBudgeted;
                }
                field("Proposed Start Date"; Rec."Proposed Start Date")
                {
                }
                field("Proposed End Date"; Rec."Proposed End Date")
                {
                }
                field("Total Budget"; Rec."Total Budget")
                {
                }
                field(Totaling; Rec.Totaling)
                {
                }
                field("Grant No"; Rec."Grant No")
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
        LineIndent := Rec."Line Type";
        isHeading := (Rec."Line Type" <> Rec."Line Type"::Activity);
        Rec.CALCFIELDS(Budgeted);
        IF NOT isHeading THEN
            IsNotBudgeted := NOT Rec.Budgeted
        ELSE
            IsNotBudgeted := FALSE;
    end;

    var
        LineIndent: Integer;
        isHeading: Boolean;
        IsNotBudgeted: Boolean;
}
