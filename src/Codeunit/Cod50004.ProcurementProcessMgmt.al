codeunit 50004 "Procurement Process Mgmt."
{
    procedure InitiateProcurementProcess(TaskOrder: Record "Purchase Header"): Code[50]
    var
        ProcurementRequest: Record "Procurement Request";
    begin
        CreateProcurementHeader(TaskOrder, ProcurementRequest);
        CopyProcurementLines(TaskOrder, ProcurementRequest."No.");
        exit(ProcurementRequest."No.");
    end;

    local procedure CreateProcurementHeader(TaskOrder: Record "Purchase Header"; var ProcurementRequest: Record "Procurement Request")
    begin
        ProcurementRequest.Init();
        ProcurementRequest."Requisiton No" := TaskOrder."No.";
        if TaskOrder.Title <> '' then
            ProcurementRequest.Title := CopyStr(TaskOrder.Title, 1, MaxStrLen(ProcurementRequest.Title))
        else
            ProcurementRequest.Title := CopyStr(TaskOrder.Narration, 1, MaxStrLen(ProcurementRequest.Title));
        ProcurementRequest."Global Dimension 1 Code" := TaskOrder."Shortcut Dimension 1 Code";
        ProcurementRequest."Global Dimension 2 Code" := TaskOrder."Shortcut Dimension 2 Code";
        ProcurementRequest."Current Budget" := CopyStr(TaskOrder."Budget Code", 1, MaxStrLen(ProcurementRequest."Current Budget"));
        ProcurementRequest."Supplier Category" := TaskOrder."Supplier Category";
        ProcurementRequest."Created By" := CopyStr(UserId, 1, MaxStrLen(ProcurementRequest."Created By"));
        ProcurementRequest."Creation Date" := Today;
        if TaskOrder."Procurement Method" <> TaskOrder."Procurement Method"::" " then
            ProcurementRequest."Procurement Method" := TaskOrder."Procurement Method";
        ProcurementRequest.Insert(true);
    end;

    local procedure CopyProcurementLines(TaskOrder: Record "Purchase Header"; ProcurementNo: Code[50])
    var
        PurchLine: Record "Purchase Line";
        ProcurementRequestLines: Record "Procurement Request Lines";
        NextLineNo: Integer;
    begin
        PurchLine.Reset();
        PurchLine.SetRange("Document Type", TaskOrder."Document Type");
        PurchLine.SetRange("Document No.", TaskOrder."No.");
        if not PurchLine.FindSet() then
            exit;

        repeat
            NextLineNo += 10000;
            ProcurementRequestLines.Init();
            ProcurementRequestLines."Procurement No" := ProcurementNo;
            ProcurementRequestLines."Line No." := NextLineNo;

            case PurchLine.Type of
                PurchLine.Type::"Fixed Asset":
                    ProcurementRequestLines.Type := ProcurementRequestLines.Type::"Fixed Asset";
                PurchLine.Type::Item:
                    ProcurementRequestLines.Type := ProcurementRequestLines.Type::Item;
                else
                    ProcurementRequestLines.Type := ProcurementRequestLines.Type::"G/L Account";
            end;

            ProcurementRequestLines.No := PurchLine."No.";
            ProcurementRequestLines.Description := CopyStr(PurchLine.Description, 1, MaxStrLen(ProcurementRequestLines.Description));
            ProcurementRequestLines."Unit of Measure" := CopyStr(PurchLine."Unit of Measure Code", 1, MaxStrLen(ProcurementRequestLines."Unit of Measure"));
            ProcurementRequestLines."Global Dimension 1 Code" := CopyStr(PurchLine."Shortcut Dimension 1 Code", 1, MaxStrLen(ProcurementRequestLines."Global Dimension 1 Code"));
            ProcurementRequestLines."Global Dimension 2 Code" := CopyStr(PurchLine."Shortcut Dimension 2 Code", 1, MaxStrLen(ProcurementRequestLines."Global Dimension 2 Code"));
            ProcurementRequestLines."Grant No." := PurchLine."Grant No.";
            ProcurementRequestLines."Objective Code" := PurchLine."Objective Code";
            ProcurementRequestLines."Output Code" := PurchLine."Output Code";
            ProcurementRequestLines."Outcome Code" := PurchLine."Outcome Code";
            ProcurementRequestLines."Activity Code" := PurchLine."Activity Code";
            ProcurementRequestLines."Partner Code" := PurchLine."Partner Code";
            ProcurementRequestLines."Procurement Plan" := PurchLine."Procurement Plan";

            ProcurementRequestLines."Unit Price" := PurchLine."Direct Unit Cost";
            ProcurementRequestLines.Quantity := PurchLine.Quantity;
            ProcurementRequestLines.Validate(Quantity);

            ProcurementRequestLines.Insert(true);
        until PurchLine.Next() = 0;
    end;

    procedure ValidateAwardEligibility(var ProcurementRequest: Record "Procurement Request")
    var
        ProcurementRequestLines: Record "Procurement Request Lines";
    begin
        ProcurementRequest.TestField(Status, ProcurementRequest.Status::Approved);
        ProcurementRequest.TestField("Procurement Method");
        ProcurementRequest.TestField("Requisiton No");
        ProcurementRequest.TestField("Generated Order No", '');

        case ProcurementRequest."Procurement Method" of
            ProcurementRequest."Procurement Method"::Tender:
                if ProcurementRequest."Tender Status" = ProcurementRequest."Tender Status"::"Order Created" then
                    Error('An order has already been created for this Tender.');
            ProcurementRequest."Procurement Method"::RFQ:
                if ProcurementRequest."Quotation Status" = ProcurementRequest."Quotation Status"::"Order Created" then
                    Error('An order has already been created for this RFQ.');
            ProcurementRequest."Procurement Method"::RFP:
                if ProcurementRequest."RFP Status" = ProcurementRequest."RFP Status"::"Order Created" then
                    Error('An order has already been created for this RFP.');
            ProcurementRequest."Procurement Method"::"Direct Procurement":
                if ProcurementRequest."Direct Procurement Status" = ProcurementRequest."Direct Procurement Status"::"Order Created" then
                    Error('An order has already been created for this Direct Procurement request.');
        end;

        ProcurementRequestLines.Reset();
        ProcurementRequestLines.SetRange("Procurement No", ProcurementRequest."No.");
        if not ProcurementRequestLines.FindSet() then
            Error('This procurement request has no lines to order.');
    end;

    procedure DetermineAwardedVendor(var ProcurementRequest: Record "Procurement Request"): Code[20]
    var
        ProcurementRequestLines: Record "Procurement Request Lines";
        VendorNo: Code[20];
    begin
        case ProcurementRequest."Procurement Method" of
            ProcurementRequest."Procurement Method"::"Direct Procurement":
                begin
                    ProcurementRequest.TestField("Vendor No");
                    ProcurementRequest.TestField("Reason For Vendor Selection");
                    VendorNo := ProcurementRequest."Vendor No";
                end;
            ProcurementRequest."Procurement Method"::Tender, ProcurementRequest."Procurement Method"::RFP:
                begin
                    ProcurementRequest.TestField("Awarded Vendor No");
                    VendorNo := ProcurementRequest."Awarded Vendor No";
                end;
            ProcurementRequest."Procurement Method"::RFQ:
                begin
                    ProcurementRequestLines.Reset();
                    ProcurementRequestLines.SetRange("Procurement No", ProcurementRequest."No.");
                    ProcurementRequestLines.FindSet();
                    repeat
                        ProcurementRequestLines.TestField("Vendor To Award");
                        if VendorNo = '' then
                            VendorNo := ProcurementRequestLines."Vendor To Award"
                        else
                            if VendorNo <> ProcurementRequestLines."Vendor To Award" then
                                Error('Lines have been awarded to different vendors. Award all lines to the same vendor before generating an order.');
                    until ProcurementRequestLines.Next() = 0;
                end;
        end;

        ValidateAwardedVendor(VendorNo);
        exit(VendorNo);
    end;

    local procedure ValidateAwardedVendor(VendorNo: Code[20])
    var
        Vendor: Record Vendor;
    begin
        if not Vendor.Get(VendorNo) then
            Error('Vendor %1 does not exist. Correct the awarded vendor before generating an order.', VendorNo);
        Vendor.TestField("PIN No.");
    end;

    procedure CreatePurchaseHeader(ProcurementRequest: Record "Procurement Request"; VendorNo: Code[20]; var NewPurchHeader: Record "Purchase Header")
    begin
        NewPurchHeader.Init();
        NewPurchHeader."Document Type" := NewPurchHeader."Document Type"::Order;
        NewPurchHeader.Insert(true);

        NewPurchHeader.Validate("Buy-from Vendor No.", VendorNo);

        NewPurchHeader."Requisition No" := CopyStr(ProcurementRequest."Requisiton No", 1, MaxStrLen(NewPurchHeader."Requisition No"));

        if ProcurementRequest."Global Dimension 1 Code" <> '' then
            NewPurchHeader.Validate("Shortcut Dimension 1 Code", ProcurementRequest."Global Dimension 1 Code");
        if ProcurementRequest."Global Dimension 2 Code" <> '' then
            NewPurchHeader.Validate("Shortcut Dimension 2 Code", ProcurementRequest."Global Dimension 2 Code");

        NewPurchHeader.Modify(true);
    end;

    procedure CreatePurchaseLines(ProcurementRequest: Record "Procurement Request"; NewPurchHeader: Record "Purchase Header")
    var
        ProcurementRequestLines: Record "Procurement Request Lines";
        NewPurchLine: Record "Purchase Line";
        LineNo: Integer;
    begin
        ProcurementRequestLines.Reset();
        ProcurementRequestLines.SetRange("Procurement No", ProcurementRequest."No.");
        ProcurementRequestLines.FindSet();
        repeat
            LineNo += 10000;
            NewPurchLine.Init();
            NewPurchLine."Document Type" := NewPurchHeader."Document Type";
            NewPurchLine."Document No." := NewPurchHeader."No.";
            NewPurchLine."Line No." := LineNo;

            case ProcurementRequestLines.Type of
                ProcurementRequestLines.Type::"G/L Account":
                    NewPurchLine.Type := NewPurchLine.Type::"G/L Account";
                ProcurementRequestLines.Type::"Fixed Asset":
                    NewPurchLine.Type := NewPurchLine.Type::"Fixed Asset";
                ProcurementRequestLines.Type::Item:
                    NewPurchLine.Type := NewPurchLine.Type::Item;
            end;
            NewPurchLine."No." := ProcurementRequestLines.No;
            NewPurchLine.Validate("No.");

            NewPurchLine.Description := CopyStr(ProcurementRequestLines.Description, 1, MaxStrLen(NewPurchLine.Description));
            NewPurchLine.Quantity := ProcurementRequestLines.Quantity;
            NewPurchLine.Validate(Quantity);
            NewPurchLine."Unit of Measure Code" := CopyStr(ProcurementRequestLines."Unit of Measure", 1, MaxStrLen(NewPurchLine."Unit of Measure Code"));
            NewPurchLine.Validate("Unit of Measure Code");
            NewPurchLine."Direct Unit Cost" := ProcurementRequestLines."Unit Price";
            NewPurchLine.Validate("Direct Unit Cost");
            NewPurchLine."Location Code" := CopyStr(ProcurementRequestLines.Location, 1, MaxStrLen(NewPurchLine."Location Code"));
            NewPurchLine.Validate("Location Code");
            NewPurchLine."Shortcut Dimension 1 Code" := CopyStr(ProcurementRequestLines."Global Dimension 1 Code", 1, MaxStrLen(NewPurchLine."Shortcut Dimension 1 Code"));
            NewPurchLine."Shortcut Dimension 2 Code" := CopyStr(ProcurementRequestLines."Global Dimension 2 Code", 1, MaxStrLen(NewPurchLine."Shortcut Dimension 2 Code"));
            NewPurchLine."Grant No." := ProcurementRequestLines."Grant No.";
            NewPurchLine."Objective Code" := ProcurementRequestLines."Objective Code";
            NewPurchLine."Output Code" := ProcurementRequestLines."Output Code";
            NewPurchLine."Outcome Code" := ProcurementRequestLines."Outcome Code";
            NewPurchLine."Activity Code" := ProcurementRequestLines."Activity Code";
            NewPurchLine."Partner Code" := ProcurementRequestLines."Partner Code";
            NewPurchLine."Procurement Plan" := ProcurementRequestLines."Procurement Plan";
            NewPurchLine.Insert(true);

            ProcurementRequestLines."Order/Contract Created" := true;
            ProcurementRequestLines.Modify();
        until ProcurementRequestLines.Next() = 0;
    end;

    procedure StampCompletion(var ProcurementRequest: Record "Procurement Request"; GeneratedOrderNo: Code[20])
    begin
        ProcurementRequest."Generated Order No" := GeneratedOrderNo;
        if ProcurementRequest."Date Awarded" = 0D then
            ProcurementRequest."Date Awarded" := Today;
        case ProcurementRequest."Procurement Method" of
            ProcurementRequest."Procurement Method"::Tender:
                ProcurementRequest."Tender Status" := ProcurementRequest."Tender Status"::"Order Created";
            ProcurementRequest."Procurement Method"::RFQ:
                ProcurementRequest."Quotation Status" := ProcurementRequest."Quotation Status"::"Order Created";
            ProcurementRequest."Procurement Method"::RFP:
                ProcurementRequest."RFP Status" := ProcurementRequest."RFP Status"::"Order Created";
            ProcurementRequest."Procurement Method"::"Direct Procurement":
                ProcurementRequest."Direct Procurement Status" := ProcurementRequest."Direct Procurement Status"::"Order Created";
        end;
        ProcurementRequest.Modify(true);
    end;

    procedure AwardVendorPerLineFromBids(RFQNo: Code[20]; VendorNo: Code[20])
    var
        QuotationVendorsBids: Record "Quotation Vendors Bids";
        ProcurementRequestLines: Record "Procurement Request Lines";
    begin
        QuotationVendorsBids.SetRange("Quote No", RFQNo);
        QuotationVendorsBids.SetRange("Vendor No", VendorNo);
        if not QuotationVendorsBids.FindSet() then
            Error('Vendor %1 has not submitted any bid lines for %2. Cannot award using real bid data.', VendorNo, RFQNo);
        repeat
            if ProcurementRequestLines.Get(RFQNo, QuotationVendorsBids."Line No") then begin
                ProcurementRequestLines."Vendor To Award" := VendorNo;
                ProcurementRequestLines."Unit Price" := QuotationVendorsBids."Unit Price";
                ProcurementRequestLines.Validate("Unit Price");
                ProcurementRequestLines.Modify(true);
            end;
        until QuotationVendorsBids.Next() = 0;
    end;
}
