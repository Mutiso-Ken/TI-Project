page 51168 "Vendor Personnel Part"
{
    PageType = ListPart;
    SourceTable = "Vendor Personnel";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Full Name"; Rec."Full Name")
                {
                }
                field("Position Held"; Rec."Position Held")
                {
                }
                field(Age; Rec.Age)
                {
                }
                field("Academic Qualification"; Rec."Academic Qualification")
                {
                }
                field("Professional Qualification"; Rec."Professional Qualification")
                {
                }
                field("Length of Service"; Rec."Length of Service")
                {
                }
            }
        }
    }

    actions
    {
    }
}
