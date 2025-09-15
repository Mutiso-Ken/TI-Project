#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 1333 "Section B-D"
{

    fields
    {
        field(1; "Employe No"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Review Period"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = ,"Technical Capacity","Organisation and planning skills","Efficiency and Effectiveness",Communication,Leadership,"SECTION C: PERSONAL QUALITIES: TO BE FILLED BY THE SUPERVISOR)","SECTION D: REFLECTIONS AND LEARNINGS";
        }
        field(4; "Employee Rating"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Supervisor Rating"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Employe No", "Review Period")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

