table 51091 "RFA Application Guidelines"
{

    fields
    {
        field(1; EntryNo; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "RFA No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = RFA.No;
        }
        field(3; Instruction; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; EntryNo, "RFA No")
        {
        }
    }

    fieldgroups
    {
    }
}
