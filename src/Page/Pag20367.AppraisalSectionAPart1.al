

page 20367 "Appraisal Section A Part 1"
{
    ApplicationArea = All;
    Caption = 'PART 1';
    PageType = ListPart;
    SourceTable = "Appraisal Lines Section A";
    SourceTableView = where(Section = const("Part A"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("What have you done"; Rec."What have you done")
                {
                    ApplicationArea = Basic;
                    Editable = MakeAppraiseeEditingTrue;
                }
                field("When?"; Rec."When?")
                {
                    ApplicationArea = Basic;
                    Editable = MakeAppraiseeEditingTrue;
                }
                field("Expected Results"; Rec."Expected Results")
                {
                    ApplicationArea = Basic;
                    Editable = MakeAppraiseeEditingTrue;
                }
                field("What was Achieved?"; Rec."What was Achieved?")
                {
                    ApplicationArea = Basic;
                    Editable = MakeAppraiseeEditingTrue;
                }
                field("Supervisor Rating"; Rec."Supervisor Rating")
                {
                    ApplicationArea = Basic;
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
