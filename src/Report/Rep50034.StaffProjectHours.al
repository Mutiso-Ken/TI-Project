#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50034 "Staff Project Hours"
{
    RDLCLayout = 'Layouts/Staff Project Hours.rdlc';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("TE Time Sheet1"; "TE Time Sheet1")
        {
            RequestFilterFields = Date;

            column(EmployeeName; "TE Time Sheet1"."Employee Name")
            {
            }
            column(Date; Format("TE Time Sheet1".Date))
            {
            }
            column(Narration; "TE Time Sheet1".Narration)
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
            trigger OnPreDataItem();
            begin

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

    trigger OnInitReport();
    begin

    end;

}