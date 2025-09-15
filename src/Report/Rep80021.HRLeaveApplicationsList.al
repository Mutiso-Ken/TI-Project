#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80021 "HR Leave Applications List"
{
    UsageCategory = ReportsAndAnalysis;
    WordLayout = 'Layouts/HRLeaveApplicationsList.docx';
    DefaultLayout = Word;

    dataset
    {
        dataitem("HR Leave Application"; "HR Leave Application")
        {
            RequestFilterFields = "Application Code";

            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(HR_Leave_Application__Application_Code_; "HR Leave Application"."Application Code")
            {
            }
            column(HR_Leave_Application__Application_Date_; "HR Leave Application"."Application Date")
            {
            }
            column(EmployeeName_HRLeaveApplication; "HR Leave Application".Names)
            {
            }
            column(HR_Leave_Application__Employee_No_; "HR Leave Application"."Employee No")
            {
            }
            column(HR_Leave_Application__Job_Tittle_; "HR Leave Application"."Job Tittle")
            {
            }
            column(HR_Leave_Application_Supervisor; "HR Leave Application".Supervisor)
            {
            }
            column(HR_Leave_Application__Leave_Type_; "HR Leave Application"."Leave Type")
            {
            }
            column(HR_Leave_Application__Days_Applied_; "HR Leave Application"."Days Applied")
            {
            }
            column(HR_Leave_Application__Start_Date_; "HR Leave Application"."Start Date")
            {
            }
            column(HR_Leave_Application__Return_Date_; "HR Leave Application"."Return Date")
            {
            }
            column(HR_Leave_Application_Reliever; "HR Leave Application".Reliever)
            {
            }
            column(HR_Leave_Application__Reliever_Name_; "HR Leave Application"."Reliever Name")
            {
            }
            column(HR_Leave_ApplicationCaption; HR_Leave_ApplicationCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(HR_Leave_Application__Application_Code_Caption; FieldCaption("Application Code"))
            {
            }
            column(HR_Leave_Application__Application_Date_Caption; FieldCaption("Application Date"))
            {
            }
            column(HR_Leave_Application__Employee_No_Caption; FieldCaption("Employee No"))
            {
            }
            column(HR_Leave_Application_SupervisorCaption; FieldCaption(Supervisor))
            {
            }
            column(HR_Leave_Application__Leave_Type_Caption; FieldCaption("Leave Type"))
            {
            }
            column(HR_Leave_Application__Days_Applied_Caption; FieldCaption("Days Applied"))
            {
            }
            column(HR_Leave_Application__Start_Date_Caption; FieldCaption("Start Date"))
            {
            }
            column(HR_Leave_Application__Return_Date_Caption; FieldCaption("Return Date"))
            {
            }
            column(HR_Leave_Application_RelieverCaption; FieldCaption(Reliever))
            {
            }
            column(HR_Leave_Application__Reliever_Name_Caption; FieldCaption("Reliever Name"))
            {
            }
            column(Picture; CI.Picture)
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
        CI.Reset;
        CI.Get;
        CI.CalcFields(CI.Picture);
        //

    end;

    var
        HR_Leave_ApplicationCaptionLbl: label 'HR Leave Application';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        CI: Record "Company Information";

    trigger OnInitReport();
    begin

    end;
}
