#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 1334 AppraisalNeeds
{

    fields
    {
        field(1; EntryNo; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; Appraisaltype; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Technical Capacity,Organisation and planning skills,Efficiency and Effectiveness,Communication,Leadership';
            OptionMembers = "Technical Capacity","Organisation and planning skills","Efficiency and Effectiveness",Communication,Leadership;
        }
        field(3; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Line type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'AppraisalScore,ActionPoints,CapacityNeeds,PersonalQualities,Rellections';
            OptionMembers = AppraisalScore,ActionPoints,CapacityNeeds,PersonalQualities,Rellections;
        }
    }

    keys
    {
        key(Key1; EntryNo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

