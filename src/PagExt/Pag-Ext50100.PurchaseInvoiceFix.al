pageextension 50100 "Purchase Invoice Fix" extends "Purchase Invoice"
{
    layout
    {
        // Add changes to page layout here
        addbefore("Vendor Invoice No.")
        {
            field("Document Type";Rec."Document Type")
            {
                Editable = true;
                Visible = true;
                Importance = Standard;
            }
        }
    }
    
    actions
    {
        // Add changes to page actions here
    }

    trigger OnOpenPage()
    begin
        // Force all records on this page to be Invoices
        Rec.SetRange("Document Type", Rec."Document Type"::Invoice);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        // Double-check and enforce document type
        // if Rec."Document Type" <> Rec."Document Type"::Invoice then begin
        //     Rec."Document Type" := Rec."Document Type"::Invoice;
        //     Rec.Modify();
        //     CurrPage.Update(false);
        // end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // Explicitly set document type for new records
        //Rec."Document Type" := Rec."Document Type"::Invoice;
    end;
}
