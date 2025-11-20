table 80050 "Appraisal Sec A(Second Part 2)"
{
    Caption = 'Appraisal Sec A(Second Part 2)';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Appraisal Code"; Code[100])
        {
            Caption = 'Appraisal Code';
            TableRelation = "Appraisal Header"."Appraisal Code";
        }
        field(2; "What capacity need? "; Text[2048])
        {
            Caption = 'What capacity needs do you need to support your current objectives and growth? ';
        }
        field(3; "Why prioritized this year?"; Text[2048])
        {
            Caption = 'Why should they be prioritized this year?';
        }
        field(4; "Comments by the supervisor"; Text[2048])
        {
            Caption = 'Comments by the supervisor';
        }
    }
    keys
    {
        key(PK; "Appraisal Code")
        {
            Clustered = true;
        }
    }
}
