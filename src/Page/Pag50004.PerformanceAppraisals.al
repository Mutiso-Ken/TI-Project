#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50004 "Performance Appraisals"
{
    CardPageID = "Performance Appraisals Card";
    PageType = List;
    SourceTable = "Purchase Header";
    SourceTableView = where("No. Series" = const('APP'));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field("Employee No"; Rec."Employee No")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field("Review From"; Rec."Review From")
                {
                    ApplicationArea = Basic;
                }
                field("Review To"; Rec."Review To")
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

