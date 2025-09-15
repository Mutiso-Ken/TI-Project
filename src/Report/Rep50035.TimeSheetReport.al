#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50035 "TimeSheet Report"
{
    WordLayout = 'Layouts/TimeSheetReport.docx';
    DefaultLayout = Word;

    dataset
    {
        dataitem("TE Time Sheet1"; "TE Time Sheet1")
        {
            RequestFilterFields = Date, "Employee No";

            column(EmployeeName; "TE Time Sheet1"."Employee Name")
            {
            }
            column(Date; Format("TE Time Sheet1".Date))
            {
            }
            column(Hours; "TE Time Sheet1".Hours)
            {
            }
            column(ProjectCode; "TE Time Sheet1"."Global Dimension 1 Code")
            {
            }
            column(ProjectName; "TE Time Sheet1".Description)
            {
            }
            column(Period; Period)
            {
            }
            column(LeaveType; "TE Time Sheet1"."Leave Type")
            {
            }
            column(Status_TETimeSheet; "TE Time Sheet1".Status)
            {
            }
            trigger OnPreDataItem();
            begin

            end;

            trigger OnAfterGetRecord();
            begin
                ApprovedBy := '';
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
        Period := "TE Time Sheet1".GetFilter("TE Time Sheet1".Date);


    end;

    var
        Period: Text;
        ApprovedBy: Text;
        Employee: Record Employee;

    trigger OnInitReport();
    begin

    end;

}