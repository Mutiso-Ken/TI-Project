table 2 "HelpDesk Tickets"
{
    Caption = 'HelpDesk Tickets';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No"; Code[20])
        {
            Caption = 'Document No';
        }
        field(2; "Employee ID"; Code[20])
        {
            Caption = 'Employee ID';
        }
        field(3; Title; Text[100])
        {
            Caption = 'Title';
        }
        field(4; Description; Text[2048])
        {
            Caption = 'Description';
        }
        field(5; "Document Link"; Text[2048])
        {
            Caption = 'Document Link';
        }
        field(6; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'New,Pending,Resolved';
            OptionMembers = New,Pending,Resolved;
        }
        field(7; "Placed On"; Date)
        {
            Caption = 'Created On';
        }
        field(8; "Resolved On"; Date)
        {
            Caption = 'Resolved On';
        }
        field(9; "Employee Name"; Text[200])
        {
            Caption = 'Employee Name';
        }
    }
    keys
    {
        key(PK; "Document No")
        {
            Clustered = true;
        }
    }
}
