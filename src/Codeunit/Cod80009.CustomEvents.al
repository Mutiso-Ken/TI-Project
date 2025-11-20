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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnBeforeCheckPurchLines', '', true, true)]
    local procedure CheckPurchLines(var PurchaseHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line"; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Approval Entry", 'OnBeforeRecordDetails', '', true, true)]
    local procedure GetRecordDetails(var ApprovalEntry: Record "Approval Entry"; var Details: Text; var IsHandled: Boolean)
    var
        RecRef: RecordRef;
        PurchHeader: Record "Purchase Header";
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
            end else begin
                Details := Format(ApprovalEntry."Record ID to Approve", 0, 1);
            end;
        end;

        IsHandled := true;
    end;


}