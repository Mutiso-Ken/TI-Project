codeunit 80012 GeneralFunctionsFactory
{
    // procedure PostNegativeLeaveEntries(HrLeaveApplications: Record "HR Leave Application")
    // var
    //     EntryNo: Integer;
    // begin


    //     HRLedgerEntries.Reset();
    //     if HRLedgerEntries.FindLast() then
    //         EntryNo := HRLedgerEntries."Entry No.";

    //     HRLedgerEntries.LockTable();
    //     HRLedgerEntries.Init();
    //     HRLedgerEntries."Entry No." := EntryNo + 1;
    //     HRLedgerEntries."Leave Period" := Format(Date2dmy(Today, 3));
    //     HRLedgerEntries."Staff Name" := HrLeaveApplications."Employee Name";
    //     HRLedgerEntries."No. of days" := HrLeaveApplications."Approved days" * -1;
    //     HRLedgerEntries."Leave Posting Description" := 'Leave taken - ' + HrLeaveApplications."Leave Type";
    //     HRLedgerEntries."Leave Type" := HrLeaveApplications."Leave Type";
    //     HRLedgerEntries."Staff No." := HrLeaveApplications."Employee No";
    //     HRLedgerEntries."Document No." := Format(Date2dmy(Today, 3));
    //     HRLedgerEntries."Leave Entry Type" := HRLedgerEntries."Leave Entry Type"::Negative;
    //     HRLedgerEntries."Posting Date" := Today;
    //     HRLedgerEntries.Insert();

    // end;



    procedure PostNegativeLeaveEntries(HrLeaveApplications: Record "HR Leave Application")
    var
        EntryNo: Integer;
    begin


        HRLedgerEntries.LockTable();
        HRLedgerEntries.Init();
        HRLedgerEntries."Leave Period" := Format(Date2dmy(Today, 3));
        HRLedgerEntries."Staff Name" := HrLeaveApplications.Names;
        HRLedgerEntries."No. of days" := HrLeaveApplications."Approved days" * -1;
        HRLedgerEntries."Leave Posting Description" := 'Leave taken - ' + HrLeaveApplications."Leave Type";
        HRLedgerEntries."Leave Type" := HrLeaveApplications."Leave Type";
        HRLedgerEntries."Staff No." := HrLeaveApplications."Employee No";
        HRLedgerEntries."Document No." := Format(Date2dmy(Today, 3)) + '-' + Format(EntryNo + 1);
        HRLedgerEntries."Leave Entry Type" := HRLedgerEntries."Leave Entry Type"::Negative;
        HRLedgerEntries."Posting Date" := Today;

        HRLedgerEntries.Insert();
    end;


    var
        HrLeaveApplications: Record "HR Leave Application";
        HRLedgerEntries: Record "HR Leave Ledger Entries";
}