page 64042 "Payment Voucher Subform"
{
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "Payment Voucher Lines";
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Percentage to Pay"; Rec."Percentage to Pay")
                {
                    ApplicationArea = All;
                }
                field("Applies to Doc. No"; Rec."Applies to Doc. No")
                {
                    ApplicationArea = All;
                    Editable = EditAppliesTo;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = All;
                }
                field("ShortcutDimCode[5]"; Rec."ShortcutDimCode[5]")
                {
                    ApplicationArea = All;
                }
                field("Budget Amount"; Rec."Budget Amount")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("W/Tax Code"; Rec."W/Tax Code")
                {
                    ApplicationArea = All;
                }
                field("W/Tax Amount"; Rec."W/Tax Amount")
                {
                    ApplicationArea = All;
                }
                field("W/VAT Code"; Rec."W/VAT Code")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        RestrictDoubleWithholding();
                    end;
                }
                field("W/VAT Amount"; Rec."W/VAT Amount")
                {
                    ApplicationArea = All;
                }
                field("Retention Code"; Rec."Retention Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Retention Amount"; Rec."Retention Amount")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Net Amount"; Rec."Net Amount")
                {
                    ApplicationArea = All;
                }
                field("Net Amount(LCY)"; Rec."Net Amount(LCY)")
                {
                    ApplicationArea = All;
                }
                field("Vatable Amount"; Rec."Vatable Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetEditControls();
        if PV.Get(Rec."Voucher No.") then
            if PV."Payment Type" = PV."Payment Type"::"Petty Cash Re-Imbursement" then
                Rec."Account Type" := Rec."Account Type"::"Bank Account";
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetEditControls();
    end;

    var
        PV: Record "Payment Voucher";
        EditAppliesTo: Boolean;
        WVATAlreadyPostedErr: Label 'Withholding VAT for invoice %1 was already deducted on posted payment voucher %2.', Comment = '%1 = invoice no., %2 = voucher no.';

    local procedure RestrictDoubleWithholding()
    var
        OtherLines: Record "Payment Voucher Lines";
        OtherPV: Record "Payment Voucher";
    begin
        if (Rec."W/VAT Code" = '') or (Rec."Applies to Doc. No" = '') then
            exit;
        OtherLines.SetRange("Applies to Doc. No", Rec."Applies to Doc. No");
        OtherLines.SetFilter("W/VAT Code", '<>%1', '');
        OtherLines.SetFilter("Voucher No.", '<>%1', Rec."Voucher No.");
        if OtherLines.FindSet() then
            repeat
                if OtherPV.Get(OtherLines."Voucher No.") then
                    if OtherPV.Posted then
                        Error(WVATAlreadyPostedErr, Rec."Applies to Doc. No", OtherPV."No.");
            until OtherLines.Next() = 0;
    end;

    local procedure SetEditControls()
    begin
        EditAppliesTo := true;
        if PV.Get(Rec."Voucher No.") then
            EditAppliesTo := PV.Status <> PV.Status::Approved;
    end;
}
