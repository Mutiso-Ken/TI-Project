pageextension 20369 "Bank Account Ledger Ext" extends "Bank Account Ledger Entries"
{
    layout
    {
        addafter("Global Dimension 2 Code")
        {

            field("Bank Acc. Posting Group"; Rec."Bank Acc. Posting Group")
            {
                ApplicationArea = all;
            }
        }
    }
}
