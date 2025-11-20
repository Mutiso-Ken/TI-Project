table 171228 "Portal Documents"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
            MinValue = 1;
        }
        field(2; "Original File Name"; Text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Original File Path"; Text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Document Number"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "File Extension"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Local Url"; Text[2000])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}