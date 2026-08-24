report 90200 "Grant Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Grant Details.rdlc';
    PreviewMode = PrintLayout;
    ApplicationArea = All;

    dataset
    {
        dataitem("Grant Header"; "Grant Header")
        {
            RequestFilterFields = "No.";
            column(Logo; CompanyInformation.Picture)
            {
            }
            column(PhoneNo; CompanyInformation."Phone No.")
            {
            }
            column(City; CompanyInformation.City)
            {
            }
            column(Address2; CompanyInformation."Address 2")
            {
            }
            column(Address; CompanyInformation.Address)
            {
            }
            column(Name; CompanyInformation.Name)
            {
            }
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
            column(GrantExpenditure_GrantHeader; "Grant Header"."Grant Expenditure")
            {
            }
            column(GrantBudget_GrantHeader; "Grant Header"."Grant Budget")
            {
            }
            dataitem("Grant Detail Lines"; "Grant Detail Lines")
            {
                DataItemLink = "Grant Code" = FIELD("No.");
                DataItemTableView = SORTING("Grant Code", "Line Type", Code, "Line No.", "Entry No.")
                                    ORDER(Ascending)
                                    WHERE("Line Type" = CONST(Activity));
                column(Objective; LineInformation[1])
                {
                }
                column(Outcome; LineInformation[2])
                {
                }
                column(Output; LineInformation[3])
                {
                }
                column(Activity; LineInformation[4])
                {
                }
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
                column(ObjectiveCode; LineType[1])
                {
                }
                column(OutcomeCode; LineType[2])
                {
                }
                column(OutputCode; LineType[3])
                {
                }
                column(ActivityCode; LineType[4])
                {
                }

                trigger OnAfterGetRecord();
                begin
                    CLEAR(LineInformation);
                    CLEAR(LineType);
                    Prefix := '';
                    Prefix := COPYSTR("Grant Detail Lines".Code, 1, 1);
                    LineType[1] := Prefix;
                    GrantLines1.RESET;
                    GrantLines1.SETRANGE("Grant No", "Grant Detail Lines"."Grant Code");
                    GrantLines1.SETRANGE("Line Type", GrantLines1."Line Type"::Objective);
                    GrantLines1.SETRANGE(Code, Prefix);
                    IF GrantLines1.FINDFIRST THEN
                        LineInformation[1] := '[' + GrantLines1.Code + '] ' + GrantLines1.Description
                    ELSE
                        LineInformation[1] := 'Undefined Objective';
                    Prefix := '';
                    Prefix := COPYSTR("Grant Detail Lines".Code, 1, 2);
                    LineType[2] := Prefix;
                    GrantLines1.RESET;
                    GrantLines1.SETRANGE("Grant No", "Grant Detail Lines"."Grant Code");
                    GrantLines1.SETRANGE("Line Type", GrantLines1."Line Type"::Outcome);
                    GrantLines1.SETRANGE(Code, Prefix);
                    IF GrantLines1.FINDFIRST THEN
                        LineInformation[2] := '[' + GrantLines1.Code + '] ' + GrantLines1.Description
                    ELSE
                        LineInformation[2] := 'Undefined Outcome';
                    Prefix := '';
                    Prefix := COPYSTR("Grant Detail Lines".Code, 1, 3);
                    LineType[3] := Prefix;
                    GrantLines1.RESET;
                    GrantLines1.SETRANGE("Grant No", "Grant Detail Lines"."Grant Code");
                    GrantLines1.SETRANGE("Line Type", GrantLines1."Line Type"::Output);
                    GrantLines1.SETRANGE(Code, Prefix);
                    IF GrantLines1.FINDFIRST THEN
                        LineInformation[3] := '[' + GrantLines1.Code + '] ' + GrantLines1.Description
                    ELSE
                        LineInformation[3] := 'Undefined Output';
                    Prefix := '';
                    Prefix := "Grant Detail Lines".Code;
                    LineType[4] := Prefix;
                    GrantLines1.RESET;
                    GrantLines1.SETRANGE("Grant No", "Grant Detail Lines"."Grant Code");
                    GrantLines1.SETRANGE("Line Type", GrantLines1."Line Type"::Activity);
                    GrantLines1.SETRANGE(Code, Prefix);
                    IF GrantLines1.FINDFIRST THEN
                        LineInformation[4] := '[' + GrantLines1.Code + '] ' + GrantLines1.Description
                    ELSE
                        LineInformation[4] := 'Undefined Activity';

                    GrantLinesII.RESET;
                    GrantLinesII.SETRANGE("Grant No", "Grant Detail Lines"."Grant Code");
                    GrantLinesII.SETRANGE(Code, "Grant Detail Lines".Code);
                    IF GrantLinesII.FINDSET THEN BEGIN
                        RatioX := CalculateAvailabilityRatios(GrantLinesII);
                    END;
                end;
            }

            trigger OnPreDataItem();
            begin
                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(Picture);
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
        LineInformation: array[10] of Text;
        Prefix: Code[10];
        GrantLines1: Record "Grant Lines";
        LineType: array[10] of Code[20];
        ObjectiveCode: Code[1];
        CompanyInformation: Record "Company Information";
        Ratio: Decimal;
        AvailableBalance: Decimal;
        IsActivity: Boolean;
        GrantLinesII: Record "Grant Lines";
        RatioX: Decimal;

    local procedure CalculateAvailabilityRatios(var GrantLines: Record "Grant Lines"): Decimal;
    var
        BGT: Decimal;
    begin
        AvailableBalance := 0;
        IsActivity := FALSE;
        Ratio := 0;
        GrantLines.CALCFIELDS("Total Budget", "Activity Total", "Objective Total", "Outcome Total", "Output Total");
        BGT := GrantLines."Total Budget";
        IF BGT = 0 THEN
            BGT := 1;
        CASE GrantLines."Line Type" OF
            GrantLines."Line Type"::Objective:
                BEGIN
                    AvailableBalance := GrantLines."Total Budget" - GrantLines."Objective Total";
                    Ratio := GrantLines."Objective Total" / BGT;
                END;
            GrantLines."Line Type"::Outcome:
                BEGIN
                    AvailableBalance := GrantLines."Total Budget" - GrantLines."Outcome Total";
                    Ratio := GrantLines."Outcome Total" / BGT;
                END;
            GrantLines."Line Type"::Output:
                BEGIN
                    AvailableBalance := GrantLines."Total Budget" - GrantLines."Output Total";
                    Ratio := GrantLines."Output Total" / BGT;
                END;
            GrantLines."Line Type"::Activity:
                BEGIN
                    AvailableBalance := GrantLines."Total Budget" - GrantLines."Activity Total";
                    Ratio := GrantLines."Activity Total" / BGT;
                    IsActivity := TRUE;
                END;
        END;
        Ratio *= 100;
        EXIT(Ratio);
    end;
}
