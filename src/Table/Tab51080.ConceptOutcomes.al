table 51080 "Concept Outcomes"
{

    fields
    {
        field(1; Objective; Code[250])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Concept Strategic Objective"."Objective Code" where("Concept Note" = field("Concept Code"));
        }
        field(2; "Concept Code"; Code[20])
        {
            TableRelation = "Concept Notes"."No.";
            DataClassification = ToBeClassified;
        }
        field(3; Outcome; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin

            end;
        }
        field(4; "Objective Name"; Text[250])
        {
            CalcFormula = Lookup("Concept Strategic Objective".Description WHERE("Objective Code" = FIELD(Objective)));
            FieldClass = FlowField;
        }
        field(5; "Budget Planned"; Decimal)
        {
        }

        field(6; "Outcome Name"; Code[250])
        {
            FieldClass = Normal;
        }

    }

    keys
    {
        key(Key1; Objective, "Concept Code", Outcome)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        JobsSetup: Record "Jobs Setup";
    begin
        IF Outcome = '' THEN BEGIN
            JobsSetup.Reset();
            JobsSetup.Get();
            JobsSetup.TestField("Outcome Nos");
            Outcome := NoSeriesMgt.GetNextNo(JobsSetup."Outcome Nos", 0D, true);
        END;
    end;
}
