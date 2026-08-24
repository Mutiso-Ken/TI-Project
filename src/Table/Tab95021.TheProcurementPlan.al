#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
table 95021 "The Procurement Plan"
{
    DataCaptionFields = "No.";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
        }

        field(5; "Grant Code"; Code[20])
        {
            Caption = 'Grant Code';
            DataClassification = ToBeClassified;
        }

        field(6; "Grant Name"; Text[1000])
        {
            Caption = 'Grant Name';
        }

        field(7; "Description of service/Goods"; Text[2000])
        {
            Caption = 'Description of service/Goods';
        }

        field(8; "Lead Logistics Officer Code"; Text[50])
        {
            Caption = 'Lead Logistics Officer Code';
            TableRelation = "User Setup"."User ID" where("Lead Logistics Officer" = const(true));

            trigger OnValidate()
            begin
                UserSetup.Reset();
                if UserSetup.Get("Lead Logistics Officer Code") then begin
                    "Full Name" := UserSetup."Full Name";
                end;
            end;
        }

        field(9; "Currency Code"; Code[20])
        {
            Caption = 'Currency Code';
            TableRelation = Currency.Code;
        }

        field(10; "End Date"; Date)
        {
            Caption = 'End Date';
        }

        field(12; "Quantity"; Integer)
        {
            Caption = 'Quantity';

            trigger OnValidate()
            begin
                Total := Quantity * "Unit Cost" * "Frequency";
            end;
        }
        field(13; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            trigger OnValidate()
            begin
                Total := Quantity * "Unit Cost" * "Frequency";
            end;
        }

        field(14; "Frequency"; Integer)
        {
            Caption = 'Frequency';

            trigger OnValidate()
            begin
                Total := Quantity * "Unit Cost" * "Frequency";
            end;
        }

        field(15; Total; Decimal)
        {
            Caption = 'Total';
            Editable = false;
        }

        field(16; "Committed"; Decimal)
        {
            Caption = 'Committed';
        }

        field(17; "Spent"; Decimal)
        {
            Caption = 'Spent';
        }

        field(18; "Remaining Amount"; Decimal)
        {
            Caption = 'Remaining Amount';
        }
        field(19; "Full Name"; Text[100])
        {
            Caption = 'Full Name';
            Editable = false;
        }
        field(20; "Pillar Code"; Code[30])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate();
            begin
                Dimensionvalues.Reset();
                Dimensionvalues.SetRange("Global Dimension No.", 2);
                Dimensionvalues.SetRange(Code, "Pillar Code");
                if Dimensionvalues.FindSet() then begin
                    "Pillar Name" := Dimensionvalues.Name
                end;
            end;
        }
        field(21; "Pillar Name"; Text[100])
        {
            Editable = false;
        }
        field(22; "Year"; Code[250])
        {
        }
        field(23; "Quarter"; Text[1000])
        {
        }
        field(24; "Plan No."; Code[20])
        {
            TableRelation = "RCK Procurement Plan Header"."No.";
        }
        field(25; "Partner Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('PARTNER'));
            trigger OnValidate()
            begin
                Dimensionvalues.Reset();
                Dimensionvalues.SetRange(Code, "Partner Code");
                if Dimensionvalues.FindFirst() then begin
                    "Partner Name" := Dimensionvalues.Description;
                end;
            end;
        }

        field(26; "Partner Name"; Text[1000])
        {
            Editable = false;
        }
        field(27; "Activity Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('ACTIVITY'));
            trigger OnValidate()
            begin
                Dimensionvalues.Reset();
                Dimensionvalues.SetRange(Code, "Activity Code");
                if Dimensionvalues.FindFirst() then begin
                    "Activity Name" := Dimensionvalues.Description;
                end;
            end;
        }

        field(28; "Activity Name"; Text[1000])
        {
            Editable = false;
        }
        field(29; "Sub-office code"; Code[250])
        {
        }
        field(40; "Period"; Code[250])
        {
            Caption = 'Period';
            TableRelation = "Procurement Years"."FY Code";
        }
        field(41; Actuals; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line"."Line Amount" where("Activity Code" = field("Activity Code")));
        }
        field(42; "G/L Account No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No." WHERE("Account Type" = CONST(Posting));
        }
        field(43; "G/L Account Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Description of service/Goods", "Pillar Name", "Grant Code", "Activity Code", "Partner Code", Quantity, "Unit Cost", Total)
        {
        }
    }

    trigger OnDelete();
    begin
    end;

    trigger OnInsert();
    begin
    end;

    var
        Dimensionvalues: Record "Dimension Value";
        UserSetup: Record "User Setup";
        grantheader: Record "Grant Header";
}
