#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 91331 "Appraisal Header"
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
                    UpdateApprovalSteps();
                end;
            end;
        }
        field(2; "Employee Name"; Text[200])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Review Period"; Code[200])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                StartMonth: Text;
                EndMonth: Text;
            begin
                "Review Period" := '';
                HRsetup.Get();
                if HRsetup."Appraisal Sessions Active" then begin
                    if (HRsetup."Review Start Date" <> 0D) and (HRsetup."Review End Date" <> 0D) then begin
                        StartMonth := UpperCase(Format(HRsetup."Review Start Date", 0, '<Month Text,3> <Year4>'));
                        EndMonth := UpperCase(Format(HRsetup."Review End Date", 0, '<Month Text,3> <Year4>'));
                        "Review Period" := StrSubstNo('%1 - %2', StartMonth, EndMonth);
                    end;
                end else
                    Error('The Appraisal period has not been activated at the moment! Kindly await for the appraisal period to be active!');
            end;

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
            Editable = false;
            trigger OnValidate()
            begin
                HREmployees.Reset();
                if HREmployees.Get("Immediate Supervisor") then begin
                    "Supervisor Name" := HREmployees.FullName();
                end else
                    "Supervisor Name" := '';
            end;
        }
        field(7; "Supervisor Name"; Text[300])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Pending Supervisor Approval,Approved';
            OptionMembers = Open,"Pending Supervisor Approval",Approved;
            // Editable = false;
            trigger OnValidate()
            begin
                if Rec.Status = Status::"Pending Supervisor Approval" then begin
                    Validate("Employee No");
                    if ("Immediate Supervisor" = '') then begin
                        if ("Appraisal Supervisor1" <> '') then
                            "Immediate Supervisor" := "Appraisal Supervisor1"
                        else
                            Error('Aproval workflow for Employee not set! Kindly set up approval workflow to proceed');
                    end;
                end;
            end;
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
                end else
                    "Appraisal SupervisorName1" := '';
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
                end else
                    "Appraisal SupervisorName2" := '';
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
                end else
                    "Appraisal SupervisorName3" := '';
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
                end else
                    "Appraisal SupervisorName4" := '';
            end;
        }
        field(16; ApprovalSteps; Integer)
        {
            Caption = 'Approval Steps';
            DataClassification = ToBeClassified;
            Editable = false;
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
        field(21; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Overall Score"; Integer)
        {
            Editable = false;
            trigger OnValidate()
            begin
                CalcFields("Part A", "Part C", "Part D");
                "Overall Score" := "Part A" + "Part C" + "Part D";
            end;
        }
        field(24; "Part A"; Integer)
        {
            MaxValue = 50;
            FieldClass = FlowField;
            CalcFormula = sum("Appraisal Lines Section A"."Supervisor Rating" where("Appraisal Code" = field("Appraisal Code")));
        }
        field(25; "Part C"; Integer)
        {
            MaxValue = 25;
            FieldClass = FlowField;
            CalcFormula = sum("Appraisal Lines Section C"."Supervisor Integer" where("Appraisal Code" = field("Appraisal Code")));
        }
        field(26; "Part D"; Integer)
        {
            MaxValue = 25;
            FieldClass = FlowField;
            CalcFormula = sum("Appraisal Lines Section D"."Supervisor Integer" where("Appraisal Code" = field("Appraisal Code")));
        }
        field(27; "Appraisee Signature"; MediaSet)
        {
            DataClassification = ToBeClassified;
        }
        field(28; "General Appraiser Comments"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Employee Comments"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Immediate Supervisor Comments"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Head Comments"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(32; "ED Comments"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(33; "First Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(34; "Second Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Third Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(36; "Fourth Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(37; "HR Comments"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(38; "First Decline"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39; "Second Decline"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Third Decline"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(41; "Fourth Decline"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        // field(35; "HOD"; Code[50])
        // {
        //     DataClassification = ToBeClassified;
        // }
        // field(36; "ED Code"; Code[50])
        // {
        //     DataClassification = ToBeClassified;
        // }
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
        Validate("Review Period");
        "Creation Date" := Today;

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

        AppraisalApprovalsTracking.Reset();
        AppraisalApprovalsTracking.SetRange("Appraisal Code", "Appraisal Code");
        if AppraisalApprovalsTracking.FindSet() then
            repeat
                AppraisalApprovalsTracking.Delete();
            until AppraisalApprovalsTracking.Next() = 0;
    end;

    trigger OnModify()
    begin
        Validate("Overall Score");
        Validate("Review Period");
        AppraisalLinesSectionC.Reset();
        AppraisalLinesSectionC.SetRange("Appraisal Code", Rec."Appraisal Code");
        if AppraisalLinesSectionC.FindSet() then
            repeat
                AppraisalLinesSectionC.Modify(true);
            until AppraisalLinesSectionC.Next() = 0;

        AppraisalLinesSectionD.Reset();
        AppraisalLinesSectionD.SetRange("Appraisal Code", Rec."Appraisal Code");
        if AppraisalLinesSectionD.FindSet() then
            repeat
                AppraisalLinesSectionD.Modify(true);
            until AppraisalLinesSectionD.Next() = 0;
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
        AppraisalApprovalsTracking: record "Appraisal Approvals Tracking";
        LineNo: Integer;

    procedure UpdateApprovalSteps()
    begin
        if Rec.Status = Status::Open then begin
            Rec."Appraisal Supervisor1" := '';
            Rec."Appraisal Supervisor2" := '';
            Rec."Appraisal Supervisor3" := '';
            Rec."Appraisal Supervisor4" := '';
            Rec."Immediate Supervisor" := '';
            Rec.Validate("Appraisal Supervisor1");
            Rec.Validate("Appraisal Supervisor2");
            Rec.Validate("Appraisal Supervisor3");
            Rec.Validate("Appraisal Supervisor4");
            Rec.Validate("Immediate Supervisor");
            Rec.Modify();
            HREmployees.Reset();
            if HREmployees.Get(Rec."Employee No") then begin
                HREmployees.FullName();
                if HREmployees."No. of Appraisals" = HREmployees."No. of Appraisals"::Two then begin
                    Rec.ApprovalSteps := 2;
                    Rec."Appraisal Supervisor1" := HREmployees."Appraisal Supervisor1";
                    Rec."Appraisal Supervisor4" := HREmployees."Appraisal Supervisor4";
                end;
                if HREmployees."No. of Appraisals" = HREmployees."No. of Appraisals"::Three then begin
                    Rec.ApprovalSteps := 3;
                    Rec."Appraisal Supervisor1" := HREmployees."Appraisal Supervisor1";
                    Rec."Appraisal Supervisor3" := HREmployees."Appraisal Supervisor3";
                    Rec."Appraisal Supervisor4" := HREmployees."Appraisal Supervisor4";
                end;
                if HREmployees."No. of Appraisals" = HREmployees."No. of Appraisals"::Four then begin
                    Rec.ApprovalSteps := 4;
                    Rec."Appraisal Supervisor1" := HREmployees."Appraisal Supervisor1";
                    Rec."Appraisal Supervisor2" := HREmployees."Appraisal Supervisor2";
                    Rec."Appraisal Supervisor3" := HREmployees."Appraisal Supervisor3";
                    Rec."Appraisal Supervisor4" := HREmployees."Appraisal Supervisor4";
                end;
                Rec."Immediate Supervisor" := HREmployees."Appraisal Supervisor1";
                Validate(Rec."Appraisal Supervisor1");
                Validate(Rec."Appraisal Supervisor2");
                Validate(Rec."Appraisal Supervisor3");
                Validate(Rec."Appraisal Supervisor4");
                Validate(Rec."Immediate Supervisor");
                Rec.Modify();
            end;
        end;
    end;

    procedure UpdateSupervisorApprovals()
    begin
        if Rec.ApprovalSteps = 2 then begin
            AppraisalApprovalsTracking.Reset();
            AppraisalApprovalsTracking.SetRange("Appraisal Code", Rec."Appraisal Code");
            if AppraisalApprovalsTracking.FindSet() then begin
                repeat
                    if AppraisalApprovalsTracking."Supervisor Code" = Rec."Appraisal Supervisor1" then begin
                        if AppraisalApprovalsTracking.Approved then begin
                            Rec."First Approval" := true;
                            Rec."First Decline" := false;
                        end else begin
                            Rec."First Decline" := true;
                            Rec."First Approval" := false;
                        end;
                    end;
                    if AppraisalApprovalsTracking."Supervisor Code" = Rec."Appraisal Supervisor4" then begin
                        if AppraisalApprovalsTracking.Approved then begin
                            Rec."Second Approval" := true;
                            Rec."Second Decline" := false;
                        end else begin
                            Rec."Second Decline" := true;
                            Rec."Second Approval" := false;
                        end;
                    end;
                    AppraisalApprovalsTracking.Validate("Supervisor Code");
                    AppraisalApprovalsTracking.Modify();
                until AppraisalApprovalsTracking.Next() = 0;
            end;
        end;
        if Rec.ApprovalSteps = 3 then begin
            AppraisalApprovalsTracking.Reset();
            AppraisalApprovalsTracking.SetRange("Appraisal Code", Rec."Appraisal Code");
            if AppraisalApprovalsTracking.FindSet() then begin
                repeat
                    if AppraisalApprovalsTracking."Supervisor Code" = Rec."Appraisal Supervisor1" then begin
                        if AppraisalApprovalsTracking.Approved then begin
                            Rec."First Approval" := true;
                            Rec."First Decline" := false;
                        end else begin
                            Rec."First Decline" := true;
                            Rec."First Approval" := false;
                        end;
                    end;
                    if AppraisalApprovalsTracking."Supervisor Code" = Rec."Appraisal Supervisor3" then begin
                        if AppraisalApprovalsTracking.Approved then begin
                            Rec."Second Approval" := true;
                            Rec."Second Decline" := false;
                        end else begin
                            Rec."Second Decline" := true;
                            Rec."Second Approval" := false;
                        end;
                    end;
                    if AppraisalApprovalsTracking."Supervisor Code" = Rec."Appraisal Supervisor4" then begin
                        if AppraisalApprovalsTracking.Approved then begin
                            Rec."Third Approval" := true;
                            Rec."Third Decline" := false;
                        end else begin
                            Rec."Third Decline" := true;
                            Rec."Third Approval" := false;
                        end;
                    end;
                    AppraisalApprovalsTracking.Validate("Supervisor Code");
                    AppraisalApprovalsTracking.Modify();
                until AppraisalApprovalsTracking.Next() = 0;
            end;
        end;
        if Rec.ApprovalSteps = 4 then begin
            AppraisalApprovalsTracking.Reset();
            AppraisalApprovalsTracking.SetRange("Appraisal Code", Rec."Appraisal Code");
            if AppraisalApprovalsTracking.FindSet() then begin
                repeat
                    if AppraisalApprovalsTracking."Supervisor Code" = Rec."Appraisal Supervisor1" then begin
                        if AppraisalApprovalsTracking.Approved then begin
                            Rec."First Approval" := true;
                            Rec."First Decline" := false;
                        end else begin
                            Rec."First Decline" := true;
                            Rec."First Approval" := false;
                        end;
                    end;
                    if AppraisalApprovalsTracking."Supervisor Code" = Rec."Appraisal Supervisor2" then begin
                        if AppraisalApprovalsTracking.Approved then begin
                            Rec."Second Approval" := true;
                            Rec."Second Decline" := false;
                        end else begin
                            Rec."Second Decline" := true;
                            Rec."Second Approval" := false;
                        end;
                    end;
                    if AppraisalApprovalsTracking."Supervisor Code" = Rec."Appraisal Supervisor3" then begin
                        if AppraisalApprovalsTracking.Approved then begin
                            Rec."Third Approval" := true;
                            Rec."Third Decline" := false;
                        end else begin
                            Rec."Third Decline" := true;
                            Rec."Third Approval" := false;
                        end;
                    end;
                    if AppraisalApprovalsTracking."Supervisor Code" = Rec."Appraisal Supervisor4" then begin
                        if AppraisalApprovalsTracking.Approved then begin
                            Rec."Fourth Approval" := true;
                            Rec."Fourth Decline" := false;
                        end else begin
                            Rec."Fourth Decline" := true;
                            Rec."Fourth Approval" := false;
                        end;
                    end;
                    AppraisalApprovalsTracking.Validate("Supervisor Code");
                    AppraisalApprovalsTracking.Modify();
                until AppraisalApprovalsTracking.Next() = 0;
            end;
        end;
        Rec.Modify();
    end;

    procedure ResetApprovalsWhenSending()
    begin

    end;

    procedure UpdateApprovalWorkflow()
    begin
        UpdateApprovalSteps();
        UpdateSupervisorApprovals();
        // Rec.Status := Rec.Status::Open;
        // Rec.Modify();
        if ((rec.Status = rec.Status::"Pending Supervisor Approval") or (Rec.Status = Rec.Status::Approved)) then begin
            Rec."Immediate Supervisor" := Rec."Appraisal Supervisor1";
            if Rec.ApprovalSteps = 2 then begin
                if Rec."First Approval" then begin
                    Rec.Status := Rec.Status::"Pending Supervisor Approval";
                    Rec."Immediate Supervisor" := Rec."Appraisal Supervisor4";
                    if Rec."Second Approval" then begin
                        Rec.Status := Rec.Status::Approved
                    end else if Rec."Second Decline" then begin
                        Rec."First Approval" := false;
                        Rec."First Decline" := false;
                        Rec."Immediate Supervisor" := Rec."Appraisal Supervisor1";
                    end;
                end else if Rec."First Decline" then begin
                    Rec.Status := Rec.Status::Open;
                    Rec."Immediate Supervisor" := '';
                end;
            end;
            // end;
            if Rec.ApprovalSteps = 3 then begin
                if Rec."First Approval" then begin
                    Rec.Status := Rec.Status::"Pending Supervisor Approval";
                    Rec."Immediate Supervisor" := Rec."Appraisal Supervisor3";
                    if Rec."Second Approval" then begin
                        Rec."Immediate Supervisor" := Rec."Appraisal Supervisor4";
                        if Rec."Third Approval" then begin
                            Rec.Status := Rec.Status::Approved;
                        end else if Rec."Third Decline" then begin
                            Rec."Immediate Supervisor" := Rec."Appraisal Supervisor3";
                            Rec."Second Approval" := false;
                            Rec."Second Decline" := false;
                        end;
                    end else if Rec."Second Decline" then begin
                        Rec."First Approval" := false;
                        Rec."First Decline" := false;
                        Rec."Immediate Supervisor" := Rec."Appraisal Supervisor1";
                    end;
                end else if Rec."First Decline" then begin
                    Rec.Status := Rec.Status::Open;
                    Rec."Immediate Supervisor" := '';
                end;
            end;
            if Rec.ApprovalSteps = 4 then begin
                if Rec."First Approval" then begin
                    Rec.Status := Rec.Status::"Pending Supervisor Approval";
                    Rec."Immediate Supervisor" := Rec."Appraisal Supervisor2";
                    if Rec."Second Approval" then begin
                        Rec."Immediate Supervisor" := Rec."Appraisal Supervisor3";
                        if Rec."Third Approval" then begin
                            Rec."Immediate Supervisor" := Rec."Appraisal Supervisor4";
                            if Rec."Fourth Approval" then begin
                                Rec.Status := Rec.Status::Approved;
                            end else if Rec."Fourth Decline" then begin
                                Rec."Immediate Supervisor" := Rec."Appraisal Supervisor3";
                                Rec."Third Approval" := false;
                                Rec."Third Decline" := false;
                            end;
                        end else if Rec."Third Decline" then begin
                            Rec."Immediate Supervisor" := Rec."Appraisal Supervisor2";
                            Rec."Second Approval" := false;
                            Rec."Second Decline" := false;
                        end;
                    end else if Rec."Second Decline" then begin
                        Rec."First Approval" := false;
                        Rec."First Decline" := false;
                        Rec."Immediate Supervisor" := Rec."Appraisal Supervisor1";
                    end;
                end else if Rec."First Decline" then begin
                    Rec.Status := Rec.Status::Open;
                    Rec."Immediate Supervisor" := '';
                end;
            end;
            Rec.Validate("Immediate Supervisor");
            Rec.Modify();
        end;
    end;

    procedure SendForApproval(): Boolean
    begin
        UpdateApprovalSteps();
        if Rec.Status = Status::Open then begin
            Rec.Status := Status::"Pending Supervisor Approval";
            Rec.Modify();
            ResetApprovalsWhenSending();
            // UpdateApprovalWorkflow();
            exit(true);
        end;
        exit(false);
    end;

    procedure ApproveDocument(appoverCode: Code[50]): Text
    begin
        AppraisalApprovalsTracking.Reset();
        AppraisalApprovalsTracking.SetRange("Appraisal Code", Rec."Appraisal Code");
        AppraisalApprovalsTracking.SetRange("Supervisor Code", Rec."Immediate Supervisor");
        if AppraisalApprovalsTracking.FindFirst() then begin
            // if AppraisalApprovalsTracking.Approved = true then
            //     exit('You have already approved this document');
            AppraisalApprovalsTracking.Approved := true;
            AppraisalApprovalsTracking."Update Date" := Today;
            AppraisalApprovalsTracking."Update Time" := Time;
            AppraisalApprovalsTracking.Modify();
        end else begin
            AppraisalApprovalsTracking.Init();
            AppraisalApprovalsTracking."Appraisal Code" := Rec."Appraisal Code";
            AppraisalApprovalsTracking."Supervisor Code" := Rec."Immediate Supervisor";
            AppraisalApprovalsTracking.Validate("Supervisor Code");
            AppraisalApprovalsTracking.Approved := true;
            AppraisalApprovalsTracking."Update Date" := Today;
            AppraisalApprovalsTracking."Update Time" := Time;
            AppraisalApprovalsTracking.Insert();
        end;
        AppraisalApprovalsTracking.Reset();
        AppraisalApprovalsTracking.SetRange("Appraisal Code", Rec."Appraisal Code");
        AppraisalApprovalsTracking.SetRange(Approved, false);
        if AppraisalApprovalsTracking.FindSet() then begin
            repeat
                AppraisalApprovalsTracking.Delete();
            until AppraisalApprovalsTracking.Next() = 0;
        end;
        Rec."First Decline" := false;
        Rec."Second Decline" := false;
        Rec."Third Decline" := false;
        Rec."Fourth Decline" := false;
        Rec.Modify();
        UpdateApprovalWorkflow();
    end;

    procedure RejectDocument(appoverCode: Code[50]): Text
    begin
        AppraisalApprovalsTracking.Reset();
        AppraisalApprovalsTracking.SetRange("Appraisal Code", Rec."Appraisal Code");
        AppraisalApprovalsTracking.SetRange("Supervisor Code", Rec."Immediate Supervisor");
        if AppraisalApprovalsTracking.FindFirst() then begin
            // if AppraisalApprovalsTracking.Approved = false then
            //     exit('You have already rejected this document');
            AppraisalApprovalsTracking.Approved := false;
            AppraisalApprovalsTracking."Update Date" := Today;
            AppraisalApprovalsTracking."Update Time" := Time;
            AppraisalApprovalsTracking.Modify();
        end else begin
            AppraisalApprovalsTracking.Init();
            AppraisalApprovalsTracking."Appraisal Code" := Rec."Appraisal Code";
            AppraisalApprovalsTracking."Supervisor Code" := Rec."Immediate Supervisor";
            AppraisalApprovalsTracking.Validate("Supervisor Code");
            AppraisalApprovalsTracking.Approved := false;
            AppraisalApprovalsTracking."Update Date" := Today;
            AppraisalApprovalsTracking."Update Time" := Time;
            AppraisalApprovalsTracking.Insert();
        end;
        UpdateApprovalWorkflow();
    end;
}

