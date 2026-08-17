#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 20364 "Appraisal Approval Tracking"
{
    // CardPageID = "Appraisal Card";
    PageType = List;
    SourceTable = "Appraisal Approvals Tracking";
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Appraisal Code"; Rec."Appraisal Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Supervisor Code"; Rec."Supervisor Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Supervisor Name"; Rec."Supervisor Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Approved; Rec.Approved)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

