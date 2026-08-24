table 51070 "Concept Strategic Objective"
{

    DrillDownPageID = "Concept Objectives";
    LookupPageID = "Concept Objectives";

    fields
    {

        field(1; "Objective Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }


        field(3; "Planned Budget"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'to be keyed in at the strategy plan inception';
        }
        field(4; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Strategic Plan,Concept Note';
            OptionMembers = "Strategic Plan","Concept Note";
        }
        field(5; "Concept Note"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Objective Code", Type, "Concept Note")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        if "Objective Code" = '' then begin
            JobSetup.Reset();
            JobSetup.Get();
            JobSetup.TestField("Objective Nos");
            "Objective Code" := NoSeries.GetNextNo(JobSetup."Objective Nos", 0D, true);
        end;
    end;

    var
        JobSetup: Record "Jobs Setup";
        NoSeries: Codeunit NoSeriesManagement;

}
