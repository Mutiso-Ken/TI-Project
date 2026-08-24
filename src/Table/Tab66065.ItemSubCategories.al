#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
table 66065 "Item Sub Categories"
{
    // version Procurement Iansoft

    DrillDownPageID = "Item Sub Categories";
    LookupPageID = "Item Sub Categories";

    fields
    {
        field(1; "Category Code"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Categories"."Category Code";
        }
        field(2; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Description, "Category Code")
        {
        }
    }

    fieldgroups
    {
    }
}
