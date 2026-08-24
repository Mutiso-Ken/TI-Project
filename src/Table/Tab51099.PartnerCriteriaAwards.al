table 51099 "Partner Criteria Awards"
{

    fields
    {
        field(1; "RFA Criteria Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "RFA Criteria".Code WHERE(RFA = FIELD("RFA Criteria Code"));
        }
        field(2; Partner; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Criteria; Text[250])
        {
            CalcFormula = Lookup("RFA Criteria".Description WHERE(Code = FIELD("RFA Criteria Code")));
            FieldClass = FlowField;
        }
        field(4; RFA; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = RFA.No;
        }
        field(5; Score; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                ObjCriteria.RESET;
                ObjCriteria.SETRANGE(RFA, RFA);
                IF ObjCriteria.FIND('-') THEN
                    IF Score > ObjCriteria."Max Score" THEN ERROR('Score cannot exceed maximum score of ' + FORMAT(ObjCriteria."Max Score"));
            end;
        }
        field(6; "Name of Partner"; Text[250])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD(Partner)));
            FieldClass = FlowField;
        }
        field(7; Comments; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "RFA Criteria Code", Partner)
        {
        }
    }

    fieldgroups
    {
    }

    var
        ObjCriteria: Record "RFA Criteria";
}
