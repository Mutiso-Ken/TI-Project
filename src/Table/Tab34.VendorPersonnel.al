table 34 "Vendor Personnel"
{
    Caption = 'Vendor Personnel';
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
        field(3; "Full Name"; Text[200])
        {
            Caption = 'Full Name';
        }
        field(4; "Academic Qualification"; Text[200])
        {
            Caption = 'Academic Qualification';
        }
        field(5; "Length of Service"; Text[200])
        {
            Caption = 'Length of Service';
        }
        field(6; "Position Held"; Text[200])
        {
            Caption = 'Position Held';
        }
        field(7; Age; Integer)
        {
            Caption = 'Age';
        }
        field(8; "Professional Qualification"; Text[200])
        {
            Caption = 'Professional Qualification';
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
