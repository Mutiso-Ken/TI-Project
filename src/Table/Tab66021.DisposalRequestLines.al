#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
table 66021 "Disposal Request Lines"
{

    fields
    {
        field(1; "Disposal No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Fixed Asset,Item';
            OptionMembers = "Fixed Asset",Item;
        }
        field(3; No; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF (Type = CONST(Item)) Item."No."
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"."No.";

            trigger OnValidate();
            begin
                IF Item.GET(No) THEN BEGIN
                    Description := Item.Description;
                    Item.CALCFIELDS(Inventory);
                    Quantity := Item.Inventory;
                    "Unit Price" := Item."Unit Cost";
                    "Total Amount" := Quantity * "Unit Price";
                END;
                IF FixedAsset.GET(No) THEN
                    Description := FixedAsset.Description;
            end;
        }
        field(4; Description; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; Reason; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                "Total Amount" := Quantity * "Unit Price";
            end;
        }
        field(7; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                "Total Amount" := Quantity * "Unit Price";
            end;
        }
        field(8; "Total Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; Accept; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Acquisition Date"; Date)
        {
            CalcFormula = Lookup("FA Depreciation Book"."Acquisition Date" WHERE("FA No." = FIELD(No)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Disposal No", No)
        {
        }
    }

    fieldgroups
    {
    }

    var
        FixedAsset: Record "Fixed Asset";
        Item: Record "Item";
}
