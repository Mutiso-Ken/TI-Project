pageextension 17202 CustomerExt extends "Customer List"
{
    layout
    {
        addafter("Payments (LCY)")
        {

            field("Customer Posting Group."; Rec."Customer Posting Group")
            {
                ApplicationArea = all;
            }
        }
    }
}