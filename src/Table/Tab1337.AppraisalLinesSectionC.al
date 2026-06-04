table 1337 "Appraisal Lines Section C"
{
    Caption = 'Appraisal Lines Section C';
    DataClassification = ToBeClassified;

    fields
    {
        field(7; "Line No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(1; "Appraisal Code"; Code[100])
        {
            Caption = 'Appraisal Code';
            TableRelation = "Appraisal Header"."Appraisal Code";
            Editable = false;
        }
        field(2; Part; Option)
        {
            OptionMembers = "Part 1","Part 2","Part 3","Part 4","Part 5","Part 6";
            Editable = false;
        }
        field(3; Question; Text[2048])
        {
            Editable = false;
        }
        field(4; "Self Rating"; Option)
        {
            OptionMembers = ,"Unsatisfactory","Improvement Required",Effective,"Highly effective",Exceptional;
            trigger OnValidate()
            begin
                "Self Integer" := "Self Rating";
            end;
        }
        field(5; "Supervisor Rating"; Option)
        {
            OptionMembers = ,"Unsatisfactory","Improvement Required",Effective,"Highly effective",Exceptional;
            trigger OnValidate()
            begin
                "Supervisor Integer" := "Supervisor Rating";
            end;
        }
        field(6; "Supervisor Comment"; Text[2048])
        {
            Caption = 'Remarks by Supervisor';
        }
        field(8; "Self Integer"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; "Supervisor Integer"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Line No.", "Appraisal Code")
        {
            Clustered = true;
        }
    }

    trigger OnModify()
    begin
        Validate("Self Rating");
        Validate("Supervisor Rating");
    end;
}
