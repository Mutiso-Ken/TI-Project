namespace TISolution.TISolution;

using Microsoft.Utilities;

pageextension 2 "Standard Text Ext" extends "Standard Text Codes"
{
    layout
    {
        addafter(Description)
        {
            field(Type; Rec.Type) { ApplicationArea = all; Caption = 'Type'; }
            // field("Net Change"; Rec."Net Change") { ApplicationArea = all; }
        }
    }
}
