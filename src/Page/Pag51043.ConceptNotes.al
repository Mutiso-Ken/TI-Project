page 51043 "Concept Notes"
{
    CardPageID = "Concept Note Card";
    PageType = List;
    SourceTable = "Concept Notes";
    SourceTableView = WHERE(Status = FILTER("Concept Formulation"));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Type of Concept Note"; Rec."Type of Concept Note")
                {
                }
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("Ending Date"; Rec."Ending Date")
                {
                }
                field(Status; Rec.Status)
                {
                }
            }
        }
    }

    actions
    {
    }
}
