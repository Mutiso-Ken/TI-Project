#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 80045 "Notice Board"
{

    fields
    {
        field(1; "Date of Announcement"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Department Announcing"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Announcement; Text[200])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Date of Announcement", Announcement)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

