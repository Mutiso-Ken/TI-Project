#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50037 "TimeSheet Report Portal"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/TimeSheet Report Portal.rdlc';

    dataset
    {
        dataitem(TimesheetLines; TimesheetLines)
        {
            column(ReportForNavId_10; 10)
            {
            }
            column(From_TimesheetLines; TimesheetLines.From)
            {
            }
            column(EmployeeName_TimesheetLines; TimesheetLines."Employee Name")
            {
            }
            column(RequesterSignature_TimesheetLines; TimesheetLines."Requester Signature")
            {
            }
            column(Approver1Signature_TimesheetLines; TimesheetLines.Approver1Signature)
            {
            }
            column(Approver2Signature_TimesheetLines; TimesheetLines.Approver2Signature)
            {
            }
            column(Approver2Name; Approver2Name)
            {
            }
            column(Approver2Date; Approver2Date)
            {
            }
            column(RequesterDate; RequesterDate)
            {
            }
            column(Approver1Name; Approver1Name)
            {
            }
            column(Approver1Date; Approver1Date)
            {
            }
            column(RequesterName; RequesterName)
            {
            }
            dataitem("TE Time Sheet1"; "TE Time Sheet1")
            {
                DataItemLink = "Document No." = field(Timesheetcode);
                column(ReportForNavId_1000000000; 1000000000)
                {
                }
                column(CompanyName; CompanyInformation.Name)
                {
                }
                column(CompAddress; CompanyInformation.Address)
                {
                }
                column(CompAddress2; CompanyInformation."Address 2")
                {
                }
                column(CompEmail; CompanyInformation."E-Mail")
                {
                }
                column(CompHomePage; CompanyInformation."Home Page")
                {
                }
                column(Companypicture; CompanyInformation.Picture)
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
                column(Stamp; '')
                {
                }
                column(Name; Name)
                {
                }
                column(MonthHours; MonthHours)
                {
                }
                column(DocumentNo_TETimeSheet1; "TE Time Sheet1"."Document No.")
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
            }

            trigger OnAfterGetRecord()
            begin
                if TimesheetLines."Requester Signature".Hasvalue = false then begin
                    HREmployees.Reset;
                    HREmployees.SetRange(HREmployees."User ID", ApprovalEntry."Approver ID");
                    HREmployees.Get(TimesheetLines."Employee No");
                    HREmployees.CalcFields(HREmployees.Signature);
                    TimesheetLines."Requester Signature" := HREmployees.Signature;
                    RequesterName := HREmployees.FullName;



                end;
                ApprovalEntry.Reset;
                ApprovalEntry.SetRange("Document No.", TimesheetLines.Timesheetcode);
                ApprovalEntry.SetRange("Sequence No.", 1);
                if ApprovalEntry.FindFirst then begin
                    RequesterDate := ApprovalEntry."Date-Time Sent for Approval";

                end;

                if Approver1Name = '' then begin
                    ApprovalEntry.Reset;
                    ApprovalEntry.SetRange("Document No.", TimesheetLines.Timesheetcode);
                    ApprovalEntry.SetRange("Sequence No.", 1);
                    ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
                    if ApprovalEntry.FindFirst then begin
                        HREmployees.Reset;
                        HREmployees.SetRange(HREmployees."User ID", ApprovalEntry."Approver ID");
                        if HREmployees.FindFirst then begin
                            HREmployees.CalcFields(HREmployees.Signature);
                            TimesheetLines.Approver1Signature := HREmployees.Signature;
                            Approver1Name := HREmployees.FullName;
                            Approver1Date := ApprovalEntry."Last Date-Time Modified";
                        end;
                    end;
                end;

                if Approver2Name = '' then begin
                    ApprovalEntry.Reset;
                    ApprovalEntry.SetRange("Document No.", TimesheetLines.Timesheetcode);
                    ApprovalEntry.SetRange("Sequence No.", 2);
                    ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
                    if ApprovalEntry.FindFirst then begin
                        HREmployees.Reset;
                        HREmployees.SetRange(HREmployees."User ID", ApprovalEntry."Approver ID");
                        if HREmployees.FindFirst then begin
                            HREmployees.CalcFields(HREmployees.Signature);
                            TimesheetLines.Approver2Signature := HREmployees.Signature;
                            Approver2Name := HREmployees.FullName;
                            Approver2Date := ApprovalEntry."Last Date-Time Modified";
                        end;
                    end;
                end;
                TimesheetLines.Modify;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        //Period := "TE Time Sheet1".GETFILTER("TE Time Sheet1".Date);
        CompanyInformation.Get;
        CompanyInformation.CalcFields(Picture);
        //CompanyInformation.CalcFields("Official Stamp");
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
        RequesterDate: DateTime;
        Approver1Name: Text;
        Approver1Date: DateTime;
        HREmployees: Record "HR Employees";
        ApprovalEntry: Record "Approval Entry";
        Approver2Name: Text;
        Approver2Date: DateTime;
        RequesterName: Text;
}

