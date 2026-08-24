page 67056 "Direct Procurement Card"
{
    // version Procurement Iansoft

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
                field(Status; Rec.Status)
                {
                }
                field(Title; Rec.Title)
                {
                }
                field("Requisiton No"; Rec."Requisiton No")
                {
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                }
                field("RFQ Deadlne Date"; Rec."RFQ Deadlne Date")
                {
                    Caption = 'Deadline Date';
                }
                field("Expected Delivery Date"; Rec."Expected Delivery Date")
                {
                }
                field("RFQ Deadline Time"; Rec."RFQ Deadline Time")
                {
                }
                field("Supplier Category"; Rec."Supplier Category")
                {
                }
            }
            group("Vendor Details")
            {
                field("Vendor No"; Rec."Vendor No")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    Editable = false;
                }
                field("Reason For Vendor Selection"; Rec."Reason For Vendor Selection")
                {
                }
            }
            part("D.P Lines Subform"; "D.P Lines Subform")
            {
                SubPageLink = "Procurement No" = FIELD("No.");
            }
        }
        area(factboxes)
        {

            part("Attached Documents"; "Document Uploads")
            {
                ApplicationArea = Basic;
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
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;
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
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction();
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::"Pending Approval");
                        IF NOT CONFIRM('Are you sure you want to cancel approval request?') THEN
                            EXIT;

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
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
            group("Tender Processing")
            {
                action("Print Report")
                {
                    Image = Report2;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        ProcurementRequest: Record "Procurement Request";
                    begin
                        ProcurementRequest.Reset();
                        ProcurementRequest.SetRange(ProcurementRequest."No.", Rec."No.");
                        if ProcurementRequest.Find('-') then
                            report.run(64006, true, true, ProcurementRequest);
                    end;
                }
                action("Award & Generate Order")
                {
                    Image = "Order";
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        //TESTFIELD(Status,Status::Approved);
                        Rec.TESTFIELD("Direct Procurement Status", Rec."Direct Procurement Status"::New);
                        Rec.TESTFIELD("Vendor No");
                        Rec.TESTFIELD("Reason For Vendor Selection");
                        IF NOT CONFIRM('Are you sure you want to create purchase order for the awarded vendors?') THEN
                            EXIT;

                        OrderNo := ProcStoreManagement.IanCreatePurchaseHeader(Rec."Vendor No", '',
                                                                                   Rec."Requisiton No", '', Rec."No.", '', Rec."Requires Inspection");

                        ProcurementRequestLines.RESET;
                        ProcurementRequestLines.SETRANGE("Procurement No", Rec."No.");
                        IF ProcurementRequestLines.FINDSET THEN BEGIN
                            REPEAT
                                ProcurementRequestLines.TESTFIELD(Description);
                                ProcStoreManagement.IanCreatePurchaseLines(OrderNo, ProcurementRequestLines.Type, ProcurementRequestLines.No,
                                                                           ProcurementRequestLines.Quantity, ProcurementRequestLines."Unit Price",
                                                                           ProcurementRequestLines.Location, Rec."Global Dimension 1 Code", Rec."Global Dimension 2 Code", ProcurementRequestLines."Shortcut Dimension 3 Code", ProcurementRequestLines."ShortcutDimCode[4]", ProcurementRequestLines."ShortcutDimCode[5]", ProcurementRequestLines."Procurement Plan", 0,
                                                                           ProcurementRequestLines.Description, ProcurementRequestLines."Dimension Set ID",
                                                                           ProcurementRequestLines."Project Code", ProcurementRequestLines."Donor Code", ProcurementRequestLines."Grant No.",
                                                                           ProcurementRequestLines."Objective Code", ProcurementRequestLines."Output Code", ProcurementRequestLines."Outcome Code", ProcurementRequestLines."Activity Code", ProcurementRequestLines."Partner Code");
                                IF OrderNo <> '' THEN BEGIN
                                    ProcurementRequestLines."Order/Contract Created" := TRUE;
                                    ProcurementRequestLines.MODIFY(TRUE);
                                END;
                            UNTIL ProcurementRequestLines.NEXT = 0;
                        END;

                        ProcurementRequestLines.RESET;
                        ProcurementRequestLines.SETRANGE("Order/Contract Created", TRUE);
                        IF ProcurementRequestLinesCopy.FINDFIRST THEN BEGIN
                            ProcStoreManagement.IanChangeStatusOnDirectProcAward(Rec, OrderNo);
                        END;
                        CurrPage.CLOSE;
                    end;
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
                action("Open Commitee Analysis Window")
                {
                    Image = OpenWorksheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 67135;
                    RunPageLink = "RFQ No." = FIELD("No.");
                    // Visible = OpenEvalutionWindowVisility;
                }
                action("Choose Committee Bidder")
                {
                    Image = PickLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

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
                action("Report")
                {
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        ProcurementRequest.RESET;
                        ProcurementRequest.SETRANGE("No.", Rec."No.");
                        IF ProcurementRequest.FINDFIRST THEN BEGIN
                            REPORT.RUNMODAL(53092, TRUE, FALSE, ProcurementRequest);
                        END;
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
                        Rec.TESTFIELD("Vendor No");
                        Rec.TESTFIELD("Reason For Vendor Selection");
                        IF NOT CONFIRM('Do you want to email vendor %1?', TRUE, Rec."Vendor Name") THEN
                            EXIT;


                        SendEmailToVendor(Rec);
                        rec.Advertised := true;
                        rec."Quotation Status" := Rec."Quotation Status"::"Supplier Invitation";
                        rec.Modify(true);
                        Message('RFQ sent to portal sucessfully');
                        CurrPage.CLOSE;
                    end;
                }
            }
            action("Supplier Bid")
            {
                Image = Vendor;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Quotation Bidders";
                RunPageLink = "Reference No" = FIELD("No."),
                                  "Vendor Category" = FIELD("Supplier Category");


            }
            action("Archive Document")
            {
                Image = Archive;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction();
                begin
                    IF NOT CONFIRM('Are you sure you want to archive this document?') THEN
                        EXIT;
                    Rec.Archives := true;
                    Rec.Modify();
                    Message('Document archived successfully!');
                end;

            }
            action("Send Email")
            {
                Image = Start;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = true;

                trigger OnAction();
                begin
                    //TESTFIELD("Quotation Status", "Quotation Status"::"Supplier Invitation");
                    Rec.TESTFIELD("Vendor No");
                    Rec.TESTFIELD("Reason For Vendor Selection");
                    IF NOT CONFIRM('Do you want to email vendor %1?', TRUE, Rec."Vendor Name") THEN
                        EXIT;


                    SendEmailToVendorNotInPortal(Rec);
                    Message('RFQ sent sucessfully');
                    CurrPage.CLOSE;
                end;
            }

        }
    }

    var
        ApprovalsMgmt: Codeunit "Custom Approvals Codeunit";
        Variant: Variant;
        OpenApprovalEntriesExistCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ProcurementRequestLines: Record "Procurement Request Lines";
        ProcurementRequestLinesCopy: Record "Procurement Request Lines";
        ProcStoreManagement: Codeunit "Proc & Store Management";
        RFQCommitteeEvaluation: Record "RFQ Committee Evaluation";
        OrderNo: Code[50];
        Winner: Code[50];
        ProcurementRequest: Record "Procurement Request";
        RFQCommitteeMembers: Record "RFQ Committee Members";
        QuotationBidders: Record "Quotation Bidders";
        QuotationVendorsBids: Record "Quotation Vendors Bids";

    local procedure SetControlAppearance();
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
    begin
        OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
    end;

    local procedure SendEmailToVendor(var ProcurementRequest: Record "Procurement Request");
    var
        Vendor: Record "Vendor";
        FileManagement: Codeunit "File Management";
        // DirectProcurementReport: Report "RCK Direct Procurement";
        SenderName: Text;
        SenderAddress: Text;
        Recepient: Text;
        CCRecepient: Text;
        Subject: Text;
        Body: Text;
        FilePath: Text;
        FileName: Text;
        Text001: Label 'C:\Vendors\DirectProcurement';
        PurchSetup: Record "Purchases & Payables Setup";
        AttachmentTempBlob: Codeunit "Temp Blob";
        AttachmentInstream: InStream;
        AttachmentOutStream: OutStream;
        SORecordReference: RecordRef;
        SMTPMail: Codeunit "Email Message";
        SendEmail: codeunit email;
        SendToList: List of [Text];
    begin
        PurchSetup.Get();
        ProcurementRequest.Reset();
        ProcurementRequest.SetRange("No.", Rec."No."); //Added DW Feb 3 2025
        IF Vendor.GET(ProcurementRequest."Vendor No") THEN BEGIN
            Vendor.TESTFIELD("E-Mail");
            FilePath := '';
            IF NOT FileManagement.ServerDirectoryExists(Text001) THEN BEGIN
                FileManagement.ServerCreateDirectory(Text001);
                FilePath := Text001 + ' ' + ProcurementRequest."No." + ' ' + ProcurementRequest."Vendor Name" + '.PDF';
                FileName := ProcurementRequest."No." + ' ' + ProcurementRequest."Vendor Name" + ' ' + 'proc.pdf';
                // CLEAR(DirectProcurementReport);
                // DirectProcurementReport.SETTABLEVIEW(ProcurementRequest);
                // DirectProcurementReport.SAVEASPDF(FilePath);
                // REPORT.SAVEASPDF(REPORT::"Direct Procurement Report", FileName, ProcurementRequest);

                AttachmentTempBlob.CreateOutStream(AttachmentOutStream);
                SORecordReference.GetTable(ProcurementRequest);
                REPORT.SAVEAS(64006, '', ReportFormat::Pdf, AttachmentOutStream, SORecordReference);
                Subject := 'Invitation For Quote';
                Recepient := Vendor."E-Mail";
                CCRecepient := PurchSetup."Procurement Email";
                Body := 'Dear ' + FORMAT(ProcurementRequest."Vendor Name") + ',<BR>' +
                 '<br> You have been invited for a quotation at RCK.' +
                 ' Please fill in the quote details in the procurement portal and the form attached below and submit.  <br>' +
          '<br> link: ' + PurchSetup."Procurement Portal" +
          '<Br><Br>Regards,' + '<br>Procurement,' + '<br>RCK Kenya.';
                Clear(SendToList);
                if Recepient <> '' then begin
                    SendToList.Add(Recepient);
                    SendToList.Add(CCRecepient);
                    SMTPMail.Create(SendToList, Subject, Body, true);
                    AttachmentTempBlob.CreateInStream(AttachmentInstream);
                    SMTPMail.AddRecipient(Enum::"Email Recipient Type"::Cc, PurchSetup."Procurement Email");
                    SMTPMail.AddAttachment('QuotationRequest.pdf', 'PDF', AttachmentInstream);

                    SendEmail.Send(SMTPMail, Enum::"Email Scenario"::Default);

                    MESSAGE('E-mail sent successfully');
                end;


            END else begin
                FilePath := Text001 + ' ' + ProcurementRequest."No." + ' ' + ProcurementRequest."Vendor Name" + '.PDF';
                FileName := ProcurementRequest."No." + ' ' + ProcurementRequest."Vendor Name" + ' ' + 'proc.pdf';
                // CLEAR(DirectProcurementReport);
                // DirectProcurementReport.SETTABLEVIEW(ProcurementRequest);
                // DirectProcurementReport.SAVEASPDF(FilePath);
                // REPORT.SAVEASPDF(REPORT::"Direct Procurement Report", FileName, ProcurementRequest);

                AttachmentTempBlob.CreateOutStream(AttachmentOutStream);
                SORecordReference.GetTable(ProcurementRequest);
                REPORT.SAVEAS(64006, '', ReportFormat::Pdf, AttachmentOutStream, SORecordReference);
                Subject := 'Invitation For Quote';
                Recepient := Vendor."E-Mail";
                CCRecepient := PurchSetup."Procurement Email";
                Body := 'Dear ' + FORMAT(ProcurementRequest."Vendor Name") + ',' +
                 '<br> You have been invited for a quotation at RCK.' +
                 ' Please fill in the quote details in the procurement portal and the form attached below and submit. <br>' +
          '<br> link: ' + PurchSetup."Procurement Portal" +
          '<Br><Br>Regards,' + '<br>Procurement,' + '<br>RCK Kenya.';
                Clear(SendToList);
                if Recepient <> '' then begin

                    SendToList.Add(Recepient);
                    SendToList.Add(CCRecepient);
                    //SendToList.Add('wesadan@gmail.com');
                    //SendToList.Add(CCRecepient);
                    SMTPMail.Create(SendToList, Subject, Body, true);
                    AttachmentTempBlob.CreateInStream(AttachmentInstream);
                    SMTPMail.AddRecipient(Enum::"Email Recipient Type"::Cc, PurchSetup."Procurement Email");
                    SMTPMail.AddAttachment('QuotationRequest.pdf', 'PDF', AttachmentInstream);
                    SendEmail.Send(SMTPMail, Enum::"Email Scenario"::Default);
                    MESSAGE('E-mail sent successfully');
                end;
            end;

            ProcurementRequest.Advertised := true;
            ProcurementRequest.Modify();
        END;
    end;

    local procedure SendEmailToVendorNotInPortal(var ProcurementRequest: Record "Procurement Request");
    var
        Vendor: Record "Vendor";
        FileManagement: Codeunit "File Management";
        // DirectProcurementReport: Report "RCK Direct Procurement";
        SenderName: Text;
        SenderAddress: Text;
        Recepient: Text;
        CCRecepient: Text;
        Subject: Text;
        Body: Text;
        FilePath: Text;
        FileName: Text;
        Text001: Label 'C:\Vendors\DirectProcurement';
        PurchSetup: Record "Purchases & Payables Setup";
        AttachmentTempBlob: Codeunit "Temp Blob";
        AttachmentInstream: InStream;
        AttachmentOutStream: OutStream;
        SORecordReference: RecordRef;
        SMTPMail: Codeunit "Email Message";
        SendEmail: codeunit email;
        SendToList: List of [Text];
    begin
        PurchSetup.Get();
        ProcurementRequest.Reset();
        ProcurementRequest.SetRange("No.", Rec."No."); //Added DW Feb 3 2025
        IF Vendor.GET(ProcurementRequest."Vendor No") THEN BEGIN
            Vendor.TESTFIELD("E-Mail");
            FilePath := '';
            IF NOT FileManagement.ServerDirectoryExists(Text001) THEN BEGIN
                FileManagement.ServerCreateDirectory(Text001);
                FilePath := Text001 + ' ' + ProcurementRequest."No." + ' ' + ProcurementRequest."Vendor Name" + '.PDF';
                FileName := ProcurementRequest."No." + ' ' + ProcurementRequest."Vendor Name" + ' ' + 'proc.pdf';
                // CLEAR(DirectProcurementReport);
                // DirectProcurementReport.SETTABLEVIEW(ProcurementRequest);
                // DirectProcurementReport.SAVEASPDF(FilePath);
                // REPORT.SAVEASPDF(REPORT::"Direct Procurement Report", FileName, ProcurementRequest);

                AttachmentTempBlob.CreateOutStream(AttachmentOutStream);
                SORecordReference.GetTable(ProcurementRequest);
                REPORT.SAVEAS(64006, '', ReportFormat::Pdf, AttachmentOutStream, SORecordReference);
                Subject := 'Invitation For Quote';
                Recepient := Vendor."E-Mail";
                CCRecepient := PurchSetup."Procurement Email";
                Body := 'Dear ' + FORMAT(ProcurementRequest."Vendor Name") + ',<BR>' +
                 '<br> You have been invited for a quotation at RCK.' +
                 ' Please fill in the quote details on attached RFQ and submit. <br>' +
          '<Br><Br>Regards,' + '<br>Procurement,' + '<br>RCK Kenya.';
                Clear(SendToList);
                if Recepient <> '' then begin
                    SendToList.Add(Recepient);
                    SendToList.Add(CCRecepient);
                    SMTPMail.Create(SendToList, Subject, Body, true);
                    AttachmentTempBlob.CreateInStream(AttachmentInstream);
                    SMTPMail.AddRecipient(Enum::"Email Recipient Type"::Cc, PurchSetup."Procurement Email");
                    SMTPMail.AddAttachment('QuotationRequest.pdf', 'PDF', AttachmentInstream);

                    SendEmail.Send(SMTPMail, Enum::"Email Scenario"::Default);

                    MESSAGE('E-mail sent successfully');
                end;


            END else begin
                FilePath := Text001 + ' ' + ProcurementRequest."No." + ' ' + ProcurementRequest."Vendor Name" + '.PDF';
                FileName := ProcurementRequest."No." + ' ' + ProcurementRequest."Vendor Name" + ' ' + 'proc.pdf';
                // CLEAR(DirectProcurementReport);
                // DirectProcurementReport.SETTABLEVIEW(ProcurementRequest);
                // DirectProcurementReport.SAVEASPDF(FilePath);
                // REPORT.SAVEASPDF(REPORT::"Direct Procurement Report", FileName, ProcurementRequest);

                AttachmentTempBlob.CreateOutStream(AttachmentOutStream);
                SORecordReference.GetTable(ProcurementRequest);
                REPORT.SAVEAS(64006, '', ReportFormat::Pdf, AttachmentOutStream, SORecordReference);
                Subject := 'Invitation For Quote';
                Recepient := Vendor."E-Mail";
                CCRecepient := PurchSetup."Procurement Email";
                Body := 'Dear ' + FORMAT(ProcurementRequest."Vendor Name") + ',' +
                 '<br> You have been invited for a quotation at RCK.' +
                 ' Please fill in the quote details in the procurement portal below and submit. <br>' +
          '<br> link: ' + PurchSetup."Procurement Portal" +
          '<Br><Br>Regards,' + '<br>Procurement,' + '<br>RCK Kenya.';
                Clear(SendToList);
                if Recepient <> '' then begin

                    SendToList.Add(Recepient);
                    SendToList.Add(CCRecepient);
                    //SendToList.Add('wesadan@gmail.com');
                    //SendToList.Add(CCRecepient);
                    SMTPMail.Create(SendToList, Subject, Body, true);
                    AttachmentTempBlob.CreateInStream(AttachmentInstream);
                    SMTPMail.AddRecipient(Enum::"Email Recipient Type"::Cc, PurchSetup."Procurement Email");
                    SMTPMail.AddAttachment('QuotationRequest.pdf', 'PDF', AttachmentInstream);
                    SendEmail.Send(SMTPMail, Enum::"Email Scenario"::Default);
                    MESSAGE('E-mail sent successfully');
                end;
            end;

            ProcurementRequest.Advertised := true;
            ProcurementRequest.Modify();
        END;
    end;
}

