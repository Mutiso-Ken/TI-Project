namespace TISolution.TISolution;

using Microsoft.Utilities;

pageextension 90002 "Standard Text Ext" extends "Standard Text Codes"
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
