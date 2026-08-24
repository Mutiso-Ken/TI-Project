page 90201 "Grant Card"
{
    PageType = Card;
    SourceTable = "Grant Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                }
                field(Title; Rec.Title)
                {
                }
                field(Narration; Rec.Narration)
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
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("Ending Date"; Rec."Ending Date")
                {
                }
                field("Project Manager"; Rec."Project Manager")
                {
                }
                field(Blocked; Rec.Blocked)
                {
                }
            }
            group("Grant Performance")
            {
                field("Grant Budgets"; Rec."Grant Budget")
                {
                }
                field("Income Accounts"; Rec."Income Accounts")
                {

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        GLaccList.LOOKUPMODE(TRUE);
                        IF NOT (GLaccList.RUNMODAL = ACTION::LookupOK) THEN
                            EXIT(FALSE);

                        Text := GLaccList.GetSelectionFilter;
                        EXIT(TRUE);
                    end;
                }
                field("Expense Accounts"; Rec."Expense Accounts")
                {

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        GLaccList.LOOKUPMODE(TRUE);
                        IF NOT (GLaccList.RUNMODAL = ACTION::LookupOK) THEN
                            EXIT(FALSE);

                        Text := GLaccList.GetSelectionFilter;
                        EXIT(TRUE);
                    end;
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
            }
            part("Grant Lines"; "Grant Lines")
            {
                SubPageLink = "Grant No" = FIELD("No.");
            }
            group("Audit Trail")
            {
                field("Created By"; Rec."Created By")
                {
                }
                field("Created Date"; Rec."Created Date")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Transfer to Budget")
            {
                Image = StepInto;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                RunObject = Page 90206;
                RunPageLink = "No." = FIELD("No.");

                trigger OnAction();
                begin
                    UserSetup.GET(USERID);
                    UserSetup.TESTFIELD("Grant Admin", TRUE);
                end;
            }
            action("Transfer Activities")
            {
                Image = MoveToNextPeriod;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    GrantLines.Reset();
                    GrantLines.SetRange(GrantLines."Grant No", Rec."No.");
                    GrantLines.SetRange("Line Type", GrantLines."Line Type"::Activity);
                    if GrantLines.FindSet() then begin
                        repeat
                            DimensionValue.Init();
                            DimensionValue."Dimension Code" := 'ACTIVITY';
                            DimensionValue.Code := GrantLines."Grant No" + '.' + GrantLines.Code;
                            DimensionValue.Name := CopyStr(GrantLines.Description, 1, MaxStrLen(DimensionValue.Name));
                            DimensionValue."Sub Office" := GrantLines."Shortcut Dimension 1 Code";
                            DimensionValue.Grant := rec."No.";
                            DimensionValue.Pillar := GrantLines."Shortcut Dimension 2 Code";
                            DimensionValue."Unique Activity" := GrantLines.Code;
                            DimensionValue."Global Dimension No." := 4;
                            DimensionValue.Insert();
                            GrantLines."Shortcut Dimension 4 Code" := GrantLines."Grant No" + '.' + GrantLines.Code;
                            GrantLines.Transfered := true;
                            GrantLines.Modify(true);
                        until GrantLines.Next() = 0;
                        Message('Activities transfered successfully!');
                    end else
                        Message('No activities to transfer');
                end;
            }
            action("Transfer Partner code")
            {
                Image = MoveToNextPeriod;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    GrantDetailLines.Reset();
                    GrantDetailLines.SetRange("Grant Code", Rec."No.");
                    GrantDetailLines.SetRange(IsTransferred, false);
                    if GrantDetailLines.FindSet() then begin
                        repeat
                            IF GrantDetailLines."External Partner Code" <> '' THEN begin
                                DimensionValue.Init();
                                DimensionValue."Dimension Code" := 'PARTNER';
                                DimensionValue.Code := GrantDetailLines."Grant Code" + '.' + GrantDetailLines."External Partner Code";
                                DimensionValue.Name := CopyStr(GrantDetailLines."Activity Description", 1, MaxStrLen(DimensionValue.Name));
                                DimensionValue.Description := GrantDetailLines."Activity Description";
                                DimensionValue.Grant := GrantDetailLines."Grant Code";
                                DimensionValue."Unique Partner" := GrantDetailLines."External Partner Code";
                                DimensionValue."Global Dimension No." := 5;
                                DimensionValue.Activity := GrantDetailLines."Grant Code" + '.' + GrantDetailLines.Code;
                                DimensionValue.Insert();
                                GrantDetailLines.IsTransferred := true;
                                GrantDetailLines."Partner Code" := GrantDetailLines."Grant Code" + '.' + GrantDetailLines."External Partner Code";
                                GrantDetailLines.Modify(true);
                            END;
                        until GrantDetailLines.Next() = 0;
                        Message('Partner code transfered successfully!');
                    end else
                        Message('No Partner code to transfer');

                end;
            }
            action("Copy Grant")
            {
                Image = CopyBOM;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    UserSetup.GET(USERID);
                    UserSetup.TESTFIELD("Grant Admin", TRUE);
                    IF CONFIRM('Do you want to copy grant lines?') THEN BEGIN
                        CLEAR(GrantLookup);
                        GrantHeader.RESET;
                        GrantHeader.SETFILTER("No.", '<>%1', Rec."No.");
                        IF GrantHeader.FINDSET THEN BEGIN
                            GrantLookup.LOOKUPMODE := TRUE;
                            GrantLookup.SETTABLEVIEW(GrantHeader);
                            GrantLookup.SetGrantNo(Rec."No.");
                            GrantLookup.RUNMODAL;
                        END ELSE
                            MESSAGE('No Grant lines found');
                    END;
                end;
            }
            action(Print)
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    GrantHeader.RESET;
                    GrantHeader.SETRANGE("No.", Rec."No.");
                    IF GrantHeader.FINDSET THEN
                        REPORT.RUN(90200, TRUE, FALSE, GrantHeader);
                end;
            }
            action(Expenditure)
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction();
                var
                    GLEntry: Record "G/L Entry";
                begin
                    GrantHeader.RESET;
                    GrantHeader.SETRANGE("No.", Rec."No.");
                    IF GrantHeader.FINDFIRST THEN BEGIN
                        GLEntry.RESET;
                        GLEntry.SETRANGE("Grant Code", GrantHeader."No.");
                        IF GLEntry.FINDSET THEN
                            REPORT.RUNMODAL(50293, TRUE, FALSE, GLEntry);
                    END;
                end;
            }
            action("Transaction Listing")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    GrantHeader.RESET;
                    GrantHeader.SETRANGE("No.", Rec."No.");
                    IF GrantHeader.FINDSET THEN
                        REPORT.RUN(50295, TRUE, FALSE, GrantHeader);
                end;
            }
            action("Grant Budget")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    GrantHeader.RESET;
                    GrantHeader.SETRANGE("No.", Rec."No.");
                    IF GrantHeader.FINDFIRST THEN
                        REPORT.RUN(50297, TRUE, FALSE, GrantHeader);
                end;
            }
            action("Grant Budget-Expenditure")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    GrantHeader.RESET;
                    GrantHeader.SETRANGE("No.", Rec."No.");
                    IF GrantHeader.FINDFIRST THEN
                        REPORT.RUN(50298, TRUE, FALSE, GrantHeader);
                end;
            }
        }
    }

    var
        GrantLines: Record "Grant Lines";
        GrantHeader: Record "Grant Header";
        GLaccList: Page "G/L Account List";
        UserSetup: Record "User Setup";
        GrantLookup: Page "Grant Lookup";
        DimensionValue: Record "Dimension Value";
        GrantDetailLines: Record "Grant Detail Lines";
}
