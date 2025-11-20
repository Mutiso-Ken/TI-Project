#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80029 "HR Leave Statement"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HR Leave Statement.rdlc';

    dataset
    {
        dataitem("HR Employees"; "HR Employees")
        {
            RequestFilterFields = "No.";

            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(Employee_No; "HR Employees"."No.")
            {
            }
            dataitem("HR Leave Ledger Entries"; "HR Leave Ledger Entries")
            {
                DataItemLink = "Staff No." = field("No.");
                DataItemTableView = where("Leave Type" = const('ANNUAL'));

                column(HR_Leave_Ledger_Entries__Leave_Period_; "HR Leave Ledger Entries"."Leave Period")
                {
                }
                column(HR_Leave_Ledger_Entries__Leave_Entry_Type_; "HR Leave Ledger Entries"."Leave Entry Type")
                {
                }
                column(HR_Leave_Ledger_Entries__Leave_Type_; "HR Leave Ledger Entries"."Leave Type")
                {
                }
                column(HR_Leave_Ledger_Entries__No__of_days_; "HR Leave Ledger Entries"."No. of days")
                {
                }
                column(HR_Leave_Ledger_Entries__Leave_Posting_Description_; "HR Leave Ledger Entries"."Leave Posting Description")
                {
                }
                column(HR_Leave_Ledger_Entries__Posting_Date_; "HR Leave Ledger Entries"."Posting Date")
                {
                }
                trigger OnPreDataItem();
                begin
                end;

                trigger OnAfterGetRecord();
                begin
                    No := No + 1;
                end;

            }
            trigger OnPreDataItem();
            begin

            end;

            trigger OnAfterGetRecord();
            begin
                Clear(Name);
                Name := "HR Employees"."First Name" + ' ' + "HR Employees"."Middle Name" + ' ' + "HR Employees"."Last Name";
            end;

        }
    }
    requestpage
    {
        SaveValues = false;
        layout
        {
        }

    }

    trigger OnPreReport()
    begin
        CI.Get();
        CI.CalcFields(CI.Picture);


    end;

    var
        CI: Record "Company Information";
        LeaveBalance: Decimal;
        EmployeeCaptionLbl: label 'Employee';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Employee_Leave_StatementCaptionLbl: label 'Employee Leave Statement';
        P_O__BoxCaptionLbl: label 'P.O. Box';
        NameCaptionLbl: label 'Name';
        Leave_BalanceCaptionLbl: label 'Leave Balance';
        Day_s_CaptionLbl: label 'Day(s)';
        No: Decimal;
        Name: Text[100];

    trigger OnInitReport();
    begin

    end;

}