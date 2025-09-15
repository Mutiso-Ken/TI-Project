#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 1330 "Induction Schedule"
{

    fields
    {
        field(1; "Employee No"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if Employee.Get("Employee No") then
                    "Employee Name" := Employee."First Name" + ' ' + Employee."Middle Name";
            end;
        }
        field(2; "Employee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Inducting Employee No"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if Employee.Get("Inducting Employee No") then
                    "Inducting Employee Name" := Employee."First Name" + ' ' + Employee."Middle Name";
            end;
        }
        field(4; "Inducting Employee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Inducted; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Date Inducted" := Today;
                "Time Inducted" := Time;
            end;
        }
        field(6; "Date Inducted"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Time Inducted"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(8; Comments; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Employee No", "Inducting Employee No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Employee: Record Employee;
}

