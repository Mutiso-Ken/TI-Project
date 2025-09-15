#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 80098 "Exit Interview"
{
    PageType = Card;
    SourceTable = "Exit Interviews";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Employee No"; Rec."Employee No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Designation; Rec.Designation)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date of Exit"; Rec."Date of Exit")
                {
                    ApplicationArea = Basic;
                }
                field("main reason(s) for your exit"; Rec."main reason(s) for your exit")
                {
                    ApplicationArea = Basic;
                }
                field("overall impression"; Rec."overall impression")
                {
                    ApplicationArea = Basic;
                }
                field("clear objectives"; Rec."clear objectives")
                {
                    ApplicationArea = Basic;
                }
                field("your performance reviewed"; Rec."your performance reviewed")
                {
                    ApplicationArea = Basic;
                }
                field("received enough recognition"; Rec."received enough recognition")
                {
                    ApplicationArea = Basic;
                }
                field("career aspirations"; Rec."career aspirations")
                {
                    ApplicationArea = Basic;
                }
                field("relationship with your"; Rec."relationship with your")
                {
                    ApplicationArea = Basic;
                }
                field("with your immediate team"; Rec."with your immediate team")
                {
                    ApplicationArea = Basic;
                }
                field("greatest accomplishments"; Rec."greatest accomplishments")
                {
                    ApplicationArea = Basic;
                }
                field("perception on TI-Kenya’s"; Rec."perception on TI-Kenya’s")
                {
                    ApplicationArea = Basic;
                }
                field("most fulfilling"; Rec."most fulfilling")
                {
                    ApplicationArea = Basic;
                }
                field("most frustrating"; Rec."most frustrating")
                {
                    ApplicationArea = Basic;
                }
                field("better place"; Rec."better place")
                {
                    ApplicationArea = Basic;
                }
                field("TI-Kenya in the future"; Rec."TI-Kenya in the future")
                {
                    ApplicationArea = Basic;
                }
                field("next step"; Rec."next step")
                {
                    ApplicationArea = Basic;
                }
                field("constructive feedback"; Rec."constructive feedback")
                {
                    ApplicationArea = Basic;
                }
                field("Intervire Conducted By"; Rec."Intervire Conducted By")
                {
                    ApplicationArea = Basic;
                    Caption = 'Interview Conducted By';
                    Editable = false;
                }
                field("Interview Date"; Rec."Interview Date")
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

