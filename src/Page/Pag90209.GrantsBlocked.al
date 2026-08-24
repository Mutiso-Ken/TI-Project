page 90209 "Grants - Blocked"
{
    Caption = 'Grants - Blocked';
    CardPageID = "Grant Card";
    PageType = List;
    SourceTable = "Grant Header";
    SourceTableView = WHERE(Blocked = filter(true));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Created By"; Rec."Created By")
                {
                }
                field("Created Date"; Rec."Created Date")
                {
                }
                field(Title; Rec.Title)
                {
                }
                field(Narration; Rec.Narration)
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("No. Series"; Rec."No. Series")
                {
                }
                field("Donor No."; Rec."Donor No.")
                {
                }
                field("Donor Name"; Rec."Donor Name")
                {
                }
                field(Goal; Rec.Goal)
                {
                }
                field("Grant Created"; Rec."Grant Created")
                {
                }
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("Ending Date"; Rec."Ending Date")
                {
                }
                field("Project Manager"; Rec."Project Manager")
                {
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                }
                field("Income Accounts"; Rec."Income Accounts")
                {
                }
                field("Expense Accounts"; Rec."Expense Accounts")
                {
                }
                field("Grant Incomes"; Rec."Grant Incomes")
                {
                }
                field("Grant Expenditure"; Rec."Grant Expenditure")
                {
                }
                field("Grant Balance"; Rec."Grant Incomes" - Rec."Grant Expenditure")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Grant Budget"; Rec."Grant Budget")
                {
                }
                field("Expenditure Variance"; Rec."Grant Budget" - Rec."Grant Expenditure")
                {
                    Style = Attention;
                    StyleExpr = isOverExpensed;
                }
                field("Burn Rate"; BRate)
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
        BRate := 0;
        Rec.CALCFIELDS("Grant Budget", "Grant Expenditure");
        IF Rec."Grant Budget" <> 0 THEN
            BRate := (Rec."Grant Expenditure" / Rec."Grant Budget") * 100;

        IF (Rec."Grant Budget" - Rec."Grant Expenditure") < 0 THEN
            isOverExpensed := TRUE
        ELSE
            isOverExpensed := FALSE;
    end;

    var
        BRate: Decimal;
        isOverExpensed: Boolean;
}
