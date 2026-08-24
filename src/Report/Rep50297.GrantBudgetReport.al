report 50297 "Grant Budget Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Grant Budget Report.rdlc';
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
                column(UnitCost; UnitCost)
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(Frequency; Frequency)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    IF GLAccount.GET("Grant Detail Lines"."G/L Account No") THEN BEGIN
                        GLAccountName := GLAccount.Name;
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
                        GrantDetailLineVar.CALCSUMS("Total Cost", "Unit Cost", Quantity, Frequency);
                        BudgetAmount := GrantDetailLineVar."Total Cost";
                        UnitCost := GrantDetailLineVar."Unit Cost";
                        Quantity := GrantDetailLineVar.Quantity;
                        Frequency := GrantDetailLineVar.Frequency;
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
        GrantLines: Record "Grant Lines";
        Type: Option Objective,Outcome,Output,Activity;
        ActivityDescription: Text;
        GrantDetailLineVar: Record "Grant Detail Lines";
        BudgetAmount: Decimal;
        UnitCost: Decimal;
        Quantity: Decimal;
        Frequency: Decimal;
        GrantDetailLineVarI: Record "Grant Detail Lines";
        BudgetAmountPerGL: Decimal;
        GrantDetailLineVarII: Record "Grant Detail Lines";
        BudgetAmountPerGrant: Decimal;
}
