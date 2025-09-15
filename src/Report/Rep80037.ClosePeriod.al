#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80037 "Close Period"
{
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("HR Employees"; "HR Employees")
        {
            DataItemTableView = where(Status = const(Active));
            RequestFilterFields = "No.", Position, "Global Dimension 2 Code", Gender;
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                //TESTFIELD(Gender);

                //Get current leave period
                HRLeavePeriods.Reset;
                //HRLeavePeriods.SETRANGE(HRLeavePeriods."New Fiscal Year",TRUE);
                HRLeavePeriods.SetRange(HRLeavePeriods.Closed, false);
                HRLeavePeriods.SetRange(HRLeavePeriods."Date Locked", false);
                if HRLeavePeriods.Find('-') then begin
                    HRLeaveTypes.Reset;
                    if LeaveTypeFilter <> '' then begin
                        HRLeaveTypes.SetRange(HRLeaveTypes.Code, LeaveTypeFilter);
                    end;

                    if HRLeaveTypes.Find('-') then begin
                        repeat
                            HRLeaveLedger.SetRange(HRLeaveLedger."Staff No.", "No.");
                            HRLeaveLedger.SetFilter(HRLeaveLedger."Leave Type", '%1', 'ANNUALADD');
                            HRLeaveLedger.SetRange(HRLeaveLedger."Leave Entry Type", LeaveEntryType);
                            HRLeaveLedger.SetRange(HRLeaveLedger."Leave Period", HRLeavePeriods."Period Code");
                            if not HRLeaveLedger.Find('-') then begin
                                OK := CheckGender("HR Employees", HRLeaveTypes);
                                if OK then begin
                                    // forfeit days
                                    if HRLeaveTypes.Code <> 'ANNUAL' then begin

                                        HRJournalLine.Init;
                                        HRJournalLine."Journal Template Name" := Text0001;
                                        HRJournalLine.Validate("Journal Template Name");

                                        HRJournalLine."Journal Batch Name" := 'DEFAULT';
                                        HRJournalLine.Validate("Journal Batch Name");

                                        HRJournalLine."Line No." := HRJournalLine."Line No." + 1000;

                                        HRJournalLine."Leave Period" := HRLeavePeriods."Period Code";
                                        HRJournalLine.Validate("Leave Period");

                                        HRJournalLine."Leave Period Start Date" := HRLeavePeriods."Starting Date";
                                        HRJournalLine.Validate("Leave Period Start Date");

                                        HRJournalLine."Staff No." := "No.";
                                        HRJournalLine.Validate("Staff No.");

                                        HRJournalLine."Posting Date" := Today;
                                        HRJournalLine."Document No." := PostingDescription;
                                        HRJournalLine.Description := 'Previous Year Days forfeited';
                                        HRJournalLine."Leave Entry Type" := HRJournalLine."leave entry type"::Negative;
                                        HRJournalLine."Leave Type" := HRLeaveTypes.Code;
                                        Grade := Grade;
                                        HRJournalLine."Document No." := HRLeavePeriods."Period Code";
                                        "Global Dimension 1 Code" := "Global Dimension 1 Code";
                                        "Global Dimension 2 Code" := "Global Dimension 2 Code";

                                        "HR Employees".CalcFields("Maternity Leave Acc.", "Paternity Leave Acc.", "Annual Leave Account", "Compassionate Leave Acc.", "Sick Leave Acc.", "Study Leave Acc", "CTO  Leave Acc.");
                                        if HRLeaveTypes.Code = 'COMPASSIONATE' then
                                            HRJournalLine."No. of Days" := -1 * "HR Employees"."Compassionate Leave Acc.";
                                        if HRLeaveTypes.Code = 'EXAM' then
                                            HRJournalLine."No. of Days" := -1 * ("HR Employees"."Study Leave Acc");
                                        if HRLeaveTypes.Code = 'MATERNITY' then
                                            HRJournalLine."No. of Days" := -1 * ("HR Employees"."Maternity Leave Acc.");
                                        if HRLeaveTypes.Code = 'PATERNITY' then
                                            HRJournalLine."No. of Days" := -1 * ("HR Employees"."Paternity Leave Acc.");

                                        if HRLeaveTypes.Code = 'SICK' then
                                            HRJournalLine."No. of Days" := -1 * ("HR Employees"."Sick Leave Acc.");
                                        if HRLeaveTypes.Code = 'CTO' then
                                            HRJournalLine."No. of Days" := -1 * ("HR Employees"."CTO  Leave Acc.");

                                        HRJournalLine.Insert;
                                        // end of forfeit






                                        HRJournalLine.Init;
                                        HRJournalLine."Journal Template Name" := Text0001;
                                        HRJournalLine.Validate("Journal Template Name");

                                        HRJournalLine."Journal Batch Name" := 'DEFAULT';
                                        HRJournalLine.Validate("Journal Batch Name");

                                        HRJournalLine."Line No." := HRJournalLine."Line No." + 1000;

                                        HRJournalLine."Leave Period" := HRLeavePeriods."Period Code";
                                        HRJournalLine.Validate("Leave Period");

                                        HRJournalLine."Leave Period Start Date" := HRLeavePeriods."Starting Date";
                                        HRJournalLine.Validate("Leave Period Start Date");

                                        HRJournalLine."Staff No." := "No.";
                                        HRJournalLine.Validate("Staff No.");

                                        HRJournalLine."Posting Date" := Today;
                                        HRJournalLine."Document No." := PostingDescription;
                                        HRJournalLine.Description := 'Earned Leave Days';
                                        HRJournalLine."Leave Entry Type" := LeaveEntryType;
                                        HRJournalLine."Leave Type" := HRLeaveTypes.Code;
                                        Grade := Grade;
                                        HRJournalLine."Document No." := HRLeavePeriods."Period Code";
                                        "Global Dimension 1 Code" := "Global Dimension 1 Code";
                                        "Global Dimension 2 Code" := "Global Dimension 2 Code";
                                        HRJournalLine."No. of Days" := HRLeaveTypes.Days;

                                        HRJournalLine.Insert;

                                        HRJournalLine2.SetRange("Journal Template Name", 'LEAVE');
                                        HRJournalLine2.SetRange("Journal Batch Name", 'DEFAULT');
                                        // CODEUNIT.RUN(CODEUNIT::"HR Leave Jnl.-Post",HRJournalLine2);
                                    end
                                    else begin
                                        HRJournalLine.Init;
                                        HRJournalLine."Journal Template Name" := Text0001;
                                        HRJournalLine.Validate("Journal Template Name");

                                        HRJournalLine."Journal Batch Name" := 'DEFAULT';
                                        HRJournalLine.Validate("Journal Batch Name");

                                        HRJournalLine."Line No." := HRJournalLine."Line No." + 1000;

                                        HRJournalLine."Leave Period" := HRLeavePeriods."Period Code";
                                        HRJournalLine.Validate("Leave Period");

                                        HRJournalLine."Leave Period Start Date" := HRLeavePeriods."Starting Date";
                                        HRJournalLine.Validate("Leave Period Start Date");

                                        HRJournalLine."Staff No." := "No.";
                                        HRJournalLine.Validate("Staff No.");

                                        HRJournalLine."Posting Date" := Today;
                                        HRJournalLine."Document No." := PostingDescription;
                                        HRJournalLine."Leave Entry Type" := HRJournalLine."leave entry type"::Negative;
                                        HRJournalLine."Leave Type" := HRLeaveTypes.Code;
                                        Grade := Grade;
                                        HRJournalLine."Document No." := HRLeavePeriods."Period Code";
                                        "Global Dimension 1 Code" := "Global Dimension 1 Code";

                                        "Global Dimension 2 Code" := "Global Dimension 2 Code";
                                        HRJournalLine.Description := 'Previous Year Days forfeited';
                                        "HR Employees".CalcFields("Annual Leave Account");
                                        HRJournalLine."No. of Days" := -1 * ("HR Employees"."Annual Leave Account");
                                        HRJournalLine.Insert;


                                        HRJournalLine.Init;
                                        HRJournalLine."Journal Template Name" := Text0001;
                                        HRJournalLine.Validate("Journal Template Name");

                                        HRJournalLine."Journal Batch Name" := 'DEFAULT';
                                        HRJournalLine.Validate("Journal Batch Name");

                                        HRJournalLine."Line No." := HRJournalLine."Line No." + 1000;

                                        HRJournalLine."Leave Period" := HRLeavePeriods."Period Code";
                                        HRJournalLine.Validate("Leave Period");

                                        HRJournalLine."Leave Period Start Date" := HRLeavePeriods."Starting Date";
                                        HRJournalLine.Validate("Leave Period Start Date");

                                        HRJournalLine."Staff No." := "No.";
                                        HRJournalLine.Validate("Staff No.");

                                        HRJournalLine."Posting Date" := Today;
                                        HRJournalLine."Document No." := PostingDescription;
                                        HRJournalLine."Leave Entry Type" := HRJournalLine."leave entry type"::Positive;
                                        HRJournalLine."Leave Type" := HRLeaveTypes.Code;
                                        Grade := Grade;
                                        HRJournalLine."Document No." := HRLeavePeriods."Period Code";
                                        "Global Dimension 1 Code" := "Global Dimension 1 Code";
                                        "Global Dimension 2 Code" := "Global Dimension 2 Code";
                                        HRJournalLine.Description := 'Days Carried Forward';
                                        "HR Employees".CalcFields("Annual Leave Account");
                                        if "HR Employees"."Annual Leave Account" < HRLeaveTypes."Max Carry Forward Days" then
                                            HRJournalLine."No. of Days" := ("HR Employees"."Annual Leave Account")
                                        else
                                            HRJournalLine."No. of Days" := HRLeaveTypes."Max Carry Forward Days";
                                        HRJournalLine.Insert;






                                        HRJournalLine.Init;
                                        HRJournalLine."Journal Template Name" := Text0001;
                                        HRJournalLine.Validate("Journal Template Name");

                                        HRJournalLine."Journal Batch Name" := 'DEFAULT';
                                        HRJournalLine.Validate("Journal Batch Name");

                                        HRJournalLine."Line No." := HRJournalLine."Line No." + 1000;

                                        HRJournalLine."Leave Period" := HRLeavePeriods."Period Code";
                                        HRJournalLine.Validate("Leave Period");

                                        HRJournalLine."Leave Period Start Date" := HRLeavePeriods."Starting Date";
                                        HRJournalLine.Validate("Leave Period Start Date");

                                        HRJournalLine."Staff No." := "No.";
                                        HRJournalLine.Validate("Staff No.");

                                        HRJournalLine."Posting Date" := Today;
                                        HRJournalLine."Document No." := PostingDescription;
                                        HRJournalLine."Leave Entry Type" := LeaveEntryType;
                                        HRJournalLine."Leave Type" := HRLeaveTypes.Code;
                                        Grade := Grade;
                                        HRJournalLine."Document No." := HRLeavePeriods."Period Code";
                                        "Global Dimension 1 Code" := "Global Dimension 1 Code";
                                        "Global Dimension 2 Code" := "Global Dimension 2 Code";
                                        HRJournalLine.Description := 'Earned Leave Days';
                                        HRJournalLine."No. of Days" := HRLeaveTypes.Days;
                                        HRJournalLine.Insert;

                                        HRJournalLine2.SetRange("Journal Template Name", 'LEAVE');
                                        HRJournalLine2.SetRange("Journal Batch Name", 'DEFAULT');

                                    end;
                                end;
                            end else begin
                                // IF HRLeaveTypes.Code='ANNUAL' THEN BEGIN
                                OK := CheckGender("HR Employees", HRLeaveTypes);
                                if OK then begin
                                end;
                                //   END ELSE BEGIN
                                //ERROR('Allocation has already been done');
                                // END;
                            end;
                        until HRLeaveTypes.Next = 0;

                    end else begin
                        Error('No Leave Type found within the applied filters [%1]', "Leave Type Filter");
                    end;



                end;
            end;
        }
        dataitem("HR Leave Types"; "HR Leave Types")
        {
            RequestFilterFields = "Code";
            column(ReportForNavId_2; 2)
            {
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(LeaveEntryType; LeaveEntryType)
                {
                    ApplicationArea = Basic;
                    Caption = 'Leave Entry Type';
                }
                field(PostingDescription; PostingDescription)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posting Description';
                }
                field(BatchName; BatchName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Batch Name';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        Message('Process complete');
    end;

    trigger OnPreReport()
    begin

        //IF PostingDescription = '' THEN ERROR('Posting description must have value');
        if not HRJournalLine.IsEmpty then begin
            if Confirm(Text0002 + Text0003, false, HRJournalLine.Count, UpperCase(HRJournalLine.TableCaption), Text0001, BatchName) = true then begin
                HRJournalLine.DeleteAll;
            end else begin
                Error('Process aborted');
            end;
        end;

        //Get Leave type filter
        LeaveTypeFilter := "HR Leave Types".GetFilter("HR Leave Types".Code);
    end;

    var
        HRLeavePeriods: Record "HR Leave Periods";
        AllocationDone: Boolean;
        HRLeaveTypes: Record "HR Leave Types";
        HRLeaveLedger: Record "HR Leave Ledger Entries";
        LeaveEntryType: Option Postive,Negative,Reimbursement;
        OK: Boolean;
        HRJournalLine: Record "HR Journal Line";
        PostingDescription: Text;
        BatchName: Option POSITIVE,NEGATIVE;
        JournalTemplate: Code[20];
        Text0001: label 'LEAVE';
        Text0002: label 'There are [%1] entries in [%2  TABLE], Journal Template Name - [%3], Journal Batch Name [%4]';
        Text0003: label '\\Do you want to proceed and overwite these entries?';
        LeaveTypeFilter: Text;
        i: Integer;
        HRLeaveLedger2: Record "HR Leave Ledger Entries";
        HRLeaveLedger3: Record "HR Leave Ledger Entries";
        HRJournalLine2: Record "HR Journal Line";
        HRLeaveJnlPostBatch: Codeunit "HR Leave Jnl.-Post Batch";


    procedure CheckGender(Emp: Record "HR Employees"; LeaveType: Record "HR Leave Types") Allocate: Boolean
    begin
        if Emp.Gender = Emp.Gender::Male then begin
            if LeaveType.Gender = LeaveType.Gender::Male then Allocate := true;
        end;

        if Emp.Gender = Emp.Gender::Female then begin
            if LeaveType.Gender = LeaveType.Gender::Female then Allocate := true;
        end;

        if LeaveType.Gender = LeaveType.Gender::Both then Allocate := true;
        exit(Allocate);

        if Emp.Gender <> LeaveType.Gender then Allocate := false;

        exit(Allocate);
    end;
}

