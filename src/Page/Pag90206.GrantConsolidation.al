page 90206 "Grant Consolidation"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Grant Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = false;
                field("No."; Rec."No.")
                {
                }
                field(Title; Rec.Title)
                {
                }
                field(Narration; Rec.Narration)
                {
                }
                field("Donor No."; Rec."Donor No.")
                {
                }
                field("Donor Name"; Rec."Donor Name")
                {
                }
            }
            group("Budget Details")
            {
                field("Consolidation Budget"; Rec."Consolidation Budget")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnClosePage();
    begin
        IF Rec."Consolidation Budget" <> '' THEN BEGIN
            IF CONFIRM('Do you want to consolidate the Grant to budget %1', FALSE, Rec."Consolidation Budget") THEN BEGIN
                GrantManagement.ConsolidateGrant(Rec."No.", Rec."Consolidation Budget");
            END;
        END;
    end;

    var
        GrantManagement: Codeunit "Grant Administration";
}
