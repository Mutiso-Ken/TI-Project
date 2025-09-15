#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 1332 "Performance Plan"
{

    fields
    {
        field(1; "Employee No"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Review Period"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "KEY RESULT AREAS"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "PERFORMANCE MEASURES"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(5; TARGET; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(6; DIRECTION; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Actual Achieved"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "% of target"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(9; Rating; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Employee No", "Review Period")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

