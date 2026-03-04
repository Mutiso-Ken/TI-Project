table 1337 "Appraisal Lines Section C"
{
    Caption = 'Appraisal Lines Section C';
    DataClassification = ToBeClassified;

    fields
    {
        field(7; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(1; "Appraisal Code"; Code[100])
        {
            Caption = 'Appraisal Code';
            TableRelation = "Appraisal Header"."Appraisal Code";
        }
        field(2; Part; Option)
        {
            OptionMembers = "Part 1","Part 2","Part 3","Part 4","Part 5","Part 6";
        }
        field(3; Question; Text[2048])
        {
        }
        field(4; "Self Rating"; Option)
        {
            OptionMembers = ,"Unsatisfactory","Improvement Required",Effective,"Highly effective",Exceptional;
        }
        field(5; "Supervisor Rating"; Option)
        {
            OptionMembers = ,"Unsatisfactory","Improvement Required",Effective,"Highly effective",Exceptional;
        }
        field(6; "Supervisor Comment"; Text[2048])
        {
            Caption = 'Remarks by Supervisor';
        }
    }
    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
    }
}
