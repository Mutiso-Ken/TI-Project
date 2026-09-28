namespace TISolution.TISolution;

page 90058 Tickets
{
    ApplicationArea = All;
    Caption = 'Tickets';
    PageType = List;
    SourceTable = "HelpDesk Tickets";
    UsageCategory = Administration;
    CardPageId = "Ticket Details";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No"; Rec."Document No")
                {
                    ToolTip = 'Specifies the value of the Document No field.', Comment = '%';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                }
                field(Title; Rec.Title)
                {
                    ToolTip = 'Specifies the value of the Title field.', Comment = '%';
                }
                field("Placed On"; Rec."Placed On")
                {
                    ToolTip = 'Specifies the value of the Created On field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(TicketsOverview)
            {
                ApplicationArea = All;
                Caption = 'Tickets Overview';
                Ellipsis = true;
                Image = Report;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ToolTip = 'Print the complete list of helpdesk tickets, with counts by status.';

                trigger OnAction()
                var
                    HelpDeskTicket: Record "HelpDesk Tickets";
                begin
                    HelpDeskTicket.CopyFilters(Rec);
                    Report.Run(Report::"Helpdesk Tickets Overview", true, false, HelpDeskTicket);
                end;
            }
        }
    }
}
