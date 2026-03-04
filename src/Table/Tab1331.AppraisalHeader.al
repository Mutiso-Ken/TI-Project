#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 1331 "Appraisal Header"
{

    fields
    {
        field(8; "Appraisal Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(1; "Employee No"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Employees"."No.";

            trigger OnValidate()
            begin
                HREmployees.Reset();
                if HREmployees.Get("Employee No") then begin
                    ApprovalSteps := 0;
                    if Status = Status::Open then begin
                        "Supervisor Name" := '';
                        "Immediate Supervisor" := '';
                    end else begin
                        "Immediate Supervisor" := HREmployees."Appraisal Supervisor1";
                        Validate("Immediate Supervisor");
                    end;

                    "Employee Name" := HREmployees.FullName();
                    "Job Title" := HREmployees."Job Title";
                    "Employee Deparment" := HREmployees."Department Name";
                    "Appraisal Supervisor1" := HREmployees."Appraisal Supervisor1";
                    "Appraisal Supervisor2" := HREmployees."Appraisal Supervisor2";
                    "Appraisal Supervisor3" := HREmployees."Appraisal Supervisor3";
                    "Appraisal Supervisor4" := HREmployees."Appraisal Supervisor4";

                    if "Appraisal Supervisor1" <> '' then
                        Validate("Appraisal Supervisor1");
                    if "Appraisal Supervisor2" <> '' then
                        Validate("Appraisal Supervisor2");
                    if "Appraisal Supervisor3" <> '' then
                        Validate("Appraisal Supervisor3");
                    if "Appraisal Supervisor4" <> '' then
                        Validate("Appraisal Supervisor4");
                end;
            end;
        }
        field(2; "Employee Name"; Text[200])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Review Period"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Employee Deparment"; Text[200])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Job Title"; Text[200])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Immediate Supervisor"; Code[50])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                HREmployees.Reset();
                if HREmployees.Get("Immediate Supervisor") then begin
                    "Supervisor Name" := HREmployees.FullName();
                end;
            end;
        }
        field(7; "Supervisor Name"; Text[300])
        {
            DataClassification = ToBeClassified;
        }
        field(9; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Pending Supervisor Approval,Approved';
            OptionMembers = Open,"Pending Supervisor Approval",Approved;
        }
        field(10; "Supervisor Section B Comments"; Text[2048])
        {
            Caption = 'General Comments by supervisor on the above section:';
            DataClassification = ToBeClassified;
        }
        field(11; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Appraisal Supervisor1"; Text[100])
        {
            Caption = 'First Appraisal Supervisor';
            DataClassification = ToBeClassified;
            TableRelation = "HR Employees"."No.";
            trigger OnValidate()
            begin
                HREmployees.Reset();
                if HREmployees.Get("Appraisal Supervisor1") then begin
                    "Appraisal SupervisorName1" := HREmployees.FullName();
                    ApprovalSteps += 1;
                end;
            end;
        }
        field(13; "Appraisal Supervisor2"; Text[100])
        {
            Caption = 'Second Appraisal Supervisor';
            DataClassification = ToBeClassified;
            TableRelation = "HR Employees"."No.";
            trigger OnValidate()
            begin
                HREmployees.Reset();
                if HREmployees.Get("Appraisal Supervisor2") then begin
                    "Appraisal SupervisorName2" := HREmployees.FullName();
                    ApprovalSteps += 1;
                end;
            end;
        }
        field(14; "Appraisal Supervisor3"; Text[100])
        {
            Caption = 'Third Appraisal Supervisor';
            DataClassification = ToBeClassified;
            TableRelation = "HR Employees"."No.";
            trigger OnValidate()
            begin
                HREmployees.Reset();
                if HREmployees.Get("Appraisal Supervisor3") then begin
                    "Appraisal SupervisorName3" := HREmployees.FullName();
                    ApprovalSteps += 1;
                end;
            end;
        }
        field(15; "Appraisal Supervisor4"; Text[100])
        {
            Caption = 'Fourth Appraisal Supervisor';
            DataClassification = ToBeClassified;
            TableRelation = "HR Employees"."No.";
            trigger OnValidate()
            begin
                HREmployees.Reset();
                if HREmployees.Get("Appraisal Supervisor4") then begin
                    "Appraisal SupervisorName4" := HREmployees.FullName();
                    ApprovalSteps += 1;
                end;
            end;
        }
        field(16; ApprovalSteps; Integer)
        {
            Caption = 'Approval Steps';
            DataClassification = ToBeClassified;
        }
        field(17; "Appraisal SupervisorName1"; Text[300])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Appraisal SupervisorName2"; Text[300])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Appraisal SupervisorName3"; Text[300])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Appraisal SupervisorName4"; Text[300])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Appraisal Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "Appraisal Code" = '' then begin
            HRsetup.Get();
            HRsetup.TestField("Appraisal Nos.");
            "Appraisal Code" := NoSeriesManagement.GetNextNo(HRsetup."Appraisal Nos.", 0D, true);
        end;
        Validate("Employee No");

        AppraisalLinesSectionA.Reset();
        AppraisalLinesSectionA.SetRange("Appraisal Code", "Appraisal Code");
        if AppraisalLinesSectionA.FindSet() then
            repeat
                AppraisalLinesSectionA.Delete();
            until AppraisalLinesSectionA.Next() = 0;

        AppraisalLinesSectionB.Reset();
        AppraisalLinesSectionB.SetRange("Appraisal Code", "Appraisal Code");
        if AppraisalLinesSectionB.FindSet() then
            repeat
                AppraisalLinesSectionB.Delete();
            until AppraisalLinesSectionB.Next() = 0;

        AppraisalLinesSectionC.Reset();
        AppraisalLinesSectionC.SetRange("Appraisal Code", "Appraisal Code");
        if AppraisalLinesSectionC.FindSet() then
            repeat
                AppraisalLinesSectionC.Delete();
            until AppraisalLinesSectionC.Next() = 0;

        AppraisalLinesSectionC.Reset();
        LineNo := AppraisalLinesSectionC.Count();
        AppraisalQuestions.Reset();
        AppraisalQuestions.SetRange(Section, AppraisalQuestions.Section::"Section C");
        if AppraisalQuestions.FindSet() then
            repeat
                LineNo += 1;
                AppraisalLinesSectionC.Init();
                AppraisalLinesSectionC."Line No." := LineNo;
                AppraisalLinesSectionC."Appraisal Code" := "Appraisal Code";
                AppraisalLinesSectionC.Question := AppraisalQuestions.Description;
                AppraisalLinesSectionC.Part := AppraisalQuestions.Part;
                AppraisalLinesSectionC.Insert();
            until AppraisalQuestions.Next() = 0;

        AppraisalLinesSectionD.Reset();
        AppraisalLinesSectionD.SetRange("Appraisal Code", "Appraisal Code");
        if AppraisalLinesSectionD.FindSet() then
            repeat
                AppraisalLinesSectionD.Delete();
            until AppraisalLinesSectionD.Next() = 0;

        AppraisalLinesSectionD.Reset();
        LineNo := AppraisalLinesSectionD.Count();
        AppraisalQuestions.Reset();
        AppraisalQuestions.SetRange(Section, AppraisalQuestions.Section::"Section D");
        if AppraisalQuestions.FindSet() then
            repeat
                LineNo += 1;
                AppraisalLinesSectionD.Init();
                AppraisalLinesSectionD."Line No." := LineNo;
                AppraisalLinesSectionD."Appraisal Code" := "Appraisal Code";
                AppraisalLinesSectionD.Question := AppraisalQuestions.Description;
                AppraisalLinesSectionD.Part := AppraisalQuestions.Part;
                AppraisalLinesSectionD.Insert();
            until AppraisalQuestions.Next() = 0;


    end;

    var
        HREmployees: Record "HR Employees";
        HRsetup: Record "HR Setup";
        NoSeriesManagement: Codeunit "No. Series";
        AppraisalLinesSectionA: record "Appraisal Lines Section A";
        AppraisalLinesSectionB: record "Appraisal Lines Section B";
        AppraisalLinesSectionC: record "Appraisal Lines Section C";
        AppraisalLinesSectionD: record "Appraisal Lines Section D";
        AppraisalQuestions: record "Appraisal Questions";
        LineNo: Integer;
}

