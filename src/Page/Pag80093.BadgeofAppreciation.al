#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 80093 "Badge of Appreciation"
{
    Caption = 'Badge of Appreciation';
    Editable = true;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "HR Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Appreciation Title"; Rec."Appreciation Title")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Picture"; Rec."Employee Picture")
                {
                    ApplicationArea = Basic;
                }
                field("Appreciation Narration"; Rec."Appreciation Narration")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                }
            }
        }
    }

    actions
    {
    }
}

