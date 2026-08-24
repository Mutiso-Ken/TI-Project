#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
table 67022 "Contract Milestone"
{

    fields
    {
        field(1; "Contract No"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Milestone Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Milestone Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; Period; DateFormula)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                IF FORMAT(Period) <> '' THEN BEGIN
                    TESTFIELD("Start Date");
                    "End Date" := CALCDATE(Period, "Start Date");
                END;
            end;
        }
        field(6; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Is Percentage"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(8; Percentage; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Fixed Amount"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(10; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Order Created"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Contract Lines"."Line No." WHERE("Contract No." = FIELD("Contract No"));

            trigger OnValidate();
            var
                ContractLines: Record "Contract Lines";
            begin
                ContractLines.RESET;
                ContractLines.SETRANGE("Contract No.", Rec."Contract No");
                ContractLines.SETRANGE("Line No.", Rec."Line No");
                IF ContractLines.FINDFIRST THEN BEGIN
                    "Item No." := ContractLines.No;
                    "Item Name" := ContractLines.Name;

                    IF "Is Percentage" THEN
                        Amount := Percentage / 100 * ContractLines."Total Amount";
                END;
            end;
        }
        field(13; "Item No."; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Item Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(15; "Tender Amount"; Decimal)
        {
            CalcFormula = Sum("Contract Lines"."Total Amount" WHERE("Contract No." = FIELD("Contract No"),
                                                                     "Line No." = FIELD("Line No")));
            FieldClass = FlowField;
        }
        field(70000; "Milestone Extended"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70001; "New End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Contract No", "Milestone Code")
        {
        }
    }

    fieldgroups
    {
    }
}
