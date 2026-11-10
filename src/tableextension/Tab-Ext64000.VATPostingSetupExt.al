tableextension 64000 "VAT Posting Setup Ext" extends "VAT Posting Setup"
{
    fields
    {
        // Liability account credited with withholding tax / withholding VAT / retention on payment vouchers
        field(64000; "Payables Credit Account"; Code[20])
        {
            Caption = 'Payables Credit Account';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account"."No." where("Account Type" = const(Posting),
                                                       Blocked = const(false));
        }
    }
}
