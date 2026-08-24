#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
table 66098 "Financial Evaluation"
{

    fields
    {
        field(1; "Reference No."; Code[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Vendor Name"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Quoted Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(4; Award; Boolean)
        {
            CalcFormula = Lookup("Tender Suppliers".Awarded WHERE("Reference No" = FIELD("Reference No."),
                                                                   "Vendor Name" = FIELD("Vendor Name")));
            FieldClass = FlowField;
        }
        field(5; "Technical Score"; Decimal)
        {
            CalcFormula = Sum("Tender Suppliers"."Technical Score" WHERE("Reference No" = FIELD("Reference No."),
                                                                          "Vendor Name" = FIELD("Vendor Name")));
            FieldClass = FlowField;
        }
        field(6; "Financial Score"; Decimal)
        {
            CalcFormula = Sum("Tender Suppliers"."Financial Score" WHERE("Reference No" = FIELD("Reference No."),
                                                                          "Vendor Name" = FIELD("Vendor Name")));
            FieldClass = FlowField;
        }
        field(7; "Total Score"; Decimal)
        {
            CalcFormula = Sum("Tender Suppliers"."Total Score" WHERE("Reference No" = FIELD("Reference No."),
                                                                      "Vendor Name" = FIELD("Vendor Name")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Reference No.", "Vendor Name")
        {
        }
    }

    fieldgroups
    {
    }
}
