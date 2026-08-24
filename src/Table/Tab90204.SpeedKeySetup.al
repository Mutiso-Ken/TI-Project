table 90204 "SpeedKey Setup"
{

    fields
    {
        field(1; SpeedKey; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Grant No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Grant Header"."No.";
        }
        field(4; "Objective Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Grant Lines".Code WHERE("Grant No" = FIELD("Grant No"),
                                                      "Line Type" = CONST(Objective));
        }
        field(5; "Outcome Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Grant Lines".Code WHERE("Grant No" = FIELD("Grant No"),
                                                      "Line Type" = CONST(Outcome));
        }
        field(6; "Output Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Grant Lines".Code WHERE("Grant No" = FIELD("Grant No"),
                                                      "Line Type" = CONST(Output));
        }
        field(7; "Activity Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Grant Lines".Code WHERE("Grant No" = FIELD("Grant No"),
                                                      "Line Type" = CONST(Activity));
        }
    }

    keys
    {
        key(Key1; SpeedKey)
        {
        }
    }

    fieldgroups
    {
    }
}
