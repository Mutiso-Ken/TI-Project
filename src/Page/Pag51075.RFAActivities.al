page 51075 "RFA Activities"
{
    PageType = ListPart;
    SourceTable = "RFA Activities";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Activity Code"; Rec."Activity Code")
                {
                    Editable = false;
                }
                field("Activity Description"; Rec."Activity Description")
                {
                }
            }
        }
    }

    actions
    {
    }
}
