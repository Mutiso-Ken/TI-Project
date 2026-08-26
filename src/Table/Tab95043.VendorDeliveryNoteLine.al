table 95043 "Vendor Delivery Note Line"
{
    Caption = 'Vendor Delivery Note Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Delivery Note No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Vendor Delivery Note"."No.";
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Quantity Delivered"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Unit of Measure"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure".Code;
        }
        field(6; "Quantity Confirmed"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Quantity Variance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; Condition; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Good,Damaged,Partial';
            OptionMembers = " ",Good,Damaged,Partial;
        }
        field(9; Remarks; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Delivery Note No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
