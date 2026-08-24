table 51156 "Additional Charges"
{

    fields
    {
        field(1; Method; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "G/L Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account" WHERE(Blocked = filter(false),
                                                 "Direct Posting" = filter(true));
        }
        field(3; Description; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Method, "G/L Account")
        {
        }
    }

    fieldgroups
    {
    }
}
