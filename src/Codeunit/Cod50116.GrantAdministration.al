codeunit 50116 "Grant Administration"
{

    trigger OnRun();
    begin
        MESSAGE('Grant Budget %1', GetGrantBudgetBalance('GRNT00016', 'AAA00', '5309', '600118'));
    end;

    var
        Window: Dialog;
        LineNo: Integer;

    procedure IsModifyAllowed(GrantNo: Code[20]);
    var
        GrantHeader: Record "Grant Header";
    begin
        IF GrantHeader.GET(GrantNo) THEN
            GrantHeader.TESTFIELD("Approval Status", GrantHeader."Approval Status"::New);
    end;

    procedure ConsolidateGrant(GrantCode: Code[20]; BudgetName: Code[20]);
    var
        GLBudgetEntry: Record "G/L Budget Entry";
        GrantDetailLines: Record "Grant Detail Lines";
        LineNo: Integer;
        GrantLines: Record "Grant Lines";
    begin
        Window.OPEN('Consolidating \#1###');
        IF BudgetName = '' THEN
            ERROR('The Budget Does Not Exist');
        GLBudgetEntry.RESET;
        GLBudgetEntry.SETRANGE("Source Code", GrantCode);
        GLBudgetEntry.SETRANGE("Budget Name", BudgetName);
        IF GLBudgetEntry.FINDSET THEN
            GLBudgetEntry.DELETEALL;
        GrantLines.RESET;
        GrantLines.SETRANGE("Grant No", GrantCode);
        IF GrantLines.FINDSET THEN BEGIN
            GLBudgetEntry.RESET;
            IF GLBudgetEntry.FINDLAST THEN
                LineNo := GLBudgetEntry."Entry No." + 1
            ELSE
                LineNo := 1;
            REPEAT
                GrantDetailLines.RESET;
                GrantDetailLines.SETRANGE("Grant Code", GrantCode);
                GrantDetailLines.SETRANGE(Code, GrantLines.Code);
                GrantDetailLines.SETRANGE("Line No.", GrantLines."Line No");
                GrantDetailLines.SETRANGE("Line Type", GrantLines."Line Type");
                IF GrantDetailLines.FINDSET THEN BEGIN
                    REPEAT
                        Window.UPDATE(1, GrantDetailLines."Activity Description");
                        GLBudgetEntry.INIT;
                        GLBudgetEntry."Entry No." := LineNo;
                        LineNo += 1;
                        GLBudgetEntry."Budget Name" := BudgetName;
                        GLBudgetEntry."G/L Account No." := GrantDetailLines."G/L Account No";
                        GLBudgetEntry.Date := GrantDetailLines."Proposed Start Date";
                        GLBudgetEntry."Global Dimension 1 Code" := GrantLines."Shortcut Dimension 1 Code";
                        GLBudgetEntry."Global Dimension 2 Code" := GrantLines."Shortcut Dimension 2 Code";
                        GLBudgetEntry.Amount := GrantDetailLines."Total Cost";
                        GLBudgetEntry.Description := COPYSTR(GrantDetailLines."Activity Description", 1, 100);
                        GLBudgetEntry."Dimension Set ID" := GrantLines."Dimension Set ID";
                        GLBudgetEntry."Source Code" := GrantDetailLines."Grant Code";
                        GLBudgetEntry.INSERT;
                        GrantDetailLines."Transfered To Budget" := TRUE;
                        GrantDetailLines."Amount Transfered" := GrantDetailLines."Total Cost";
                        GrantDetailLines.MODIFY;
                    UNTIL GrantDetailLines.NEXT = 0;
                END;
            UNTIL GrantLines.NEXT = 0;
        END;
        Window.CLOSE;
    end;

    procedure GetGrantBudgetBalance(GrantCode: Code[20]; ActivityCode: Code[20]; GLCode: Code[20]; ExternalPartnerCode: Code[20]) BudgetBalance: Decimal;
    var
        GrantDetailLines: Record "Grant Detail Lines";
        TotalBudget: Decimal;
        TotalExpenses: Decimal;
        GrantHeader: Record "Grant Header";
    begin
        TotalBudget := 0;
        TotalExpenses := 0;
        BudgetBalance := 0;
        IF GrantHeader.GET(GrantCode) THEN BEGIN
            IF GrantHeader.Blocked THEN
                EXIT(0);
        END ELSE
            EXIT(0);
        GrantDetailLines.RESET;
        GrantDetailLines.SETRANGE("Grant Code", GrantCode);
        GrantDetailLines.SETRANGE(Code, ActivityCode);
        GrantDetailLines.SETRANGE("G/L Account No", GLCode);
        GrantDetailLines.SETRANGE("External Partner Code", ExternalPartnerCode);
        IF GrantDetailLines.FINDSET THEN BEGIN
            GrantDetailLines.CALCSUMS("Total Cost");
            TotalBudget := GrantDetailLines."Total Cost";
            REPEAT
                GrantDetailLines.CALCFIELDS(Expenditure);
                TotalExpenses += GrantDetailLines.Expenditure;
            UNTIL GrantDetailLines.NEXT = 0;
        END;
        BudgetBalance := TotalBudget - TotalExpenses;
        IF BudgetBalance < 0 THEN
            BudgetBalance := 0;
        EXIT(BudgetBalance);
    end;
}
