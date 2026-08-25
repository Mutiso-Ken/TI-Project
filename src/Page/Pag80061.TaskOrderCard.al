#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 80061 "Task Order Card"
{
    Caption = 'Purchase Requisition';
    DeleteAllowed = true;
    PageType = Card;
    SourceTable = "Purchase Header";
    SourceTableView = where("Document Type" = const(Quote),
                            DocApprovalType = const(Requisition));
    ApplicationArea = All;
    PromotedActionCategories = ',,,Approvals,Attachments,Comments,Preview';

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Employee No"; Rec."Employee No")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Title; Rec.Title)
                {
                    ApplicationArea = Basic;
                }
                field("Requested Receipt Date"; Rec."Requested Receipt Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Requested Delivery Date';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Procurement Method"; Rec."Procurement Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the intended procurement route for this requisition''s lines (set per line, or here as a default).';
                }
                field("Requisition Date"; Rec."Created On")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Approval Entries"; Rec."Approval Entries")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Process Initiated"; Rec."Process Initiated")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            part(PurchLines; "Requisition Subform")
            {
                Caption = 'Purchase Requisition Lines';
                SubPageLink = "Document No." = field("No.");
                ApplicationArea = All;
            }
        }
        area(factboxes)
        {
            systempart(Control5; Notes)
            {
                Visible = true;
            }
            part("Attached Documents"; "Document Uploads")
            {
                ApplicationArea = Basic;
                Caption = 'Attachments';
                SubPageLink = "Document Number" = field("No.");
            }
            systempart(Control17; Links)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Approvals)
            {
                action("Send Approval Request")
                {
                    ApplicationArea = Basic, Suite;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Request approval of the document.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        Rec.TestField(Title);
                        Rec.TestField("Shortcut Dimension 2 Code");
                        if not Confirm('Are you sure you want to send it for approval?') then
                            exit;

                        if ApprovalsMgmt.CheckPurchaseApprovalPossible(Rec) then
                            ApprovalsMgmt.OnSendPurchaseDocForApproval(Rec);
                    end;
                }
                action(ApprovalsEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'View the pending or open approval entries for this document.';
                    // Visible = OpenApprovalEntriesExist;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        ApprovalEntries.SetRecordFilters(Database::"Purchase Header", Rec."Document Type", Rec."No.");
                        ApprovalEntries.Run;
                    end;
                }
                action("Cancel Approval Request")
                {
                    ApplicationArea = Basic;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::"Pending Approval");
                        IF NOT CONFIRM('Are you sure you want to cancel approval request?') THEN
                            EXIT;
                        ApprovalEntry.Reset();
                        ApprovalEntry.SetRange("Document No.", rec."No.");
                        if ApprovalEntry.FindSet() then begin
                            repeat
                                ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                                ApprovalEntry.Modify(true);
                            until ApprovalEntry.Next() = 0;
                        end;
                        rec.Status := Rec.Status::Open;
                        rec.Modify(true);
                        CurrPage.CLOSE();
                    end;
                }
                action("Re-Open Document")
                {
                    ApplicationArea = Basic;
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        ReleasePurchDoc: Codeunit "Release Purchase Document";
                    begin
                        Rec.TESTFIELD("Process Initiated", FALSE);
                        ReleasePurchDoc.PerformManualReopen(Rec);
                    end;
                }
                action("Validate Approval")
                {
                    ApplicationArea = Basic;

                    trigger OnAction()
                    var
                        AppEntry: Record "Approval Entry";
                        ReleasePurchDoc: Codeunit "Release Purchase Document";
                    begin
                        AppEntry.reset;
                        AppEntry.setrange("Document No.", Rec."No.");
                        AppEntry.setrange("Table ID", Database::"Purchase Header");
                        AppEntry.Setrange(Status, AppEntry.Status::Open);
                        if not AppEntry.find('-') then
                            ReleasePurchDoc.PerformManualRelease(Rec);
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
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
                            EXIT;
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                        CurrPage.CLOSE();
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

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        IF NOT CONFIRM('Are you sure you want to Reject the document?') THEN
                            EXIT;
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RECORDID);
                        CurrPage.CLOSE;
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

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        IF NOT CONFIRM('Are you sure you want to delegate approval of the document?') THEN
                            EXIT;
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RECORDID);
                        CurrPage.CLOSE();
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category6;
                    ToolTip = 'View or add comments for the record.';

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
                action(Attachments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Attachments';
                    Image = Attach;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "Document Uploads";
                    RunPageLink = "Document Number" = field("No.");
                    ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';
                }
                action("&Print")
                {
                    ApplicationArea = Basic;
                    Caption = '&Print';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Report;
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        Rec.RESET;
                        Rec.SETRANGE("No.", Rec."No.");
                        REPORT.RUN(REPORT::"Purchase Requisition Document", TRUE, FALSE, Rec);
                    end;
                }
                action("Preview Order No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Preview Order No.';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction();
                    begin
                        LinkedPurchaseHeader.RESET;
                        LinkedPurchaseHeader.SETRANGE("Requisition No", Rec."No.");
                        IF LinkedPurchaseHeader.FINDFIRST THEN BEGIN
                            MESSAGE('This requisition is attached to Purchase Order No: %1 with the Status: %2', LinkedPurchaseHeader."No.", LinkedPurchaseHeader.Status);
                        END ELSE
                            ERROR('No purchase order exists for this document yet');
                    end;
                }
            }
            group("Procurement Processing")
            {
                action("Create Procurement Process")
                {
                    ApplicationArea = Basic;
                    Image = Start;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Send this approved requisition''s lines into Procurement (Tender/RFQ/Direct Procurement/RFP), grouped per line by their Procurement Method.';

                    trigger OnAction();
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Released);
                        Rec.TESTFIELD("Process Initiated", FALSE);
                        PurchLineRFQ.RESET;
                        PurchLineRFQ.SETRANGE("Document Type", Rec."Document Type");
                        PurchLineRFQ.SETRANGE("Document No.", Rec."No.");
                        IF PurchLineRFQ.FINDSET THEN
                            REPEAT
                                PurchLineRFQ.TESTFIELD("Total Amount");
                                PurchLineRFQ.TestField("Procurement Method");
                            UNTIL PurchLineRFQ.NEXT = 0;

                        IF NOT CONFIRM('Are you sure you want to start procurement process?') THEN
                            EXIT;

                        ProcurementNo := ProcStoreManagement.IanInitiateProcurementProcess(Rec);
                        IF ProcurementNo <> '' THEN BEGIN
                            MESSAGE('Procurement No. [%1] has been created', ProcurementNo);
                            Rec."Process Initiated" := TRUE;
                            Rec.MODIFY(TRUE);
                            OpenProcurementRequestCard(ProcurementNo);
                        END ELSE
                            MESSAGE('No lines had a Procurement Method set - nothing was sent to Procurement.');
                        CurrPage.CLOSE();
                    end;
                }
                action("Archive Document")
                {
                    ApplicationArea = Basic;
                    Image = Archive;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        IF NOT CONFIRM('Are you sure you want to archive this document?') THEN
                            EXIT;
                        Rec.Archived := true;
                        Rec.Modify();
                        Message('Document archived successfully!');
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        SetControlAppearance;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        Rec."Created On" := TODAY;
        Rec.DocApprovalType := Rec.DocApprovalType::Requisition;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        PurchasesPayablesSetup.Get;
        Rec."Doc Type" := Rec."doc type"::PurchReq;
        Rec."No." := NoSeriesManagement.GetNextNo(PurchasesPayablesSetup."Requisition Nos.", Today, true);
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter;
        Rec."Assigned User ID" := UserId;
        Rec."User ID" := UserId;
        Rec."Requested Receipt Date" := Today;
        Rec."Buy-from Vendor No." := 'FM-V00123';
        Rec."Vendor Posting Group" := 'TRADERS';
        Rec.PR := true;
        Rec.Requisition := true;
    end;

    trigger OnOpenPage();
    begin
        if UserMgt.GetPurchasesFilter <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgt.GetPurchasesFilter);
            Rec.FilterGroup(0);
        end;
        Rec."Doc Type" := Rec."doc type"::PurchReq;
        Rec."Assigned User ID" := UserId;
        Rec.Requisition := true;
        SetControlAppearance;
    end;

    var
        OpenApprovalEntriesExistCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ProcStoreManagement: Codeunit "Proc & Store Management";
        ProcurementNo: Code[50];
        PurchLineRFQ: Record "Purchase Line";
        ApprovalEntry: Record "Approval Entry";
        LinkedPurchaseHeader: Record "Purchase Header";
        UserMgt: Codeunit "User Setup Management";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";

    local procedure SetControlAppearance();
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
    end;

    local procedure OpenProcurementRequestCard(ProcurementNo: Code[50])
    var
        ProcurementRequest: Record "Procurement Request";
        DirectProcurementCard: Page "Direct Procurement Card";
        QuotationCard: Page "Quotation Card";
        ProcurementRequestCard: Page "Procurement Request Card";
    begin
        if not ProcurementRequest.Get(ProcurementNo) then
            exit;

        case ProcurementRequest."Procurement Method" of
            ProcurementRequest."Procurement Method"::"Direct Procurement":
                begin
                    DirectProcurementCard.SetRecord(ProcurementRequest);
                    DirectProcurementCard.Run();
                end;
            ProcurementRequest."Procurement Method"::RFQ:
                begin
                    QuotationCard.SetRecord(ProcurementRequest);
                    QuotationCard.Run();
                end;
            else begin
                // Tender or RFP - no dedicated card exists.
                ProcurementRequestCard.SetRecord(ProcurementRequest);
                ProcurementRequestCard.Run();
            end;
        end;
    end;
}
