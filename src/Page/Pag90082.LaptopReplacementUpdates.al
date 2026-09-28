page 90082 "Laptop Replacement Updates"
{
    PageType = ListPart;
    SourceTable = "Laptop Replacement Updates";
    Caption = 'Updates';
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTableView = sorting("Entry No.") order(descending);

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Update DateTime"; Rec."Update DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when this update was recorded.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the request at the time of this update.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a note about this update.';
                }
                field("Updated By"; Rec."Updated By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies who made this update.';
                }
            }
        }
    }
}
