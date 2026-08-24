table 51159 "Cheque Ledger Entries"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Payee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Original Cheque No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Posted By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Posted On"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Posted At"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "New Cheque No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Reason for Voiding"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Approved By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Approved On"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Approved at"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Cheque Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}
