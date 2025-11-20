#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80022 "HR Leave Balance Report"
{
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HR Leave Balance Report.rdlc';
    ;

    dataset
    {
        dataitem("HR Employees"; "HR Employees")
        {
            CalcFields = "Annual Leave Account", "Compassionate Leave Acc.", "Paternity Leave Acc.", "Sick Leave Acc.", "Study Leave Acc", "Maternity Leave Acc.", "CTO  Leave Acc.";
            DataItemTableView = where(Status = const(Active));

            column(No; "HR Employees"."No.")
            {
            }
            column(Surname; "HR Employees"."Last Name")
            {
            }
            column(Firstname; "HR Employees"."First Name")
            {
            }
            column(MIddle; "HR Employees"."Middle Name")
            {
            }
            column(Annualleave; "HR Employees"."Annual Leave Account")
            {
            }
            column(CompassionateLeaveAcc_HREmployees; "HR Employees"."Compassionate Leave Acc.")
            {
            }
            column(MaternityLeaveAcc_HREmployees; "HR Employees"."Maternity Leave Acc.")
            {
            }
            column(PaternityLeaveAcc_HREmployees; "HR Employees"."Paternity Leave Acc.")
            {
            }
            column(SickLeaveAcc_HREmployees; "HR Employees"."Sick Leave Acc.")
            {
            }
            column(StudyLeaveAcc_HREmployees; "HR Employees"."Study Leave Acc")
            {
            }
            column(CTOLeaveAcc_HREmployees; "HR Employees"."CTO  Leave Acc.")
            {
            }
            trigger OnPreDataItem();
            begin

            end;

            trigger OnAfterGetRecord();
            begin
                if PayrollEmployee.Get("HR Employees"."No.") then
                    Liability := (PayrollEmployee."Basic Pay" / 22) * "HR Employees"."Annual Leave Account";
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
    var
        PayrollEmployee: Record "Payroll Employee_AU";
        Liability: Decimal;

    trigger OnInitReport();
    begin

    end;

    trigger OnPreReport();
    begin

    end;

}