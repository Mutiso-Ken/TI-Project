//************************************************************************
pageextension 172177 "GenJournalPageExtension" extends "General Journal"
{
    layout
    {
        modify("External Document No.")
        {
            Visible = true;
        }

        modify("Shortcut Dimension 1 Code")
        {
            Visible = true;

        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = true;
        }

        // Add changes to page layout here
        modify("EU 3-Party Trade")
        {
            Visible = false;
        }
        modify("Gen. Posting Type")
        {
            Visible = false;
        }
        modify("Currency Code")
        {
            Visible = True;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = false;
        }
        modify("Bal. Gen. Posting Type")
        {
            Visible = false;
        }
        modify("Bal. Gen. Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Bal. Gen. Prod. Posting Group")
        {
            Visible = false;
        }
        modify("Deferral Code")
        {
            Visible = false;
        }
        modify(Comment)
        {
            Visible = false;
        }
        modify("VAT Bus. Posting Group")
        {
            Visible = false;
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
            field("Line No."; Rec."Line No.")
            { }
            field(GeneralPostingType; Rec."Gen. Posting Type") { }
            field("VAT ProdPosting Group"; Rec."VAT Prod. Posting Group") { }
            field("VATBusPosting Group"; Rec."VAT Bus. Posting Group") { }
        }
        addafter("External Document No.")
        {
            field("Source No."; Rec."Source No.") { }
        }
    }

    actions
    {
        // Add changes to page actions here
        addbefore(PostAndPrint)
        {
            action("Payment Voucher")
            {
                ApplicationArea = Basic, Suite;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    GenJnl: Record "Gen. Journal Line";
                begin
                    GenJnl.SETRANGE(GenJnl."Journal Template Name", rec."Journal Template Name");
                    GenJnl.SETRANGE(GenJnl."Journal Batch Name", rec."Journal Batch Name");
                    GenJnl.SETRANGE(GenJnl."Document No.", rec."Document No.");
                    REPORT.RUN(80026, TRUE, TRUE, GenJnl);
                end;
            }
        }
    }

    var
        myInt: Integer;
}


