page 51077 "RFA Criteria"
{
    PageType = ListPart;
    SourceTable = "RFA Criteria";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Max Score"; Rec."Max Score")
                {
                }
            }
        }
    }

    actions
    {
    }
}
