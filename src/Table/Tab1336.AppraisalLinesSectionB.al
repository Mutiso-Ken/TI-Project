table 1336 "Appraisal Lines Section B"
{
    Caption = 'Appraisal Lines Section B';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No"; Integer)
        {
            Caption = 'Line No';
            AutoIncrement = true;
        }
        field(2; "Appraisal Code"; Code[50])
        {
            Caption = 'Appraisal Code';
        }
        field(3; Part; Option)
        {
            OptionMembers = "Part 1","Part 2","Part 3","Part 4","Part 5","Part 6";
        }
        field(5; "Question Description"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Self-appraisal (Comments)"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Comments by the supervisor"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Line No", "Appraisal Code")
        {
            Clustered = true;
        }
    }
}
