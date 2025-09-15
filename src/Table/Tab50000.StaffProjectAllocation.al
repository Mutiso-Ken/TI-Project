#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 50000 "Staff Project Allocation"
{

    fields
    {
        field(1; "Staff Code"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Employees"."No.";

            trigger OnValidate()
            begin
                if HREmployees.Get("Staff Code") then
                    "Staff Name" := HREmployees.FullName;
            end;
        }
        field(2; "Fund Code"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('FUND'));
        }
        field(3; Hours; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Staff Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Staff Code", "Fund Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        HREmployees: Record "HR Employees";
}

