#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
table 66095 "Tender Suppliers"
{
    Caption = 'Tender Suppliers';

    fields
    {
        field(1; "Reference No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Vendor Name"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Adress; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Post Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; City; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Physical Location"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Email Address"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Contact Person Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Contact Person Phone No."; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Contact Person E-mail"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Bid Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Security Bid Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Security Bid Receipt No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Technical Score"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Passed Mandatory"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Passed Technical"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(17; Awarded; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Supplier No."; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No.";

            trigger OnValidate();
            begin
                IF Vendor.GET("Supplier No.") THEN BEGIN
                    "Vendor Name" := Vendor.Name;
                    "Email Address" := Vendor."E-Mail";
                    Adress := Vendor.Address;
                    "Post Code" := Vendor."Post Code";
                    City := Vendor.City;
                    "Physical Location" := Vendor."Address 2";
                END;
            end;
        }
        field(19; "Chose From"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Expressed Interest,Vendor';
            OptionMembers = "Expressed Interest",Vendor;
        }
        field(20; "Financial Score"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Total Score"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Vendor No."; Code[20])
        {
            // NOTE: RCK's "Supplier Application" pre-registration table was not ported
            // (it is a ~2300-line clone of the base Vendor table used only for a
            // disabled field here). Points at the real Vendor table instead.
            DataClassification = ToBeClassified;
            Enabled = false;
            TableRelation = Vendor."No.";
        }
        field(23; "Supplier Application"; Code[50])
        {
            // NOTE: RCK's "Supplier Application" table was not ported; see field 22.
            DataClassification = ToBeClassified;
            Enabled = false;
        }
        field(24; "Bid Bond Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Bid Bond Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Bid Bond End Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                IF "Bid Bond End Date" < "Bid Bond Start Date" THEN
                    ERROR('This Date is not Applicable');
                IF "Bid Bond End Date" < TODAY THEN
                    "Bond Status" := "Bond Status"::Inactive;
                IF "Bid Bond End Date" > TODAY THEN
                    "Bond Status" := "Bond Status"::Active;
                IF "Bid Bond End Date" = TODAY THEN
                    "Bond Status" := "Bond Status"::Active;
            end;
        }
        field(27; "Bond Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = '" ,Active,Inactive"';
            OptionMembers = " ",Active,Inactive;
        }
        field(28; "Response Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Reference No", "Vendor Name")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Vendor: Record "Vendor";
}
