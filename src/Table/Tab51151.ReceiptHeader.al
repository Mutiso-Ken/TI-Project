table 51151 "Receipt Header"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Imprest No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Used for Surrender"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Net Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }
}
