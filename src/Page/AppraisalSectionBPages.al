//APPRAISAL Part B PAGES

page 20369 "Appraisal Section B Part 1"
{
    ApplicationArea = All;
    Caption = 'What did you do well in relation to your objectives?';
    PageType = ListPart;
    SourceTable = "Appraisal Lines Section B";
    SourceTableView = where(Part = const("Part 1"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Question Description"; Rec."Question Description")
                {
                    ApplicationArea = Basic;
                    Editable = MakeAppraiseeEditingTrue;
                }
                field("Self-appraisal (Comments)"; Rec."Self-appraisal (Comments)")
                {
                    ApplicationArea = Basic;
                    Editable = MakeAppraiseeEditingTrue;
                }
                field("Comments by the supervisor"; Rec."Comments by the supervisor")
                {
                    Caption = 'Supervisor`s Feedback';
                    ApplicationArea = Basic;
                    Editable = MakeSupervisorEditingTrue;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Part := Rec.Part::"Part 1";
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance();
    end;

    local procedure SetControlAppearance()
    begin
        if AppraisalHeader.Get(Rec."Appraisal Code") then begin
            if AppraisalHeader.Status = AppraisalHeader.Status::"Pending Supervisor Approval" then begin
                HREmployees.Reset();
                if HREmployees.Get(AppraisalHeader."Immediate Supervisor") then begin
                    if HrEmployees."User ID" = UserId then
                        MakeSupervisorEditingTrue := true;
                end;
            end;
            if AppraisalHeader.Status = AppraisalHeader.Status::Open then begin
                HREmployees.Reset();
                if HREmployees.Get(AppraisalHeader."Employee No") then begin
                    if HrEmployees."User ID" = UserId then
                        MakeAppraiseeEditingTrue := true;
                end;
            end;
        end;
    end;

    var
        MakeAppraiseeEditingTrue: Boolean;
        MakeSupervisorEditingTrue: Boolean;
        HREmployees: Record "HR Employees";
        AppraisalHeader: Record "Appraisal Header";
}
page 20370 "Appraisal Section B Part 2"
{
    ApplicationArea = All;
    Caption = 'What enabled you to perform well?';
    PageType = ListPart;
    SourceTable = "Appraisal Lines Section B";
    SourceTableView = where(Part = const("Part 2"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Question Description"; Rec."Question Description")
                {
                    ApplicationArea = Basic;
                    Editable = MakeAppraiseeEditingTrue;
                }
                field("Self-appraisal (Comments)"; Rec."Self-appraisal (Comments)")
                {
                    ApplicationArea = Basic;
                    Editable = MakeAppraiseeEditingTrue;
                }
                field("Comments by the supervisor"; Rec."Comments by the supervisor")
                {
                    Caption = 'Supervisor`s Feedback';
                    ApplicationArea = Basic;
                    Editable = MakeSupervisorEditingTrue;
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Part := Rec.Part::"Part 2";
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance();
    end;

    local procedure SetControlAppearance()
    begin
        if AppraisalHeader.Get(Rec."Appraisal Code") then begin
            if AppraisalHeader.Status = AppraisalHeader.Status::"Pending Supervisor Approval" then begin
                HREmployees.Reset();
                if HREmployees.Get(AppraisalHeader."Immediate Supervisor") then begin
                    if HrEmployees."User ID" = UserId then
                        MakeSupervisorEditingTrue := true;
                end;
            end;
            if AppraisalHeader.Status = AppraisalHeader.Status::Open then begin
                HREmployees.Reset();
                if HREmployees.Get(AppraisalHeader."Employee No") then begin
                    if HrEmployees."User ID" = UserId then
                        MakeAppraiseeEditingTrue := true;
                end;
            end;
        end;
    end;

    var
        MakeAppraiseeEditingTrue: Boolean;
        MakeSupervisorEditingTrue: Boolean;
        HREmployees: Record "HR Employees";
        AppraisalHeader: Record "Appraisal Header";
}
page 20371 "Appraisal Section B Part 3"
{
    ApplicationArea = All;
    Caption = 'What didn’t you do well?';
    PageType = ListPart;
    SourceTable = "Appraisal Lines Section B";
    SourceTableView = where(Part = const("Part 3"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Question Description"; Rec."Question Description")
                {
                    ApplicationArea = Basic;
                    Editable = MakeAppraiseeEditingTrue;
                }
                field("Self-appraisal (Comments)"; Rec."Self-appraisal (Comments)")
                {
                    ApplicationArea = Basic;
                    Editable = MakeAppraiseeEditingTrue;
                }
                field("Comments by the supervisor"; Rec."Comments by the supervisor")
                {
                    Caption = 'Supervisor`s Feedback';
                    ApplicationArea = Basic;
                    Editable = MakeSupervisorEditingTrue;
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Part := Rec.Part::"Part 3";
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance();
    end;

    local procedure SetControlAppearance()
    begin
        if AppraisalHeader.Get(Rec."Appraisal Code") then begin
            if AppraisalHeader.Status = AppraisalHeader.Status::"Pending Supervisor Approval" then begin
                HREmployees.Reset();
                if HREmployees.Get(AppraisalHeader."Immediate Supervisor") then begin
                    if HrEmployees."User ID" = UserId then
                        MakeSupervisorEditingTrue := true;
                end;
            end;
            if AppraisalHeader.Status = AppraisalHeader.Status::Open then begin
                HREmployees.Reset();
                if HREmployees.Get(AppraisalHeader."Employee No") then begin
                    if HrEmployees."User ID" = UserId then
                        MakeAppraiseeEditingTrue := true;
                end;
            end;
        end;
    end;

    var
        MakeAppraiseeEditingTrue: Boolean;
        MakeSupervisorEditingTrue: Boolean;
        HREmployees: Record "HR Employees";
        AppraisalHeader: Record "Appraisal Header";
}
page 20372 "Appraisal Section B Part 4"
{
    ApplicationArea = All;
    Caption = 'What are some of the problems encountered and how were they handled?';
    PageType = ListPart;
    SourceTable = "Appraisal Lines Section B";
    SourceTableView = where(Part = const("Part 4"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Question Description"; Rec."Question Description")
                {
                    ApplicationArea = Basic;
                    Editable = MakeAppraiseeEditingTrue;
                }
                field("Self-appraisal (Comments)"; Rec."Self-appraisal (Comments)")
                {
                    ApplicationArea = Basic;
                    Editable = MakeAppraiseeEditingTrue;
                }
                field("Comments by the supervisor"; Rec."Comments by the supervisor")
                {
                    Caption = 'Supervisor`s Feedback';
                    ApplicationArea = Basic;
                    Editable = MakeSupervisorEditingTrue;
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Part := Rec.Part::"Part 4";
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance();
    end;

    local procedure SetControlAppearance()
    begin
        if AppraisalHeader.Get(Rec."Appraisal Code") then begin
            if AppraisalHeader.Status = AppraisalHeader.Status::"Pending Supervisor Approval" then begin
                HREmployees.Reset();
                if HREmployees.Get(AppraisalHeader."Immediate Supervisor") then begin
                    if HrEmployees."User ID" = UserId then
                        MakeSupervisorEditingTrue := true;
                end;
            end;
            if AppraisalHeader.Status = AppraisalHeader.Status::Open then begin
                HREmployees.Reset();
                if HREmployees.Get(AppraisalHeader."Employee No") then begin
                    if HrEmployees."User ID" = UserId then
                        MakeAppraiseeEditingTrue := true;
                end;
            end;
        end;
    end;

    var
        MakeAppraiseeEditingTrue: Boolean;
        MakeSupervisorEditingTrue: Boolean;
        HREmployees: Record "HR Employees";
        AppraisalHeader: Record "Appraisal Header";
}


