pageextension 172186 paymentjournal extends "Payment Journal"
{
    layout
    {
        // Add changes to page layout here
        modify("Account No.")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                GenJnlManagement.GetAccounts(Rec, acoountname, BalAccName);

            end;
        }
        addafter("Account No.")
        {
            field(AccName2; AccName)
            {
                Visible = true;
                Editable = false;
            }
        }
        modify("Account Name")
        {
            Visible = true;
        }

        addafter("Account No.")
        {
            field(acoountname; acoountname)
            {
                Caption = 'Account Name';
                Visible = true;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(Post)
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
        acoountname: Text[250];
}