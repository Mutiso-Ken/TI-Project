table 51098 "Selected RFA Partners"
{

    fields
    {
        field(1; Partner; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No." WHERE("Account Type" = FILTER("Implementing Partner"));

            trigger OnValidate();
            begin
                ObjCust.GET(Partner);
                Email := ObjCust."E-Mail";
            end;
        }
        field(2; RFA; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Notified; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(4; Email; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Email Sent"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Date of Selection"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Selected By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Name; Text[250])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD(Partner)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; Partner, RFA)
        {
        }
    }

    fieldgroups
    {
    }

    var
        ObjCust: Record "Customer";
}
