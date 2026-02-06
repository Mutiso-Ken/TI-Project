namespace TISolution.TISolution;

using Microsoft.Purchases.Document;

pageextension 172189 "Purchase Order" extends "Purchase Order"
{
    layout

    {

        addafter("Vendor Shipment No.")
        {
            field("Requisition No"; Rec."Requisition No")
            {

                ApplicationArea = all;
            }
            field("Mission Proposal No"; Rec."Mission Proposal No")
            {
                ApplicationArea = all;
            }

        }
    }

}
