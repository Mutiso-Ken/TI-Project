#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 80099 perms
{
    PageType = List;
    SourceTable = "License Permission";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Object Type"; Rec."Object Type")
                {
                    ApplicationArea = Basic;
                }
                field("Object Number"; Rec."Object Number")
                {
                    ApplicationArea = Basic;
                }
                field("Read Permission"; Rec."Read Permission")
                {
                    ApplicationArea = Basic;
                }
                field("Insert Permission"; Rec."Insert Permission")
                {
                    ApplicationArea = Basic;
                }
                field("Modify Permission"; Rec."Modify Permission")
                {
                    ApplicationArea = Basic;
                }
                field("Delete Permission"; Rec."Delete Permission")
                {
                    ApplicationArea = Basic;
                }
                field("Execute Permission"; Rec."Execute Permission")
                {
                    ApplicationArea = Basic;
                }
                field("Limited Usage Permission"; Rec."Limited Usage Permission")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

