#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 80049 Notify
{

    fields
    {
        field(1; "code"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Employee Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Employees";

            trigger OnValidate()
            begin
                if HREmployees.Get("Employee Code") then begin
                    Email := HREmployees."E-Mail";
                    Names := HREmployees."First Name" + ' ' + HREmployees."Middle Name" + ' ' + HREmployees."Last Name";
                end;
            end;
        }
        field(3; Email; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Names; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "code", "Employee Code")
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

