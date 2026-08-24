report 50296 "Detailed Grant Expenditure"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Detailed Grant Expenditure.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = WHERE(Reversed = filter(false),
                                      "Account Category" = FILTER("Cost of Goods Sold" | Expense),
                                      "Grant Code" = FILTER(<> ''));
            RequestFilterFields = "Grant Code", "Posting Date";
            column(GrantCode_GLEntry; "G/L Entry"."Grant Code")
            {
            }
            column(GLAccountNo_GLEntry; "G/L Entry"."G/L Account No.")
            {
            }
            column(PostingDate_GLEntry; "G/L Entry"."Posting Date")
            {
            }
            column(Description_GLEntry; "G/L Entry".Description)
            {
            }
            column(Amount_GLEntry; "G/L Entry".Amount)
            {
            }
            column(ActivityCode_GLEntry; "G/L Entry"."Activity Code")
            {
            }
            column(PartnerCode_GLEntry; "G/L Entry"."Partner Code")
            {
            }
            column(GLAccountName; GLAccountName)
            {
            }
            column(Title; Title)
            {
            }
            column(ActivityDescription; ActivityDescription)
            {
            }

            trigger OnAfterGetRecord();
            begin
                IF GLAccount.GET("G/L Entry"."G/L Account No.") THEN BEGIN
                    GLAccountName := GLAccount.Name;
                END;
                IF GrantHeader.GET("G/L Entry"."Grant Code") THEN BEGIN
                    Title := GrantHeader.Title;
                END;
                ActivityDescription := '';
                GrantLines.RESET;
                GrantLines.SETRANGE("Grant No", "G/L Entry"."Grant Code");
                GrantLines.SETRANGE(Code, "G/L Entry"."Activity Code");
                IF GrantLines.FINDFIRST THEN BEGIN
                    ActivityDescription := GrantLines.Description;
                END;

                IF ActivityDescription = '' THEN BEGIN
                    ActivityDescription := "G/L Entry".Description;
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
        GLAccountName: Text;
        GLAccount: Record "G/L Account";
        Title: Text;
        GrantHeader: Record "Grant Header";
        ActivityDescription: Text;
        GrantLines: Record "Grant Lines";
}
