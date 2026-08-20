page 75 "Subscription Renewal History"
{
    Caption = 'Renewal History';
    PageType = ListPart;
    SourceTable = "Subscription Renewal History";
    SourceTableView = sorting("Entry No.") order(descending);
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Renewal Date"; Rec."Renewal Date")
                {
                    ToolTip = 'Specifies the date this renewal was recorded.';
                }
                field("Amount Paid"; Rec."Amount Paid")
                {
                    ToolTip = 'Specifies the amount paid for this renewal.';
                }
                field("Previous Due Date"; Rec."Previous Due Date")
                {
                    ToolTip = 'Specifies what the due date was before this renewal.';
                }
                field("New Due Date"; Rec."New Due Date")
                {
                    ToolTip = 'Specifies the new due date after this renewal.';
                }
                field("Payment Method"; Rec."Payment Method")
                {
                    ToolTip = 'Specifies how this renewal was paid.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies any remarks about this renewal.';
                }
                field("Renewed By"; Rec."Renewed By")
                {
                    ToolTip = 'Specifies who recorded this renewal.';
                }
            }
        }
    }
}