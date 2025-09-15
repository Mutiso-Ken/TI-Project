#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 80087 "HR Setups"
{
    ApplicationArea = Basic;
    Editable = false;
    PageType = List;
    SourceTable = "HR Setup";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee Nos."; Rec."Employee Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Leave Application Nos."; Rec."Leave Application Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Base Calendar"; Rec."Base Calendar")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("HR SETUP")
                {
                    ApplicationArea = Basic;
                    Ellipsis = true;
                    Image = AddAction;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HR Setup";
                }
                action("Notice Board")
                {
                    ApplicationArea = Basic;
                    Ellipsis = true;
                    Image = AddWatch;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Notice Board";
                }
                action("Badge of Appreciation")
                {
                    ApplicationArea = Basic;
                    Ellipsis = true;
                    Image = Alerts;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Badge of Appreciation";
                }
                action("HR Documents")
                {
                    ApplicationArea = Basic;
                    Ellipsis = true;
                    Image = DocumentEdit;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "HR Documents";
                }
                action("Diarized Dates")
                {
                    ApplicationArea = Basic;
                    Ellipsis = true;
                    Image = DueDate;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Chart of Cost Types";
                }
            }
        }
    }
}

