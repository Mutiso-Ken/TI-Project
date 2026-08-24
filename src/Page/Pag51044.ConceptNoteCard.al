page 51044 "Concept Note Card"
{
    SourceTable = "Concept Notes";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                }
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("Ending Date"; Rec."Ending Date")
                {
                }
                field(Status; Rec.Status)
                {
                    Caption = 'Stage';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                }
                field("Person Responsible"; Rec."Person Responsible")
                {
                }
                field("Type of Concept Note"; Rec."Type of Concept Note")
                {
                }

            }
            part(Objectives; "Concept Objectives")
            {
                Caption = 'Objectives';
                SubPageLink = Type = FILTER("Concept Note"),
                              "Concept Note" = FIELD("No.");
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Uploads")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Document Number" = FIELD("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send Approval Request")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    VarVariant := Rec;
                    IF CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) THEN
                        CustomApprovals.OnSendDocForApproval(VarVariant);
                end;
            }
            action("Cancel Approval Request")
            {
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    VarVariant := Rec;
                    IF CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) THEN
                        CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                end;
            }
            action(Approvals)
            {
                Image = Approvals;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    ApprovalMgt.OpenApprovalEntriesPage(Rec.RECORDID);
                end;
            }
        }
    }

    var
        CustomApprovals: Codeunit "Custom Approvals Codeunit";
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        VarVariant: Variant;
}
