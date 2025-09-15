#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50016 "Timesheet Entries"
{
    PageType = List;
    SourceTable = "TE Time Sheet1";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No"; Rec."Employee No")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Narration; Rec.Narration)
                {
                    ApplicationArea = Basic;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                }
                field(Hours; Rec.Hours)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Staff Project Hours")
            {
                ApplicationArea = Basic;
                Image = Receipt;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Report "Staff Project Hours";
            }
            action("TimeSheet Report")
            {
                ApplicationArea = Basic;
                Image = Receipt;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Report "TimeSheet Report";
            }
            action("TimeSheet Report Summary")
            {
                ApplicationArea = Basic;
                Image = Receipt;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Report "TimeSheet Report Summary";
            }
        }
    }
}

