table 90035 "Vendor Company Directors"
{
    Caption = 'Vendor Company Directors';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; No; Integer)
        {
            Caption = 'No';
            AutoIncrement = true;
        }
        field(2; "Full Name"; Text[1000])
        {
            Caption = 'Full Name';
        }
        field(3; Nationality; Text[200])
        {
            Caption = 'Nationality';
        }
        field(4; Citizenship; Text[200])
        {
            Caption = 'Citizenship';
        }
        field(5; Shares; Text[200])
        {
            Caption = 'Shares';
        }
        field(6; VendorID; Code[50])
        {
            Caption = 'VendorID';
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
