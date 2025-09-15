#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 80086 "Notice Board"
{
    ApplicationArea = Basic;
    PageType = Card;
    RefreshOnActivate = false;
    SourceTable = "Notice Board";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Date of Announcement"; Rec."Date of Announcement")
                {
                    ApplicationArea = Basic;
                }
                field("Department Announcing"; Rec."Department Announcing")
                {
                    ApplicationArea = Basic;
                }
                field(Announcement; Rec.Announcement)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin

        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
    end;
}

