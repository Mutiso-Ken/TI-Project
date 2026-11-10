// Setup fields used by the Payment Voucher module (tables 64024 / 64025)

pageextension 64000 "PV VAT Posting Setup Ext" extends "VAT Posting Setup"
{
    layout
    {
        addafter("Purchase VAT Account")
        {
            field("Payables Credit Account"; Rec."Payables Credit Account")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the liability account credited with withholding tax, withholding VAT or retention when a payment voucher is posted.';
            }
        }
    }
}

pageextension 64001 "PV VAT Prod. Posting Grps Ext" extends "VAT Product Posting Groups"
{
    layout
    {
        addafter(Description)
        {
            field("WT/WV"; Rec."WT/WV")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether this group is a withholding tax (Tax) or withholding VAT (VAT) code on payment voucher lines.';
            }
        }
    }
}

pageextension 64002 "PV Payment Methods Ext" extends "Payment Methods"
{
    layout
    {
        addafter(Description)
        {
            field("M-PESA"; Rec."M-PESA")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether M-PESA transaction charges apply to payment vouchers that use this method.';
            }
            field("Is Check"; Rec."Is Check")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether a cheque no. and cheque date are required when posting payment vouchers that use this method.';
            }
        }
    }
}
