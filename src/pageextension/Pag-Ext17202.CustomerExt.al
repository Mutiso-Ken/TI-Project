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
        addafter("Balance Due (LCY)")
        {

            field("Net Change";Rec."Net Change")
            {
                ApplicationArea = all;
            }
             field("Net Change (LCY)";Rec."Net Change (LCY)")
            {
                ApplicationArea = all;
            }
        }
    }
}