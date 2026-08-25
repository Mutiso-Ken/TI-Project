table 5045 "Vendor Invoice Line"
{
    Caption = 'Vendor Invoice Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Vendor Invoice"."No.";
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Invoice No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
