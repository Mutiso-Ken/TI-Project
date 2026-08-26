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
}
