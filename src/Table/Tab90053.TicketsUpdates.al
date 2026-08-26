table 90053 "Tickets Updates"
{
    Caption = 'Tickets Updates';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            AutoIncrement = true;
            Caption = '';
        }
        field(2; "Ticket No"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Comment; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Update DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Ticket Status"; Option)
        {
            Caption = 'Status';
            OptionCaption = 'New,Pending,In Progress,Resolved';
            OptionMembers = New,Pending,"In Progress",Resolved;
        }
    }
    keys
    {
        key(PK; "Entry No")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        Updates: Record "Tickets Updates";
    begin
        Updates.Reset();
        if Updates.FindLast() then
            Rec."Entry No" := Updates."Entry No" + 100
        else
            Rec."Entry No" := 100;
    end;
}
