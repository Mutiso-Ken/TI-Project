pageextension 172191 "Bank Acc. Reconciliation" extends "Bank Acc. Reconciliation"
{
    layout
    {
        // Add changes to page layout here
        modify(ApplyBankLedgerEntries)
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
    }


    var
        myInt: Integer;
}

