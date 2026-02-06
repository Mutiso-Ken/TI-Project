pageextension 20379 "Fixed Asset" extends "Fixed Asset List"
{
    layout
    {
        addafter(Description)
        {
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code") { ApplicationArea = all; }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code") { ApplicationArea = all; }
        }
    }
}
pageextension 20380 "Fixed Asset page" extends "Fixed Asset Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("FA Subclass Code")
        {
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = all;
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = all;
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
