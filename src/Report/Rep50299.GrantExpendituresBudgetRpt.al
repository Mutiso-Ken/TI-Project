report 50299 "Grant Expenditures-Budget Rpt"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Grant Expenditures-Budget Rpt.rdlc';
    PreviewMode = PrintLayout;
    ApplicationArea = All;

    dataset
    {
        dataitem("Grant Header"; "Grant Header")
        {
            RequestFilterFields = "No.";
            column(No_GrantHeader; "Grant Header"."No.")
            {
            }
            column(CreatedBy_GrantHeader; "Grant Header"."Created By")
            {
            }
            column(CreatedDate_GrantHeader; "Grant Header"."Created Date")
            {
            }
            column(Title_GrantHeader; "Grant Header".Title)
            {
            }
            column(Narration_GrantHeader; "Grant Header".Narration)
            {
            }
            column(Status_GrantHeader; "Grant Header".Status)
            {
            }
            column(NoSeries_GrantHeader; "Grant Header"."No. Series")
            {
            }
            column(DonorNo_GrantHeader; "Grant Header"."Donor No.")
            {
            }
            column(DonorName_GrantHeader; "Grant Header"."Donor Name")
            {
            }
            column(Goal_GrantHeader; "Grant Header".Goal)
            {
            }
            column(GrantCreated_GrantHeader; "Grant Header"."Grant Created")
            {
            }
            column(StartingDate_GrantHeader; "Grant Header"."Starting Date")
            {
            }
            column(EndingDate_GrantHeader; "Grant Header"."Ending Date")
            {
            }
            column(ProjectManager_GrantHeader; "Grant Header"."Project Manager")
            {
            }
            column(GlobalDimension1Code_GrantHeader; "Grant Header"."Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code_GrantHeader; "Grant Header"."Global Dimension 2 Code")
            {
            }
            column(ConsolidationBudget_GrantHeader; "Grant Header"."Consolidation Budget")
            {
            }
            column(ApprovalStatus_GrantHeader; "Grant Header"."Approval Status")
            {
            }
            column(GrantIncomes_GrantHeader; "Grant Header"."Grant Incomes")
            {
            }
            column(IncomeAccounts_GrantHeader; "Grant Header"."Income Accounts")
            {
            }
            column(ExpenseAccounts_GrantHeader; "Grant Header"."Expense Accounts")
            {
            }
            column(GrantExpenditure_GrantHeader; "Grant Header"."Grant Expenditure")
            {
            }
            column(GrantBudget_GrantHeader; "Grant Header"."Grant Budget")
            {
            }
            column(Blocked_GrantHeader; "Grant Header".Blocked)
            {
            }
            dataitem(Expenditure; "G/L Entry")
            {
                DataItemLink = "Grant Code" = FIELD("No.");
                DataItemTableView = SORTING("G/L Account No.", "Posting Date")
                                    ORDER(Ascending)
                                    WHERE("Account Category" = FILTER("Cost of Goods Sold" | Expense));
                column(EntryNo_Expenditure; Expenditure."Entry No.")
                {
                }
                column(GLAccountNo_Expenditure; Expenditure."G/L Account No.")
                {
                }
                column(PostingDate_Expenditure; Expenditure."Posting Date")
                {
                }
                column(DocumentType_Expenditure; Expenditure."Document Type")
                {
                }
                column(DocumentNo_Expenditure; Expenditure."Document No.")
                {
                }
                column(Description_Expenditure; Expenditure.Description)
                {
                }
                column(BalAccountNo_Expenditure; Expenditure."Bal. Account No.")
                {
                }
                column(Amount_Expenditure; Expenditure.Amount)
                {
                }
                column(GlobalDimension1Code_Expenditure; Expenditure."Global Dimension 1 Code")
                {
                }
                column(GlobalDimension2Code_Expenditure; Expenditure."Global Dimension 2 Code")
                {
                }
                column(GrantCode_Expenditure; Expenditure."Grant Code")
                {
                }
                column(ObjectiveCode_Expenditure; Expenditure."Objective Code")
                {
                }
                column(OutcomeCode_Expenditure; Expenditure."Outcome Code")
                {
                }
                column(OutputCode_Expenditure; Expenditure."Output Code")
                {
                }
                column(ActivityCode_Expenditure; Expenditure."Activity Code")
                {
                }
                column(PartnerCode_Expenditure; Expenditure."Partner Code")
                {
                }
                column(ActivityDescription; ActivityDescription)
                {
                }
                column(BudgetAmount; BudgetAmount)
                {
                }
                column(BudgetAmountPerGL; BudgetAmountPerGL)
                {
                }
                column(BudgetAmountPerGrant; BudgetAmountPerGrant)
                {
                }
                column(GLAccountName_Expenditure; Expenditure."G/L Account Name")
                {
                }
                column(GLBudget; GLBudget)
                {
                }
                column(GLAccountName; GLAccountName)
                {
                }
                column(ExpenditureAmount; ExpenditureAmount)
                {
                }
                column(ExpenditureAmountPerGL; ExpenditureAmountPerGL)
                {
                }
                column(ExpenditureAmountPerGrant; ExpenditureAmountPerGrant)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    IF GLAccount.GET(Expenditure."G/L Account No.") THEN BEGIN
                        GLAccountName := GLAccount.Name;
                    END;
                    BudgetAmount := 0;
                    BudgetAmountPerGL := 0;
                    BudgetAmountPerGrant := 0;
                    ExpenditureAmount := 0;
                    ExpenditureAmountPerGL := 0;
                    ExpenditureAmountPerGrant := 0;
                    ActivityDescription := '';
                    GrantLines.RESET;
                    GrantLines.SETRANGE(Code, Expenditure."Activity Code");
                    IF GrantLines.FINDFIRST THEN BEGIN
                        ActivityDescription := GrantLines.Description;
                    END;

                    GLEntry.RESET;
                    GLEntry.SETRANGE("Grant Code", Expenditure."Grant Code");
                    GLEntry.SETRANGE("G/L Account No.", Expenditure."G/L Account No.");
                    GLEntry.SETRANGE("Activity Code", Expenditure."Activity Code");
                    GLEntry.SETRANGE("Partner Code", Expenditure."Partner Code");
                    IF GLEntry.FINDSET THEN BEGIN
                        GLEntry.CALCSUMS(Amount);
                        ExpenditureAmount := GLEntry.Amount;
                        GrantDetailLineVar.RESET;
                        GrantDetailLineVar.SETRANGE("Grant Code", GLEntry."Grant Code");
                        GrantDetailLineVar.SETRANGE("G/L Account No", GLEntry."G/L Account No.");
                        GrantDetailLineVar.SETRANGE(Code, GLEntry."Activity Code");
                        GrantDetailLineVar.SETRANGE("External Partner Code", GLEntry."Partner Code");
                        IF GrantDetailLineVar.FINDSET THEN BEGIN
                            GrantDetailLineVar.CALCSUMS("Total Cost");
                            BudgetAmount := GrantDetailLineVar."Total Cost";
                        END;
                    END;

                    GLEntryI.RESET;
                    GLEntryI.SETRANGE("Grant Code", Expenditure."Grant Code");
                    GLEntryI.SETRANGE("G/L Account No.", Expenditure."G/L Account No.");
                    IF GLEntryI.FINDSET THEN BEGIN
                        GLEntryI.CALCSUMS(Amount);
                        ExpenditureAmountPerGL := GLEntryI.Amount;
                        ExpenditureAmountPerGrant += ExpenditureAmountPerGL;
                        GrantDetailLineVarI.RESET;
                        GrantDetailLineVarI.SETRANGE("Grant Code", GLEntryI."Grant Code");
                        GrantDetailLineVarI.SETRANGE("G/L Account No", GLEntryI."G/L Account No.");
                        IF GrantDetailLineVarI.FINDSET THEN BEGIN
                            GrantDetailLineVarI.CALCSUMS("Total Cost");
                            BudgetAmountPerGL := GrantDetailLineVarI."Total Cost";
                        END;
                    END;

                    GrantDetailLines.RESET;
                    GrantDetailLines.SETRANGE("Grant Code", Expenditure."Grant Code");
                    IF GrantDetailLines.FINDSET THEN BEGIN
                        GrantDetailLines.CALCSUMS("Total Cost");
                        BudgetAmountPerGrant := GrantDetailLines."Total Cost";
                    END;
                end;

                trigger OnPreDataItem();
                begin
                    Expenditure.SETFILTER("G/L Account No.", "Grant Header"."Expense Accounts");
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
        Income: Option;
        Expenses: Integer;
        GrantDetailLines: Record "Grant Detail Lines";
        ActivityDescription: Text;
        GLBudget: Decimal;
        GLAccount: Record "G/L Account";
        GLAccountName: Text;
        GrantLines: Record "Grant Lines";
        GLEntry: Record "G/L Entry";
        ExpenditureAmount: Decimal;
        GLEntryI: Record "G/L Entry";
        ExpenditureAmountPerGL: Decimal;
        GLEntryII: Record "G/L Entry";
        ExpenditureAmountPerGrant: Decimal;
        GrantDetailLinesRec: Record "Grant Detail Lines";
        GrantDetailLineVar: Record "Grant Detail Lines";
        BudgetAmount: Decimal;
        GrantDetailLineVarI: Record "Grant Detail Lines";
        BudgetAmountPerGL: Decimal;
        GrantDetailLineVarII: Record "Grant Detail Lines";
        BudgetAmountPerGrant: Decimal;
}
