page 67031 "Quotation Card"
{
    // version Procurement Iansoft

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Procurement Request";
    ApplicationArea = All;
    PromotedActionCategories = ',,,ReOpen,Attachments';

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
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field(Title; Rec.Title)
                {
                    Editable = false;
                }
                field("Requisiton No"; Rec."Requisiton No")
                {
                    Editable = false;
                }
                field("Supplier Category"; Rec."Supplier Category")
                {
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = false;
                }
                field("Expected Delivery Date"; Rec."Expected Delivery Date")
                {
                }
                field("RFQ Deadlne Date"; Rec."RFQ Deadlne Date")
                {
                }
                field("RFQ Deadline Time"; Rec."RFQ Deadline Time")
                {
                }

                field("Reason For Vendor Selection"; Rec."Reason For Vendor Selection")
                {
                }
            }
            part("Quotation Lines Subform"; "Quotation Lines Subform")
            {
                //Editable = false;
                SubPageLink = "Procurement No" = FIELD("No.");
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Uploads")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Document Number" = field("No.");
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
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = Rec.Status = Rec.Status::New;

                    trigger OnAction();
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::New);
                        IF NOT CONFIRM('Are you sure you want to send it for approval?') THEN
                            EXIT;

                        Variant := Rec;
                        IF ApprovalsMgmt.CheckApprovalsWorkflowEnabled(Variant) THEN
                            ApprovalsMgmt.OnSendDocForApproval(Variant);
                        CurrPage.CLOSE();
                    end;
                }
                action("Cancel Approval Request")
                {
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = Rec.Status = Rec.Status::"Pending Approval";
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::"Pending Approval");
                        IF NOT CONFIRM('Are you sure you want to cancel approval request?') THEN
                            EXIT;
                        ApprovalEntry.RESET;
                        ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                        IF ApprovalEntry.FINDSET THEN BEGIN
                            ApprovalEntry.DELETEALL;
                            Rec.Status := Rec.Status::New;
                            IF Rec.MODIFY(TRUE) THEN BEGIN
                                MESSAGE('Approval has been cancelled');
                            END;
                        END;
                        Variant := Rec;
                        IF ApprovalsMgmt.CheckApprovalsWorkflowEnabled(Variant) THEN
                            ApprovalsMgmt.OnCancelDocApprovalRequest(Variant);
                        CurrPage.CLOSE();
                    end;
                }
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistCurrUser;
                    PromotedIsBig = true;
                    ToolTip = 'Approve the requested changes.';

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
                        IF NOT CONFIRM('Are you sure you want to Approve the document?') THEN
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
                    PromotedCategory = Category4;
                    ToolTip = 'View or add comments for the record.';
                    Visible = true;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
            group("Quotation Processing")
            {
                action(Suppliers)
                {
                    Image = Vendor;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Quotation Bidders";
                    RunPageLink = "Reference No" = FIELD("No."),
                                  "Vendor Category" = FIELD("Supplier Category");

                    trigger OnAction();
                    begin
                        Rec.TESTFIELD("Supplier Category");
                    end;
                }
                action("Send To Portal")
                {
                    Image = Start;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = true;

                    trigger OnAction();
                    begin
                        //TESTFIELD("Quotation Status", "Quotation Status"::"Supplier Invitation");
                        IF NOT CONFIRM('Are you sure you want to send Emails to suppliers?') THEN
                            EXIT;

                        QuotationBidders.RESET;
                        QuotationBidders.SETRANGE("Reference No", Rec."No.");
                        //QuotationBidders.SETRANGE("Email Sent", FALSE);
                        IF QuotationBidders.FINDSET THEN BEGIN
                            REPEAT
                                QuotationBidders.TESTFIELD("E-mail Address");
                                SendQuotesToSuppliers(QuotationBidders, Rec."No.", Rec."Vendor No");
                                QuotationBidders."Email Sent" := TRUE;
                                QuotationBidders.MODIFY(TRUE);
                            UNTIL QuotationBidders.NEXT = 0;
                        END;

                        rec.Advertised := true;
                        rec."Quotation Status" := Rec."Quotation Status"::"Supplier Invitation";
                        rec.Modify(true);
                        Message('RFQ sent to portal sucessfully');
                    end;
                }
                action("End Evaluation & Suggest Winner")
                {
                    Image = CalculateLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        QuotationBidders: Record "Quotation Bidders";
                    begin
                        //Test if A winner exists
                        ProcurementRequestLines.RESET;
                        ProcurementRequestLines.SETRANGE("Procurement No", Rec."No.");
                        ProcurementRequestLines.SETFILTER("Vendor To Award", '<>%1', '');
                        IF ProcurementRequestLines.FINDFIRST THEN
                            ERROR('A winner has already been Indentified');
                        //End of Test

                        IF NOT CONFIRM('Are you sure you want to end the evaluation stage and award the vendor?') THEN
                            EXIT;
                        QuotationBidders.Reset();
                        QuotationBidders.SetRange("Reference No", Rec."No.");
                        QuotationBidders.SetRange("Award Vendor", true);
                        if QuotationBidders.Find('-') then begin
                            Winner := QuotationBidders."Vendor No.";
                            QuotationBidders.CalcFields("Total Quoted Amount");
                            WinnerAmount := QuotationBidders."Total Quoted Amount";
                        end else
                            Error('Kindly award atleast one bidder/vendor');
                        //Winner := ProcStoreManagement.IanGetTheLeastQuotedAmount(Rec."No.");
                        //WinnerAmount := ProcStoreManagement.IanGetTheLeastQuotedVendorAmount(Rec."No.");

                        ProcurementRequestLines.RESET;
                        ProcurementRequestLines.SETRANGE("Procurement No", Rec."No.");
                        IF ProcurementRequestLines.FINDSET THEN BEGIN
                            REPEAT
                                ProcurementRequestLines."Vendor To Award" := Winner;
                                ProcurementRequestLines."Unit Price" := WinnerAmount;
                                ProcurementRequestLines.VALIDATE("Unit Price");
                                ProcurementRequestLines.MODIFY(TRUE);
                            UNTIL ProcurementRequestLines.NEXT = 0;
                        END;

                        MESSAGE('Process successfully completed');
                    end;
                }

                action(Attachments)
                {
                    Image = Documents;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page "Document Uploads";
                    RunPageLink = "Document Number" = FIELD("No.");
                }
                action("Pick Committee Members")
                {
                    Image = Users;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        RFQCommitteeMembers.RESET;
                        RFQCommitteeMembers.SETRANGE("RFQ No.", Rec."No.");
                        PAGE.RUNMODAL(67143, RFQCommitteeMembers);
                    end;
                }
                action("Start Commitee Analysis")
                {
                    Image = Start;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        Rec.TESTFIELD("Quotation Status", Rec."Quotation Status"::"Supplier Invitation");
                        IF NOT Confirm('Do you want to initiate the committee evaluation?', TRUE) THEN
                            EXIT;
                        RFQCommitteeEvaluation.RESET;
                        RFQCommitteeEvaluation.SETRANGE("RFQ No.", Rec."No.");
                        PAGE.RUNMODAL(67135, RFQCommitteeEvaluation);


                        Rec."RFQ Com. Analysis Initiated" := TRUE;
                        Rec.MODIFY(TRUE);
                    end;
                }
                action("Award & Generate Order")
                {
                    Image = "Order";
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        LineNo: Integer;
                    begin
                        IF NOT CONFIRM('Are you sure you want to create purchase order for the awarded vendors?') THEN
                            EXIT;

                        ProcurementRequestLinesCopy.RESET;
                        ProcurementRequestLinesCopy.SETRANGE("Procurement No", Rec."No.");
                        IF ProcurementRequestLinesCopy.FINDSET THEN BEGIN
                            //    ProcurementRequestLinesCopy.CALCSUMS("Total Amount");
                            //    TotalQuotedAmount := ProcurementRequestLinesCopy."Total Amount";
                            //    IF TotalQuotedAmount > 50000 THEN BEGIN
                            //      ERROR('Any RFQ over 50,000/- should go through an approval process, kindly send the document for approval.');
                            //      END;
                            if ProcurementRequestLinesCopy."Vendor To Award" = '' then Error('There is no vendor selected for award');
                            OrderNo := ProcStoreManagement.IanCreatePurchaseHeader(ProcurementRequestLinesCopy."Vendor To Award", '',
                                                                             Rec."Requisiton No", Rec."No.", '', '', Rec."Requires Inspection");
                            REPEAT
                                ProcStoreManagement.IanCreatePurchaseLines(OrderNo, ProcurementRequestLinesCopy.Type, ProcurementRequestLinesCopy.No,
                                                                           ProcurementRequestLinesCopy.Quantity, ProcurementRequestLinesCopy."Unit Price",
                                                                           ProcurementRequestLinesCopy.Location, Rec."Global Dimension 1 Code"
                                                                           , Rec."Global Dimension 2 Code", ProcurementRequestLinesCopy."Shortcut Dimension 3 Code", ProcurementRequestLinesCopy."ShortcutDimCode[4]", ProcurementRequestLinesCopy."ShortcutDimCode[5]", ProcurementRequestLinesCopy."Procurement Plan", 0, ProcurementRequestLinesCopy.Description,
                                                                           ProcurementRequestLinesCopy."Dimension Set ID", ProcurementRequestLinesCopy."Project Code", ProcurementRequestLinesCopy."Donor Code",
                                                                           ProcurementRequestLinesCopy."Grant No.", ProcurementRequestLinesCopy."Objective Code", ProcurementRequestLinesCopy."Output Code",
                                                                           ProcurementRequestLinesCopy."Outcome Code", ProcurementRequestLinesCopy."Activity Code", ProcurementRequestLinesCopy."Partner Code");

                                IF OrderNo <> '' THEN BEGIN
                                    ProcurementRequestLinesCopy."Order/Contract Created" := TRUE;
                                    ProcurementRequestLinesCopy.MODIFY(TRUE);
                                END;
                            UNTIL ProcurementRequestLinesCopy.NEXT = 0;
                        END;

                        ProcurementRequestLines.RESET;
                        ProcurementRequestLines.SETRANGE("Order/Contract Created", TRUE);
                        IF ProcurementRequestLinesCopy.FINDFIRST THEN BEGIN
                            ProcStoreManagement.IanChangeStatusOnQuotationAward(Rec, OrderNo);
                        END;

                        CurrPage.CLOSE;
                    end;
                }
                action("Re-Open Document")
                {
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    trigger OnAction()
                    var
                        ProcurementRequestLines: Record "Procurement Request Lines";
                        QuotationBidders: Record "Quotation Bidders";
                    begin
                        // TestField("Quotation Status", "Quotation Status"::"Order Created");
                        if Confirm('Are you sure you want to reopen this RFQ?', false) = true then begin
                            Rec."Quotation Status" := Rec."Quotation Status"::"Supplier Invitation";
                            Rec."Generated Order No" := '';
                            Rec."Date Awarded" := 0D;
                            ProcurementRequestLines.Reset();
                            ProcurementRequestLines.SetRange("Procurement No", Rec."No.");
                            if ProcurementRequestLines.FindSet() then begin
                                repeat
                                    ProcurementRequestLines."Vendor To Award" := '';
                                    ProcurementRequestLines.Modify(true);
                                until ProcurementRequestLines.Next() = 0;
                            end;
                            QuotationBidders.Reset();
                            QuotationBidders.SetRange("Reference No", Rec."No.");
                            QuotationBidders.SetRange("Award Vendor", true);
                            if QuotationBidders.FindFirst() then begin
                                QuotationBidders."Award Vendor" := false;
                                QuotationBidders.Modify(true);
                            end;
                            Rec.Modify(true);
                            Message('RFQ has been successfully reopened you can now Award another vendor');
                        end else
                            exit;

                    end;

                }
                action("Open Commitee Analysis Window")
                {
                    Image = OpenWorksheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 67135;
                    RunPageLink = "RFQ No." = FIELD("No.");
                    Visible = OpenEvalutionWindowVisility;
                }
                action("Choose Committee Bidder")
                {
                    Image = PickLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = ChooseBiddersVisibility;

                    trigger OnAction();
                    begin
                        IF NOT Confirm('Do you want to selected the vendor picked by the committee?', TRUE) THEN
                            EXIT;

                        RFQCommitteeEvaluation.RESET;
                        RFQCommitteeEvaluation.SETRANGE("RFQ No.", Rec."No.");
                        RFQCommitteeEvaluation.SETRANGE(Award, TRUE);
                        IF RFQCommitteeEvaluation.FINDFIRST THEN BEGIN
                            //  REPEAT
                            RFQCommitteeEvaluation.TESTFIELD("Quoted Amount");
                            QuotationVendorsBids.RESET;
                            QuotationVendorsBids.SETRANGE("Vendor No", RFQCommitteeEvaluation."Vendor No.");
                            IF QuotationVendorsBids.FINDFIRST THEN BEGIN
                                REPEAT
                                    ProcurementRequestLinesCopy.RESET;
                                    ProcurementRequestLinesCopy.SETRANGE("Procurement No", QuotationVendorsBids."Quote No");
                                    ProcurementRequestLinesCopy.SETRANGE("Line No.", QuotationVendorsBids."Line No");
                                    IF ProcurementRequestLinesCopy.FINDFIRST THEN BEGIN
                                        REPEAT
                                            ProcurementRequestLinesCopy."Vendor To Award" := RFQCommitteeEvaluation."Vendor No.";
                                            //            RFQCommitteeEvaluation.CALCFIELDS("Unit Price");
                                            ProcurementRequestLinesCopy."Unit Price" := QuotationVendorsBids."Unit Price";
                                            ProcurementRequestLinesCopy.VALIDATE("Unit Price");
                                            ProcurementRequestLinesCopy.MODIFY(TRUE);
                                        UNTIL ProcurementRequestLinesCopy.NEXT = 0;
                                    END;
                                UNTIL QuotationVendorsBids.NEXT = 0;
                            END;
                            //    UNTIL RFQCommitteeEvaluation.NEXT = 0;
                        END;
                    end;
                }
                action("Print Quote")
                {
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        ProcurementRequest.RESET;
                        ProcurementRequest.SETRANGE("No.", Rec."No.");
                        IF ProcurementRequest.FINDFIRST THEN BEGIN
                            REPORT.RUNMODAL(53026, TRUE, FALSE, ProcurementRequest);
                        END;
                    end;
                }
                action("Print Quotation Analysis")
                {
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        Rec.TESTFIELD("Reason For Vendor Selection");
                        QuotationBidders.RESET;
                        QuotationBidders.SETRANGE("Reference No", Rec."No.");
                        IF QuotationBidders.FINDFIRST THEN BEGIN
                            REPORT.RUNMODAL(53061, TRUE, FALSE, QuotationBidders);
                        END;
                    end;
                }
                action("Re-Open Invitation")
                {
                    Image = ReopenCancelled;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = ReOpenInvitationVisible;

                    trigger OnAction();
                    begin
                        IF NOT CONFIRM('Are you sure you want to re-open the Quote?') THEN
                            EXIT;
                        ProcurementRequestCopy.RESET;
                        ProcurementRequestCopy.SETRANGE("No.", Rec."No.");
                        IF ProcurementRequestCopy.FINDFIRST THEN BEGIN
                            ProcurementRequestCopy.TESTFIELD("Quotation Status", ProcurementRequestCopy."Quotation Status"::"Supplier Invitation");
                            ProcurementRequestCopy."Quotation Status" := ProcurementRequestCopy."Quotation Status"::New;
                            IF ProcurementRequestCopy.MODIFY(TRUE) THEN BEGIN
                                MESSAGE('Quote has successfully been opened');
                            END;
                        END;
                        CurrPage.CLOSE;
                    end;
                }
            }
        }
        area(reporting)
        {
            action("RFQ Report")
            {

                trigger OnAction();
                begin
                    ProcurementRequest.RESET;
                    ProcurementRequest.SETRANGE("No.", Rec."No.");
                    IF ProcurementRequest.FINDFIRST THEN BEGIN
                        REPORT.RUNMODAL(53098, TRUE, FALSE, ProcurementRequest);
                    END;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        IanSetControlAppearance();
    end;

    trigger OnAfterGetRecord();
    begin
        IanSetControlAppearance();
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        Rec.Status := Rec.Status::New;
        Rec."Procurement Method" := Rec."Procurement Method"::RFQ;
    end;

    trigger OnOpenPage();
    begin
        IanSetControlAppearance();
        ControlVisibility;
    end;

    var
        ApprovalsMgmt: Codeunit "Custom Approvals Codeunit";
        Variant: Variant;
        OpenApprovalEntriesExistCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ProcurementRequestLines: Record "Procurement Request Lines";
        ProcurementRequestLinesCopy: Record "Procurement Request Lines";
        ProcStoreManagement: Codeunit "Proc & Store Management";
        OrderNo: Code[50];
        Winner: Code[50];
        StartEvaluationVisible: Boolean;
        EndEvaluationVisible: Boolean;
        AwardWinnerVisible: Boolean;
        ProReq: Record "Procurement Request";
        Inspection: Boolean;
        RFQCommitteeEvaluation: Record "RFQ Committee Evaluation";
        ProcurementRequest: Record "Procurement Request";
        ConfirmManagement: Codeunit "Confirm Management";
        StartEvaluationVisibility: Boolean;
        OpenEvalutionWindowVisility: Boolean;
        ChooseBiddersVisibility: Boolean;
        RFQCommitteeMembers: Record "RFQ Committee Members";
        WinnerAmount: Decimal;
        QuotationBidders: Record "Quotation Bidders";
        TotalQuotedAmount: Decimal;
        ProcurementRequestCopy: Record "Procurement Request";
        ReOpenInvitationVisible: Boolean;
        ApprovalEntry: Record "Approval Entry";
        QuotationVendorsBids: Record "Quotation Vendors Bids";

    local procedure IanSetControlAppearance();
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
    begin
        OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
        IF Rec."Quotation Status" IN [Rec."Quotation Status"::"Supplier Invitation"] THEN
            StartEvaluationVisible := TRUE
        ELSE
            StartEvaluationVisible := FALSE;

        IF (IanCheckIfWinnersAreSuggested) AND (Rec."Quotation Status" IN [Rec."Quotation Status"::"Quote Submission"]) AND (Rec."Generated Order No" = '') THEN
            AwardWinnerVisible := TRUE
        ELSE
            AwardWinnerVisible := FALSE;

        IF (IanCheckIfBidsHaveBeenSubmitted) AND (Rec."Quotation Status" IN [Rec."Quotation Status"::"Quote Submission"]) AND (Rec."Generated Order No" = '')
            AND NOT (IanCheckIfWinnersAreSuggested) THEN
            EndEvaluationVisible := TRUE
        ELSE
            EndEvaluationVisible := FALSE;
    end;

    local procedure IanCheckIfWinnersAreSuggested(): Boolean;
    var
        ProcurementRequestLinesLocal: Record "Procurement Request Lines";
    begin
        ProcurementRequestLinesLocal.RESET;
        ProcurementRequestLinesLocal.SETRANGE("Procurement No", Rec."No.");
        ProcurementRequestLinesLocal.SETFILTER("Vendor To Award", '<>%1', '');
        EXIT(ProcurementRequestLinesLocal.FINDFIRST);
    end;

    local procedure IanCheckIfBidsHaveBeenSubmitted(): Boolean;
    var
        QuotationBidders: Record "Quotation Bidders";
    begin
        QuotationBidders.RESET;
        QuotationBidders.SETRANGE("Reference No", Rec."No.");
        QuotationBidders.CALCFIELDS("Total Quoted Amount");
        QuotationBidders.SETFILTER("Total Quoted Amount", '<>%1', 0);
        EXIT(QuotationBidders.FINDFIRST);
    end;

    local procedure ControlVisibility(): Boolean;
    begin
        StartEvaluationVisibility := FALSE;
        OpenEvalutionWindowVisility := FALSE;
        ChooseBiddersVisibility := FALSE;
        ReOpenInvitationVisible := FALSE;
        IF (Rec."Quotation Status" = Rec."Quotation Status"::New) AND (Rec."RFQ Com. Analysis Initiated" = FALSE) THEN BEGIN
            StartEvaluationVisibility := FALSE;
            OpenEvalutionWindowVisility := FALSE;
            ChooseBiddersVisibility := FALSE;
            ReOpenInvitationVisible := FALSE;
        END ELSE
            IF (Rec."Quotation Status" = Rec."Quotation Status"::"Supplier Invitation") AND (Rec."RFQ Com. Analysis Initiated" = FALSE) THEN BEGIN
                StartEvaluationVisibility := TRUE;
                OpenEvalutionWindowVisility := FALSE;
                ChooseBiddersVisibility := FALSE;
                ReOpenInvitationVisible := TRUE;
            END ELSE
                IF (Rec."Quotation Status" = Rec."Quotation Status"::"Supplier Invitation") AND (Rec."RFQ Com. Analysis Initiated" = TRUE) THEN BEGIN
                    StartEvaluationVisibility := FALSE;
                    OpenEvalutionWindowVisility := TRUE;
                    ChooseBiddersVisibility := TRUE;
                    ReOpenInvitationVisible := FALSE;
                END;
    end;

    procedure SendQuotesToSuppliers(var QuotationBiddersII: Record "Quotation Bidders"; QuoteNo: Code[20]; VendorNo: Code[20]);
    var
        SenderAddress: Text;
        SenderName: Text;
        Recepient: Text;
        Body: Text;
        Subject: Text;
        RCKRequestforQuotation: Report "RCK Request for Quotation";
        Fpath: Text[255];
        FileManagement: Codeunit "File Management";
        FileName: Text[255];
        CCRecepient: Text[255];
        Vendor: Record "Vendor";
        QuotationBiddersCopy: Record "Quotation Bidders";
        PurchSetup: Record "Purchases & Payables Setup";
        AttachmentTempBlob: Codeunit "Temp Blob";
        AttachmentInstream: InStream;
        AttachmentOutStream: OutStream;
        SORecordReference: RecordRef;
        SMTPMail: Codeunit "Email Message";
        SendEmail: codeunit email;
        SendToList: List of [Text];
        Text001: Label 'C:/RCKSupplierQuotes/Quotes.pdf';
    begin

        Fpath := '';
        IF NOT FileManagement.ServerDirectoryExists(Text001) THEN
            FileManagement.ServerCreateDirectory(Text001);
        Fpath := Text001 + ' ' + QuotationBiddersII."Reference No" + ' ' + QuotationBiddersII."Vendor No." + ' ' + QuotationBiddersII."Vendor Name" + '.PDF';
        FileName := QuotationBiddersII."Reference No" + ' ' + QuotationBiddersII."Vendor No." + ' ' + QuotationBiddersII."Vendor Name" + ' ' + 'Quote' + '.pdf';
        CLEAR(RCKRequestforQuotation);
        QuotationBiddersCopy.RESET;
        QuotationBiddersCopy.SETRANGE("Reference No", QuotationBiddersII."Reference No");
        QuotationBiddersCopy.SETRANGE("Vendor No.", QuotationBiddersII."Vendor No.");
        QuotationBiddersCopy.FINDFIRST;
        AttachmentTempBlob.CreateOutStream(AttachmentOutStream);
        SORecordReference.GetTable(QuotationBiddersCopy);
        REPORT.SAVEAS(64008, '', ReportFormat::Pdf, AttachmentOutStream, SORecordReference);
        Subject := 'Invitation For Quote';
        Recepient := QuotationBiddersII."E-mail Address";
        PurchSetup.Reset();
        PurchSetup.Get();
        PurchSetup.TestField("Procurement Email");
        CCRecepient := PurchSetup."Procurement Email";
        Body := 'Dear ' + FORMAT(QuotationBiddersII."Vendor Name") + ', <br>' +
          '<br>Kindly log in to the vendor portal at your earliest convenience to review and take action on the pending items.' +
          ' Please fill in the quote details in the procurement portal and the form attached below and submit. <br>' +
          '<br> link: ' + PurchSetup."Procurement Portal" +
          '<Br><Br>Regards,' + '<br>Procurement,' + '<br>RCK Kenya.';
        Clear(SendToList);
        if Recepient <> '' then begin
            SendToList.Add(Recepient);
            SMTPMail.Create(SendToList, Subject, Body, true);
            AttachmentTempBlob.CreateInStream(AttachmentInstream);
            SMTPMail.AddRecipient(Enum::"Email Recipient Type"::Cc, PurchSetup."Procurement Email");
            SMTPMail.AddAttachment('QuotationRequest.pdf', 'PDF', AttachmentInstream);
            SendEmail.Send(SMTPMail, Enum::"Email Scenario"::Default);
        end;
    end;

}

