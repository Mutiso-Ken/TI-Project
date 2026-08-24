codeunit 51155 "Proc & Store Management"
{
    // version Procurement Iansoft


    trigger OnRun();
    begin
    end;

    var
        IanSoftFactory: Codeunit "IanSoftFactory";
        UserSetup: Record "User Setup";
        ProcurementSetup: Record "Procurement Setup";
        Employee: Record "HR Employees";

    procedure IanGetPlannedQuantity(Dim1: Code[50]; TypeParam: Option "G/L Account","Fixed Asset",Item; NoParam: Code[50]; PlanName: Text): Integer;
    var
        ConProcPlanLine: Record "Procurement Plan Lines";
    begin
        ConProcPlanLine.RESET;
        ConProcPlanLine.SETRANGE("Global Dimension 2 Code", Dim1);
        ConProcPlanLine.SETRANGE(Type, TypeParam);
        ConProcPlanLine.SETRANGE(No, NoParam);
        ConProcPlanLine.SETRANGE("Plan No.", PlanName);
        IF ConProcPlanLine.FINDSET THEN BEGIN
            ConProcPlanLine.CALCSUMS(Quantity);
            EXIT(ConProcPlanLine.Quantity);
        END;
    end;

    procedure IanGetPlannedAmount(Dim1: Code[50]; TypeParam: Option "G/L Account","Fixed Asset",Item; NoParam: Code[50]; PlanName: Text): Decimal;
    var
        ConProcPlanLine: Record "Procurement Plan Lines";
    begin
        ConProcPlanLine.RESET;
        ConProcPlanLine.SETRANGE("Global Dimension 2 Code", Dim1);
        ConProcPlanLine.SETRANGE(Type, TypeParam);
        ConProcPlanLine.SETRANGE(No, NoParam);
        ConProcPlanLine.SETRANGE("Plan No.", PlanName);
        IF ConProcPlanLine.FINDSET THEN BEGIN
            ConProcPlanLine.CALCSUMS("Total Amount");
            EXIT(ConProcPlanLine."Total Amount");
        END;
    end;

    procedure IanGetRequisitionedQuantity(Dim1: Code[50]; TypeParam: Option "G/L Account","Fixed Asset",Item; NoParam: Code[50]; PlanName: Text): Integer;
    var
        RequsitionLines: Record "Purchase Line";
    begin
        RequsitionLines.RESET;
        RequsitionLines.SETRANGE("Shortcut Dimension 1 Code", Dim1);
        RequsitionLines.SETRANGE(Type, TypeParam);
        RequsitionLines.SETRANGE("No.", NoParam);
        RequsitionLines.SETRANGE("Procurement Plan", PlanName);
        RequsitionLines.SETRANGE("Line Status", RequsitionLines."Line Status"::Approved);
        IF RequsitionLines.FINDSET THEN BEGIN
            RequsitionLines.CALCSUMS(Quantity);
            EXIT(RequsitionLines.Quantity);

        END;
    end;

    procedure IanGetRequisitionedAmount(Dim1: Code[50]; TypeParam: Option "G/L Account","Fixed Asset",Item; NoParam: Code[50]; PlanName: Text): Decimal;
    var
        RequsitionLines: Record "Purchase Line";
    begin
        RequsitionLines.RESET;
        RequsitionLines.SETRANGE("Shortcut Dimension 1 Code", Dim1);
        RequsitionLines.SETRANGE(Type, TypeParam);
        RequsitionLines.SETRANGE("No.", NoParam);
        RequsitionLines.SETRANGE("Procurement Plan", PlanName);
        RequsitionLines.SETRANGE("Line Status", RequsitionLines."Line Status"::Approved);
        IF RequsitionLines.FINDSET THEN BEGIN
            RequsitionLines.CALCSUMS("Total Amount");
            EXIT(RequsitionLines."Total Amount");
        END;
    end;

    procedure IanGetQuantityAvailableinStore(No: Code[20]; Location: Code[50]): Decimal;
    begin
    end;

    procedure IanGenerateSupplierMandatoryRequirements(VenderName: Text; RequirementCode: Code[100]; RequirementDescription: Text; EvaluatorId: Code[70]; EvaluatorNo: Code[50]; EvaluatorName: Text; LineNo: Integer; TenderNo: Code[100]);
    var
        SupplierMandatoryEvaluation: Record "Supplier Mandatory Evaluation";
    begin
        SupplierMandatoryEvaluation.INIT;
        SupplierMandatoryEvaluation."Reference No" := TenderNo;
        SupplierMandatoryEvaluation."Requirement Code" := RequirementCode;
        SupplierMandatoryEvaluation."Requirement Description" := RequirementDescription;
        SupplierMandatoryEvaluation."Evaluator ID" := EvaluatorId;
        SupplierMandatoryEvaluation."Evaluator Name" := EvaluatorName;
        SupplierMandatoryEvaluation."Evaluator No." := EvaluatorNo;
        SupplierMandatoryEvaluation."Vendor Name" := VenderName;
        IF NOT SupplierMandatoryEvaluation.GET(TenderNo, RequirementCode, EvaluatorId, VenderName) THEN
            SupplierMandatoryEvaluation.INSERT;
    end;

    procedure IanGenerateSupplierTechnicalRequirements(VenderName: Text; RequirementCode: Code[100]; RequirementDescription: Text; EvaluatorId: Code[70]; EvaluatorNo: Code[50]; EvaluatorName: Text; LineNo: Integer; TenderNo: Code[100]; MaxScore: Decimal);
    var
        SupplierTechEvaluation: Record "Supplier Technical Evaluation";
    begin
        SupplierTechEvaluation.INIT;
        SupplierTechEvaluation."Reference No" := TenderNo;
        SupplierTechEvaluation."Requirement Code" := RequirementCode;
        SupplierTechEvaluation."Requirement Description" := RequirementDescription;
        SupplierTechEvaluation."Evaluator ID" := EvaluatorId;
        SupplierTechEvaluation."Evaluator Name" := EvaluatorName;
        SupplierTechEvaluation."Evaluator No." := EvaluatorNo;
        SupplierTechEvaluation."Vendor Name" := VenderName;
        SupplierTechEvaluation."Max Score" := MaxScore;
        IF NOT SupplierTechEvaluation.GET(TenderNo, RequirementCode, EvaluatorId, VenderName) THEN
            SupplierTechEvaluation.INSERT;

    end;

    procedure IanGenerateSupplierFinacialEvaluation(VenderName: Text; TenderNo: Code[100]; Amount: Decimal; TechnicalScore: Decimal);
    var
        SupplierFinancialEvaluation: Record "Financial Evaluation";
    begin
        SupplierFinancialEvaluation.INIT;
        SupplierFinancialEvaluation."Reference No." := TenderNo;
        SupplierFinancialEvaluation."Vendor Name" := VenderName;
        SupplierFinancialEvaluation."Quoted Amount" := Amount;
        SupplierFinancialEvaluation."Technical Score" := TechnicalScore;
        IF NOT SupplierFinancialEvaluation.GET(TenderNo, VenderName) THEN
            SupplierFinancialEvaluation.INSERT;

    end;

    procedure IanCheckIfPassedMandatory(ReferenceNo: Code[100]; VendorName: Text): Boolean;
    var
        SupplierMandatoryEvaluation: Record "Supplier Mandatory Evaluation";
    begin
        SupplierMandatoryEvaluation.RESET;
        SupplierMandatoryEvaluation.SETRANGE("Reference No", ReferenceNo);
        SupplierMandatoryEvaluation.SETRANGE("Vendor Name", VendorName);
        SupplierMandatoryEvaluation.SETRANGE(Complied, FALSE);
        EXIT(SupplierMandatoryEvaluation.FINDFIRST);

    end;

    procedure IanCalculateVendorTotal(ReferenceNo: Code[30]; VendorName: Text): Decimal;
    var
        SupplierTechnicalEvaluation: Record "Supplier Technical Evaluation";
    begin
        SupplierTechnicalEvaluation.RESET;
        SupplierTechnicalEvaluation.SETRANGE("Reference No", ReferenceNo);
        SupplierTechnicalEvaluation.SETRANGE("Vendor Name", VendorName);
        IF SupplierTechnicalEvaluation.FINDSET THEN BEGIN
            SupplierTechnicalEvaluation.CALCSUMS(Score);
            EXIT(SupplierTechnicalEvaluation.Score);
        END;
    end;

    procedure IanUpdateSupplierIfPassedTechnical(ReferenceNo: Code[30]; VendorName: Text; Passed: Boolean);
    var
        TenderSuppliers: Record "Tender Suppliers";
    begin
        TenderSuppliers.RESET;
        TenderSuppliers.SETRANGE("Reference No", ReferenceNo);
        TenderSuppliers.SETRANGE("Vendor Name", VendorName);
        IF TenderSuppliers.FINDFIRST THEN BEGIN
            TenderSuppliers."Passed Technical" := Passed;
            TenderSuppliers.MODIFY(TRUE);
        END;
    end;

    procedure IanUpdateSupplierIfPassedMandatory(ReferenceNo: Code[30]; VendorName: Text; Failed: Boolean);
    var
        TenderSuppliers: Record "Tender Suppliers";
    begin
        TenderSuppliers.RESET;
        TenderSuppliers.SETRANGE("Reference No", ReferenceNo);
        TenderSuppliers.SETRANGE("Vendor Name", VendorName);
        IF TenderSuppliers.FINDFIRST THEN BEGIN
            IF Failed THEN
                TenderSuppliers."Passed Mandatory" := FALSE
            ELSE
                TenderSuppliers."Passed Mandatory" := TRUE;
            TenderSuppliers.MODIFY(TRUE);
        END;
    end;

    local procedure IanGetCalculateTotalScore(ReferenceNo: Code[50]): Code[50];
    var
        TenderSuppliers: Record "Tender Suppliers";
    begin

        TenderSuppliers.RESET;
        TenderSuppliers.SETRANGE("Reference No", ReferenceNo);
        IF TenderSuppliers.FINDSET THEN BEGIN
            REPEAT
                TenderSuppliers."Total Score" := TenderSuppliers."Financial Score" + TenderSuppliers."Technical Score";
                TenderSuppliers.MODIFY(TRUE);
            UNTIL TenderSuppliers.NEXT = 0;
        END;
    end;

    procedure IanEndTenderProcess(ReferenceNo: Code[50]);
    var
        FinancialScore: Decimal;
        TenderSuppliers: Record "Tender Suppliers";
        LeastScore: Decimal;
        MaxScore: Decimal;
        ProcurementRequest: Record "Procurement Request";
        Winner: Code[100];
    begin
        IF ProcurementRequest.GET(ReferenceNo) THEN
            MaxScore := ProcurementRequest."Financial Score";


        TenderSuppliers.RESET;
        TenderSuppliers.SETRANGE("Reference No", ReferenceNo);
        TenderSuppliers.SETRANGE("Passed Mandatory", TRUE);
        TenderSuppliers.SETRANGE("Passed Technical", TRUE);
        IF TenderSuppliers.FINDSET THEN BEGIN
            REPEAT
                LeastScore := IanGetLeastBidAmount(ReferenceNo);
                FinancialScore := IanCalculateFinancialScore(LeastScore, TenderSuppliers."Bid Amount", MaxScore);
                IanUpdateSupplierWithFinScore(ReferenceNo, TenderSuppliers."Vendor Name", FinancialScore);
                IanUpdateSupplierWithTotalScore(ReferenceNo, TenderSuppliers."Vendor Name", FinancialScore, TenderSuppliers."Technical Score");
            UNTIL TenderSuppliers.NEXT = 0;
        END;

        Winner := IanGetTenderWinner(ReferenceNo);
        MESSAGE('Winner is %1', Winner);
    end;

    local procedure IanGetTenderWinner(ReferenceNo: Code[50]): Text;
    var
        TenderSuppliers: Record "Tender Suppliers";
    begin

        TenderSuppliers.RESET;
        TenderSuppliers.SETRANGE("Reference No", ReferenceNo);
        TenderSuppliers.SETRANGE("Passed Mandatory", TRUE);
        TenderSuppliers.SETRANGE("Passed Technical", TRUE);
        TenderSuppliers.SETCURRENTKEY("Total Score");
        TenderSuppliers.SETASCENDING("Total Score", TRUE);
        IF TenderSuppliers.FINDLAST THEN BEGIN
            TenderSuppliers.Awarded := TRUE;
            IF TenderSuppliers.MODIFY THEN
                EXIT(TenderSuppliers."Vendor Name");
        END;
    end;

    local procedure IanGetLeastBidAmount(ReferenceNo: Code[50]): Decimal;
    var
        TenderSuppliers: Record "Tender Suppliers";
    begin

        TenderSuppliers.RESET;
        TenderSuppliers.SETRANGE("Reference No", ReferenceNo);
        TenderSuppliers.SETRANGE("Passed Mandatory", TRUE);
        TenderSuppliers.SETRANGE("Passed Technical", TRUE);
        TenderSuppliers.SETCURRENTKEY("Bid Amount");
        TenderSuppliers.SETASCENDING("Bid Amount", TRUE);
        IF TenderSuppliers.FINDFIRST THEN
            EXIT(TenderSuppliers."Bid Amount");
    end;

    procedure IanGetNoofEvaluators(ReferenceNo: Code[30]): Integer;
    var
        EvaluationCommittee: Record "Evaluation Committee";
    begin
        EvaluationCommittee.RESET;
        EvaluationCommittee.SETRANGE("Reference No", ReferenceNo);
        EvaluationCommittee.SETRANGE(Stage, EvaluationCommittee.Stage::Technical);
        EXIT(EvaluationCommittee.COUNT);
    end;

    procedure IanEndTechnicalEvaluation(ProcurementRequest: Record "Procurement Request");
    var
        TenderSuppliers: Record "Tender Suppliers";
        TotalScore: Decimal;
        GetScore: Decimal;
        Passed: Boolean;
        CountFailed: Integer;
        CountPassed: Integer;
    begin
        ProcurementRequest.TESTFIELD("Technical Pass Mark");
        TenderSuppliers.RESET;
        TenderSuppliers.SETRANGE("Reference No", ProcurementRequest."No.");
        IF TenderSuppliers.FINDSET THEN BEGIN
            REPEAT
                TotalScore := IanCalculateVendorTotal(ProcurementRequest."No.", TenderSuppliers."Vendor Name");
                GetScore := IanCalculateTechnicalScore(IanGetNoofEvaluators(ProcurementRequest."No."), TotalScore);
                IanUpdateSupplierWithScore(ProcurementRequest."No.", TenderSuppliers."Vendor Name", GetScore);
                IF GetScore >= ProcurementRequest."Technical Pass Mark" THEN BEGIN
                    Passed := TRUE;
                    CountPassed += 1;
                END ELSE BEGIN
                    Passed := FALSE;
                    CountFailed += 1;
                END;
                IanUpdateSupplierIfPassedTechnical(ProcurementRequest."No.", TenderSuppliers."Vendor Name", Passed);
            UNTIL TenderSuppliers.NEXT = 0;
        END;

        MESSAGE('Technical evaluation has ended \ %1 suppliers passed \ %2 Failed', CountPassed, CountFailed);
    end;

    procedure IanEndMandatoryEvaluation(ProcurementRequest: Record "Procurement Request");
    var
        TenderSuppliers: Record "Tender Suppliers";
        Failed: Boolean;
        CountFailed: Integer;
        CountPassed: Integer;
    begin
        ProcurementRequest.TESTFIELD("Technical Pass Mark");
        TenderSuppliers.RESET;
        TenderSuppliers.SETRANGE("Reference No", ProcurementRequest."No.");
        IF TenderSuppliers.FINDSET THEN BEGIN
            REPEAT
                Failed := IanCheckIfPassedMandatory(ProcurementRequest."No.", TenderSuppliers."Vendor Name");
                IF Failed THEN BEGIN
                    CountFailed += 1;
                END ELSE BEGIN
                    CountPassed += 1;
                END;
                IanUpdateSupplierIfPassedMandatory(ProcurementRequest."No.", TenderSuppliers."Vendor Name", Failed);
            UNTIL TenderSuppliers.NEXT = 0;
        END;

        MESSAGE('Mandatory evaluation has ended \ %1 suppliers passed \ %2 Failed', CountPassed, CountFailed);
    end;

    procedure IanUpdateSupplierWithTotalScore(ReferenceNo: Code[30]; VendorName: Text; FinancialScore: Decimal; TechScore: Decimal);
    var
        TenderSuppliers: Record "Tender Suppliers";
    begin
        TenderSuppliers.RESET;
        TenderSuppliers.SETRANGE("Reference No", ReferenceNo);
        TenderSuppliers.SETRANGE("Vendor Name", VendorName);
        IF TenderSuppliers.FINDFIRST THEN BEGIN
            TenderSuppliers."Total Score" := FinancialScore + TechScore;
            TenderSuppliers.MODIFY(TRUE);
        END;
    end;

    procedure IanUpdateSupplierWithFinScore(ReferenceNo: Code[30]; VendorName: Text; FinancialScore: Decimal);
    var
        TenderSuppliers: Record "Tender Suppliers";
    begin
        TenderSuppliers.RESET;
        TenderSuppliers.SETRANGE("Reference No", ReferenceNo);
        TenderSuppliers.SETRANGE("Vendor Name", VendorName);
        IF TenderSuppliers.FINDFIRST THEN BEGIN
            TenderSuppliers."Financial Score" := FinancialScore;
            TenderSuppliers.MODIFY(TRUE);
        END;
    end;

    procedure IanCalculateFinancialScore(LeastScore: Decimal; SupplierScore: Decimal; FinacialMaxScore: Decimal): Decimal;
    begin

        EXIT((LeastScore / SupplierScore) * FinacialMaxScore);
    end;

    procedure IanUpdateSupplierWithScore(ReferenceNo: Code[30]; VendorName: Text; TechnicalScore: Decimal);
    var
        TenderSuppliers: Record "Tender Suppliers";
    begin
        TenderSuppliers.RESET;
        TenderSuppliers.SETRANGE("Reference No", ReferenceNo);
        TenderSuppliers.SETRANGE("Vendor Name", VendorName);
        IF TenderSuppliers.FINDFIRST THEN BEGIN
            TenderSuppliers."Technical Score" := TechnicalScore;
            TenderSuppliers.MODIFY(TRUE);
        END;
    end;

    procedure IanCalculateTechnicalScore(NoOfEvaluators: Integer; TotalScore: Decimal): Decimal;
    begin
        EXIT((TotalScore / NoOfEvaluators));
    end;

    procedure IanSubmitMandatoryScore(EvaluationCommittee: Record "Evaluation Committee");
    var
        SenderAddress: Text;
        SenderName: Text;
        Recepient: Text;
        Subject: Text;
        Body: Text;
    begin
        EvaluationCommittee."Submitted Mandatory Evaluation" := TRUE;
        IF EvaluationCommittee.MODIFY(TRUE) THEN BEGIN
            ProcurementSetup.GET;
            ProcurementSetup.TESTFIELD("Procurement Officer User Id");
            IF UserSetup.GET(ProcurementSetup."Procurement Officer User Id") THEN BEGIN
                Recepient := UserSetup."E-Mail";
                Subject := 'Technical Evaluation Submition';
                IF Employee.GET(UserSetup."Employee no") THEN
                    Body := 'Dear ' + FORMAT(Employee."First Name" + ' ' + Employee."Last Name") + ' <br> ' + FORMAT(EvaluationCommittee."Employee Name") + ' has submitted their ' +
                           'Mandatory evaluation for tender No. ' + FORMAT(EvaluationCommittee."Reference No") + '<br><br> This is a system generated E-mail ' +
                           'Please do not reply to it <br> Regards';

                IanSoftFactory.IanSendEmailWithoutAttachement(SenderName, SenderAddress, Recepient, Subject, Body);
            END;
            MESSAGE('Mandatory Evaluation successfully Submited');
        END;
    end;

    procedure IanSubmitTechnicalScore(EvaluationCommittee: Record "Evaluation Committee");
    var
        SenderAddress: Text;
        SenderName: Text;
        Recepient: Text;
        Subject: Text;
        Body: Text;
    begin
        EvaluationCommittee."Submitted Technical Evaluation" := TRUE;
        IF EvaluationCommittee.MODIFY(TRUE) THEN BEGIN
            ProcurementSetup.GET;
            ProcurementSetup.TESTFIELD("Procurement Officer User Id");
            IF UserSetup.GET(ProcurementSetup."Procurement Officer User Id") THEN BEGIN
                Recepient := UserSetup."E-Mail";
                Subject := 'Technical Evaluation Submition';
                IF Employee.GET(UserSetup."Employee no") THEN
                    Body := 'Dear ' + FORMAT(Employee."First Name" + ' ' + Employee."Last Name") + ' <br> ' + FORMAT(EvaluationCommittee."Employee Name") + ' has submitted their ' +
                           'technical evaluation for tender No. ' + FORMAT(EvaluationCommittee."Reference No") + '<br><br> This is a system generated E-mail ' +
                           'Please do not reply to it <br> Regards';

                IanSoftFactory.IanSendEmailWithoutAttachement(SenderName, SenderAddress, Recepient, Subject, Body);
            END;
            MESSAGE('Technical Evaluation successfully Submited');
        END;
    end;

    procedure IanCreatePurchaseHeader(VendorNo: Code[50]; TenderNo: Code[100]; RequistionNo: Code[100]; RFQNo: Code[100]; RFPNo: Code[100]; ContractNo: Code[100]; "Require Inspection": Boolean): Code[70];
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        NoSeriesManagement: Codeunit "No. Series";
        PurchaseHeader: Record "Purchase Header";
        InvoiceNo: Code[50];
        ProcurementRequest: Record "Procurement Request";
    begin
        PurchaseHeader.INIT;
        PurchaseHeader.VALIDATE("Document Type", PurchaseHeader."Document Type"::Order);
        PurchaseHeader.VALIDATE("Buy-from Vendor No.", VendorNo);
        PurchasesPayablesSetup.GET;
        InvoiceNo := NoSeriesManagement.GetNextNo(PurchasesPayablesSetup."Order Nos.", 0D, TRUE);
        PurchaseHeader.VALIDATE("No.", InvoiceNo);
        PurchaseHeader.VALIDATE("Document Date", TODAY);
        // None of "Tender No", "Contract No", "Requires Inspection", "Procurement Doc.
        // No.", "Quotation No" or "Order Type" exist on Purchase Header here - the
        // already-modernized CreatePurchaseHeader in Cod50004.ProcurementProcessMgmt.al
        // doesn't set them either, so they were dropped rather than renamed. The
        // trailing SETRANGE("Quotation No", ProcurementRequest."No.") block below was
        // also dead in the original: ProcurementRequest is never populated before this
        // read, so the filter was always blank.
        // "Tender No" := TenderNo;
        // "Contract No" := ContractNo;
        PurchaseHeader."Requisition No" := RequistionNo;
        // "Requires Inspection" := "Require Inspection";
        // "Procurement Doc. No." := RFPNo;
        //"Procurement Doc. No.":=RFQNo;
        PurchaseHeader."Created By" := USERID;
        PurchaseHeader.INSERT;
        // PurchaseHeader.RESET;
        // PurchaseHeader.SETRANGE("Quotation No", ProcurementRequest."No.");
        // IF PurchaseHeader.FINDFIRST THEN BEGIN
        //     PurchaseHeader."Order Type" := PurchaseHeader."Order Type"::Normal;
        //     PurchaseHeader.MODIFY;
        // END;

        EXIT(InvoiceNo);
    end;

    procedure IanCreatePurchaseLines(InvoiceNo: Code[50]; TypeParam: Option "G/L Account","Fixed Asset",Item; No: Code[50]; QuantityParam: Integer; UnitPrice: Decimal; LocationParam: Code[50]; GlobalDim1: Code[50]; GlobalDim2: Code[50]; GlobalDim3: Code[50]; GlobalDim4: Code[50]; GlobalDim5: Code[50]; ProPlan: Code[450]; BudgetAmount: Decimal; DescriptionParam: Text[250]; dimsetid: Integer; ProjectCode: Code[10]; DonorN: Code[20]; GrantN: Code[20]; ObjectiveN: Code[20]; Output: Code[20]; Outcome: Code[20]; ActivityN: Code[20]; PartnerN: Code[20]): Boolean;
    var
        PurchaseLine: Record "Purchase Line";
        GLAccount: Record "G/L Account";
        FixedAsset: Record "Fixed Asset";
        Item: Record "Item";
        PurchaseHeader: Record "Purchase Header";
    begin
        PurchaseLine.INIT;
        PurchaseLine.VALIDATE("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine."Document No." := InvoiceNo;
        PurchaseLine.VALIDATE("Document No.");
        IF TypeParam IN [TypeParam::"Fixed Asset"] THEN BEGIN
            PurchaseLine.VALIDATE(Type, PurchaseLine.Type::"Fixed Asset");
        END;
        IF TypeParam IN [TypeParam::"G/L Account"] THEN BEGIN
            PurchaseLine.VALIDATE(Type, PurchaseLine.Type::"G/L Account");
        END;
        IF TypeParam IN [TypeParam::Item] THEN BEGIN
            PurchaseLine.VALIDATE(Type, PurchaseLine.Type::Item);
        END;

        PurchaseLine."No." := No;
        IF FixedAsset.GET(PurchaseLine."No.") THEN BEGIN
            PurchaseLine.Description := FixedAsset.Description;
            PurchaseLine.VALIDATE("No.");
            PurchaseLine."FA Posting Type" := PurchaseLine."FA Posting Type"::Maintenance;
        END;
        IF GLAccount.GET(PurchaseLine."No.") THEN BEGIN
            PurchaseLine.VALIDATE("No.");
        END;
        IF Item.GET(PurchaseLine."No.") THEN BEGIN
            PurchaseLine.Description := Item.Description;
            PurchaseLine.VALIDATE("No.");
        END;

        IF PurchaseHeader.GET(PurchaseHeader."Document Type"::Order, InvoiceNo) THEN
            PurchaseLine.VALIDATE("Buy-from Vendor No.", PurchaseHeader."Buy-from Vendor No.");
        PurchaseLine.Quantity := QuantityParam;
        PurchaseLine.VALIDATE(Quantity);
        PurchaseLine."Unit Cost" := UnitPrice;
        PurchaseLine."Direct Unit Cost" := UnitPrice;
        PurchaseLine.VALIDATE("Direct Unit Cost");
        PurchaseLine."Location Code" := LocationParam;
        //PurchaseLine.VALIDATE("Location Code");
        // Purchase Line has no field named "Description 2" - the field with that
        // caption is actually named "Description 3" (Tab-Ext50003.PurchaseLine3.al).
        PurchaseLine."Description 3" := COPYSTR(DescriptionParam, 1, 50);
        PurchaseLine.VALIDATE("Description 3", COPYSTR(DescriptionParam, 1, 50));
        // "Project Code" only exists on Purchase Header (field 90156), not on Purchase
        // Line; there's no per-line project code to set here.
        // PurchaseLine."Project Code" := ProjectCode;
        PurchaseLine."Donor No." := DonorN;
        PurchaseLine."Grant No." := GrantN;
        PurchaseLine."Objective Code" := ObjectiveN;
        PurchaseLine."Output Code" := Output;
        PurchaseLine."Outcome Code" := Outcome;
        PurchaseLine."Activity Code" := ActivityN;
        PurchaseLine."Partner Code" := PartnerN;
        PurchaseLine."Procurement Plan" := ProPlan;
        PurchaseLine."Shortcut Dimension 1 Code" := GlobalDim1;
        PurchaseLine."Shortcut Dimension 2 Code" := GlobalDim2;
        PurchaseLine.ValidateShortcutDimCode(3, GlobalDim3);
        PurchaseLine.ValidateShortcutDimCode(4, GlobalDim4);
        PurchaseLine.ValidateShortcutDimCode(5, GlobalDim5);
        // "Budget Amount" doesn't exist on Purchase Line either (same gap as
        // Tab28.ProcurementRequestLines.al, which comments out the same assignment).
        // PurchaseLine."Budget Amount" := BudgetAmount;
        // PurchaseLine."Dimension Set ID" := dimsetid;
        // Purchase Line has no "Narration" field; the nearest equivalent is the custom
        // "Grants Narration" field (field 80009).
        PurchaseLine."Grants Narration" := DescriptionParam;
        PurchaseLine."Line No." := PurchaseLine.COUNT + 1;
        PurchaseLine.INSERT;


    end;

    procedure IanSendQuoteToSuppliers(VendorNo: Code[10]; VendorName: Text; EmailAddress: Text; AttachementFilePath: Text; AttachementName: Text);
    var
        IanSoftFactory: Codeunit "IanSoftFactory";
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
        Text001: Label 'C:\RCKQuotes\Quotes.pdf';
    begin
        Subject := 'Invitation For Quote';
        Body := 'Hello <br> You have been invited for a quotation at RCK' +
               ' Please log in to the portal and submit your bids <br>' +
                ' This is a system generated Mail, Please dont reply to it <Br>Regards';
        IanSoftFactory.IanSendEmailWithoutAttachement(SenderName, SenderAddress, EmailAddress, Subject, Body);
    end;

    procedure IanSendTenderToSuppliers(VendorNo: Code[10]; VendorName: Text; EmailAddress: Text; AttachementFilePath: Text; AttachementName: Text; ClosingDate: Date);
    var
        IanSoftFactory: Codeunit "IanSoftFactory";
        SenderAddress: Text;
        SenderName: Text;
        Body: Text;
        Subject: Text;
    begin
        Subject := 'Invitation For Tender';
        Body := 'Hello <br> You have been invited for tendering at RCK' +
               ' Please log in to the portal and submit your bids <br>' +
                ' This is a system generated Mail, Please dont reply to it <Br>Regards';
        IanSoftFactory.IanSendEmailWithoutAttachement(SenderName, SenderAddress, EmailAddress, Subject, Body);
    end;

    procedure IanStartQuotationEvaluation(var ProcurementRequest: Record "Procurement Request");
    var
        QuotationBidders: Record "Quotation Bidders";
        ProcurementRequestLines: Record "Procurement Request Lines";
    begin
        ProcurementRequest."Quotation Status" := ProcurementRequest."Quotation Status"::"Quote Submission";
        IF ProcurementRequest.MODIFY(TRUE) THEN BEGIN
            ProcurementRequestLines.RESET;
            ProcurementRequestLines.SETRANGE("Procurement No", ProcurementRequest."No.");
            IF ProcurementRequestLines.FINDSET THEN BEGIN
                REPEAT
                    QuotationBidders.RESET;
                    QuotationBidders.SETRANGE("Reference No", ProcurementRequest."No.");
                    IF QuotationBidders.FINDSET THEN BEGIN
                        REPEAT
                            IanCreateVendorBidsLines(ProcurementRequest."No.", QuotationBidders."Vendor No.", QuotationBidders."Vendor Name",
                                                      ProcurementRequestLines."Line No.", ProcurementRequestLines.No, ProcurementRequestLines.Name,
                                                      ProcurementRequestLines.Description, ProcurementRequestLines.Quantity);
                        UNTIL QuotationBidders.NEXT = 0;
                    END;
                UNTIL ProcurementRequestLines.NEXT = 0;
            END;
            MESSAGE('Quotation successfuly moved to evaluation');
        END;
    end;

    local procedure IanCreateVendorBidsLines(QuoteNo: Code[100]; VendorNo: Code[100]; VendorName: Text; LineNo: Integer; ItemNo: Code[100]; ItemName: Text; LineDescription: Text; QuantityVar: Integer);
    var
        QuotationBidders: Record "Quotation Bidders";
        QuotationVendorsBids: Record "Quotation Vendors Bids";
    begin
        QuotationVendorsBids.INIT;
        QuotationVendorsBids."Quote No" := QuoteNo;
        QuotationVendorsBids."Vendor No" := VendorNo;
        QuotationVendorsBids."Vendor Name" := VendorName;
        QuotationVendorsBids."Line No" := LineNo;
        QuotationVendorsBids."Item No" := ItemNo;
        QuotationVendorsBids."Item Name" := ItemName;
        QuotationVendorsBids.Description := QuotationVendorsBids.Description;
        QuotationVendorsBids.Quantity := QuantityVar;
        QuotationVendorsBids.INSERT;
    end;

    procedure IanGetTheLeastQuotedAmount(QuoteNo: Code[50]): Code[100];
    var
        QuotationVendorsBids: Record "Quotation Bidders";
    begin
        QuotationVendorsBids.RESET;
        QuotationVendorsBids.SETRANGE("Reference No", QuoteNo);
        QuotationVendorsBids.CALCFIELDS("Total Quoted Amount");
        QuotationVendorsBids.SETFILTER("Total Quoted Amount", '>%1', 0);
        QuotationVendorsBids.SETCURRENTKEY("Total Quoted Amount");
        QuotationVendorsBids.SETASCENDING("Total Quoted Amount", TRUE);
        IF QuotationVendorsBids.FINDFIRST THEN
            EXIT(QuotationVendorsBids."Vendor No.");
    end;

    procedure IanChangeStatusOnVendorInvitation(ProcurementRequest: Record "Procurement Request");
    begin
        ProcurementRequest."Quotation Status" := ProcurementRequest."Quotation Status"::"Supplier Invitation";
        ProcurementRequest."Date Advertisement" := TODAY;
        IF ProcurementRequest.MODIFY(TRUE) THEN
            MESSAGE('Invitation Successfully Sent');
    end;

    procedure IanChangeStatusOnQuotationAward(ProcurementRequest: Record "Procurement Request"; OrderNo: Code[50]);
    begin
        ProcurementRequest."Quotation Status" := ProcurementRequest."Quotation Status"::"Order Created";
        ProcurementRequest."Generated Order No" := OrderNo;
        ProcurementRequest."Date Awarded" := TODAY;
        IF ProcurementRequest.MODIFY(TRUE) THEN
            MESSAGE('Order(s) Successfuly created');
    end;

    procedure IanChangeStatusOnRFPAward(ProcurementRequest: Record "Procurement Request"; OrderNo: Code[100]);
    begin
        ProcurementRequest."RFP Status" := ProcurementRequest."RFP Status"::"Order Created";
        ProcurementRequest."Generated Order No" := OrderNo;
        ProcurementRequest."Date Awarded" := TODAY;
        IF ProcurementRequest.MODIFY(TRUE) THEN
            MESSAGE('Order(s) Successfuly created');
    end;

    procedure IanChangeStatusOnDirectProcAward(ProcurementRequest: Record "Procurement Request"; OrderNo: Code[100]);
    begin
        ProcurementRequest."Direct Procurement Status" := ProcurementRequest."Direct Procurement Status"::"Order Created";
        ProcurementRequest."Generated Order No" := OrderNo;
        ProcurementRequest."Date Awarded" := TODAY;
        IF ProcurementRequest.MODIFY(TRUE) THEN
            MESSAGE('Order(s) Successfuly created');
    end;

    procedure IanStartTenderMandatoryEvaluation(var ProcurementRequest: Record "Procurement Request");
    var
        TenderSuppliers: Record "Tender Suppliers";
        EvaluationCommittee: Record "Evaluation Committee";
        TechnicalSpecifications: Record "Mandatory Requirements";
        SenderAddress: Text;
        SenderName: Text;
        Recepient: Text;
        Subject: Text;
        Body: Text;
        ProcurementSetup: Record "Procurement Setup";
        Employee: Record "Employee";
        UserSetup: Record "User Setup";
        ProgressWindow: Dialog;
    begin
        TenderSuppliers.RESET;
        TenderSuppliers.SETRANGE("Reference No", ProcurementRequest."No.");
        IF TenderSuppliers.FINDSET THEN BEGIN
            ProgressWindow.OPEN('Setting Up For : #1################ \ Creating Evaluation records For : #2################# Creating Mand. Spec. : #3####################');
            REPEAT
                ProgressWindow.UPDATE(1, TenderSuppliers."Vendor Name");
                EvaluationCommittee.RESET;
                EvaluationCommittee.SETRANGE("Reference No", ProcurementRequest."No.");
                EvaluationCommittee.SETRANGE(Stage, EvaluationCommittee.Stage::Mandatory);
                IF EvaluationCommittee.FINDSET THEN BEGIN
                    REPEAT
                        SLEEP(100);
                        ProgressWindow.UPDATE(2, EvaluationCommittee."User Name");
                        TechnicalSpecifications.RESET;
                        TechnicalSpecifications.SETRANGE("Reference No", ProcurementRequest."No.");
                        IF TechnicalSpecifications.FINDSET THEN BEGIN
                            REPEAT
                                SLEEP(100);
                                ProgressWindow.UPDATE(3, TechnicalSpecifications."Requirement Description");
                                SLEEP(100);
                                IanGenerateSupplierMandatoryRequirements(TenderSuppliers."Vendor Name", TechnicalSpecifications."Requirement Code",
                                                                          TechnicalSpecifications."Requirement Description", EvaluationCommittee."User Name",
                                                                          EvaluationCommittee."Employee No.", EvaluationCommittee."Employee Name",
                                                                          0, ProcurementRequest."No.");
                            UNTIL TechnicalSpecifications.NEXT = 0;
                        END;
                    UNTIL EvaluationCommittee.NEXT = 0;
                END;
            UNTIL TenderSuppliers.NEXT = 0;
            ProgressWindow.CLOSE();
        END;
        ProcurementRequest."Tender Status" := ProcurementRequest."Tender Status"::"Mandatory Req Evaluation";
        ProcurementRequest."Date of Mandatory Evaluation" := TODAY;
        IF ProcurementRequest.MODIFY(TRUE) THEN BEGIN
            ProcurementSetup.GET;
            EvaluationCommittee.RESET;
            EvaluationCommittee.SETRANGE("Reference No", ProcurementRequest."No.");
            EvaluationCommittee.SETRANGE(Stage, EvaluationCommittee.Stage::Mandatory);
            IF EvaluationCommittee.FINDSET THEN BEGIN
                ProgressWindow.OPEN('Notifying Evaluation Commitee Member : #1#########################');
                REPEAT
                    ProgressWindow.UPDATE(1, EvaluationCommittee."Employee Name");
                    SLEEP(100);
                    IF UserSetup.GET(EvaluationCommittee."User Name") THEN
                        Recepient := UserSetup."E-Mail";
                    Subject := 'Mandatory Evaluation Invitation';
                    Body := 'Dear ' + FORMAT(EvaluationCommittee."Employee Name") + ' <br> Mandatory Evaluation for tender No ' + FORMAT(ProcurementRequest."No.") +
                           ' has been initiated and you are invited to start the evaluation ' +
                           '<br><br> This is a system generated E-mail ' +
                           'Please do not reply to it <br> Regards';

                    IanSoftFactory.IanSendEmailWithoutAttachement(SenderName, SenderAddress, Recepient, Subject, Body);
                UNTIL EvaluationCommittee.NEXT = 0;
                ProgressWindow.CLOSE();
            END;
            MESSAGE('Tender Successfully moved to mandatory evaluation');
        END;
    end;

    procedure IanStartTenderTechnicalEvaluation(ProcurementRequest: Record "Procurement Request");
    var
        TenderSuppliers: Record "Tender Suppliers";
        EvaluationCommittee: Record "Evaluation Committee";
        TechnicalSpecifications: Record "Technical Specifications";
        SenderAddress: Text;
        SenderName: Text;
        Recepient: Text;
        Subject: Text;
        Body: Text;
        ProcurementSetup: Record "Procurement Setup";
        Employee: Record "Employee";
        UserSetup: Record "User Setup";
        ProgressWindow: Dialog;
    begin
        IanEndMandatoryEvaluation(ProcurementRequest);
        TenderSuppliers.RESET;
        TenderSuppliers.SETRANGE("Reference No", ProcurementRequest."No.");
        TenderSuppliers.SETRANGE("Passed Mandatory", TRUE);
        IF TenderSuppliers.FINDSET THEN BEGIN
            ProgressWindow.OPEN('Setting Up For : #1################ \ Creating Evaluation records For : #2################# Creating Tech. Spec. : #3####################');
            REPEAT
                ProgressWindow.UPDATE(1, TenderSuppliers."Vendor Name");
                SLEEP(100);
                EvaluationCommittee.RESET;
                EvaluationCommittee.SETRANGE("Reference No", ProcurementRequest."No.");
                EvaluationCommittee.SETRANGE(Stage, EvaluationCommittee.Stage::Technical);
                IF EvaluationCommittee.FINDSET THEN BEGIN
                    REPEAT
                        ProgressWindow.UPDATE(2, EvaluationCommittee."Employee Name");
                        SLEEP(100);
                        TechnicalSpecifications.RESET;
                        TechnicalSpecifications.SETRANGE("Reference No.", ProcurementRequest."No.");
                        IF TechnicalSpecifications.FINDSET THEN BEGIN
                            REPEAT
                                ProgressWindow.UPDATE(3, TechnicalSpecifications."Requirement Specification");
                                SLEEP(100);
                                IanGenerateSupplierTechnicalRequirements(TenderSuppliers."Vendor Name", TechnicalSpecifications."Requirement Code",
                                                                          TechnicalSpecifications."Requirement Specification", EvaluationCommittee."User Name",
                                                                          EvaluationCommittee."Employee No.", EvaluationCommittee."Employee Name",
                                                                          0, ProcurementRequest."No.", TechnicalSpecifications."Max Weigth");
                            UNTIL TechnicalSpecifications.NEXT = 0;
                        END;
                    UNTIL EvaluationCommittee.NEXT = 0;
                END;
            UNTIL TenderSuppliers.NEXT = 0;
            ProgressWindow.CLOSE();
        END ELSE BEGIN
            MESSAGE('No supplier passed Mandatory');
            EXIT;
        END;
        ProcurementRequest."Tender Status" := ProcurementRequest."Tender Status"::"Technical Req Evaluation";
        ProcurementRequest."Date of Technical Evaluation" := TODAY;
        ProcurementSetup.GET;
        EvaluationCommittee.RESET;
        EvaluationCommittee.SETRANGE("Reference No", ProcurementRequest."No.");
        EvaluationCommittee.SETRANGE(Stage, EvaluationCommittee.Stage::Technical);
        IF EvaluationCommittee.FINDSET THEN BEGIN
            ProgressWindow.OPEN('Notifying Evaluation Member : #1#######################');
            REPEAT
                ProgressWindow.UPDATE(1, EvaluationCommittee."Employee Name");
                SLEEP(100);
                IF UserSetup.GET(EvaluationCommittee."User Name") THEN
                    Recepient := UserSetup."E-Mail";
                Subject := 'Technical Evaluation Invitation';
                Body := 'Dear ' + FORMAT(EvaluationCommittee."Employee Name") + ' <br> Technical Evaluation for tender No ' + FORMAT(ProcurementRequest."No.") +
                       'has been initiated and you are invited to start the evaluation ' +
                       '<br><br> This is a system generated E-mail ' +
                       'Please do not reply to it <br> Regards';

                IanSoftFactory.IanSendEmailWithoutAttachement(SenderName, SenderAddress, Recepient, Subject, Body);
            UNTIL EvaluationCommittee.NEXT = 0;
            ProgressWindow.CLOSE();
        END;
        MESSAGE('Tender Successfully moved to technical evaluation');
    end;

    procedure IanStartTenderFinancialEvaluation(ProcurementRequest: Record "Procurement Request");
    var
        TenderSuppliers: Record "Tender Suppliers";
        ProgressWindow: Dialog;
    begin
        IanEndTechnicalEvaluation(ProcurementRequest);
        TenderSuppliers.RESET;
        TenderSuppliers.SETRANGE("Reference No", ProcurementRequest."No.");
        TenderSuppliers.SETRANGE("Passed Technical", TRUE);
        IF TenderSuppliers.FINDSET THEN BEGIN
            ProgressWindow.OPEN('Creating Financial Evaluation For : #1###########################');
            REPEAT
                ProgressWindow.UPDATE(1, TenderSuppliers."Vendor Name");
                SLEEP(100);
                TenderSuppliers.TESTFIELD("Bid Amount");
                IanGenerateSupplierFinacialEvaluation(TenderSuppliers."Vendor Name", ProcurementRequest."No.", TenderSuppliers."Bid Amount", TenderSuppliers."Technical Score");
            UNTIL TenderSuppliers.NEXT = 0;
            ProgressWindow.CLOSE();
        END ELSE BEGIN
            MESSAGE('No supplier passed technical');
            EXIT;
        END;
        ProcurementRequest."Tender Status" := ProcurementRequest."Tender Status"::"Financial Evaluation";
        ProcurementRequest."Date of Financial Evaluation" := TODAY;
        IF ProcurementRequest.MODIFY(TRUE) THEN
            MESSAGE('Tender Successfully moved to financial evaluation');
    end;

    procedure IanChangeStatusToOrderCreated(ProcurementRequest: Record "Procurement Request"; OrderNo: Code[50]);
    begin
        ProcurementRequest."Tender Status" := ProcurementRequest."Tender Status"::"Order Created";
        ProcurementRequest."Generated Order No" := OrderNo;
        ProcurementRequest."Date Awarded" := TODAY;
        IF ProcurementRequest.MODIFY(TRUE) THEN
            MESSAGE('Order No [%1] successfully created', OrderNo);
    end;

    procedure IanChangeStatusToContractCreated(ProcurementRequest: Record "Procurement Request"; ContractNo: Code[50]);
    begin
        ProcurementRequest."Tender Status" := ProcurementRequest."Tender Status"::"Contract Created";
        ProcurementRequest."Contract No Generated" := ContractNo;
        ProcurementRequest."Date Awarded" := TODAY;
        IF ProcurementRequest.MODIFY(TRUE) THEN
            MESSAGE('Contract No [%1] successfully created', ContractNo);
    end;

    procedure IanMoveTenderToAdvertisementStage(ProcurementRequest: Record "Procurement Request");
    begin
        ProcurementRequest."Tender Status" := ProcurementRequest."Tender Status"::Advertised;
        ProcurementRequest."Date Advertisement" := TODAY;
        IF ProcurementRequest.MODIFY(TRUE) THEN
            MESSAGE('Tender Successfully moved to advertised staged');
    end;

    procedure IanCreateContractHeader(VendorNo: Code[50]; TenderNo: Code[100]; RequistionNo: Code[100]): Code[70];
    var
        ProcurementSetup: Record "Procurement Setup";
        NoSeriesManagement: Codeunit "No. Series";
        ContractHeader: Record "Contract Header";
        ContractNo: Code[50];
    begin
        ContractHeader.INIT;
        ProcurementSetup.GET;
        ContractNo := NoSeriesManagement.GetNextNo(ProcurementSetup."Contract Nos", 0D, TRUE);
        ContractHeader."No." := ContractNo;
        ContractHeader."Vendor No." := VendorNo;
        ContractHeader.VALIDATE("Vendor No.");
        ContractHeader."Tender No." := TenderNo;
        ContractHeader.VALIDATE("Tender No.");
        ContractHeader."Requisition No" := RequistionNo;
        ContractHeader.INSERT;

        EXIT(ContractNo);
    end;

    procedure IanCreateContractLines(ContractNo: Code[50]; ProcurementRequestLines: Record "Procurement Request Lines"): Boolean;
    var
        ContractLines: Record "Contract Lines";
    begin
        ContractLines.INIT;
        ContractLines.TRANSFERFIELDS(ProcurementRequestLines);
        ContractLines."Contract No." := ContractNo;
        ContractLines.INSERT;
    end;

    procedure IanCreateVendorToAward(VendorName: Text; EmailAddress: Code[10]; PhoneNo: Code[10]; VendorCategoryParam: Code[100]): Code[100];
    var
        Vendor: Record "Vendor";
        SupplierCategory: Record "Supplier Category";
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        VendorNoAssigned: Code[100];
        NoSeriesManagement: Codeunit "No. Series";
    begin
        SupplierCategory.RESET;
        SupplierCategory.SETRANGE("Category Code", VendorCategoryParam);
        IF SupplierCategory.FINDFIRST THEN BEGIN
            PurchasesPayablesSetup.GET;
            PurchasesPayablesSetup.TESTFIELD("Vendor Nos.");
            VendorNoAssigned := NoSeriesManagement.GetNextNo(PurchasesPayablesSetup."Vendor Nos.", 0D, TRUE);
            Vendor.INIT;
            Vendor."No." := VendorNoAssigned;
            Vendor.VALIDATE(Name, VendorName);
            Vendor."Supplier Category" := VendorCategoryParam;
            Vendor."Gen. Bus. Posting Group" := SupplierCategory."Gen. Bus. Posting Group";
            Vendor."VAT Bus. Posting Group" := SupplierCategory."VAT Bus. Posting Group";
            Vendor."Vendor Posting Group" := SupplierCategory."Vendor Posting Group";
            IF VendorNoAssigned <> '' THEN
                Vendor.INSERT;
        END;

        EXIT(VendorNoAssigned);
    end;

    procedure IanInitiateProcurementProcess(RequisitionHeader: Record "Purchase Header"): Code[50];
    var
        RequisitionLines: Record "Purchase Line";
        ProcurementRequest: Record "Procurement Request";
        ProcurementRequestLines: Record "Procurement Request Lines";
        ProcurementNo: Code[50];
    begin
        RequisitionLines.RESET;
        RequisitionLines.SETRANGE("Document Type", RequisitionHeader."Document Type");
        RequisitionLines.SETRANGE("Document No.", RequisitionHeader."No.");
        RequisitionLines.SETRANGE("Procurement Method", RequisitionLines."Procurement Method"::Tender);
        IF RequisitionLines.FINDFIRST THEN BEGIN
            ProcurementNo := IanCreateProcurementHeader(RequisitionHeader, RequisitionLines."Procurement Method");
            REPEAT
                IanCreateProcurementLines(RequisitionLines, ProcurementNo);
            UNTIL RequisitionLines.NEXT = 0;
        END;

        RequisitionLines.RESET;
        RequisitionLines.SETRANGE("Document Type", RequisitionHeader."Document Type");
        RequisitionLines.SETRANGE("Document No.", RequisitionHeader."No.");
        RequisitionLines.SETRANGE("Procurement Method", RequisitionLines."Procurement Method"::RFP);
        IF RequisitionLines.FINDFIRST THEN BEGIN
            ProcurementNo := IanCreateProcurementHeader(RequisitionHeader, RequisitionLines."Procurement Method");
            REPEAT
                IanCreateProcurementLines(RequisitionLines, ProcurementNo);
            UNTIL RequisitionLines.NEXT = 0;
        END;

        RequisitionLines.RESET;
        RequisitionLines.SETRANGE("Document Type", RequisitionHeader."Document Type");
        RequisitionLines.SETRANGE("Document No.", RequisitionHeader."No.");
        RequisitionLines.SETRANGE("Procurement Method", RequisitionLines."Procurement Method"::RFQ);
        IF RequisitionLines.FINDFIRST THEN BEGIN
            ProcurementNo := IanCreateProcurementHeader(RequisitionHeader, RequisitionLines."Procurement Method");
            REPEAT
                IanCreateProcurementLines(RequisitionLines, ProcurementNo);
            UNTIL RequisitionLines.NEXT = 0;
        END;

        RequisitionLines.RESET;
        RequisitionLines.SETRANGE("Document Type", RequisitionHeader."Document Type");
        RequisitionLines.SETRANGE("Document No.", RequisitionHeader."No.");
        RequisitionLines.SETRANGE("Procurement Method", RequisitionLines."Procurement Method"::"Direct Procurement");
        IF RequisitionLines.FINDFIRST THEN BEGIN
            ProcurementNo := IanCreateProcurementHeader(RequisitionHeader, RequisitionLines."Procurement Method");
            REPEAT
                IanCreateProcurementLines(RequisitionLines, ProcurementNo);
            UNTIL RequisitionLines.NEXT = 0;
        END;

        EXIT(ProcurementNo);
    end;

    local procedure IanCreateProcurementHeader(RequisitionHeader: Record "Purchase Header"; ProcurementMethod: Option " ",Tender,RFQ,"Direct Procurement",RFP): Code[50];
    var
        ProcurementRequest: Record "Procurement Request";
        ProcurementSetup: Record "Procurement Setup";
        NoSeriesManagement: Codeunit "No. Series";
        ProcurementNo: Code[50];
    begin
        IF ProcurementMethod IN [ProcurementMethod::Tender] THEN BEGIN
            ProcurementSetup.GET;
            ProcurementSetup.TESTFIELD("Tender Nos");
            ProcurementNo := NoSeriesManagement.GetNextNo(ProcurementSetup."Tender Nos", 0D, TRUE);
        END;

        IF ProcurementMethod IN [ProcurementMethod::RFQ] THEN BEGIN
            ProcurementSetup.GET;
            ProcurementSetup.TESTFIELD("Quotation Nos");
            ProcurementNo := NoSeriesManagement.GetNextNo(ProcurementSetup."Quotation Nos", 0D, TRUE);
        END;

        IF ProcurementMethod IN [ProcurementMethod::RFP] THEN BEGIN
            ProcurementSetup.GET;
            ProcurementSetup.TESTFIELD("RFP Nos");
            ProcurementNo := NoSeriesManagement.GetNextNo(ProcurementSetup."RFP Nos", 0D, TRUE);
        END;

        IF ProcurementMethod IN [ProcurementMethod::"Direct Procurement"] THEN BEGIN
            ProcurementSetup.GET;
            ProcurementSetup.TESTFIELD("Direct Procurement Nos");
            ProcurementNo := NoSeriesManagement.GetNextNo(ProcurementSetup."Direct Procurement Nos", 0D, TRUE);
        END;

        ProcurementRequest.INIT;
        ProcurementRequest."No." := ProcurementNo;
        ProcurementRequest."Requisiton No" := RequisitionHeader."No.";
        ProcurementRequest."Global Dimension 1 Code" := RequisitionHeader."Shortcut Dimension 1 Code";
        ProcurementRequest."Global Dimension 2 Code" := RequisitionHeader."Shortcut Dimension 2 Code";
        ProcurementRequest."Current Budget" := RequisitionHeader."Budget Code";
        ProcurementRequest."Supplier Category" := RequisitionHeader."Supplier Category";
        // "Plan Name" doesn't exist on Purchase Header (dropped along with Requisition
        // Header elsewhere in this app, e.g. Tab28.ProcurementRequestLines.al OnInsert) -
        // no header-level plan to copy from here.
        //  ProcurementRequest."Procurement Plan" := RequisitionHeader."Plan Name";
        ProcurementRequest."Created By" := USERID;
        ProcurementRequest."Creation Date" := TODAY;
        ProcurementRequest.Title := RequisitionHeader.Title;
        ProcurementRequest."Procurement Method" := ProcurementMethod;
        // "Requisition Type"/"FA Maintenance" doesn't exist on Purchase Header either;
        // same dropped concept as above.
        // IF RequisitionHeader."Requisition Type" = RequisitionHeader."Requisition Type"::"FA Maintenance" THEN
        //     ProcurementRequest."Original Doc. Type" := ProcurementRequest."Original Doc. Type"::Maintenance;
        ProcurementRequest.INSERT;

        EXIT(ProcurementNo);
    end;

    local procedure IanCreateProcurementLines(RequisitionLines: Record "Purchase Line"; ProcurementNo: Code[50]);
    var
        ProcurementRequestLines: Record "Procurement Request Lines";
    begin
        ProcurementRequestLines.INIT;
        ProcurementRequestLines.TRANSFERFIELDS(RequisitionLines);
        ProcurementRequestLines."ShortcutDimCode[4]" := RequisitionLines."ShortcutDimCode[4]";
        ProcurementRequestLines."Procurement No" := ProcurementNo;
        ProcurementRequestLines.INSERT;
    end;

    procedure IanInitateProcurementplan(ProcurementPlanInitiation: Record "Procurement Plan Initiation");
    var
        ProcurementPlanHeader: Record "Procurement Plan Header";
        DimensionValue: Record "Dimension Value";
        NoSeriesManagement: Codeunit "No. Series";
        ProcurementSetup: Record "Procurement Setup";
        UserSetup: Record "User Setup";
        Body: Text;
        SenderName: Text;
        SenderAddress: Text;
        Recepient: Text;
        Subject: Text;
        ProgressWindow: Dialog;
    begin
        IanOnBeforeProcurementPlanInitiation(ProcurementPlanInitiation);
        DimensionValue.RESET;
        DimensionValue.SETRANGE("Global Dimension No.", 2);
        DimensionValue.SETFILTER(Code, '=%1|=%2|=%3|=%4|=%5|=%6|=%7|=%8', 'ZIMMERMAN', 'STORES', 'RESPITE', 'NYUMBANI VILLAGE', 'MEDICAL', 'LAB', 'KANGEMI', 'HQ');
        IF DimensionValue.FINDSET THEN BEGIN
            ProgressWindow.OPEN('Initiating for #1############# \ Sending Mail to #2#################');
            REPEAT
                ProgressWindow.UPDATE(1, DimensionValue.Code);
                ProcurementPlanHeader.INIT;
                ProcurementPlanHeader.Name := ProcurementPlanInitiation."Plan Name";
                ProcurementPlanHeader."Global Dimension 2 Code" := DimensionValue.Code;
                UserSetup.RESET;
                UserSetup.SETRANGE("Head of Department", DimensionValue.Code);
                IF UserSetup.FINDFIRST THEN BEGIN
                    ProcurementPlanHeader."Employee No" := UserSetup."Employee no";
                    ProcurementPlanHeader.VALIDATE("Employee No");
                    Recepient := UserSetup."E-Mail";
                    Subject := 'Procurement Plan';
                    Body := 'Dear ' + FORMAT(ProcurementPlanHeader."Employee Name") + '<br>Procurement plan for ' + FORMAT(ProcurementPlanInitiation."Plan Name") +
                          ' has been initiated. Please log in to NAV ERP and plan for your department <br>This is a system generated Email' +
                          'Please do not reply to it <Br> Regards';
                    SLEEP(100);
                    ProgressWindow.UPDATE(2, Recepient);
                    SLEEP(100);
                    IanSoftFactory.IanSendEmailWithoutAttachement(SenderName, SenderAddress, Recepient, Subject, Body);
                END;
                //            ELSE
                //              ERROR('Dimension %1 has no user assigned as head in user setup',DimensionValue.Code);

                ProcurementPlanHeader."Financial Year" := ProcurementPlanInitiation."Financial Year";
                ProcurementPlanHeader."Current Budget" := ProcurementPlanInitiation."Current Budget";
                ProcurementPlanHeader."Date Created" := TODAY;
                ProcurementPlanHeader."Created By" := USERID;
                ProcurementPlanHeader."Start Date" := ProcurementPlanInitiation."Start Date";
                ProcurementPlanHeader."End Date" := ProcurementPlanInitiation."End Date";
                ProcurementPlanHeader.INSERT;
            UNTIL DimensionValue.NEXT = 0;
            ProgressWindow.CLOSE();
        END;
        IanOnAfterProcurementPlanInitiation(ProcurementPlanInitiation);
    end;

    [IntegrationEvent(false, false)]
    local procedure IanOnBeforeProcurementPlanInitiation(ProcurementPlanInitiation: Record "Procurement Plan Initiation");
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure IanOnAfterProcurementPlanInitiation(ProcurementPlanInitiation: Record "Procurement Plan Initiation");
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, 51155, 'IanOnAfterProcurementPlanInitiation', '', false, false)]
    local procedure IanChangeStatusToInitiated(ProcurementPlanInitiation: Record "Procurement Plan Initiation");
    begin
        ProcurementPlanInitiation.Initiated := TRUE;
        IF ProcurementPlanInitiation.MODIFY(TRUE) THEN
            MESSAGE('Successfully initiated');
    end;



    procedure IanCreateCustomerToAward(CustomerName: Text; EmailAddress: Code[10]; PhoneNo: Code[10]; CustomerCategoryParam: Code[100]): Code[100];
    var
        Customer: Record "Customer";
        CustomerCategory: Record "Customer Category";
        SalesSetup: Record "Sales & Receivables Setup";
        CustomerNoAssigned: Code[100];
        NoSeriesManagement: Codeunit "No. Series";
    begin
        CustomerCategory.RESET;
        CustomerCategory.SETRANGE("Category Code", CustomerCategoryParam);
        IF CustomerCategory.FINDFIRST THEN BEGIN
            SalesSetup.GET;
            SalesSetup.TESTFIELD("Customer Nos.");
            CustomerNoAssigned := NoSeriesManagement.GetNextNo(SalesSetup."Customer Nos.", 0D, TRUE);
            Customer.INIT;
            Customer."No." := CustomerNoAssigned;
            Customer.VALIDATE(Name, CustomerName);
            Customer."Gen. Bus. Posting Group" := CustomerCategory."Gen. Bus. Posting Group";
            Customer."VAT Bus. Posting Group" := CustomerCategory."VAT Bus. Posting Group";
            Customer."Customer Posting Group" := CustomerCategory."Customer Posting Group";
            IF CustomerNoAssigned <> '' THEN
                Customer.INSERT;
        END;

        EXIT(CustomerNoAssigned);
    end;


    [IntegrationEvent(false, false)]
    local procedure IanCheckIfDepartmentHasAssignedUser();
    begin
    end;

    local procedure IanCreateFixedAsset(Name: Integer);
    begin
    end;

    procedure IanGetTheLeastQuotedVendorAmount(QuoteNo: Code[50]): Decimal;
    var
        QuotationBidders: Record "Quotation Bidders";
        QuotationVendorsBids: Record "Quotation Vendors Bids";
    begin
        QuotationBidders.RESET;
        QuotationBidders.SETRANGE("Reference No", QuoteNo);
        QuotationBidders.CALCFIELDS("Total Quoted Amount");
        QuotationBidders.SETFILTER("Total Quoted Amount", '>%1', 0);
        QuotationBidders.SETCURRENTKEY("Total Quoted Amount");
        QuotationBidders.SETASCENDING("Total Quoted Amount", TRUE);
        IF QuotationBidders.FINDFIRST THEN BEGIN
            QuotationVendorsBids.RESET;
            QuotationVendorsBids.SETRANGE("Quote No", QuotationBidders."Reference No");
            QuotationVendorsBids.SETRANGE("Vendor No", QuotationBidders."Vendor No.");
            IF QuotationVendorsBids.FINDFIRST THEN BEGIN
                EXIT(QuotationVendorsBids."Unit Price");
            END;
        END;

        // EXIT(QuotationVendorsBids."Total Quoted Amount");
    end;
}

