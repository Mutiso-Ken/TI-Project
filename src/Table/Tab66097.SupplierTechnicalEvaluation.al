#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
table 66097 "Supplier Technical Evaluation"
{
    // version Procurement Iansoft


    fields
    {
        field(1; "Reference No"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Requirement Code"; Code[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Requirement Description"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Evaluator ID"; Code[70])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Evaluator No."; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Evaluator Name"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "Vendor Name"; Text[200])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; Score; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                IF Score > "Max Score" THEN
                    ERROR('Score cannot be more than %1', "Max Score");
            end;
        }
        field(9; Comment; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Max Score"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Reference No", "Requirement Code", "Evaluator ID", "Vendor Name")
        {
        }
        key(Key2; "Vendor Name")
        {
        }
    }

    fieldgroups
    {
    }
}
