#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
page 66008 "Procurement Plan List PA"
{
    // version Procurement Iansoft
    // NOTE: RCK's CardPageID ("Procurement Plan Card") was not ported; omitted so
    // this page falls back to the system default card instead of a missing object.

    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Procurement Plan Header";
    SourceTableView = WHERE(Status = CONST("Pending Approval"),
                            Type = CONST(Original));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Rec.Name)
                {
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                }
                field("Employee No"; Rec."Employee No")
                {
                }
                field("Employee Name"; Rec."Employee Name")
                {
                }
                field("Financial Year"; Rec."Financial Year")
                {
                }
            }
        }
    }

    actions
    {
    }
}
