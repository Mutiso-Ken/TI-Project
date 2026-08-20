namespace TISolution.TISolution;
page 60 "Ticket Updates"
{
    ApplicationArea = All;
    Caption = 'Ticket Updates';
    PageType = ListPart;
    SourceTable = "Tickets Updates";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies the value of the Comment field.', Comment = '%';
                }
                field("Ticket Status"; Rec."Ticket Status")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Update DateTime"; Rec."Update DateTime")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Update DateTime field.', Comment = '%';
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        if TicketTable.Get(Rec."Ticket No") then
            CurrPage.Editable(TicketTable.Status <> TicketTable.Status::Resolved);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        TicketTable.Get(Rec."Ticket No");
        if TicketTable.Status <> TicketTable.Status::Resolved then begin
            Rec."Ticket Status" := TicketTable.Status;
            Rec."Update DateTime" := CurrentDateTime;
        end else
            Error('You cannot add an update after a ticket has been resolved');
    end;

    trigger OnAfterGetCurrRecord()
    begin
        TicketTable.Get(Rec."Ticket No");
        CurrPage.Editable(TicketTable.Status <> TicketTable.Status::Resolved);
    end;

    var
        TicketTable: Record "HelpDesk Tickets";
}