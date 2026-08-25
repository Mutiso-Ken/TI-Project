#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
page 67072 "Disposal Request List Approved"
{
    // version Procurement Iansoft
    // NOTE: the legacy system's CardPageID ("Disposal Request Card") was not ported; omitted so
    // this page falls back to the system default card instead of a missing object.

    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Disposal Request";
    SourceTableView = WHERE(Status = CONST(Approved));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Disposal No"; Rec."Disposal No")
                {
                }
                field("Employee No"; Rec."Employee No")
                {
                }
                field("Emploayee Name"; Rec."Emploayee Name")
                {
                }
                field("Created On"; Rec."Created On")
                {
                }
            }
        }
    }

    actions
    {
    }
}
