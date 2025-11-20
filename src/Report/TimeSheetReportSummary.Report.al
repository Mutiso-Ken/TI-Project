#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50036 "TimeSheet Report Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/TimeSheet Report Summary.rdlc';

    dataset
    {
        dataitem("TE Time Sheet1"; "TE Time Sheet1")
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(EntryNo; "TE Time Sheet1"."Line No.")
            {
            }
            column(EmployeeNo; "TE Time Sheet1"."Employee No")
            {
            }
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
            column(Status_TETimeSheet; "TE Time Sheet1".Status)
            {
            }
            column(ApprovedBy; ApprovedBy)
            {
            }
            column(TotalHours; TotalHours)
            {
            }
            column(LastDate; LastDate)
            {
            }
            column(MonthCaptionOne; MonthCaptionOne)
            {
            }
            column(Stamp; CompanyInformation.Picture)
            {
            }
            column(Name; Name)
            {
            }
            column(MonthHours; MonthHours)
            {
            }
            column(ProjectTotal; ProjectTotal)
            {
            }
            dataitem("HR Employees"; "HR Employees")
            {
                DataItemLink = "No." = field("Employee No");
                column(ReportForNavId_1; 1)
                {
                }
                column(EmployeeSignature_HREmployees; "HR Employees".Signature)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                // MonthHours:=0;
                // ProjectTotal:=0;

                // TimesheetLines.RESET;
                // TimesheetLines.SETRANGE(Timesheetcode,"TE Time Sheet1"."Document No.");
                // TimesheetLines.SETRANGE(Status,TimesheetLines.Status::Approved);



                LastDate := CalcDate('<CM>', AsAt);
                MonthCaptionOne := Format(AsAt, 0, '<Month Text>');

                TotalHours := 0;
                TETimeSheet.Reset;
                TETimeSheet.CopyFilters("TE Time Sheet1");
                if TETimeSheet.FindSet then begin
                    repeat
                        TotalHours := TotalHours + TETimeSheet.Hours;
                    until TETimeSheet.Next = 0;
                end;



                DimensionValue.Reset;
                DimensionValue.SetRange(Code, "TE Time Sheet1"."Global Dimension 1 Code");
                if DimensionValue.FindFirst then begin
                    Name := DimensionValue.Name;
                end;
            end;

            trigger OnPreDataItem()
            begin
                SetFilter(Date, '%1..%2', CalcDate('-CM', AsAt), CalcDate('CM', AsAt));
                SetFilter("Employee No", EmployeeNo);

                //SETFilter(Status,Status::Approved);
                //SETRANGE(status,;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Date; AsAt)
                {
                    ApplicationArea = Basic;
                }
                field(Employee; EmployeeNo)
                {
                    ApplicationArea = Basic;
                    TableRelation = "HR Employees";
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

    trigger OnInitReport()
    begin
        CompanyInformation.Reset;
        CompanyInformation.CalcFields(Picture);
    end;

    trigger OnPreReport()
    begin
        Period := "TE Time Sheet1".GetFilter("TE Time Sheet1".Date);
    end;

    var
        Period: Text;
        ApprovedBy: Text;
        Employee: Record Employee;
        TotalHours: Decimal;
        TETimeSheet: Record "TE Time Sheet1";
        AsAt: Date;
        LastDate: Date;
        MonthCaptionOne: Text;
        Name: Text;
        DimensionValue: Record "Dimension Value";
        CompanyInformation: Record "Company Information";
        ProjectTotal: Decimal;
        MonthHours: Decimal;
        EmployeeNo: Text;
       
}

