#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
page 67043 "Signed Contract List"
{
    // version Procurement Iansoft
    // NOTE: RCK's CardPageID ("Contract Card") was not ported; omitted so this page
    // falls back to the system default card instead of a missing object.

    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Contract Header";
    SourceTableView = WHERE("Contract Status" = CONST(Signed));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Requisition No"; Rec."Requisition No")
                {
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Tender No."; Rec."Tender No.")
                {
                }
                field("Tender Title"; Rec."Tender Title")
                {
                }
            }
        }
    }

    actions
    {
    }
}
