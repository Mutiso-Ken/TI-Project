#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 //  ForNAV settings
Page 20365 "Appraisal Card"
{
    PageType = Card;
    SourceTable = "Appraisal Header";
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Category6_caption,Category7_caption,Category8_caption,Category9_caption,Category10_caption';

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Appraisal Code"; Rec."Appraisal Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Employee No"; Rec."Employee No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Deparment"; Rec."Employee Deparment")
                {
                    ApplicationArea = Basic;
                }
                field(ApprovalSteps; Rec.ApprovalSteps)
                {
                    Caption = 'Approval Steps';
                    ApplicationArea = Basic;
                }
                field("Supervisor Name"; Rec."Supervisor Name")
                {
                    Caption = 'Current Approving Supervisor';
                    ApplicationArea = Basic;
                }
                field("Review Period"; Rec."Review Period")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = StatusEdit;
                }
                field("Overall Score"; Rec."Overall Score")
                {
                    ApplicationArea = Basic;
                }
                // field("Part A"; Rec."Part A")
                // {
                //     ApplicationArea = Basic;
                // }
                // field("Part C"; Rec."Part C")
                // {
                //     ApplicationArea = Basic;
                // }
                // field("Part D"; Rec."Part D")
                // {
                //     ApplicationArea = Basic;
                // }
            }

            label("SECTION A")
            {
                ApplicationArea = Basic, Suite;
                Style = Strong;
                Caption = 'SECTION A: PERFORMANCE RESULTS (MEASURES 5 CORE RESULTS) 50 MARKS';
            }
            part("Appraisal Section A Part 1"; "Appraisal Section A Part 1")
            {
                Caption = '';
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }
            part("Appraisal Section A Part 2"; "Appraisal Section A Part 2")
            {
                Caption = '';
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }

            label("SECTION B")
            {
                ApplicationArea = Basic, Suite;
                Style = Strong;
                Caption = 'SECTION B: PERFORMANCE RESULTS (MEASURES 5 CORE RESULTS) 50 MARKS';
            }
            part(Section1; "Appraisal Section B Part 1")
            {
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }
            part(Section2; "Appraisal Section B Part 2")
            {
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }
            part(Section3; "Appraisal Section B Part 3")
            {
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }
            part(Section4; "Appraisal Section B Part 4")
            {
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }
            label("SECTION C")
            {
                ApplicationArea = Basic, Suite;
                Style = Strong;
                Caption = 'SECTION C: VALUES AND COMPETENCIES (TECHNICAL & BEHAVIOURAL) (25 MARKS)';
            }
            part(SectionC1; "Appraisal Section C Part 1")
            {
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }
            part(SectionC2; "Appraisal Section C Part 2")
            {
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }
            part(SectionC3; "Appraisal Section C Part 3")
            {
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }
            part(SectionC4; "Appraisal Section C Part 4")
            {
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }
            part(SectionC5; "Appraisal Section C Part 5")
            {
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }
            label("SECTION D")
            {
                ApplicationArea = Basic, Suite;
                Style = Strong;
                Caption = 'SECTION D: PERSONAL QUALITIES: 25 MARKS (TO BE FILLED BY THE SUPERVISOR)';
            }
            part(SectionD1; "Appraisal Section D Part 1")
            {
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
                Editable = MakeSupervisorEditingTrue;
            }
            part(SectionD2; "Appraisal Section D Part 2")
            {
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
                Editable = MakeSupervisorEditingTrue;
            }
            part(SectionD3; "Appraisal Section D Part 3")
            {
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
                Editable = MakeSupervisorEditingTrue;
            }
            part(SectionD4; "Appraisal Section D Part 4")
            {
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
                Editable = MakeSupervisorEditingTrue;
            }
            part(SectionD5; "Appraisal Section D Part 5")
            {
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
                Editable = MakeSupervisorEditingTrue;
            }
            group("Comments")
            {
                field("Employee Comments"; Rec."Employee Comments")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Immediate Supervisor Comments"; Rec."Immediate Supervisor Comments")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("General Appraiser Comments"; Rec."General Appraiser Comments")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Head Comments"; Rec."Head Comments")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("HR Comments"; Rec."HR Comments")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("ED Comments"; Rec."ED Comments")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Approval)
            {
                Caption = 'Approval';

                action(SendApprovalRequest)
                {
                    ApplicationArea = All;
                    Caption = 'Send For Approval';
                    Image = SendApprovalRequest;
                    ToolTip = 'Send appraisal For Approval for the specified period.';
                    Visible = MakeAppraiseeEditingTrue;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;



                    trigger OnAction()
                    begin
                        if Confirm('Are you sure you want to send this appraisal for approval?') then begin
                            if Rec.Status <> rec.Status::Open then
                                Error('You cannot send the appraisal for approval at this moment!');
                            AppraisalHeader.SendForApproval();
                        end;
                    end;
                }
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    ToolTip = 'Approve the employee appraisal for the specified period.';
                    Visible = MakeSupervisorEditingTrue;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;



                    trigger OnAction()
                    begin
                        if Confirm('Are you sure you want to approve this appraisal?') then begin
                            Rec.UpdateApprovalSteps();
                            Rec.ApproveDocument(Rec."Immediate Supervisor");
                            Rec.UpdateApprovalWorkflow();
                        end;
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    ToolTip = 'Reject the employee appraisal for the specified period.';
                    Visible = MakeSupervisorEditingTrue;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        if Confirm('Are you sure you want to reject this appraisal?') then begin
                            Rec.UpdateApprovalSteps();
                            Rec.RejectDocument(Rec."Immediate Supervisor");
                            Rec.UpdateApprovalWorkflow();
                        end;
                    end;
                }

                action("&Print")
                {
                    ApplicationArea = Basic;
                    Caption = '&Print';
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    // Visible = false;

                    trigger OnAction()
                    begin
                        // if LinesCommitted then
                        //     Error('All Lines should be committed');
                        Rec.Reset;
                        Rec.SetRange("Appraisal Code", Rec."Appraisal Code");
                        Report.Run(50038, true, true, Rec);
                        Rec.Reset;
                        //DocPrint.PrintPurchHeader(Rec);
                    end;
                }
                action("Update")
                {
                    ApplicationArea = Basic;
                    Caption = 'Update Appraisal Approvers';
                    Ellipsis = true;
                    Image = UpdateDescription;
                    Promoted = true;
                    PromotedCategory = Process;
                    // Visible = false;

                    trigger OnAction()
                    begin
                        Message(UpdateApprisalApprovers());
                    end;
                }
                action("View Approval Entries")
                {
                    ApplicationArea = Basic;
                    Ellipsis = true;
                    Image = ApplyEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    // Visible = false;


                    RunObject = page "Appraisal Approval Tracking";
                    RunPageLink = "Appraisal Code" = field("Appraisal Code");
                }
            }
        }
    }


    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        HrSetup.Get;
        HRsetup.TestField("Appraisal Nos.");
        Rec."Appraisal Code" := NoSeriesManagement.GetNextNo(HrSetup."Appraisal Nos.", Today, true);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        Rec.Validate("Overall Score");
        SetControlAppearance();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Rec.Validate("Overall Score");
    end;

    local procedure SetControlAppearance()
    begin
        if Rec.Status = rec.Status::"Pending Supervisor Approval" then begin
            HREmployees.Reset();
            if HREmployees.Get(Rec."Immediate Supervisor") then begin
                if HrEmployees."User ID" = UserId then
                    MakeSupervisorEditingTrue := true;
            end;
        end;
        if Rec.Status = rec.Status::Open then begin
            HREmployees.Reset();
            if HREmployees.Get(Rec."Employee No") then begin
                if HrEmployees."User ID" = UserId then
                    MakeAppraiseeEditingTrue := true;
            end;
        end;
    end;

    local procedure UpdateApprisalApprovers(): Text
    begin
        // if AppraisalHeader.Get(Rec."Appraisal Code") then
        Rec.UpdateApprovalWorkflow();
        exit('Record approval workflow is okay!');
        // StatusEdit := true;
    end;

    var
        HrSetup: Record "HR Setup";
        NoSeriesManagement: Codeunit "No. Series";
        AppraisalLinesSectionA: record "Appraisal Lines Section A";
        AppraisalLinesSectionB: record "Appraisal Lines Section B";
        AppraisalLinesSectionC: record "Appraisal Lines Section C";
        AppraisalLinesSectionD: record "Appraisal Lines Section D";
        MakeSupervisorEditingTrue: Boolean;
        MakeAppraiseeEditingTrue: Boolean;
        StatusEdit: Boolean;
        HrEmployees: Record "HR Employees";
        AppraisalApprovalsTracking: Record "Appraisal Approvals Tracking";
        Portalcodeunit: Codeunit PortalEntry;
        AppraisalHeader: Record "Appraisal Header";
}

