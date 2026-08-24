table 51161 "Payment Types"
{

    fields
    {
        field(1; "Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "G/L Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No." WHERE("Account Type" = CONST(Posting),
                                                     "Income/Balance" = CONST("Income Statement"));
        }
        field(4; "Source Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = '" ,Payment,Imprest"';
            OptionMembers = " ",Payment,Imprest;
        }
        field(5; Taxable; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Exemption Amount"; Decimal)
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
