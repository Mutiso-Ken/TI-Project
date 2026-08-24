tableextension 50049 "Dimension Value Ext" extends "Dimension Value"
{

    fields
    {
        field(70002; "Fund Code"; code[550])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = filter(false));
        }
        field(70003; "Budget Line"; code[450])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = filter(false));
        }
        field(70004; "Budget Category"; code[450])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = filter(false));
        }
        field(70007; Description; Text[2048])
        {

        }

        field(70020; "Max No. of Employees"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(70021; "Minimum No. of Employees"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(70022; "Pillar"; code[550])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                         "Dimension Value Type" = CONST(Standard),
                                                         Blocked = filter(false));
        }
        field(70023; "Partner"; code[450])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                         "Dimension Value Type" = CONST(Standard),
                                                         Blocked = filter(false));
        }
        field(70024; "Sub Office"; Code[450])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                         "Dimension Value Type" = CONST(Standard),
                                                         Blocked = filter(false));
        }
        field(70025; "Grant"; code[250])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3),
                                                         Blocked = const(false));
        }
        field(70026; "Activity"; code[250])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4),
                                                         Blocked = const(false));
        }
        field(70027; "Grant Budget Amount"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                         "Dimension Value Type" = CONST(Standard),
                                                         Blocked = filter(false));
        }
        field(70028; "Unique Partner"; Code[20])
        {
        }
        field(70029; "Unique Activity"; Code[20])
        {
        }

    }
    fieldgroups
    {
        addlast(DropDown; Description)
        {
        }
    }

}