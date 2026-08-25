table 5042 "Vendor Delivery Note"
{
    Caption = 'Vendor Delivery Note';
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
        field(4; "Vendor No"; Code[20])
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
        field(5; "Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Delivery Note Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Date Submitted"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'New,Confirmed,Rejected';
            OptionMembers = New,Confirmed,Rejected;
        }
        field(9; Remarks; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Approved Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Document Name"; Text[255])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Document Path"; Text[2048])
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
            ProcurementSetup.TestField("Delivery Note Nos");
            "No." := NoSeriesMgt.GetNextNo(ProcurementSetup."Delivery Note Nos", 0D, true);
        end;
        if "Date Submitted" = 0D then
            "Date Submitted" := Today;
    end;

    var
        Vendor: Record Vendor;
}
