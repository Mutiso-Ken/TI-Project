tableextension 50007 "Fixed Asset" extends "Fixed Asset"
{
    fields
    {
        field(141; "Tag Number"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(142; "Acquisition Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(143; "Staff Assigned"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
    }
}
