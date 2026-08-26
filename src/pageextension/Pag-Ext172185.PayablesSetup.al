pageextension 60185 "PayablesSetup" extends "Purchases & Payables Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Posted Credit Memo Nos.")
        {

            // field("Tender Request No"; Rec."Tender Request No") { Caption = 'Purchase Quotes Nos'; ApplicationArea = all; }
            // field("Quotation Request No"; Rec."Quotation Request No") { ApplicationArea = all; }
            // field("Requisition Default Vendor"; Rec."Requisition Default Vendor") { ApplicationArea = all; }
            // field("Vendor Posting Group"; Rec."Vendor Posting Group") { ApplicationArea = all; }
            field("Surrender Nos."; Rec."Surrender Nos.") { ApplicationArea = all; }
            field("Imprest Nos."; Rec."Imprest Nos.") { ApplicationArea = all; }
            field("Mission Proposal Nos."; Rec."Mission Proposal Nos.") { ApplicationArea = all; }
            field("Payment Memo Nos."; Rec."Payment Memo Nos.") { ApplicationArea = all; }
            field("Requisition Nos."; rec."Requisition Nos.") { ApplicationArea = all; }

            field("Budget Balance 25%"; Rec."Budget Balance 25%") { ApplicationArea = all; }
            field("Budget Balance 10%"; Rec."Budget Balance 10%") { ApplicationArea = all; }
            field("Procurement Email"; Rec."Procurement Email") { ApplicationArea = all; }
            field("Procurement Portal"; Rec."Procurement Portal") { ApplicationArea = all; }

        }

    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}