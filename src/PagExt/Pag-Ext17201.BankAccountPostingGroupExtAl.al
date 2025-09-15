pageextension 17201 "BankAccountPostingGroupExt.Al" extends "Bank Account List"
{
    layout
    {
        addafter(BalanceLCY)
        {
            field("Bank Acc Posting Group"; Rec."Bank Acc. Posting Group") { ApplicationArea = all; Caption = 'Posting Group'; }
            field("Net Change"; Rec."Net Change") { ApplicationArea = all; }
        }
    }
}
