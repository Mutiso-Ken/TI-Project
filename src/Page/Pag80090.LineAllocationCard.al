#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 80090 "Line Allocation Card"
{
    PageType = Card;
    SourceTable = "Allocation Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Allocation No"; Rec."Allocation No")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = Basic;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic;
                }
                field("Posting Description"; Rec."Posting Description")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control8; "Line Allocation subform")
            {
                SubPageLink = "Allocation No" = field("Allocation No");
            }
        }
    }

    actions
    {
    }
}

