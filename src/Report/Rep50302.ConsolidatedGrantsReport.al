report 50302 "Consolidated Grants Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Consolidated Grants Report.rdlc';
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
            column(Narration_GrantHeader; "Grant Header".Narration)
            {
            }
            column(Expenditure; Expenditure)
            {
            }
            column(Budget; Budget)
            {
            }
            column(Income; Income)
            {
            }

            trigger OnAfterGetRecord();
            begin
                Expenditure := 0;
                Income := 0;
                Budget := 0;
                GLEntry.RESET;
                GLEntry.CALCFIELDS("Account Category");
                GLEntry.SETRANGE("Grant Code", "Grant Header"."No.");
                GLEntry.SETFILTER("Account Category", '%1|%2', GLEntry."Account Category"::"Cost of Goods Sold", GLEntry."Account Category"::Expense);
                IF GLEntry.FINDSET THEN BEGIN
                    GLEntry.CALCSUMS(Amount);
                    Expenditure := GLEntry.Amount;
                END;

                GLEntryII.RESET;
                GLEntryII.CALCFIELDS("Account Category");
                GLEntryII.SETRANGE("Grant Code", "Grant Header"."No.");
                GLEntryII.SETFILTER("Account Category", '%1', GLEntryII."Account Category"::Income);
                IF GLEntryII.FINDSET THEN BEGIN
                    GLEntryII.CALCSUMS(Amount);
                    Income := ABS(GLEntryII.Amount);
                END;

                GrantDetailLines.RESET;
                GrantDetailLines.SETRANGE("Grant Code", "Grant Header"."No.");
                IF GrantDetailLines.FINDSET THEN BEGIN
                    GrantDetailLines.CALCSUMS("Total Cost");
                    Budget := GrantDetailLines."Total Cost";
                END;
            end;
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
        GLEntry: Record "G/L Entry";
        Expenditure: Decimal;
        GrantDetailLines: Record "Grant Detail Lines";
        Budget: Decimal;
        GLAccount: Record "G/L Account";
        GLEntryII: Record "G/L Entry";
        Income: Decimal;
}
