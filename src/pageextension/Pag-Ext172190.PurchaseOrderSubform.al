namespace TISolution.TISolution;

using Microsoft.Purchases.Document;

pageextension 172190 "Purchase Order Subform" extends "Purchase Order Subform"
{
    layout

    {
        modify(Description)
        {
            Visible = false;
        }
        addafter("No.")
        {
            field("Description 3";Rec."Description 3")
            {
                ApplicationArea = all;
                Caption='Descrption';
            }
        }
    }

}
