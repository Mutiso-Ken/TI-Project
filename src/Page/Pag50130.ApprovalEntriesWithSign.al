#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
page 50130 "Approval Entries With Sign"
{
    // A read-only Approval Entries list (for use as a FactBox on document cards) that resolves
    // each approver's signature from HR Employees, matched via "User ID" = "Approver ID" - the
    // same lookup already used for signatures on the Mission Proposal and payroll-side reports.
    PageType = ListPart;
    SourceTable = "Approval Entry";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ApproverName; ApproverName)
                {
                    ApplicationArea = All;
                    Caption = 'Approver';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Last Date-Time Modified"; Rec."Last Date-Time Modified")
                {
                    ApplicationArea = All;
                    Caption = 'Date';
                }
                field(Signature; ApproverEmployee.Signature)
                {
                    ApplicationArea = All;
                    Caption = 'Signature';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ApproverName := '';
        Clear(ApproverEmployee);

        ApproverEmployee.Reset();
        ApproverEmployee.SetRange("User ID", Rec."Approver ID");
        if ApproverEmployee.FindFirst() then begin
            ApproverEmployee.CalcFields(Signature);
            ApproverName := ApproverEmployee.FullName;
        end;
    end;

    var
        ApproverEmployee: Record "HR Employees";
        ApproverName: Text[100];
}
