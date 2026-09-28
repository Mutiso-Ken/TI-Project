namespace TISolution.TISolution;

page 90059 "Ticket Details"
{
    ApplicationArea = All;
    Caption = 'Ticket Details';
    PageType = Card;
    SourceTable = "HelpDesk Tickets";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(Description; Rec.Description)
                {
                    Editable = false;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                // field("Document Link"; Rec."Document Link")
                // {
                //     Editable = false;
                //     ToolTip = 'Specifies the value of the Document Link field.', Comment = '%';
                // }
                field("Document No"; Rec."Document No")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Document No field.', Comment = '%';
                }
                field("Employee ID"; Rec."Employee ID")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee ID field.', Comment = '%';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                }
                field("Placed On"; Rec."Placed On")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Created On field.', Comment = '%';
                }
                field("Resolved On"; Rec."Resolved On")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Resolved On field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    Editable = isnotResolved;
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    trigger OnValidate()
                    begin
                        TicketUpdates.Reset();
                        if Rec.Status = Rec.Status::Pending then begin
                            TicketUpdates.Init();
                            TicketUpdates."Ticket No" := Rec."Document No";
                            TicketUpdates."Ticket Status" := Rec.Status;
                            TicketUpdates."Update DateTime" := CurrentDateTime;
                            TicketUpdates.Comment := 'Ticket Status changed to Pending';
                            TicketUpdates.Insert(true);
                        end;
                        if Rec.Status = Rec.Status::"In Progress" then begin
                            TicketUpdates.Init();
                            TicketUpdates."Ticket No" := Rec."Document No";
                            TicketUpdates."Ticket Status" := Rec.Status;
                            TicketUpdates."Update DateTime" := CurrentDateTime;
                            TicketUpdates.Comment := 'Ticket Status changed to In progress';
                            TicketUpdates.Insert(true);
                        end;
                        if Rec.Status = Rec.Status::Resolved then begin
                            TicketUpdates.Init();
                            TicketUpdates."Ticket No" := Rec."Document No";
                            TicketUpdates."Ticket Status" := Rec.Status;
                            TicketUpdates."Update DateTime" := CurrentDateTime;
                            TicketUpdates.Comment := 'Ticket Status changed to In progress';
                            TicketUpdates.Insert(true);
                            Rec."Resolved On" := Today;
                            isnotResolved := false;
                            CurrPage.Update(true);
                        end;
                    end;
                }
                field(Title; Rec.Title)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Title field.', Comment = '%';
                }
            }
            part("Ticket Updates"; "Ticket Updates")
            {
                ApplicationArea = all;
                SubPageLink = "Ticket No" = field("Document No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(OpenDocumentLink)
            {
                ApplicationArea = All;
                Caption = 'Open Document Link';
                Image = Link;
                Enabled = Rec."Document Link" <> '';
                ToolTip = 'Opens the document link attached to this ticket.';

                trigger OnAction()
                begin
                    Hyperlink(Rec."Document Link");
                end;
            }
            action("&Print")
            {
                ApplicationArea = All;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Print the details of this ticket.';

                trigger OnAction()
                var
                    HelpDeskTicket: Record "HelpDesk Tickets";
                begin
                    HelpDeskTicket.SetRange("Document No", Rec."Document No");
                    Report.Run(Report::"Helpdesk Ticket Document", true, false, HelpDeskTicket);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        isnotResolved := Rec.Status <> Rec.Status::Resolved;
    end;

    trigger OnAfterGetRecord()
    begin
        isnotResolved := Rec.Status <> Rec.Status::Resolved;
    end;

    var
        TicketUpdates: Record "Tickets Updates";
        isnotResolved: Boolean;
}
