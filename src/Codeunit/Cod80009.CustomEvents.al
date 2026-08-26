codeunit 80009 CustomEvents
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeInsertEvent', '', false, false)]
    local procedure PurchaseHeaderOnBeforeInsert(var Rec: Record "Purchase Header"; RunTrigger: Boolean)
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
#pragma warning disable AL0432
        NoSeriesManagement: Codeunit NoSeriesManagement;
#pragma warning restore AL0432
        UserMgt: Codeunit "User Setup Management";
    begin
        RunTrigger := true;
        PurchasesPayablesSetup.Get;

        if rec.IM then begin
            Rec."No." := NoSeriesManagement.GetNextNo(PurchasesPayablesSetup."Imprest Nos.", Today, true);
            Rec."Document Type" := Rec."Document Type"::Quote;
            Rec."Buy-from Vendor No." := 'FM-V00123';
        end else if rec.SR then begin
            Rec."Document Type" := Rec."Document Type"::Quote;
            Rec."Buy-from Vendor No." := 'FM-V00123';
        end else if Rec.PM then begin
            Rec."No." := NoSeriesManagement.GetNextNo(PurchasesPayablesSetup."Payment Memo Nos.", Today, true);
            Rec."Document Type" := Rec."Document Type"::Quote;
            Rec."Buy-from Vendor No." := 'FM-V00123';
        end;

        if Rec."Document Type" = rec."Document Type"::Order then begin
            Rec."No." := NoSeriesManagement.GetNextNo(PurchasesPayablesSetup."Order Nos.", Today, true);
        end;


        // Default assignments
        if Rec."Responsibility Center" = '' then
            Rec."Responsibility Center" := UserMgt.GetPurchasesFilter;

        if Rec."Assigned User ID" = '' then
            Rec."Assigned User ID" := UserId;

        if Rec."User ID" = '' then
            Rec."User ID" := UserId;

        if Rec."Requested Receipt Date" = 0D then
            Rec."Requested Receipt Date" := Today;
        if Rec."Vendor Posting Group" = '' then
            Rec."Vendor Posting Group" := 'TRADERS';

    end;

    // Budget Line ("Shortcut Dimension 3 Code") is filtered to the header's Fund ("Shortcut
    // Dimension 1 Code") via that Dimension Value's "Fund Code" back-reference. Fund lives on the
    // base "Purchase Header" table, so its OnValidate can't be extended directly from the
    // tableextension - this reacts to the platform's implicit per-field validate event instead, and
    // clears a Budget Line (and, transitively via its own OnValidate, a Budget Category) that no
    // longer belongs to the newly-selected Fund.
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Shortcut Dimension 1 Code', false, false)]
    local procedure PurchaseHeaderOnAfterValidateShortcutDim1Code(var Rec: Record "Purchase Header")
    var
        DimensionValue: Record "Dimension Value";
    begin
        if Rec."Shortcut Dimension 3 Code" = '' then
            exit;

        DimensionValue.SetRange("Global Dimension No.", 3);
        DimensionValue.SetRange(Code, Rec."Shortcut Dimension 3 Code");
        DimensionValue.SetRange("Fund Code", Rec."Shortcut Dimension 1 Code");
        if not DimensionValue.FindFirst() then
            Rec.Validate("Shortcut Dimension 3 Code", '');
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterGetNoSeriesCode', '', false, false)]
    local procedure GetNOseriesCode(var PurchHeader: Record "Purchase Header"; PurchSetup: Record "Purchases & Payables Setup"; var NoSeriesCode: Code[20])
    begin
        if PurchHeader."Document Type" = PurchHeader."Document Type"::Quote then begin
            if PurchHeader.SR = true then begin
                NoSeriesCode := PurchSetup."Surrender Nos.";
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnBeforeCheckPurchaseApprovalPossible', '', true, true)]
    local procedure CheckPurchaseApprovalPossible(var PurchaseHeader: Record "Purchase Header"; var Result: Boolean; var IsHandled: Boolean)
    begin
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Quote then begin
            Result := true;
            IsHandled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnBeforeCheckPurchaseApprovalPossible', '', true, true)]
    local procedure ValidateTaskOrderLinesBeforeApproval(var PurchaseHeader: Record "Purchase Header"; var Result: Boolean; var IsHandled: Boolean)
    var
        PurchaseLine: Record "Purchase Line";
    begin
        if not PurchaseHeader.PR then
            exit;

        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        if PurchaseLine.FindSet() then
            repeat
                PurchaseLine.TestField("Shortcut Dimension 1 Code");
                PurchaseLine.TestField("Shortcut Dimension 2 Code");
                PurchaseLine.TestField("No.");
                if PurchaseLine."Car Repair/Maintenance" then
                    PurchaseLine.TestField("Vehicle Reg. No");
                PurchaseLine.TestField(Quantity);
            until PurchaseLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnBeforeCheckPurchLines', '', true, true)]
    local procedure CheckPurchLines(var PurchaseHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line"; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    // Standard "Post" auto-releases an Open document inline (via this same codeunit) before
    // posting it, and the custom Approval Entry workflow used by SendApprovalRequest/"Validate
    // Approval" on the Purchase Order page is not otherwise wired into that release step - so
    // Post alone, with no manual Release and no approval, would go straight through. This blocks
    // release (and therefore Post) for LPOs (Document Type = Order) unless every approval entry
    // for the document is Approved - covering the manual Release action and Post's auto-release
    // alike, not just the one "Validate Approval" button.
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnBeforeReleasePurchaseDoc', '', true, true)]
    local procedure BlockOrderReleaseWithoutFullApproval(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; var SkipCheckReleaseRestrictions: Boolean; var IsHandled: Boolean; SkipWhseRequestOperations: Boolean)
    var
        AppEntry: Record "Approval Entry";
    begin
        if PreviewMode then
            exit;
        if PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::Order then
            exit;

        AppEntry.Reset();
        AppEntry.SetRange("Document No.", PurchaseHeader."No.");
        AppEntry.SetRange("Table ID", Database::"Purchase Header");
        if not AppEntry.FindSet() then
            Error('%1 %2 cannot be released or posted: it has not been sent for approval.', PurchaseHeader."Document Type", PurchaseHeader."No.");

        AppEntry.SetFilter(Status, '<>%1', AppEntry.Status::Approved);
        if not AppEntry.IsEmpty() then
            Error('%1 %2 cannot be released or posted: not every approval entry is Approved (some are still open, rejected, or canceled).', PurchaseHeader."Document Type", PurchaseHeader."No.");
    end;


    [EventSubscriber(ObjectType::Table, Database::"Approval Entry", 'OnBeforeRecordDetails', '', true, true)]
    local procedure GetRecordDetails(var ApprovalEntry: Record "Approval Entry"; var Details: Text; var IsHandled: Boolean)
    var
        RecRef: RecordRef;
        PurchHeader: Record "Purchase Header";
        ProcurementRequest: Record "Procurement Request";
    begin
        if RecRef.Get(ApprovalEntry."Record ID to Approve") then begin
            if RecRef.Number = Database::"Purchase Header" then begin
                RecRef.SetTable(PurchHeader);
                if PurchHeader.PM then
                    Details := 'Payment Memo Approval Requested By ' + PurchHeader."Employee Name"
                else if PurchHeader.PR then
                    Details := 'Purchase Requisition Approval Requested By ' + PurchHeader."Employee Name"
                else if PurchHeader.MP then
                    Details := 'Mission Proposal Approval Requested By ' + PurchHeader."Employee Name"
                else if PurchHeader.IM then
                    Details := 'Imprest Approval Requested By ' + PurchHeader."Employee Name"
                else if PurchHeader.SR then
                    Details := 'Surrender Approval Requested By ' + PurchHeader."Employee Name"
                else
                    Details := 'Approval Requested';
                ApprovalEntry."Approval Details" := Details;
                ApprovalEntry.Modify();
            end else if RecRef.Number = Database::"Procurement Request" then begin
                RecRef.SetTable(ProcurementRequest);
                Details := 'Procurement Request (' + Format(ProcurementRequest."Procurement Method") + ') Approval Requested By ' + ProcurementRequest."Created By";
                ApprovalEntry."Approval Details" := Details;
                ApprovalEntry.Modify();
            end else begin
                Details := Format(ApprovalEntry."Record ID to Approve", 0, 1);
            end;
        end;

        IsHandled := true;
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Check Line", 'OnBeforeCheckAccountNo', '', false, false)]
    local procedure OnBeforeCheckAccountNo(var GenJnlLine: Record "Gen. Journal Line"; var CheckDone: Boolean)
    begin
        CheckDone := true;
    end;


}