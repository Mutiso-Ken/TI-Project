page 67036 "Quotation Bidders"
{
    // version Procurement Iansoft

    PageType = List;
    SourceTable = "Quotation Bidders";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vendor No."; Rec."Vendor No.")
                {
                    Editable = PageEditableFields;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    Editable = PageEditableFields;
                }
                field("E-mail Address"; Rec."E-mail Address")
                {
                    Editable = PageEditableFields;
                }
                field("Phone No"; Rec."Phone No")
                {
                    Editable = PageEditableFields;
                }
                field("Total Quoted Amount"; Rec."Total Quoted Amount")
                {
                    Editable = false;
                }
                field("Award Vendor"; Rec."Award Vendor")
                {
                    Editable = PageEditableFields;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Email Quotation To Vendors")
            {
                Image = SendMail;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = EmailSuppliersVisible;

                trigger OnAction();
                begin
                    ProcurementRequest.RESET;
                    ProcurementRequest.SETRANGE("No.", Rec."Reference No");
                    IF ProcurementRequest.FINDFIRST THEN BEGIN
                        ProcurementRequest.TESTFIELD("Expected Delivery Date");
                        ProcurementRequest.TESTFIELD("RFQ Deadlne Date");
                        ProcurementRequest.TESTFIELD("RFQ Deadline Time");
                    END;

                    IF NOT CONFIRM('Are you sure you want to invite the vendors for quotation?') THEN
                        EXIT;

                    QuotationBidders.RESET;
                    QuotationBidders.SETRANGE("Reference No", Rec."Reference No");
                    QuotationBidders.SETRANGE("Email Sent", FALSE);
                    IF QuotationBidders.FINDSET THEN BEGIN
                        REPEAT
                            QuotationBidders.TESTFIELD("E-mail Address");
                            SendQuotesToSuppliers(QuotationBidders, Rec."Reference No", Rec."Vendor No.");
                            QuotationBidders."Email Sent" := TRUE;
                            QuotationBidders.MODIFY(TRUE);
                        UNTIL QuotationBidders.NEXT = 0;
                    END;


                    // QuotationBidders.RESET;
                    // QuotationBidders.SETRANGE("Reference No","Reference No");
                    // IF QuotationBidders.FINDFIRST THEN BEGIN
                    //  REPEAT
                    //    UNTIL QuotationBidders.NEXT = 0;
                    //  END;
                    // QuotationBiddersII.RESET;
                    // QuotationBiddersII.SETRANGE("Reference No","Reference No");
                    // QuotationBiddersII.SETRANGE("Vendor No.","Vendor No.");
                    // QuotationBiddersII.SETRANGE("Vendor Category","Vendor Category");
                    // IF QuotationBiddersII.FINDSET THEN BEGIN
                    //  REPEAT
                    //    Fpath := '';
                    //    IF NOT FileManagement.ServerDirectoryExists(Text001) THEN
                    //      FileManagement.ServerCreateDirectory(Text001);
                    //      Fpath := Text001+' '+ QuotationBiddersII."Reference No"+' '+QuotationBiddersII."Vendor No."+' '+QuotationBiddersII."Vendor Name"+'.PDF';
                    //      FileName := QuotationBiddersII."Reference No"+' '+QuotationBiddersII."Vendor No."+' '+QuotationBiddersII."Vendor Name"+' '+'Quote'+'.pdf';
                    //      CLEAR(RCKRequestforQuotation);
                    //      RCKRequestforQuotation.SETTABLEVIEW(QuotationBiddersII);
                    //      RCKRequestforQuotation.Header(QuotationBiddersII);
                    //      RCKRequestforQuotation.SAVEASPDF(Fpath);
                    //      REPORT.SAVEASPDF(REPORT::"RCK Request for Quotation",FileName,QuotationBiddersII);
                    //      SMTPMailSetup.GET;
                    //      SenderAddress:=SMTPMailSetup."User ID";
                    //      SenderName:=SMTPMailSetup."Send As";
                    //      Subject:='Invitation For Quote';
                    //      Recepient := QuotationBiddersII."E-mail Address";
                    //      CCRecepient := 'procurement@rckkenya.org';
                    //      Body:='Dear '+ FORMAT(QuotationBiddersII."Vendor Name")+','+
                    //       '<br> You have been invited for a quotation at RCK.'+
                    //       ' Please fill in the attached form and submit your quote <br>'+
                    //       '<Br>Regards,'+'<br>Procurement,'+'<br>RCK Kenya.';
                    //       IF (SenderName<>'') AND (SenderAddress<>'') AND (Recepient<>'') AND (Subject<>'') AND (Body<>'') THEN
                    //            BEGIN
                    //            SMTPMail.CreateMessage(SenderName,SenderAddress,Recepient,Subject,Body,TRUE);
                    //            SMTPMail.AddCC(CCRecepient);
                    //            SMTPMail.AddAttachment(Fpath,FileName);
                    //            SMTPMail.Send();
                    //            END;
                    // //      ProcStoreManagement.IanSendQuoteToSuppliers(QuotationBidders."Vendor No.",QuotationBidders."Vendor Name",
                    // //                                                  QuotationBidders."E-mail Address",'','');
                    //    UNTIL QuotationBiddersII.NEXT = 0;
                    //  END;



                    ProcurementRequest.RESET;
                    ProcurementRequest.SETRANGE("No.", Rec."Reference No");
                    IF ProcurementRequest.FINDFIRST THEN BEGIN
                        ProcStoreManagement.IanChangeStatusOnVendorInvitation(ProcurementRequest);
                        //ProcStoreManagement.IanStartQuotationEvaluation(ProcurementRequest);
                    END;
                    CurrPage.CLOSE();
                end;
            }
            action("Quote Attached")
            {
                Image = Documents;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Quote Attached";
                RunPageLink = "Document No" = FIELD("Reference No"), Owner = field("Vendor No.");
            }
            action("Quotes Per Item")
            {
                Enabled = QuotesPerVendorVisible;
                Image = Evaluate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    IF NOT CONFIRM('Are you sure you want to open this window?') THEN
                        EXIT;

                    QuotationVendorsBids.RESET;
                    QuotationVendorsBids.SETRANGE("Vendor No", Rec."Vendor No.");
                    QuotationVendorsBids.SETRANGE("Quote No", Rec."Reference No");
                    IF QuotationVendorsBids.FINDFIRST THEN BEGIN
                        CLEAR(VendorQuotedAmountPerItem);
                        VendorQuotedAmountPerItem.SETTABLEVIEW(QuotationVendorsBids);
                        VendorQuotedAmountPerItem.RUNMODAL();
                    END;
                end;
            }
            action("RFQ Print Out")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction();
                begin
                    Rec.RESET;
                    Rec.SETRANGE("Vendor No.", Rec."Vendor No.");
                    Rec.SETRANGE("Reference No", Rec."Reference No");
                    REPORT.RUN(64004, TRUE, FALSE, Rec);
                end;
            }
            action("RFQ Quote Print Out")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    Rec.RESET;
                    Rec.SETRANGE("Vendor No.", Rec."Vendor No.");
                    Rec.SETRANGE("Reference No", Rec."Reference No");
                    REPORT.RUN(64008, TRUE, FALSE, Rec);
                end;
            }
            action("Evaluation Report")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report 64007;
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        IanControlPageAppearance();
    end;

    trigger OnAfterGetRecord();
    begin
        IanControlPageAppearance();
    end;

    trigger OnOpenPage();
    begin
        IanControlPageAppearance();
    end;

    var
        VendorQuotedAmountPerItem: Page "Vendor Quoted Amount Per Item";
        QuotationVendorsBids: Record "Quotation Vendors Bids";
        ProcurementRequest: Record "Procurement Request";
        ProcStoreManagement: Codeunit "Proc & Store Management";
        QuotationBidders: Record "Quotation Bidders";
        EmailSuppliersVisible: Boolean;
        PageEditableFields: Boolean;
        QuotesPerVendorVisible: Boolean;
        SenderAddress: Text;
        SenderName: Text;
        Recepient: Text;
        Body: Text;
        Subject: Text;
        Fpath: Text[255];
        FileManagement: Codeunit "File Management";
        FileName: Text[255];
        CCRecepient: Text[255];
        Text001: Label 'C:/RCKSupplierQuotes/Quotes.pdf';
        Vendor: Record "Vendor";

    local procedure IanControlPageAppearance();
    begin
        IF ProcurementRequest.GET(Rec."Reference No") THEN BEGIN
            IF NOT (ProcurementRequest."Quotation Status" IN [ProcurementRequest."Quotation Status"::New]) THEN BEGIN
                EmailSuppliersVisible := FALSE;
                PageEditableFields := FALSE;
            END ELSE BEGIN
                EmailSuppliersVisible := TRUE;
                PageEditableFields := TRUE;
            END;
            IF NOT (ProcurementRequest."Quotation Status" IN [ProcurementRequest."Quotation Status"::"Quote Submission"]) THEN BEGIN
                QuotesPerVendorVisible := FALSE;
            END ELSE BEGIN
                QuotesPerVendorVisible := TRUE;
            END;
        END;
        PageEditableFields := true;
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
        //RCKRequestforQuotation.SETTABLEVIEW(QuotationBiddersCopy);
        //RCKRequestforQuotation.Header(QuotationBiddersII);
        //RCKRequestforQuotation.SAVEASPDF(Fpath);
        AttachmentTempBlob.CreateOutStream(AttachmentOutStream);
        SORecordReference.GetTable(QuotationBiddersCopy);
        REPORT.SAVEAS(64008, '', ReportFormat::Pdf, AttachmentOutStream, SORecordReference);
        //REPORT.SAVEASPDF(REPORT::"RCK Request for Quotation", FileName, QuotationBiddersCopy);
        // SMTPMailSetup.GET;
        // SenderAddress := SMTPMailSetup."User ID";
        // SenderName := SMTPMailSetup."Send As";
        Subject := 'Invitation For Quote';
        Recepient := QuotationBiddersII."E-mail Address";
        PurchSetup.Reset();
        PurchSetup.Get();
        PurchSetup.TestField("Procurement Email");
        CCRecepient := PurchSetup."Procurement Email";
        Body := 'Dear ' + FORMAT(QuotationBiddersII."Vendor Name") + ',' +
          '<br> You have been invited for a quotation at RCK.' +
          ' Please fill in the attached form and submit your quote <br>' +
          '<Br>Regards,' + '<br>Procurement,' + '<br>RCK Kenya.';
        Clear(SendToList);
        if Recepient <> '' then begin
            SendToList.Add(Recepient);
            SMTPMail.Create(SendToList, Subject, Body, true);
            AttachmentTempBlob.CreateInStream(AttachmentInstream);
            SMTPMail.AddRecipient(Enum::"Email Recipient Type"::Cc, PurchSetup."Procurement Email");
            SMTPMail.AddAttachment('QuotationRequest.pdf', 'PDF', AttachmentInstream);
            SendEmail.Send(SMTPMail, Enum::"Email Scenario"::Default);
        end;
        // IF (SenderName <> '') AND (SenderAddress <> '') AND (Recepient <> '') AND (Subject <> '') AND (Body <> '') THEN BEGIN
        //     // SMTPMail.CreateMessage(SenderName, SenderAddress, Recepient, Subject, Body, TRUE);
        //     // SMTPMail.AddCC(CCRecepient);
        //     // SMTPMail.AddAttachment(Fpath, FileName);
        //     // SMTPMail.Send();
        //     IF EXISTS(Fpath) THEN
        //         ERASE(Fpath);
        // END;
        //      ProcStoreManagement.IanSendQuoteToSuppliers(QuotationBidders."Vendor No.",QuotationBidders."Vendor Name",
        //                                                  QuotationBidders."E-mail Address",'','');
    end;
}

