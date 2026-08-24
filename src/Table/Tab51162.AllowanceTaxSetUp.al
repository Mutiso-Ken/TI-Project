table 51162 "Allowance Tax Set Up"
{

    fields
    {
        field(1; "Tax Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Tax Percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Tax Account"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }
    }

    keys
    {
        key(Key1; "Tax Code")
        {
        }
    }

    fieldgroups
    {
    }
}
