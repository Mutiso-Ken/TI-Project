#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
page 50127 "Approved Procurement Plan List"
{
    PageType = List;
    SourceTable = "RCK Procurement Plan Header";
    SourceTableView = where(Status = filter(Approved));
    CardPageId = "Approved Procurement Plan Card";
    Editable = false;
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Sub-Office Code"; Rec."Sub-Office Code")
                {
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }
                field("Total Plan Amount"; Rec."Total Plan Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
