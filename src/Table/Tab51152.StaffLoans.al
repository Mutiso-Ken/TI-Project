table 51152 "Staff Loans"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Loan Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Maximum Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Repayment Period"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(5; Instalments; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }
}
