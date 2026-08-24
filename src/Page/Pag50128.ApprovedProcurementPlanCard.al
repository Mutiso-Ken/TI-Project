#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
page 50128 "Approved Procurement Plan Card"
{
    PageType = Card;
    SourceTable = "RCK Procurement Plan Header";
    Editable = false;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Created DateTime"; Rec."Created DateTime")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sub-Office Code"; Rec."Sub-Office Code")
                {
                    ApplicationArea = All;
                }
                field("Sub-Office Name"; Rec."Sub-Office Name")
                {
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }
                field("Total Plan Amount"; Rec."Total Plan Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            part("Procurement Plan Lines"; "Procurement Plan Lines")
            {
                ApplicationArea = All;
                SubPageLink = "Plan No." = field("No.");
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Mark as Posted")
            {
                ApplicationArea = All;
                Image = CreateBinContent;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.TestField(Posted, false);
                    Rec.Posted := true;
                    Rec.Modify(true);
                    Message('Procurement Plan marked as posted.');
                end;
            }
        }
    }
}
