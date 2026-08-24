tableextension 50063 "GeneralLedgerSetupExt" extends "General Ledger Setup"
{
    fields
    {

        field(50063; "Grant Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50064; "Current Budget"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Budget Name".Name;
        }
        field(50065; "Current Budget Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50066; "Current Budget End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

    }
}
