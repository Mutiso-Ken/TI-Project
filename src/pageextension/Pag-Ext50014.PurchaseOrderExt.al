namespace TISolution.TISolution;

using Microsoft.Purchases.Document;
using System.Automation;
using System.Security.User;

pageextension 50014 "Purchase Order Ext" extends "Purchase Order"
{
    layout
    {
        modify("Posting Description") { Visible = true; }
        modify("Buy-from") { Visible = false; }
        addafter("Vendor Shipment No.")
        {
            field("Requisition No"; Rec."Requisition No")
            {

                ApplicationArea = all;
            }
            field("Mission Proposal No"; Rec."Mission Proposal No")
            {
                ApplicationArea = all;
            }

        }
        //modify(totalta)


    }
    actions
    {

        modify(Approvals)
        {
            Visible = false;
        }
        modify(Release)
        {
            Visible = false;
        }
        addbefore(SendApprovalRequest)
        {
            action("View Requisition")
            {
                Image = OpenWorksheet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    Rec.TestField("Requisition No");
                    IF NOT CONFIRM('Are you sure you want to open the purchase requisition?') THEN
                        EXIT;
                    PurchaseHeader.RESET;
                    PurchaseHeader.SETRANGE("No.", Rec."Requisition No");
                    PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Quote);
                    PurchaseHeader.SETRANGE(PR, TRUE);
                    IF PurchaseHeader.FINDFIRST THEN BEGIN
                        PAGE.RUNMODAL(PAGE::"Purchase Quote", PurchaseHeader);
                    END;
                end;
            }
            action("View Procurement")
            {
                Image = OpenWorksheet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IF NOT CONFIRM('Are you sure you want to open the procurement document?') THEN
                        EXIT;
                    PurchaseHeader.RESET;
                    PurchaseHeader.SETRANGE("No.", Rec."No.");
                    IF PurchaseHeader.FINDFIRST THEN BEGIN
                        ProcurementRequest.RESET;
                        ProcurementRequest.SETRANGE("Generated Order No", PurchaseHeader."No.");
                        IF ProcurementRequest.FINDFIRST THEN BEGIN
                            CASE ProcurementRequest."Procurement Method" OF
                                ProcurementRequest."Procurement Method"::"Direct Procurement":
                                    BEGIN
                                        PAGE.RUNMODAL(PAGE::"Direct Procurement Card", ProcurementRequest);
                                    END;
                                ProcurementRequest."Procurement Method"::RFQ:
                                    BEGIN
                                        PAGE.RUNMODAL(PAGE::"Quotation Card", ProcurementRequest);
                                    END;
                                ProcurementRequest."Procurement Method"::RFP, ProcurementRequest."Procurement Method"::Tender:
                                    BEGIN
                                        // No dedicated RFP/Tender card exists; fall back to the general Procurement Request Card.
                                        PAGE.RUNMODAL(PAGE::"Procurement Request Card", ProcurementRequest);
                                    END;
                            END;
                        END;
                    END;
                end;
            }
            action("Print Purchase Requisition")
            {
                Image = PrintForm;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    Rec.TestField("Requisition No");
                    IF NOT CONFIRM('Are you sure you want to print the purchase requisition?') THEN
                        EXIT;
                    PurchaseHeader.RESET;
                    PurchaseHeader.SETRANGE("No.", Rec."Requisition No");
                    PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Quote);
                    PurchaseHeader.SETRANGE(PR, TRUE);
                    IF PurchaseHeader.FINDFIRST THEN BEGIN
                        REPORT.RUNMODAL(REPORT::"Purchase Requisition Document", TRUE, FALSE, PurchaseHeader);
                    END;
                end;
            }
            action("Print Procurement Document")
            {
                Image = PrintForm;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IF NOT CONFIRM('Are you sure you want to print the procurement document?') THEN
                        EXIT;
                    PurchaseHeader.RESET;
                    PurchaseHeader.SETRANGE("No.", Rec."No.");
                    PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Order);
                    IF PurchaseHeader.FINDFIRST THEN BEGIN
                        ProcurementRequest.RESET;
                        ProcurementRequest.SETRANGE("Generated Order No", PurchaseHeader."No.");
                        IF ProcurementRequest.FINDFIRST THEN BEGIN
                            CASE ProcurementRequest."Procurement Method" OF
                                ProcurementRequest."Procurement Method"::"Direct Procurement":
                                    BEGIN
                                        REPORT.RUNMODAL(REPORT::"TI Direct Procurement", TRUE, FALSE, ProcurementRequest);
                                    END;
                                ProcurementRequest."Procurement Method"::RFQ:
                                    BEGIN
                                        QuotationBidders.RESET;
                                        QuotationBidders.SETRANGE("Reference No", ProcurementRequest."No.");
                                        IF QuotationBidders.FINDFIRST THEN BEGIN
                                            REPORT.RUNMODAL(REPORT::"TI Request for Quotation", TRUE, FALSE, QuotationBidders);
                                        END;
                                    END;
                                ProcurementRequest."Procurement Method"::RFP, ProcurementRequest."Procurement Method"::Tender:
                                    BEGIN
                                        // No RFP/Tender-specific document exists; the general Procurement Request Document covers any method.
                                        REPORT.RUNMODAL(REPORT::"Procurement Request Document", TRUE, FALSE, ProcurementRequest);
                                    END;
                            END;
                        END;
                    END;
                end;
            }
        }
        addafter(Approvals)
        {
            action(Approvals1)
            {
                AccessByPermission = TableData "Approval Entry" = R;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Approvals';
                Image = Approvals;
                ToolTip = 'View the approval entries of the latest approval request for this order. Entries from earlier requests that were rejected or canceled and then resent are hidden.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    AppEntry: Record "Approval Entry";
                begin
                    AppEntry.Reset();
                    AppEntry.SetCurrentKey("Entry No.");
                    AppEntry.SetRange("Table ID", Database::"Purchase Header");
                    AppEntry.SetRange("Record ID to Approve", Rec.RecordId);
                    if not AppEntry.FindLast() then
                        Error('There are no approval entries for order %1. Send it for approval first.', Rec."No.");

                    // Only the latest request: every "Send Approval Request" gets its own Workflow Step Instance ID.
                    AppEntry.SetRange("Workflow Step Instance ID", AppEntry."Workflow Step Instance ID");
                    Page.Run(Page::"Document Approval Entries", AppEntry);
                end;
            }
        }
        modify(Reopen)
        {
            trigger OnBeforeAction()
            var
                UserSetup: Record "User Setup";
            begin
                UserSetup.Get(UserId);
                if UserSetup."Procurement Officer" = false then error('You have not been granted the rights to perform this function');
            end;
        }
        addafter(Reopen)
        {
            // The standard Reopen refuses a Pending Approval order. This one cancels the pending
            // approval request first (through the workflow, so its open entries are canceled and the
            // workflow instance is closed), then reopens the order so it can be edited and resent.
            action(ReopenDocument)
            {
                ApplicationArea = All;
                Caption = 'Reopen Document';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Reopen the order so it can be edited and sent for approval again. A pending approval request is canceled first.';
                Enabled = Rec.Status <> Rec.Status::Open;

                trigger OnAction()
                var
                    UserSetup: Record "User Setup";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    ReleasePurchDoc: Codeunit "Release Purchase Document";
                begin
                    if not UserSetup.Get(UserId) or not UserSetup."Procurement Officer" then
                        Error('You have not been granted the rights to perform this function');
                    if Rec.Status = Rec.Status::Open then
                        exit;
                    if not Confirm('Reopen order %1? Any pending approval request will be canceled.', false, Rec."No.") then
                        exit;

                    if Rec.Status = Rec.Status::"Pending Approval" then begin
                        ApprovalsMgmt.OnCancelPurchaseApprovalRequest(Rec);
                        Rec.Find();
                    end;

                    if Rec.Status <> Rec.Status::Open then
                        ReleasePurchDoc.Reopen(Rec);

                    CurrPage.Update(false);
                end;
            }
        }
        modify(SendApprovalRequest)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                Rec.TESTFIELD(Status, Rec.Status::Open);
                Rec.TESTFIELD("Posting Description");
                //TEstfiedl Mandatory
                PurchaseLine.RESET;
                PurchaseLine.SETRANGE("Document No.", Rec."No.");
                IF PurchaseLine.FINDFIRST THEN BEGIN
                    REPEAT
                        PurchaseLine.TESTFIELD("Direct Unit Cost");
                        PurchaseLine.TESTFIELD(Quantity);
                        PurchaseLine.TESTFIELD("Shortcut Dimension 1 Code");
                        PurchaseLine.TESTFIELD("Shortcut Dimension 2 Code");
                    // PurchaseLine.TESTFIELD(S);
                    // PurchaseLine.TESTFIELD("Activity Code");
                    //IanSoftFactory.FnBudgetControl(PurchaseLine."Grant No.",PurchaseLine."Activity Code",PurchaseLine."Budget G/L Account");
                    //PurchaseLine.TESTFIELD("Partner Code");
                    UNTIL PurchaseLine.NEXT = 0;
                END;
            end;
        }
        addafter(CancelApprovalRequest)
        {
            action("Validate Approval")
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    CustomEvents: Codeunit CustomEvents;
                begin
                    // Every entry of the current approval request must be Approved before this can release (and so post).
                    CustomEvents.CheckPurchDocFullyApproved(Rec);

                    Rec.Status := Rec.Status::Released;
                    Rec.Modify();
                end;
            }
        }
    }

    var
        PurchaseLine: Record "Purchase Line";

        ProcurementRequest: Record "Procurement Request";
        PurchaseHeader: Record "Purchase Header";
        QuotationBidders: Record "Quotation Bidders";

}

pageextension 60193 "Purchase Invoice" extends "Purchase Invoices"
{
    layout

    {

        modify("Status")
        {
            Visible = True;
        }

    }
}

