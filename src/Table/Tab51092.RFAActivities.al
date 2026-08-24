table 51092 "RFA Activities"
{
    DrillDownPageID = "RFA Activities";
    LookupPageID = "RFA Activities";

    fields
    {
        field(1; EntryNo; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "Activity Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Activity Description"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "RFA Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = RFA.No;
        }
    }

    keys
    {
        key(Key1; EntryNo, "RFA Code", "Activity Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    var
        RFAActivity: Record "RFA Activities";
    begin
        IF "Activity Code" = '' THEN BEGIN
            RFAActivity.RESET;
            IF RFAActivity.FINDLAST THEN BEGIN
                "Activity Code" := INCSTR(RFAActivity."Activity Code");
            END ELSE BEGIN
                "Activity Code" := 'ACTIVITY0001';
            END;
        END;
    end;
}
