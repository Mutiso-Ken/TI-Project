#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
table 50104 "Procurement Years"
{
    Caption = 'Procurement Years';
    DataCaptionFields = "FY Code";
    DrillDownPageID = "Procurement Years";
    LookupPageID = "Procurement Years";
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "FY Code"; Code[20])
        {
            Caption = 'FY Code';
            NotBlank = true;
        }
        field(2; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(3; "End Date"; Date)
        {
            Caption = 'End Date';
        }
        field(4; "Current Year"; Boolean)
        {
            Caption = 'Current Year';
        }
    }

    keys
    {
        key(Key1; "FY Code")
        {
        }
    }

    fieldgroups
    {
    }
}
