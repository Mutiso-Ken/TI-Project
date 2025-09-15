#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 80003 "HR Leave Jnl.-Post"
{
    TableNo = "HR Journal Line";

    trigger OnRun()
    begin
        HRJournalLine.Copy(Rec);
        Code;
        Rec.Copy(HRJournalLine);
    end;

    var
        Text000: label 'Do you want to post the journal lines?';
        Text001: label 'There is nothing to post.';
        Text002: label 'The journal lines were successfully posted.';
        Text003: label 'The journal lines were successfully posted. You are now in the %1 journal.';
        HRLeaveJournalTemplate: Record "HR Leave Journal Template";
        HRJournalLine: Record "HR Journal Line";
        HRLeaveJnlPostBatch: Codeunit "HR Leave Jnl.-Post Batch";
        TempJnlBatchName: Code[10];

    local procedure "Code"()
    begin
        HRLeaveJournalTemplate.Get(HRJournalLine."Journal Template Name");
        HRLeaveJournalTemplate.TestField("Force Posting Report", false);

        if not Confirm(Text000, false) then
            exit;

        TempJnlBatchName := HRJournalLine."Journal Batch Name";

        HRLeaveJnlPostBatch.Run(HRJournalLine);

        if HRJournalLine."Line No." = 0 then
            Message(Text001)
        else
            if TempJnlBatchName = HRJournalLine."Journal Batch Name" then
                Message(Text002)
            else
                Message(
                  Text003,
                  HRJournalLine."Journal Batch Name");

        if not HRJournalLine.Find('=><') or (TempJnlBatchName <> HRJournalLine."Journal Batch Name") then begin
            HRJournalLine.Reset;
            HRJournalLine.FilterGroup := 2;
            HRJournalLine.SetRange("Journal Template Name", HRJournalLine."Journal Template Name");
            HRJournalLine.SetRange("Journal Batch Name", HRJournalLine."Journal Batch Name");
            HRJournalLine.FilterGroup := 0;
            HRJournalLine."Line No." := 1;
        end;
    end;
}

