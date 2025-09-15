tableextension 50005 "Purchases & Payables Setup Ext" extends "Purchases & Payables Setup"
{
    fields
    {
        field(6603; "Requisition Nos."; Code[20])
        {
            Caption = 'Requisition Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(6604; "Mission Proposal Nos."; Code[20])
        {
            Caption = 'Mission Proposal Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(6605; "Imprest Nos."; Code[20])
        {
            Caption = 'Imprest Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(6606; "Surrender Nos."; Code[20])
        {
            Caption = 'Imprest Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(6607; "Line Nos."; Code[20])
        {
            Caption = 'Line Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(6608; "Payment Memo Nos."; Code[20])
        {
            Caption = 'Payment Memo Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }
}
