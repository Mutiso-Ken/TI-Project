#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 1331 "Appraisal Header"
{

    fields
    {
        field(1; "Employee No"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Employee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Review Period"; Code[50])
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

