namespace TISolution.TISolution;

using System.Automation;

pageextension 172188 "Approval Entries" extends "Approval Entries"
{
    layout
    {
        modify("Limit Type")
        {
            Visible = false;
        }
        modify("Salespers./Purch. Code")
        {
            Visible = false;
        }
        modify("Currency Code")
        {
            Visible = false;
        }
        modify("Amount (LCY)")
        {
            Visible = false;
        }

        modify("Available Credit Limit (LCY)")
        {
            Visible = false;
        }


    }

}
