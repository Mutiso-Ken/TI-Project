page 51150 "Per Diem Scales LookUp"
{
    PageType = List;
    SourceTable = "Per Diem Rates";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec."Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}
