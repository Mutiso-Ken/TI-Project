tableextension 50069 "Purchases Payables Setup Ext" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50069; "Budget Balance 25%"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50070; "Budget Balance 10%"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50071; "Procurement Email"; Text[80])
        {
            Caption = 'Procurement Email';
            ExtendedDatatype = EMail;
            DataClassification = ToBeClassified;
        }
        field(50072; "Procurement Portal"; Text[250])
        {
            Caption = 'Procurement Portal';
            DataClassification = ToBeClassified;
        }
    }
}
