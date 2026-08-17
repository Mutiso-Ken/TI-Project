table 40 "Vendor Clients Details"
{
    Caption = 'Vendor Clients Details';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; No; Integer)
        {
            Caption = 'No';
            AutoIncrement = true;
        }
        field(2; VendorID; Code[50])
        {
            Caption = 'VendorID';
        }
        field(3; "Client Organization"; Text[500])
        {
            Caption = 'Client Organization';
        }
        field(4; "Client Addres"; Text[200])
        {
            Caption = 'Client Addres';
        }
        field(5; "Contact Person"; Text[200])
        {
            Caption = 'Contact Person';
        }
        field(6; Telephone; Text[100])
        {
            Caption = 'Telephone';
        }
        field(7; "Value of Contract"; Decimal)
        {
            Caption = 'Value of Contract';
        }
        field(8; "Contract Duration"; Text[200])
        {
            Caption = 'Contract Duration';
        }
        field(9; "Doc Contract Evidence"; Boolean)
        {
            Caption = 'Doc Contract Evidence';
        }
        field(10; "Contract Evidence Path"; Text[1000])
        {
            Caption = 'Contract Evidence Path';
        }
        field(11; "Contract Evidence Name"; Text[500])
        {
            Caption = 'Contract Evidence Name';
        }
    }
    keys
    {
        key(PK; No)
        {
            Clustered = true;
        }
    }
}
