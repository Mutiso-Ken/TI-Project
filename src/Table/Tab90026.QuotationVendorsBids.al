table 90026 "Quotation Vendors Bids"
{
    // version Procurement Iansoft

    DrillDownPageID = "Vendor Quoted Amount Per Item";
    LookupPageID = "Vendor Quoted Amount Per Item";

    fields
    {
        field(1; "Quote No"; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(2; "Vendor No"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = true;

            trigger OnValidate();
            begin
                IF Vendor.GET("Vendor No") THEN BEGIN
                    "Vendor Name" := Vendor.Name;
                END;
            end;
        }
        field(3; "Vendor Name"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Item No"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate();
            begin
                IF Item.GET("Item No") THEN BEGIN
                    "Item Name" := Item.Description;
                END ELSE
                    IF GLAccount.GET("Item No") THEN BEGIN
                        "Item Name" := GLAccount.Name;
                    END ELSE
                        IF FixedAsset.GET("Item No") THEN BEGIN
                            "Item Name" := FixedAsset.Description;
                        END;
            end;
        }
        field(6; "Item Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "Quoted Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "VAT %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Lead Time"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "VAT Inclusive"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(12; Quantity; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                "Quoted Amount" := "Unit Price" * Quantity;
            end;
        }
        field(13; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                "Quoted Amount" := "Unit Price" * Quantity;
            end;
        }
        field(14; MyField; Blob)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Quote No", "Vendor No", "Line No")
        {
        }
        key(Key2; "Quoted Amount")
        {
        }
        key(Key3; "Item No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Vendor: Record "Vendor";
        GLAccount: Record "G/L Account";
        Item: Record "Item";
        FixedAsset: Record "Fixed Asset";
}

