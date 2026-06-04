namespace System.Automation;

page 50020 "Appraisal Approvals Activities"
{
    Caption = 'Appraisal Approvals';
    PageType = CardPart;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "Appraisal Header";

    layout
    {
        area(content)
        {
            cuegroup(Approvals)
            {
                Caption = 'Pending Appraisal Approvals';

                field("Requests to Approve"; ApprovalsNumber)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies requests for appraisals that you must approve for other users before they can proceed.';

                    trigger OnDrillDown()
                    var
                        AppraisalList: Page "Appraisal List";
                    begin
                        AppraisalsHeader.Reset();
                        // Apply the same filters used to calculate the count
                        AppraisalsHeader.SetRange("Immediate Supervisor", SupervisorNo);
                        AppraisalsHeader.SetRange(Status, AppraisalsHeader.Status::"Pending Supervisor Approval");

                        Clear(AppraisalList);
                        AppraisalList.SetTableView(AppraisalsHeader);
                        AppraisalList.Run();
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        CalculateCueValues();
    end;

    local procedure CalculateCueValues()
    begin
        ApprovalsNumber := 0;
        HREmployees.Reset();
        HREmployees.SetRange("User ID", UserId);
        if HREmployees.Find('-') then begin
            SupervisorNo := HREmployees."No.";
        end;

        AppraisalsHeader.Reset();
        AppraisalsHeader.SetRange("Immediate Supervisor", SupervisorNo);
        AppraisalsHeader.SetRange(Status, AppraisalsHeader.Status::"Pending Supervisor Approval");

        if AppraisalsHeader.FindSet() then
            ApprovalsNumber := AppraisalsHeader.Count();
    end;

    var
        ApprovalsNumber: Integer;
        AppraisalsHeader: Record "Appraisal Header";
        HREmployees: record "HR Employees";
        SupervisorNo: Code[20];
}