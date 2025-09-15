#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 80048 "Diarized Dates"
{

    fields
    {
        field(1; "Code"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Header; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Body; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "1st Notification On"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "2nd Notification On"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "3rd Notification On"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

