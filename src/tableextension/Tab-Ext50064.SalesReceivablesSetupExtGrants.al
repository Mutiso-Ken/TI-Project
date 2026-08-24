tableextension 50064 "SalesReceivablesSetupExtGrants" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50067; "Max No of Imprests"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50068; "Max No of Disbursements"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50069; "Grants Request Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50070; "Grants Surrender Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }
}
