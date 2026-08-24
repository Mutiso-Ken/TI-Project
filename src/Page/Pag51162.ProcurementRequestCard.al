page 51162 "Procurement Request Card"
{
    PageType = Card;
    SourceTable = "Procurement Request";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                }
                field(Title; Rec.Title)
                {
                }
                field("Procurement Method"; Rec."Procurement Method")
                {
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field("Requisiton No"; Rec."Requisiton No")
                {
                }
                field("Current Budget"; Rec."Current Budget")
                {
                }
                field("Supplier Category"; Rec."Supplier Category")
                {
                }
                field("Procurement Plan"; Rec."Procurement Plan")
                {
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                }
                field("Requires Inspection"; Rec."Requires Inspection")
                {
                }
                field("Total Amount"; Rec."Total Amount")
                {
                }
                field("Source of Funds"; Rec."Source of Funds")
                {
                }
                field("Created By"; Rec."Created By")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
            }
            group("Tender Details")
            {
                Caption = 'Tender Details';
                field("Tender Type"; Rec."Tender Type")
                {
                }
                field("Tender Status"; Rec."Tender Status")
                {
                }
                field("Tender Opening Date"; Rec."Tender Opening Date")
                {
                }
                field("Tender Duration"; Rec."Tender Duration")
                {
                }
                field("Tender Closing Date"; Rec."Tender Closing Date")
                {
                }
                field("Extended Closing Date"; Rec."Extended Closing Date")
                {
                }
                field("Extension Period"; Rec."Extension Period")
                {
                }
                field("Tender Security Amount"; Rec."Tender Security Amount")
                {
                }
                field("Minimum No. of Suppliers"; Rec."Minimum No. of Suppliers")
                {
                }
                field(Advertised; Rec.Advertised)
                {
                }
                field("Date of Advertisement"; Rec."Date of Advertisement")
                {
                }
            }
            group("RFQ Details")
            {
                Caption = 'RFQ Details';
                field("Quotation Status"; Rec."Quotation Status")
                {
                }
                field("RFQ Deadlne Date"; Rec."RFQ Deadlne Date")
                {
                }
                field("RFQ Deadline Time"; Rec."RFQ Deadline Time")
                {
                }
                field("RFQ Com. Analysis Initiated"; Rec."RFQ Com. Analysis Initiated")
                {
                }
            }
            group("Evaluation & Award")
            {
                Caption = 'Evaluation & Award';
                field("Technical Pass Mark"; Rec."Technical Pass Mark")
                {
                }
                field("Tender Max Score"; Rec."Tender Max Score")
                {
                }
                field("Technical Score"; Rec."Technical Score")
                {
                }
                field("Financial Score"; Rec."Financial Score")
                {
                }
                field("Vendor No"; Rec."Vendor No")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field("Awarded Vendor No"; Rec."Awarded Vendor No")
                {
                }
                field("Date Awarded"; Rec."Date Awarded")
                {
                }
                field("Reason For Vendor Selection"; Rec."Reason For Vendor Selection")
                {
                }
                field("Generated Order No"; Rec."Generated Order No")
                {
                }
                field("Contract No Generated"; Rec."Contract No Generated")
                {
                }
                field(Archives; Rec.Archives)
                {
                }
            }
            group(Termination)
            {
                Caption = 'Termination';
                field("Terminated By"; Rec."Terminated By")
                {
                }
                field("Date of termination"; Rec."Date of termination")
                {
                }
                field("Reason For Termination"; Rec."Reason For Termination")
                {
                }
            }
            part("Lines"; "Quotation Lines Subform")
            {
                Caption = 'Lines';
                SubPageLink = "Procurement No" = FIELD("No.");
            }
            part("Bidders"; "Quotation Bidders Part")
            {
                Caption = 'Invited / Bidding Vendors';
                SubPageLink = "Reference No" = FIELD("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Approvals)
            {
                Caption = 'Approvals';
                Image = Approvals;

                action("Send Approval Request")
                {
                    ApplicationArea = All;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Request approval of this procurement request.';
                    Visible = Rec.Status = Rec.Status::New;

                    trigger OnAction()
                    begin
                        Rec.TestField("Procurement Method");
                        Rec.TestField(Status, Rec.Status::New);
                        if not Confirm('Are you sure you want to send it for approval?') then
                            exit;

                        Variant := Rec;
                        if CustomApprovalsCodeunit.CheckApprovalsWorkflowEnabled(Variant) then
                            CustomApprovalsCodeunit.OnSendDocForApproval(Variant);
                    end;
                }
                action("Cancel Approval Request")
                {
                    ApplicationArea = All;
                    Caption = 'Cancel Approval Re&quest';
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Cancel the pending approval request.';
                    Visible = Rec.Status = Rec.Status::"Pending Approval";

                    trigger OnAction()
                    begin
                        Rec.TestField(Status, Rec.Status::"Pending Approval");
                        if not Confirm('Are you sure you want to cancel the approval request?') then
                            exit;

                        Variant := Rec;
                        if CustomApprovalsCodeunit.CheckApprovalsWorkflowEnabled(Variant) then
                            CustomApprovalsCodeunit.OnCancelDocApprovalRequest(Variant);
                    end;
                }
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Approve the requested procurement request.';
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if not Confirm('Are you sure you want to Approve the document?') then
                            exit;
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Reject the approval request.';
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if not Confirm('Are you sure you want to Reject the document?') then
                            exit;
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = All;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Delegate the approval to a substitute approver.';
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if not Confirm('Are you sure you want to delegate approval of the document?') then
                            exit;
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(ApprovalEntries)
                {
                    ApplicationArea = All;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'View the approval entries for this procurement request.';

                    trigger OnAction()
                    begin
                        ApprovalEntry.Reset();
                        ApprovalEntry.SetRange("Table ID", Database::"Procurement Request");
                        ApprovalEntry.SetRange("Document No.", Rec."No.");
                        Page.Run(Page::"Approval Entries", ApprovalEntry);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'View or add comments for the record.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
            action("&Print")
            {
                ApplicationArea = All;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Print the Procurement Request Document.';

                trigger OnAction()
                var
                    ProcurementRequest: Record "Procurement Request";
                begin
                    ProcurementRequest.SetRange("No.", Rec."No.");
                    Report.Run(Report::"Procurement Request Document", true, false, ProcurementRequest);
                end;
            }
            group("Procurement Award")
            {
                Caption = 'Award & Order';
                Image = MakeOrder;

                action("Award & Generate Order")
                {
                    ApplicationArea = All;
                    Caption = 'Award && Generate Order';
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Create a real Purchase Order from this awarded Procurement Request, carrying its lines and linking back to the original Task Order.';

                    trigger OnAction()
                    var
                        ProcurementProcessMgmt: Codeunit "Procurement Process Mgmt.";
                        NewPurchHeader: Record "Purchase Header";
                        AwardedVendorNo: Code[20];
                    begin
                        ProcurementProcessMgmt.ValidateAwardEligibility(Rec);
                        AwardedVendorNo := ProcurementProcessMgmt.DetermineAwardedVendor(Rec);
                        if not Confirm('Generate a Purchase Order for vendor %1 totaling %2? This cannot be undone.', false, AwardedVendorNo, Rec."Total Amount") then
                            exit;
                        ProcurementProcessMgmt.CreatePurchaseHeader(Rec, AwardedVendorNo, NewPurchHeader);
                        ProcurementProcessMgmt.CreatePurchaseLines(Rec, NewPurchHeader);
                        ProcurementProcessMgmt.StampCompletion(Rec, NewPurchHeader."No.");
                        Message('Purchase Order %1 has been generated from %2.', NewPurchHeader."No.", Rec."No.");
                        Page.Run(Page::"Purchase Order", NewPurchHeader);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateApprovalVisibility();
    end;

    trigger OnOpenPage()
    begin
        UpdateApprovalVisibility();
    end;

    var
        CustomApprovalsCodeunit: Codeunit "Custom Approvals Codeunit";
        ApprovalEntry: Record "Approval Entry";
        Variant: Variant;
        OpenApprovalEntriesExistCurrUser: Boolean;

    local procedure UpdateApprovalVisibility()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
    end;
}
