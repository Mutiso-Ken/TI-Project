// namespace TISolution.TISolution;

page 20368 "Appraisal Section A Part 2"
{
    ApplicationArea = All;
    Caption = 'PART 2';
    PageType = ListPart;
    SourceTable = "Appraisal Lines Section A";
    SourceTableView = where(Section = const("Part B"));

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("What capacity need? "; Rec."Capacity Needed")
                {
                    ToolTip = 'Specifies the value of the What capacity needs do you need to support your current objectives and growth? field.', Comment = '%';
                    ApplicationArea = all;
                    Editable = MakeAppraiseeEditingTrue;
                }
                field("Why prioritized this year?"; Rec."Why Prioritize")
                {
                    ToolTip = 'Specifies the value of the Why should they be prioritized this year? field.', Comment = '%';
                    ApplicationArea = all;
                    Editable = MakeAppraiseeEditingTrue;
                }
                field("Comments by the supervisor"; Rec."Comments by the supervisor")
                {
                    ToolTip = 'Specifies the value of the Comments by the supervisor field.', Comment = '%';
                    ApplicationArea = all;
                    Editable = MakeSupervisorEditingTrue;
                }
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance();
    end;

    local procedure SetControlAppearance()
    begin
        if AppraisalHeader.Get(Rec."Appraisal Code") then begin
            HREmployees.Reset();
            if HREmployees.Get(AppraisalHeader."Immediate Supervisor") then begin
                if HrEmployees."User ID" = UserId then
                    MakeSupervisorEditingTrue := true;
            end;
            HREmployees.Reset();
            if HREmployees.Get(AppraisalHeader."Employee No") then begin
                if HrEmployees."User ID" = UserId then
                    MakeAppraiseeEditingTrue := true;
            end;
        end;
    end;

    var
        MakeAppraiseeEditingTrue: Boolean;
        MakeSupervisorEditingTrue: Boolean;
        HREmployees: Record "HR Employees";
        AppraisalHeader: Record "Appraisal Header";
}
