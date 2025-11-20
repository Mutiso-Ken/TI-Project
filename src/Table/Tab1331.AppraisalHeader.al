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
                    "Employee Name" := HREmployees.FullName();
                    "Job Title" := HREmployees."Job Title";
                    "Employee Deparment" := HREmployees."Department Name";
                    "Immediate Supervisor" := HREmployees."Supervisor ID";
                    Validate("Immediate Supervisor");
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
        field(7; "Supervisor Name"; text[200])
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

        AppraisalLinesSectionB.Reset();
        AppraisalLinesSectionB.SetRange("Appraisal Code", "Appraisal Code");
        if AppraisalLinesSectionB.FindSet() then
            repeat
                AppraisalLinesSectionB.Delete();
            until AppraisalLinesSectionB.Next() = 0;

        AppraisalQuestions.Reset();
        AppraisalQuestions.SetRange(Section, AppraisalQuestions.Section::"Section B");
        if AppraisalQuestions.FindSet() then
            repeat
                AppraisalLinesSectionB.Reset();
                if AppraisalLinesSectionB.FindLast() then
                    LineNo := AppraisalLinesSectionB."Line No" + 10
                else
                    LineNo := 10;
                AppraisalLinesSectionB.Init();
                AppraisalLinesSectionB."Line No" := LineNo;
                AppraisalLinesSectionB."Appraisal Code" := "Appraisal Code";
                AppraisalLinesSectionB.Question := AppraisalQuestions.Code;
                AppraisalLinesSectionB."Question Description" := AppraisalQuestions.Description;
                AppraisalLinesSectionB.Insert();
            until AppraisalQuestions.Next() = 0;
    end;

    var
        HREmployees: Record "HR Employees";
        HRsetup: Record "HR Setup";
        NoSeriesManagement: Codeunit "No. Series";
        AppraisalLinesSectionB: record "Appraisal Lines Section B";
        AppraisalQuestions: Record AppraisalQuestions;
        LineNo: Integer;
}

