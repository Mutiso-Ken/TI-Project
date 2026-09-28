table 90081 "Laptop Replacement Updates"
{
    Caption = 'Laptop Replacement Updates';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "Request No."; Code[20])
        {
            Caption = 'Request No.';
            TableRelation = "Laptop Replacement Request"."No.";
        }
        field(3; "Update DateTime"; DateTime)
        {
            Caption = 'Update Date/Time';
            Editable = false;
        }
        field(4; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = "Pending Review","ICT Assessed",Approved,Rejected,Fulfilled;
            OptionCaption = 'Pending Review,ICT Assessed,Approved,Rejected,Fulfilled';
            Editable = false;
        }
        field(5; Comment; Text[250])
        {
            Caption = 'Comment';
            Editable = false;
        }
        field(6; "Updated By"; Code[50])
        {
            Caption = 'Updated By';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(RequestKey; "Request No.", "Entry No.")
        {
        }
    }
}
