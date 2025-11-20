#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50035 "TimeSheet Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/TimeSheet Report.rdlc';

    dataset
    {
        dataitem("TE Time Sheet1";"TE Time Sheet1")
        {
            RequestFilterFields = "Global Dimension 1 Code","Employee No";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(EmployeeNo;"TE Time Sheet1"."Employee No")
            {
            }
            column(DocumentNo_TETimeSheet1;"TE Time Sheet1"."Document No.")
            {
            }
            column(EmployeeName;"TE Time Sheet1"."Employee Name")
            {
            }
            column(Narration;"TE Time Sheet1".Narration)
            {
            }
            column(Date;"TE Time Sheet1".Date)
            {
            }
            column(Hours;"TE Time Sheet1".Hours)
            {
            }
            column(ProjectCode;"TE Time Sheet1"."Global Dimension 1 Code")
            {
            }
            column(ProjectName;"TE Time Sheet1".Description)
            {
            }
            column(Period;Period)
            {
            }
            column(LeaveType;"TE Time Sheet1"."Leave Type")
            {
            }
            column(Status_TETimeSheet;"TE Time Sheet1".Status)
            {
            }
            column(ApprovedBy;ApprovedBy)
            {
            }
            column(LastDate;LastDate)
            {
            }
            column(Signature;HREmployees.Signature)
            {
            }
            column(AsAt;AsAt)
            {
            }
            column(Picture;CompanyInfo.Picture)
            {
            }
            column(phone;CompanyInfo."Phone No.")
            {
            }
            column(Address;CompanyInfo.Address)
            {
            }
            column(Email;CompanyInfo."E-Mail")
            {
            }
            column(PostalCode;CompanyInfo."Post Code")
            {
            }
            column(Address2;CompanyInfo."Address 2")
            {
            }
            column(Name;CompanyInfo.Name)
            {
            }

            trigger OnAfterGetRecord()
            begin

                "TE Time Sheet1".SetFilter(Date,'%1..%2',CalcDate('-CM',AsAt),CalcDate('CM',AsAt));
                ApprovedBy:='';
                LastDate:=CalcDate('<CM>',AsAt);
                 HREmployees.Reset;
                 HREmployees.SetRange(HREmployees."No.","TE Time Sheet1"."Employee No");
                 if HREmployees.FindFirst then begin
                  Name:=HREmployees.FullName;
                  HREmployees.CalcFields(HREmployees.Signature);
                  end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Date;AsAt)
                {
                    ApplicationArea = Basic;
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
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    trigger OnPreReport()
    begin
        Period := "TE Time Sheet1".GetFilter("TE Time Sheet1".Date);
    end;

    var
        Period: Text;
        ApprovedBy: Text;
        Employee: Record Employee;
        HREmployees: Record "HR Employees";
        LastDate: Date;
        AsAt: Date;
        Name: Text;
        CompanyInfo: Record "Company Information";
}

