page 51169 "Vendor Company Directors Part"
{
    PageType = ListPart;
    SourceTable = "Vendor Company Directors";
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
                field(Nationality; Rec.Nationality)
                {
                }
                field(Citizenship; Rec.Citizenship)
                {
                }
                field(Shares; Rec.Shares)
                {
                }
            }
        }
    }

    actions
    {
    }
}
