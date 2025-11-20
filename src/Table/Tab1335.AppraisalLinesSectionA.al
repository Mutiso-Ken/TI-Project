table 1335 "Appraisal Lines Section A"
{
    Caption = 'Appraisal Lines';
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
            TableRelation = "Appraisal Header"."Appraisal Code";
        }
        field(3; Section; Option)
        {
            OptionCaption = '"Section A","Section B","Section C","Section D"';
            OptionMembers = "Section A","Section B","Section C","Section D";
        }
        field(4; "What have you done"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "When?"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Expected Results"; Text[2048])
        {
            Caption = 'What were the expected results? (Quantifiable, Measurable Results - as per DIP targets)';
            DataClassification = ToBeClassified;
        }
        field(7; "What was Achieved?"; text[2048])
        {
            Caption = 'What was achieved against these objectives (in terms of quantifiable measurable targets with the when and the how?)';
            DataClassification = ToBeClassified;
        }
        field(8; "Supervisor Rating"; Integer)
        {
            Caption = 'Rating by supervisor based on evidence (Out of 10 Marks)';
        }
        field(9; "Capacity Needed"; text[2048])
        {
            Caption = 'What capacity needs do you need to support your current objectives and growth?';
            DataClassification = ToBeClassified;
        }
        field(10; "Why Prioritize"; Text[2048])
        {
            Caption = 'Why should they be prioritized this year?';
            DataClassification = ToBeClassified;
        }

        field(11; "Comments by the supervisor"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Line No")
        {
            Clustered = true;
        }
    }
}
