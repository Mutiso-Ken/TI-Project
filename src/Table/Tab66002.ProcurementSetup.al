#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
table 66002 "Procurement Setup"
{
    Caption = 'Procurement Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Procurement Plan  Nos"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(4; "Purchase Requisition Nos"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(6; "Contract Nos"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(7; "Tender Nos"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(8; "Quotation Nos"; Code[30])
        {
            Caption = 'RFQ Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(9; "RFP Nos"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(10; "Direct Procurement Nos"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(11; "Procurement Officer User Id"; Code[70])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID";
        }
        field(12; "Current Procurement Plan"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Disposal Request Nos"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(14; "Delivery Note Nos"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(15; "Invoice Nos"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(20; "Tender Threshold"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "RFQ Threshold"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "RFP Threshold"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Direct Threshold"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}
