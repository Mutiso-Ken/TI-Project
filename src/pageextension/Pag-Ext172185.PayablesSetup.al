pageextension 60185 "PayablesSetup" extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Posted Credit Memo Nos.")
        {
            field("Surrender Nos."; Rec."Surrender Nos.") { ApplicationArea = all; }
            field("Imprest Nos."; Rec."Imprest Nos.") { ApplicationArea = all; }
            field("Mission Proposal Nos."; Rec."Mission Proposal Nos.") { ApplicationArea = all; }
            field("Payment Memo Nos."; Rec."Payment Memo Nos.") { ApplicationArea = all; }
            field("Requisition Nos."; rec."Requisition Nos.") { ApplicationArea = all; }

            field("Budget Balance 25%"; Rec."Budget Balance 25%") { ApplicationArea = all; }
            field("Budget Balance 10%"; Rec."Budget Balance 10%") { ApplicationArea = all; }
            field("Procurement Email"; Rec."Procurement Email") { ApplicationArea = all; }
            field("Procurement Portal"; Rec."Procurement Portal") { ApplicationArea = all; }
            field("Payment Voucher Nos."; Rec."Payment Voucher Nos.") { ApplicationArea = all; }
            field("Expense VAT Bus. Posting Group"; Rec."Expense VAT Bus. Posting Group") { ApplicationArea = all; }
        }
    }

    actions
    {
    }

    var
        myInt: Integer;
}
