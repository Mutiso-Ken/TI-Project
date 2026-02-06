namespace TISolution.TISolution;

using Microsoft.Finance.GeneralLedger.Ledger;

pageextension 172178 GeneralledgerEntries extends "General Ledger Entries"


{
    layout
    {

        
        modify("Source No.")
        {
            Visible = true;
        }
        modify("VAT Prod. Posting Group")
        {
            Visible = false;
        }
        addbefore(Amount)
        {
            field("DebitAmount"; Rec."Debit Amount") { }
            field("CreditAmount"; Rec."Credit Amount") { }
        }

        addlast(Control1)
        {
            field(GeneralPostingType; Rec."Gen. Posting Type") { }
            field("VAT ProdPosting Group"; Rec."VAT Prod. Posting Group") { }
            field("VATBusPosting Group"; Rec."VAT Bus. Posting Group") { }
        }
        addbefore("Bal. Account Type")
        {
            field("SourceNo.";Rec."Source No.") { }
        }
    
}
}

