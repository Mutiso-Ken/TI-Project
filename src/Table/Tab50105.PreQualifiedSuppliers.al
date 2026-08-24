#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
table 50105 "PreQualified Suppliers"
{
    Caption = 'PreQualified Suppliers';
    DataCaptionFields = "Entry No.";
    DrillDownPageID = "Prequalified Suppliers";
    LookupPageID = "Prequalified Suppliers";
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            Editable = false;
        }
        field(2; FY; Code[30])
        {
            Caption = 'FY';
            TableRelation = "Procurement Years"."FY Code";

            trigger OnValidate()
            begin
                ProcurementYears.Reset();
                if ProcurementYears.Get(FY) then begin
                    "Start Date" := ProcurementYears."Start Date";
                    "End Date" := ProcurementYears."End Date";
                end;
            end;
        }
        field(3; "Start Date"; Date)
        {
            Caption = 'Start Date';
            Editable = false;
        }
        field(4; "End Date"; Date)
        {
            Caption = 'End Date';
            Editable = false;
        }
        field(5; "Supplier Name"; Text[100])
        {
            Caption = 'Supplier Name';
        }
        field(6; "E-mail"; Text[100])
        {
            Caption = 'E-mail';
        }
        field(7; "Phone No."; Text[20])
        {
            Caption = 'Phone No.';
        }
        field(8; "Physical Address"; Text[100])
        {
            Caption = 'Physical Address';
        }
        field(9; "Date Added"; Date)
        {
            Caption = 'Date Added';
        }
        field(10; "Time Added"; Time)
        {
            Caption = 'Time Added';
        }
        field(11; "Category Code"; Code[50])
        {
            Caption = 'Category Code';
            TableRelation = "Procurement Categories".Code;

            trigger OnValidate()
            begin
                ProcurementCategory.Reset();
                ProcurementCategory.SetRange(Code, "Category Code");
                if ProcurementCategory.FindSet() then begin
                    "Category Name" := ProcurementCategory.Description;
                end;
            end;
        }
        field(12; "Category Name"; Text[100])
        {
            Caption = 'Category Name';
            Editable = false;
        }
        field(13; "Linked Vendor No."; Code[20])
        {
            Caption = 'Linked Vendor No.';
            TableRelation = Vendor."No.";

            trigger OnValidate()
            begin
                if Vendor.Get("Linked Vendor No.") then begin
                    "Linked Vendor Name" := Vendor.Name;
                end;
            end;
        }
        field(14; "Linked Vendor Name"; Text[100])
        {
            Caption = 'Linked Vendor Name';
            Editable = false;
        }
        field(15; "Contact Person Name"; Text[100])
        {
            Caption = 'Contact Person Name';
        }
        field(16; "BDDoc"; Code[50])
        {
            Caption = 'BDDoc';
        }
        field(17; "Attachment Type"; Text[100])
        {
            Caption = 'Attachment Type';
        }
        field(18; "Mode of addition"; Option)
        {
            Caption = 'Mode of addition';
            OptionCaption = 'Portal,Manual';
            OptionMembers = Portal,Manual;
        }
        field(19; "mannual addition by user"; Code[50])
        {
        }
        field(20; "Addition Date"; Date)
        {
        }
        field(21; "Addition Time"; Time)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Date Added" := Today;
        "Time Added" := Time;
        "Addition Date" := Today;
        "Addition Time" := Time;
        "mannual addition by user" := UserId;
        "Attachment Type" := 'PREQUALIFICATION';
    end;

    var
        ProcurementYears: Record "Procurement Years";
        ProcurementCategory: Record "Procurement Categories";
        Vendor: Record Vendor;
}
