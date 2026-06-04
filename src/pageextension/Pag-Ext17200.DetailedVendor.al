
pageextension 17200 "VendorListpage.Al" extends "Vendor List"
{
    layout
    {
        addafter("Balance (LCY)")
        {
            field("Net Change"; Rec."Net Change") { ApplicationArea = all; }
            field("Net Change (LCY)"; Rec."Net Change (LCY)") { ApplicationArea = all; }
        }
    }
}
