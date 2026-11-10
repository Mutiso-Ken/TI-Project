tableextension 64001 "VAT Product Posting Group Ext" extends "VAT Product Posting Group"
{
    fields
    {
        // Marks a VAT product posting group as a withholding tax or withholding VAT code for payment vouchers
        field(64000; "WT/WV"; Option)
        {
            Caption = 'WT/WV';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Tax,VAT';
            OptionMembers = " ",Tax,VAT;
        }
    }
}
