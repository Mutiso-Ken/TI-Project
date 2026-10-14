table 50228 "Portal Documents"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
            MinValue = 1;
        }
        field(2; "Original File Name"; Text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Original File Path"; Text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Document Number"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "File Extension"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Local Url"; Text[2000])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Shared With Vendors"; Boolean)
        {
            Caption = 'Shared With Vendors';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                ProcurementRequest: Record "Procurement Request";
            begin
                if "Shared With Vendors" then begin
                    if not ProcurementRequest.Get("Document Number") then
                        Error('Documents can only be shared with vendors from an RFQ or Direct Procurement document.');
                    if not (ProcurementRequest."Procurement Method" in [ProcurementRequest."Procurement Method"::RFQ, ProcurementRequest."Procurement Method"::"Direct Procurement"]) then
                        Error('Documents can only be shared with vendors from an RFQ or Direct Procurement document.');
                    "Shared By" := CopyStr(UserId, 1, MaxStrLen("Shared By"));
                    "Shared On" := Today;
                end else begin
                    "Shared By" := '';
                    "Shared On" := 0D;
                end;
            end;
        }
        field(8; "Source Document No."; Code[100])
        {
            Caption = 'Source Document No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; "Shared By"; Code[50])
        {
            Caption = 'Shared By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
        }
        field(10; "Shared On"; Date)
        {
            Caption = 'Shared On';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}