tableextension 50001 "Standard Text Ext" extends "Standard Text"
{
    fields
    {
        field(3; "GL Account"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(4; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(5; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = ,"Focus Area","Sub Pillar","GL Category",Department;
        }
    }
}
