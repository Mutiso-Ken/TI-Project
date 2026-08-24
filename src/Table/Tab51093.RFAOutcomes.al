table 51093 "RFA Outcomes"
{

    fields
    {
        field(1; EntryNo; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; RFA; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Outcome Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Outcome; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; EntryNo, RFA)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    var
        RFAOutcome: Record "RFA Outcomes";
    begin
        IF "Outcome Code" = '' THEN BEGIN
            RFAOutcome.RESET;
            IF RFAOutcome.FINDLAST THEN BEGIN
                "Outcome Code" := INCSTR(RFAOutcome."Outcome Code");
            END ELSE BEGIN
                "Outcome Code" := 'OUTCOME0001';
            END;
        END;
    end;
}
