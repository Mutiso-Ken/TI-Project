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
            field("CreditAmount"; Rec."Credit Amount") { }
            field("DebitAmount"; Rec."Debit Amount") { }
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
        addafter(PostAndPrint)
        {
            //  /action("Account closure Slip")
            action("Import Journal")
            {
                ApplicationArea = Basic, suite;
                Caption = 'Import Csvs';
                Promoted = true;
                Image = Import;
                PromotedCategory = Process;
                //RunObject = xmlport "Import Journals";
            }

            action("Import Loans Journal")
            {
                ApplicationArea = Basic, suite;
                Caption = 'Import Loans Csvs';
                Promoted = true;
                Image = Import;
                PromotedCategory = Process;
                //RunObject = xmlport "Import Loans Journals";
            }


        }
    }

    var
        myInt: Integer;
}


