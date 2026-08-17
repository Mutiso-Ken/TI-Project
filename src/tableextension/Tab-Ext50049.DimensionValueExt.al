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
        field(70003; "Budget Category"; code[450])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = filter(false));
        }
        field(70007; Description; Text[2048])
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