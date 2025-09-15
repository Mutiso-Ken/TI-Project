#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 80043 "Allocation Header"
{
    DrillDownPageID = "Line Allocations";
    LookupPageID = "Line Allocations";

    fields
    {
        field(1; "Allocation No"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Total Amount"; Decimal)
        {
            CalcFormula = sum("Allocation LineII".Amount where("Allocation No" = field("Allocation No")));
            FieldClass = FlowField;
        }
        field(4; Blocked; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Posting Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Allocation No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

