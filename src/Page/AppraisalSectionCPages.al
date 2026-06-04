//APPRAISAL SECTION B PAGES

page 20373 "Appraisal Section C Part 1"
{
    ApplicationArea = All;
    Caption = 'Technical Skills';
    PageType = ListPart;
    SourceTable = "Appraisal Lines Section C";
    SourceTableView = where(Part = const("Part 1"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Question Description"; Rec."Question")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Answer"; Rec."Self Rating")
                {
                    ApplicationArea = Basic;
                    Editable = MakeAppraiseeEditingTrue;
                }
                field("Self-appraisal (Comments)"; Rec."Supervisor Rating")
                {
                    ApplicationArea = Basic;
                    Editable = MakeSupervisorEditingTrue;
                }
                field("Comments by the supervisor"; Rec."Supervisor Comment")
                {
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
page 20374 "Appraisal Section C Part 2"
{
    ApplicationArea = All;
    Caption = 'General Organisation Skills';
    PageType = ListPart;
    SourceTable = "Appraisal Lines Section C";
    SourceTableView = where(Part = const("Part 2"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Question Description"; Rec."Question")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Answer"; Rec."Self Rating")
                {
                    ApplicationArea = Basic;
                    Editable = MakeAppraiseeEditingTrue;
                }
                field("Self-appraisal (Comments)"; Rec."Supervisor Rating")
                {
                    ApplicationArea = Basic;
                    Editable = MakeSupervisorEditingTrue;
                }
                field("Comments by the supervisor"; Rec."Supervisor Comment")
                {
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
page 20375 "Appraisal Section C Part 3"
{
    ApplicationArea = All;
    Caption = 'Self Management & Flexibility';
    PageType = ListPart;
    SourceTable = "Appraisal Lines Section C";
    SourceTableView = where(Part = const("Part 3"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Question Description"; Rec."Question")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Answer"; Rec."Self Rating")
                {
                    ApplicationArea = Basic;
                    Editable = MakeAppraiseeEditingTrue;
                }
                field("Self-appraisal (Comments)"; Rec."Supervisor Rating")
                {
                    ApplicationArea = Basic;
                    Editable = MakeSupervisorEditingTrue;
                }
                field("Comments by the supervisor"; Rec."Supervisor Comment")
                {
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
page 20376 "Appraisal Section C Part 4"
{
    ApplicationArea = All;
    Caption = 'Communication';
    PageType = ListPart;
    SourceTable = "Appraisal Lines Section C";
    SourceTableView = where(Part = const("Part 4"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Question Description"; Rec."Question")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Answer"; Rec."Self Rating")
                {
                    ApplicationArea = Basic;
                    Editable = MakeAppraiseeEditingTrue;
                }
                field("Self-appraisal (Comments)"; Rec."Supervisor Rating")
                {
                    ApplicationArea = Basic;
                    Editable = MakeSupervisorEditingTrue;
                }
                field("Comments by the supervisor"; Rec."Supervisor Comment")
                {
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
page 20377 "Appraisal Section C Part 5"
{
    ApplicationArea = All;
    Caption = 'Leadership';
    PageType = ListPart;
    SourceTable = "Appraisal Lines Section C";
    SourceTableView = where(Part = const("Part 5"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Question Description"; Rec."Question")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Answer"; Rec."Self Rating")
                {
                    ApplicationArea = Basic;
                    Editable = MakeAppraiseeEditingTrue;
                }
                field("Self-appraisal (Comments)"; Rec."Supervisor Rating")
                {
                    ApplicationArea = Basic;
                    Editable = MakeSupervisorEditingTrue;
                }
                field("Comments by the supervisor"; Rec."Supervisor Comment")
                {
                    ApplicationArea = Basic;
                    Editable = MakeSupervisorEditingTrue;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Part := Rec.Part::"Part 5";
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
