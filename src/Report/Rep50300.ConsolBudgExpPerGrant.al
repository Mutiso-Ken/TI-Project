report 50300 "Consol. Budg.-Exp. Per Grant"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Consol. Budg.-Exp. Per Grant.rdlc';
    Caption = 'Consolidated Budget/Expenditure Report Per Grant';
    ApplicationArea = All;

    dataset
    {
        dataitem("Grant Header"; "Grant Header")
        {
            column(No_GrantHeader; "Grant Header"."No.")
            {
            }
            column(Title_GrantHeader; "Grant Header".Title)
            {
            }
            dataitem("G/L Account"; "G/L Account")
            {
                DataItemTableView = WHERE("Account Category" = FILTER("Cost of Goods Sold" | Expense));
                column(No_GLAccount; "G/L Account"."No.")
                {
                }
                column(Name_GLAccount; "G/L Account".Name)
                {
                }
                column(ExpenditureAmount; ExpenditureAmount)
                {
                }
                column(BudgetAmount; BudgetAmount)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    ExpenditureAmount := 0;
                    BudgetAmount := 0;

                    GLEntry.RESET;
                    GLEntry.SETRANGE("Grant Code", "Grant Header"."No.");
                    GLEntry.SETRANGE("G/L Account No.", "G/L Account"."No.");
                    IF GLEntry.FINDSET THEN BEGIN
                        GLEntry.CALCSUMS(Amount);
                        ExpenditureAmount := GLEntry.Amount;
                    END;
                    GrantDetailLinesRec.RESET;
                    GrantDetailLinesRec.SETRANGE("Grant Code", "Grant Header"."No.");
                    GrantDetailLinesRec.SETRANGE("G/L Account No", "G/L Account"."No.");
                    IF GrantDetailLinesRec.FINDSET THEN BEGIN
                        GrantDetailLinesRec.CALCSUMS("Total Cost");
                        BudgetAmount := GrantDetailLinesRec."Total Cost";
                    END;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        GLAccountVar: Record "G/L Account";
        GLAccountName: Text;
        GLEntry: Record "G/L Entry";
        ExpenditureAmount: Decimal;
        GrantDetailLinesRec: Record "Grant Detail Lines";
        Ok: Boolean;
        BudgetAmount: Decimal;
}
