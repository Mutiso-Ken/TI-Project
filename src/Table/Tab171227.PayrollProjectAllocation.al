#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 171227 "Payroll Project Allocation"
{

    fields
    {
        field(1; Period; Date)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payroll Calender_AU"."Date Opened";
        }
        field(2; "Employee No"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payroll Employee_AU"."No.";

            trigger OnValidate()
            var
                Name: Text;
            begin
                HREmployees.Reset();
                HREmployees.SetRange(HREmployees."No.", "Employee No");
                if HREmployees.FindSet() then begin
                    Name := HREmployees.Firstname + ' ' + HREmployees.Lastname;
                    rec."Employee Name" := Name;
                
                end;
            end;
        }
        field(3; "Employee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable=false;
        }
        field(4; "Project Code"; Code[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Program Code';
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('PROGRAM'));
        }
        field(5; Allocation; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Budget Line Code"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('BUDGET LINES'));
        }
    }

    keys
    {
        key(Key1; Period, "Project Code", "Employee No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Employee No", "Employee Name")
        {
        }
    }

    var
        HREmployees: Record "Payroll Employee_AU";
}

