tableextension 50065 "Payment Method Ext Grants" extends "Payment Method"
{
    fields
    {
        field(50065; "M-PESA"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50066; "Is Check"; Boolean)
        {
            Caption = 'Is Check';
            DataClassification = ToBeClassified;
        }
    }
}
