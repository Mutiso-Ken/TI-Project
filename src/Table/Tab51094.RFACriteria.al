table 51094 "RFA Criteria"
{

    fields
    {
        field(1; EntryNo; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; RFA; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = RFA.No;
        }
        field(4; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Max Score"; Decimal)
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
        RFACriteria: Record "RFA Criteria";
    begin
        IF Code = '' THEN BEGIN
            RFACriteria.RESET;
            IF RFACriteria.FINDLAST THEN BEGIN
                Code := INCSTR(RFACriteria.Code);
            END ELSE BEGIN
                Code := 'CRITERIA0001';
            END;
        END;
    end;
}
