report 50298 "Grant Budget-Expenditure Rpt"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Grant Budget-Expenditure Rpt.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Grant Header"; "Grant Header")
        {
            RequestFilterFields = "No.";
            column(No_GrantHeader; "Grant Header"."No.")
            {
            }
            column(Title_GrantHeader; "Grant Header".Title)
            {
            }
            dataitem("Grant Detail Lines"; "Grant Detail Lines")
            {
                DataItemLink = "Grant Code" = FIELD("No.");
                column(GrantCode_GrantDetailLines; "Grant Detail Lines"."Grant Code")
                {
                }
                column(Code_GrantDetailLines; "Grant Detail Lines".Code)
                {
                }
                column(EntryType_GrantDetailLines; "Grant Detail Lines"."Entry Type")
                {
                }
                column(EntryNo_GrantDetailLines; "Grant Detail Lines"."Entry No.")
                {
                }
                column(ActivityDescription_GrantDetailLines; "Grant Detail Lines"."Activity Description")
                {
                }
                column(ProposedStartDate_GrantDetailLines; "Grant Detail Lines"."Proposed Start Date")
                {
                }
                column(ProposedEndDate_GrantDetailLines; "Grant Detail Lines"."Proposed End Date")
                {
                }
                column(Quantity_GrantDetailLines; "Grant Detail Lines".Quantity)
                {
                }
                column(UnitCost_GrantDetailLines; "Grant Detail Lines"."Unit Cost")
                {
                }
                column(TotalCost_GrantDetailLines; "Grant Detail Lines"."Total Cost")
                {
                }
                column(Frequency_GrantDetailLines; "Grant Detail Lines".Frequency)
                {
                }
                column(LineNo_GrantDetailLines; "Grant Detail Lines"."Line No.")
                {
                }
                column(TargetDescription_GrantDetailLines; "Grant Detail Lines"."Target Description")
                {
                }
                column(TargetIndicator_GrantDetailLines; "Grant Detail Lines"."Target Indicator")
                {
                }
                column(AchievedTargetDescription_GrantDetailLines; "Grant Detail Lines"."Achieved Target Description")
                {
                }
                column(AchievedTargetNumber_GrantDetailLines; "Grant Detail Lines"."Achieved Target Number")
                {
                }
                column(Output_GrantDetailLines; "Grant Detail Lines".Output)
                {
                }
                column(LineType_GrantDetailLines; "Grant Detail Lines"."Line Type")
                {
                }
                column(GLAccountNo_GrantDetailLines; "Grant Detail Lines"."G/L Account No")
                {
                }
                column(GLAccountName_GrantDetailLines; "Grant Detail Lines"."G/L Account Name")
                {
                }
                column(TransferedToBudget_GrantDetailLines; "Grant Detail Lines"."Transfered To Budget")
                {
                }
                column(AmountTransfered_GrantDetailLines; "Grant Detail Lines"."Amount Transfered")
                {
                }
                column(ShortcutDimension1Code_GrantDetailLines; "Grant Detail Lines"."Shortcut Dimension 1 Code")
                {
                }
                column(ShortcutDimension2Code_GrantDetailLines; "Grant Detail Lines"."Shortcut Dimension 2 Code")
                {
                }
                column(DimensionSetID_GrantDetailLines; "Grant Detail Lines"."Dimension Set ID")
                {
                }
                column(ExternalPartnerCode_GrantDetailLines; "Grant Detail Lines"."External Partner Code")
                {
                }
                column(Expenditure_GrantDetailLines; "Grant Detail Lines".Expenditure)
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

                trigger OnAfterGetRecord();
                begin
                    ExpenditureAmount := 0;
                    IF GLAccount.GET("Grant Detail Lines"."G/L Account No") THEN BEGIN
                        GLAccountName := GLAccount.Name;
                    END;

                    GLEntry.RESET;
                    GLEntry.CALCFIELDS("Account Category");
                    GLEntry.SETRANGE("Grant Code", "Grant Detail Lines"."Grant Code");
                    GLEntry.SETRANGE("G/L Account No.", "Grant Detail Lines"."G/L Account No");
                    GLEntry.SETRANGE("Activity Code", "Grant Detail Lines".Code);
                    GLEntry.SETRANGE("Partner Code", "Grant Detail Lines"."External Partner Code");
                    GLEntry.SETFILTER("Account Category", '%1|%2', GLEntry."Account Category"::"Cost of Goods Sold", GLEntry."Account Category"::Expense);
                    IF GLEntry.FINDSET THEN BEGIN
                        GLEntry.CALCSUMS(Amount);
                        ExpenditureAmount := GLEntry.Amount;
                    END;

                    GLEntryI.RESET;
                    GLEntryI.CALCFIELDS("Account Category");
                    GLEntryI.SETRANGE("Grant Code", "Grant Detail Lines"."Grant Code");
                    GLEntryI.SETRANGE("G/L Account No.", "Grant Detail Lines"."G/L Account No");
                    GLEntryI.SETFILTER("Account Category", '%1|%2', GLEntryI."Account Category"::"Cost of Goods Sold", GLEntryI."Account Category"::Expense);
                    IF GLEntryI.FINDSET THEN BEGIN
                        GLEntryI.CALCSUMS(Amount);
                        ExpenditureAmountPerGL := GLEntryI.Amount;
                    END;

                    GLEntryII.RESET;
                    GLEntryII.CALCFIELDS("Account Category");
                    GLEntryII.SETRANGE("Grant Code", "Grant Detail Lines"."Grant Code");
                    GLEntryII.SETFILTER("Account Category", '%1|%2', GLEntryII."Account Category"::"Cost of Goods Sold", GLEntryII."Account Category"::Expense);
                    IF GLEntryII.FINDSET THEN BEGIN
                        GLEntryII.CALCSUMS(Amount);
                        ExpenditureAmountPerGrant := GLEntryII.Amount;
                    END;

                    GrantLines.RESET;
                    GrantLines.SETRANGE("Grant No", "Grant Detail Lines"."Grant Code");
                    GrantLines.SETRANGE(Code, "Grant Detail Lines".Code);
                    IF GrantLines.FINDFIRST THEN BEGIN
                        ActivityDescription := GrantLines.Description;
                    END;

                    GrantDetailLineVar.RESET;
                    GrantDetailLineVar.SETRANGE("Grant Code", "Grant Detail Lines"."Grant Code");
                    GrantDetailLineVar.SETRANGE("G/L Account No", "Grant Detail Lines"."G/L Account No");
                    GrantDetailLineVar.SETRANGE(Code, "Grant Detail Lines".Code);
                    GrantDetailLineVar.SETRANGE("External Partner Code", "Grant Detail Lines"."External Partner Code");
                    IF GrantDetailLineVar.FINDSET THEN BEGIN
                        GrantDetailLineVar.CALCSUMS("Total Cost");
                        BudgetAmount := GrantDetailLineVar."Total Cost";
                    END;

                    GrantDetailLineVarI.RESET;
                    GrantDetailLineVarI.SETRANGE("Grant Code", "Grant Detail Lines"."Grant Code");
                    GrantDetailLineVarI.SETRANGE("G/L Account No", "Grant Detail Lines"."G/L Account No");
                    IF GrantDetailLineVarI.FINDSET THEN BEGIN
                        GrantDetailLineVarI.CALCSUMS("Total Cost");
                        BudgetAmountPerGL := GrantDetailLineVarI."Total Cost";
                    END;

                    GrantDetailLineVarII.RESET;
                    GrantDetailLineVarII.SETRANGE("Grant Code", "Grant Detail Lines"."Grant Code");
                    IF GrantDetailLineVarII.FINDSET THEN BEGIN
                        GrantDetailLineVarII.CALCSUMS("Total Cost");
                        BudgetAmountPerGrant := GrantDetailLineVarII."Total Cost";
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
        GLAccount: Record "G/L Account";
        GLAccountName: Text;
        GLEntry: Record "G/L Entry";
        ExpenditureAmount: Decimal;
        GLEntryI: Record "G/L Entry";
        ExpenditureAmountPerGL: Decimal;
        GLEntryII: Record "G/L Entry";
        ExpenditureAmountPerGrant: Decimal;
        GrantDetailLinesRec: Record "Grant Detail Lines";
        Ok: Boolean;
        GrantLines: Record "Grant Lines";
        ActivityDescription: Text;
        GrantDetailLineVar: Record "Grant Detail Lines";
        BudgetAmount: Decimal;
        GrantDetailLineVarI: Record "Grant Detail Lines";
        BudgetAmountPerGL: Decimal;
        GrantDetailLineVarII: Record "Grant Detail Lines";
        BudgetAmountPerGrant: Decimal;
}
