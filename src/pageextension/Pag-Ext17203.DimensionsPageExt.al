namespace TISolution.TISolution;

using Microsoft.Finance.Dimension;

pageextension 17203 DimensionsPageExt extends "Dimension Values"
{
    layout
    {
        addafter(Name)
        {
            field("Fund Code"; Rec."Fund Code")
            {
                ApplicationArea = all;
            }
            field("Budget Category"; Rec."Budget Category")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addafter("Where-Used List")
        {
            action("Project Budget")
            {
                ApplicationArea = Dimensions;
                Caption = 'Fund Budget';
                Image = Dimensions;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = Page "Fund Budget";
                RunPageLink = "Dimension Code" = filter('BUDGET LINES'),
                                  "Fund Code" = field(Code);
            }
        }
    }
}
