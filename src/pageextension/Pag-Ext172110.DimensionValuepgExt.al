//************************************************************************
pageextension 60110 "DimensionValuepgExt" extends "Dimension Value List"

{
    layout
    {
        addlast(Control1)

        {
            field("Global Dimension No."; Rec."Global Dimension No.")
            {
                ApplicationArea = basic;
            }
        }

    }
}


