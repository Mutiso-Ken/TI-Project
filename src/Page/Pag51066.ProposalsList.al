page 51066 "Proposals List"
{

    CardPageID = "Proposals Card";
    Editable = false;
    PageType = List;
    SourceTable = "Grant Funding Application";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Application No"; Rec."Application No")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("FOA ID"; Rec."FOA ID")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Opportunity  Title"; Rec."Opportunity  Title")
                {
                }
                field("Call Type"; Rec."Call Type")
                {
                }
                field("Grant Type"; Rec."Grant Type")
                {
                }
                field("Justification for Application"; Rec."Justification for Application")
                {
                }
                field("Research Center"; Rec."Research Center")
                {
                }
                field("Primary Research Program ID"; Rec."Primary Research Program ID")
                {
                }
                field("Primary Research Area"; Rec."Primary Research Area")
                {
                }
                field("Requested Grant Amount(LCY)"; Rec."Requested Grant Amount(LCY)")
                {
                }
                field("Awarded Grant Amount (LCY)"; Rec."Awarded Grant Amount (LCY)")
                {
                }
                field("Approval Status"; Rec."Approval Status")
                {
                }
                field("Grant Admin Team Code"; Rec."Grant Admin Team Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}
