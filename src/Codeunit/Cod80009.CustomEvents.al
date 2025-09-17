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
        end else if rec.SR then begin
            Rec."No." := NoSeriesManagement.GetNextNo(PurchasesPayablesSetup."Surrender Nos.", Today, true);
        end else if Rec.PM then begin
            Rec."No." := NoSeriesManagement.GetNextNo(PurchasesPayablesSetup."Payment Memo Nos.", Today, true);
            
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
        Rec."Document Type" := Rec."Document Type"::Quote;
        if Rec."Buy-from Vendor No." = '' then
            Rec."Buy-from Vendor No." := 'FM-V00052';
        if Rec."Vendor Posting Group" = '' then
            Rec."Vendor Posting Group" := 'TRADERS';
    end;

    var
        myInt: Integer;
}