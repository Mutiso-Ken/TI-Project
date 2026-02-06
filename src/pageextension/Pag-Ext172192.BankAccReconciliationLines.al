pageextension 172192 "Bank Acc. Reconciliation Lines" extends "Bank Acc. Reconciliation Lines"
{
    layout
    {
        // Add changes to page layout here
        addafter("Applied Amount")
        {
            field(Reconciled; Rec.Reconciled)
            {
                ApplicationArea = all;
                Editable = true;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}