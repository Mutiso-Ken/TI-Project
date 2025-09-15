#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 80006 "HR Leave Jnl.-Post Line"
{
    Permissions = TableData "Ins. Coverage Ledger Entry" = rimd,
                  TableData "Insurance Register" = rimd;
    TableNo = "HR Journal Line";

    trigger OnRun()
    begin
        GLSetup.Get;
        /*TempJnlLineDim2.RESET;
        TempJnlLineDim2.DELETEALL;
        IF "Shortcut Dimension 1 Code" <> '' THEN BEGIN
          TempJnlLineDim2."Table ID" := DATABASE::"Insurance Journal Line";
          TempJnlLineDim2."Journal Template Name" := "Journal Template Name";
          TempJnlLineDim2."Journal Batch Name" := "Journal Batch Name";
          TempJnlLineDim2."Journal Line No." := "Line No.";
          TempJnlLineDim2."Dimension Code" := GLSetup."Global Dimension 1 Code";
          TempJnlLineDim2."Dimension Value Code" := "Shortcut Dimension 1 Code";
          TempJnlLineDim2.INSERT;
        END;
        IF "Shortcut Dimension 2 Code" <> '' THEN BEGIN
          TempJnlLineDim2."Table ID" := DATABASE::"HR Journal Line";
          TempJnlLineDim2."Journal Template Name" := "Journal Template Name";
          TempJnlLineDim2."Journal Batch Name" := "Journal Batch Name";
          TempJnlLineDim2."Journal Line No." := "Line No.";
          TempJnlLineDim2."Dimension Code" := GLSetup."Global Dimension 2 Code";
          TempJnlLineDim2."Dimension Value Code" := "Shortcut Dimension 2 Code";
          TempJnlLineDim2.INSERT;
        END;*/
        RunWithCheck(Rec);

    end;

    var
        GLSetup: Record "General Ledger Setup";
        FA: Record "HR Employees";
        Insurance: Record "HR Leave Application";
        InsuranceJnlLine: Record "HR Journal Line";
        InsCoverageLedgEntry: Record "HR Leave Ledger Entries";
        InsCoverageLedgEntry2: Record "HR Leave Ledger Entries";
        InsuranceReg: Record "HR Leave Register";
        InsuranceJnlCheckLine: Codeunit "HR Leave Jnl.-Check Line";
        DimMgt: Codeunit DimensionManagement;
        NextEntryNo: Integer;


    procedure RunWithCheck(var InsuranceJnlLine2: Record "HR Journal Line")
    begin
        InsuranceJnlLine.Copy(InsuranceJnlLine2);
        /*TempJnlLineDim.RESET;
        TempJnlLineDim.DELETEALL;*/
        //DimMgt.CopyJnlLineDimToJnlLineDim(TempJnlLineDim2,TempJnlLineDim);
        Code(true);
        InsuranceJnlLine2 := InsuranceJnlLine;

    end;


    procedure RunWithOutCheck(var InsuranceJnlLine2: Record "HR Journal Line")
    begin
        InsuranceJnlLine.Copy(InsuranceJnlLine2);

        /*TempJnlLineDim.RESET;
        TempJnlLineDim.DELETEALL;*/
        //DimMgt.CopyJnlLineDimToJnlLineDim(TempJnlLineDim2,TempJnlLineDim);

        Code(false);
        InsuranceJnlLine2 := InsuranceJnlLine;

    end;

    local procedure "Code"(CheckLine: Boolean)
    begin
        if InsuranceJnlLine."Document No." = '' then
            exit;
        if CheckLine then
            //    InsuranceJnlCheckLine.RunCheck(InsuranceJnlLine,TempJnlLineDim);
            Insurance.Reset;
        //Insurance.SETRANGE("Leave Application No.",
        // Insurance.GET("Document No.");
        FA.Get(InsuranceJnlLine."Staff No.");
        CopyFromJnlLine(InsCoverageLedgEntry, InsuranceJnlLine);
        //MakeInsCoverageLedgEntry.CopyFromInsuranceCard(InsCoverageLedgEntry,Insurance);
        if NextEntryNo = 0 then begin
            InsCoverageLedgEntry.LockTable;
            if InsCoverageLedgEntry2.Find('+') then
                NextEntryNo := InsCoverageLedgEntry2."Entry No.";
            InsuranceReg.LockTable;
            if InsuranceReg.Find('+') then
                InsuranceReg."No." := InsuranceReg."No." + 1
            else
                InsuranceReg."No." := 1;
            InsuranceReg.Init;
            InsuranceReg."From Entry No." := NextEntryNo + 1;
            InsuranceReg."Creation Date" := Today;
            InsuranceReg."Source Code" := InsuranceJnlLine."Source Code";
            InsuranceReg."Journal Batch Name" := InsuranceJnlLine."Journal Batch Name";
            InsuranceReg."User ID" := UserId;
        end;
        NextEntryNo := NextEntryNo + 1;
        InsCoverageLedgEntry."Entry No." := NextEntryNo;
        InsCoverageLedgEntry.Insert;
        /*
        DimMgt.MoveJnlLineDimToLedgEntryDim(
          TempJnlLineDim,DATABASE::"Ins. Coverage Ledger Entry",
          InsCoverageLedgEntry."Entry No.");
        */
        if InsuranceReg."To Entry No." = 0 then begin
            InsuranceReg."To Entry No." := NextEntryNo;
            InsuranceReg.Insert;
        end else begin
            InsuranceReg."To Entry No." := NextEntryNo;
            InsuranceReg.Modify;
        end;

    end;

    local procedure CopyFromJnlLine(var InsCoverageLedgEntry: Record "HR Leave Ledger Entries"; var InsuranceJnlLine: Record "HR Journal Line")
    begin
        InsCoverageLedgEntry."User ID" := UserId;
        InsCoverageLedgEntry."Leave Period" := InsuranceJnlLine."Leave Period";
        InsCoverageLedgEntry."Staff No." := InsuranceJnlLine."Staff No.";
        InsCoverageLedgEntry."Staff Name" := InsuranceJnlLine."Staff Name";
        InsCoverageLedgEntry."Posting Date" := InsuranceJnlLine."Posting Date";
        InsCoverageLedgEntry."Leave Recalled No." := InsuranceJnlLine."Leave Recalled No.";
        InsCoverageLedgEntry."Leave Entry Type" := InsuranceJnlLine."Leave Entry Type";
        InsCoverageLedgEntry."Leave Type" := InsuranceJnlLine."Leave Type";
        InsCoverageLedgEntry."Leave Approval Date" := InsuranceJnlLine."Leave Approval Date";
        InsCoverageLedgEntry."Leave Type" := InsuranceJnlLine."Leave Type";
        if InsCoverageLedgEntry."Leave Approval Date" = 0D then
            InsCoverageLedgEntry."Leave Approval Date" := InsCoverageLedgEntry."Posting Date";
        InsCoverageLedgEntry."Document No." := InsuranceJnlLine."Document No.";
        InsCoverageLedgEntry."External Document No." := InsuranceJnlLine."External Document No.";
        InsCoverageLedgEntry."No. of days" := InsuranceJnlLine."No. of Days";
        InsCoverageLedgEntry."Leave Posting Description" := InsuranceJnlLine.Description;
        InsCoverageLedgEntry."Global Dimension 1 Code" := InsuranceJnlLine."Shortcut Dimension 1 Code";
        InsCoverageLedgEntry."Global Dimension 2 Code" := InsuranceJnlLine."Shortcut Dimension 2 Code";
        InsCoverageLedgEntry."Source Code" := InsuranceJnlLine."Source Code";
        InsCoverageLedgEntry."Journal Batch Name" := InsuranceJnlLine."Journal Batch Name";
        InsCoverageLedgEntry."Reason Code" := InsuranceJnlLine."Reason Code";
        //Closed := SetDisposedFA(InsCoverageLedgEntry."Staff No.");
        InsCoverageLedgEntry."No. Series" := InsuranceJnlLine."Posting No. Series";
    end;
}

