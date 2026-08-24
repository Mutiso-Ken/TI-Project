#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
table 66101 "Proc. Line Service Types"
{

    DataCaptionFields = "Code", "Service Name";
    DrillDownPageID = "Proc. Line Types";
    LookupPageID = "Proc. Line Types";

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Service Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "G/L Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
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
