#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 80005 "HR Leave Jnl.-Check Line"
{
    TableNo = "HR Journal Line";

    trigger OnRun()
    begin
        GLSetup.Get;

        /*IF "Shortcut Dimension 1 Code" <> '' THEN BEGIN
          TempJnlLineDim."Table ID" := DATABASE::"HR Journal Line";
          TempJnlLineDim."Journal Template Name" := "Journal Template Name";
          TempJnlLineDim."Journal Batch Name" := "Journal Batch Name";
          TempJnlLineDim."Journal Line No." := "Line No.";
          TempJnlLineDim."Dimension Code" := GLSetup."Global Dimension 1 Code";
          TempJnlLineDim."Dimension Value Code" := "Shortcut Dimension 1 Code";
          TempJnlLineDim.INSERT;
        END;
        IF "Shortcut Dimension 2 Code" <> '' THEN BEGIN
          TempJnlLineDim."Table ID" := DATABASE::"HR Journal Line";
          TempJnlLineDim."Journal Template Name" := "Journal Template Name";
          TempJnlLineDim."Journal Batch Name" := "Journal Batch Name";
          TempJnlLineDim."Journal Line No." := "Line No.";
          TempJnlLineDim."Dimension Code" := GLSetup."Global Dimension 2 Code";
          TempJnlLineDim."Dimension Value Code" := "Shortcut Dimension 2 Code";
          TempJnlLineDim.INSERT;
        END;
        
        RunCheck(Rec,TempJnlLineDim);*/

    end;

    var
        Text000: label 'The combination of dimensions used in %1 %2, %3, %4 is blocked. %5';
        Text001: label 'A dimension used in %1 %2, %3, %4 has caused an error. %5';
        GLSetup: Record "General Ledger Setup";
        FASetup: Record "HR Setup";
        DimMgt: Codeunit DimensionManagement;
        CallNo: Integer;
        Text002: label 'The Posting Date Must be within the open leave periods';
        Text003: label 'The Posting Date Must be within the allowed Setup date';
        LeaveEntries: Record "HR Leave Ledger Entries";
        Text004: label 'The Allocation of Leave days has been done for the period';


    procedure ValidatePostingDate(var InsuranceJnlLine: Record "HR Journal Line")
    begin
        if InsuranceJnlLine."Leave Entry Type" = InsuranceJnlLine."leave entry type"::Negative then begin
            InsuranceJnlLine.TestField("Leave Period");
        end;
        InsuranceJnlLine.TestField("Document No.");
        InsuranceJnlLine.TestField("Posting Date");
        InsuranceJnlLine.TestField("Staff No.");
        if (InsuranceJnlLine."Posting Date" < InsuranceJnlLine."Leave Period Start Date") or
           (InsuranceJnlLine."Posting Date" > InsuranceJnlLine."Leave Period End Date") then
            // ERROR(FORMAT(Text002));

            FASetup.Get();
        if (FASetup."Leave Posting Period[FROM]" <> 0D) and (FASetup."Leave Posting Period[TO]" <> 0D) then begin
            if (InsuranceJnlLine."Posting Date" < FASetup."Leave Posting Period[FROM]") or
               (InsuranceJnlLine."Posting Date" > FASetup."Leave Posting Period[TO]") then
                Error(Format(Text003));
        end;
        /*
             LeaveEntries.RESET;
             LeaveEntries.SETRANGE(LeaveEntries."Leave Type","Leave Type Code");
            IF LeaveEntries.FIND('-') THEN BEGIN
         IF LeaveEntries."Leave Transaction Type"=LeaveEntries."Leave Transaction Type"::"Leave Allocation" THEN BEGIN
         IF (LeaveEntries."Posting Date"<"Leave Period Start Date") OR
             (LeaveEntries."Posting Date">"Leave Period End Date")  THEN
             ERROR(FORMAT(Text004));
                     END;
           END;
        */

    end;


    procedure RunCheck(var InsuranceJnlLine: Record "HR Journal Line")
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        if InsuranceJnlLine."Leave Entry Type" = InsuranceJnlLine."leave entry type"::Negative then begin
            InsuranceJnlLine.TestField("Leave Application No.");
        end;
        InsuranceJnlLine.TestField("Document No.");
        InsuranceJnlLine.TestField("Posting Date");
        InsuranceJnlLine.TestField("Staff No.");
        CallNo := 1;

        /* IF NOT DimMgt.CheckJnlLineDimComb(JnlLineDim) THEN
           ERROR(
             Text000,
             TABLECAPTION,"Journal Template Name","Journal Batch Name","Line No.",
             DimMgt.GetDimCombErr);
         */
        //  TableID[1] := DATABASE::Table56175;
        TableID[1] := Database::"HR Journal Line";
        No[1] := InsuranceJnlLine."Leave Application No.";
        /* IF NOT DimMgt.CheckJnlLineDimValuePosting(JnlLineDim,TableID,No) THEN
           IF "Line No." <> 0 THEN
             ERROR(
               Text001,
               TABLECAPTION,"Journal Template Name","Journal Batch Name","Line No.",
               DimMgt.GetDimValuePostingErr)
           ELSE
             ERROR(DimMgt.GetDimValuePostingErr); */
        ValidatePostingDate(InsuranceJnlLine);

    end;

    local procedure JTCalculateCommonFilters()
    begin
    end;
}

