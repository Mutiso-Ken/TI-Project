page 50131 "Document Approval Entries"
{
    Caption = 'Approval Entries';
    PageType = List;
    SourceTable = "Approval Entry";
    SourceTableView = sorting("Table ID", "Document Type", "Document No.", "Sequence No.");
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sequence No."; Rec."Sequence No.")
                {
                    ApplicationArea = All;
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = All;
                }
                field(ApproverName; ApproverName)
                {
                    ApplicationArea = All;
                    Caption = 'Approver Name';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    StyleExpr = StatusStyle;
                }
                field("Sender ID"; Rec."Sender ID")
                {
                    ApplicationArea = All;
                }
                field("Date-Time Sent for Approval"; Rec."Date-Time Sent for Approval")
                {
                    ApplicationArea = All;
                }
                field("Last Date-Time Modified"; Rec."Last Date-Time Modified")
                {
                    ApplicationArea = All;
                }
                field("Last Modified By User ID"; Rec."Last Modified By User ID")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        HREmployee: Record "HR Employees";
    begin
        ApproverName := '';
        HREmployee.SetRange("User ID", Rec."Approver ID");
        if HREmployee.FindFirst() then
            ApproverName := HREmployee.FullName();

        case Rec.Status of
            Rec.Status::Approved:
                StatusStyle := 'Favorable';
            Rec.Status::Rejected, Rec.Status::Canceled:
                StatusStyle := 'Unfavorable';
            Rec.Status::Open:
                StatusStyle := 'Ambiguous';
            else
                StatusStyle := 'Standard';
        end;
    end;

    var
        ApproverName: Text[100];
        StatusStyle: Text;
}
