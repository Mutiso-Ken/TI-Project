report 80043 "Employee Leave Report"
{
    Caption = 'Employee Leave Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/EmployeeLeaveReport.rdlc';

    dataset
    {
        dataitem("HR Leave Application"; "HR Leave Application")
        {
            RequestFilterFields = "Employee No", Status;

            column(CompanyInfoName; CompanyInfo.Name) { }
            column(CompanyInfoPicture; CompanyInfo.Picture) { }
            column(LeavePeriodFromTxt; PeriodStartTxt) { }
            column(LeavePeriodToTxt; PeriodEndTxt) { }
            column(Employee_No; "Employee No") { }
            column(Employee_Name; Names) { }
            column(Leave_Type; "Leave Type") { }
            column(Application_Date; "Application Date") { }
            column(Start_Date; "Start Date") { }
            column(End_Date; "End Date") { }
            column(Days_Applied; "Days Applied") { }
            column(Approved_Days; "Approved days") { }
            column(Status_Text; Format(Status)) { }
            column(Approval_DateTime; ApprovalDateTime) { }
            column(Approved_By; ApproverName) { }

            trigger OnPreDataItem()
            begin
                if PeriodStartFilter <> 0D then
                    SetFilter("End Date", '>=%1', PeriodStartFilter);
                if PeriodEndFilter <> 0D then
                    SetFilter("Start Date", '<=%1', PeriodEndFilter);
            end;

            trigger OnAfterGetRecord()
            begin
                GetApprovalInfo("Application Code");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(PeriodStart; PeriodStartFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Leave From Date';
                        ToolTip = 'Show only leave applications whose leave period overlaps this start date.';
                    }
                    field(PeriodEnd; PeriodEndFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Leave To Date';
                        ToolTip = 'Show only leave applications whose leave period overlaps this end date.';
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);

        if PeriodStartFilter <> 0D then
            PeriodStartTxt := Format(PeriodStartFilter)
        else
            PeriodStartTxt := 'Earliest';

        if PeriodEndFilter <> 0D then
            PeriodEndTxt := Format(PeriodEndFilter)
        else
            PeriodEndTxt := 'Latest';
    end;

    var
        CompanyInfo: Record "Company Information";
        PeriodStartFilter: Date;
        PeriodEndFilter: Date;
        PeriodStartTxt: Text[30];
        PeriodEndTxt: Text[30];
        ApprovalDateTime: DateTime;
        ApproverName: Text[100];

    local procedure GetApprovalInfo(ApplicationCode: Code[20])
    var
        ApprovalEntry: Record "Approval Entry";
        ApproverEmp: Record "HR Employees";
    begin
        Clear(ApprovalDateTime);
        ApproverName := '';

        ApprovalEntry.Reset();
        ApprovalEntry.SetRange("Table ID", Database::"HR Leave Application");
        ApprovalEntry.SetRange("Document No.", ApplicationCode);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
        if ApprovalEntry.FindLast() then begin
            ApprovalDateTime := ApprovalEntry."Last Date-Time Modified";
            ApproverName := ApprovalEntry."Approver ID";
            ApproverEmp.Reset();
            ApproverEmp.SetRange("User ID", ApprovalEntry."Approver ID");
            if ApproverEmp.FindFirst() then
                ApproverName := ApproverEmp.FullName;
        end;
    end;
}
