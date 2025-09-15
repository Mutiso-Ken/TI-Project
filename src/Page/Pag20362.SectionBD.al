#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 20362 "Section B-D"
{
    PageType = ListPart;
    SourceTable = "Section B-D";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employe No"; Rec."Employe No")
                {
                    ApplicationArea = Basic;
                }
                field("Review Period"; Rec."Review Period")
                {
                    ApplicationArea = Basic;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field("Employee Rating"; Rec."Employee Rating")
                {
                    ApplicationArea = Basic;
                }
                field("Supervisor Rating"; Rec."Supervisor Rating")
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

