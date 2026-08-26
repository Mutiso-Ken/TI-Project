table 95044 "Vendor Invoice"
{
    Caption = 'Vendor Invoice';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Procurement No"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Procurement Request"."No.";
        }
        field(3; "Purchase Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Delivery Note No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Vendor Delivery Note"."No.";
        }
        field(5; "Vendor No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No.";

            trigger OnValidate();
            begin
                if Vendor.Get("Vendor No") then
                    "Vendor Name" := Vendor.Name
                else
                    "Vendor Name" := '';
            end;
        }
        field(6; "Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "Vendor Invoice No."; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Date Submitted"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Invoice Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Total Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'New,Approved,Rejected';
            OptionMembers = New,Approved,Rejected;
        }
        field(14; Remarks; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Document Name"; Text[255])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Document Path"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit "No. Series";
        ProcurementSetup: Record "Procurement Setup";
    begin
        if "No." = '' then begin
            ProcurementSetup.Get();
            ProcurementSetup.TestField("Invoice Nos");
            "No." := NoSeriesMgt.GetNextNo(ProcurementSetup."Invoice Nos", 0D, true);
        end;
        if "Date Submitted" = 0D then
            "Date Submitted" := Today;
    end;

    var
        Vendor: Record Vendor;
}
