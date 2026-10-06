#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50361 "Appraisal List"
{
    CardPageID = "Appraisal Card";
    PageType = List;
    SourceTable = "Appraisal Header";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Appraisal Code"; Rec."Appraisal Code")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ApplicationArea = Basic;
                }
                field("Review Period"; Rec."Review Period")
                {
                    ApplicationArea = Basic;
                }
                field("Supervisor Name"; Rec."Supervisor Name")
                {
                    Caption = 'Current Approving Supervisor';
                    ApplicationArea = Basic;
                }
                field(ApprovalSteps; Rec.ApprovalSteps)
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ClearStaleApprovers)
            {
                ApplicationArea = Basic;
                Caption = 'Clear Current Approvers (Open/Approved)';
                ToolTip = 'Clears the current approving supervisor on all appraisals that are open or approved. Appraisals pending approval are not changed.';
                Image = ClearLog;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    AppraisalHdr: Record "Appraisal Header";
                    Cleared: Integer;
                begin
                    if not Confirm('Clear the current approving supervisor on all appraisals that are open or approved? Appraisals pending approval will not be changed.') then
                        exit;
                    Cleared := AppraisalHdr.ClearStaleCurrentApprovers();
                    CurrPage.Update(false);
                    Message('%1 appraisal(s) updated.', Cleared);
                end;
            }
        }
    }
}

