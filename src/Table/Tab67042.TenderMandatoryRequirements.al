#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
table 67042 "Tender Mandatory Requirements"
{
    DataCaptionFields = "Mandatory Code", "Requirement Description";
    DrillDownPageID = "Tender Mandatory Requirements";
    LookupPageID = "Tender Mandatory Requirements";

    fields
    {
        field(1; "Mandatory Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Requirement Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Mandatory Code")
        {
        }
    }

    fieldgroups
    {
    }
}
