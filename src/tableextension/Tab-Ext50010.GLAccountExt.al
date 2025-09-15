tableextension 50010 "G/L Account Ext" extends "G/L Account"
{
    fields
    {
        field(8001; "Used for Pettycash"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
}
