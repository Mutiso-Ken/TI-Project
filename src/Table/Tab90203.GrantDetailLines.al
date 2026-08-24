table 90203 "Grant Detail Lines"
{
    DrillDownPageID = "Grant Detail Lines";
    LookupPageID = "Grant Detail Lines";

    fields
    {
        field(1; "Grant Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'G/L Account';
            OptionMembers = "G/L Account";
        }
        field(4; "Entry No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(5; "Activity Description"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Proposed Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Proposed End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin

                "Total Cost" := "Unit Cost" * Quantity * Frequency;
            end;
        }
        field(9; "Unit Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 5 : 5;

            trigger OnValidate();
            begin
                "Total Cost" := "Unit Cost" * Quantity * Frequency;

            end;
        }
        field(10; "Total Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; Frequency; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                "Total Cost" := "Unit Cost" * Quantity * Frequency;
            end;
        }
        field(12; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; "Target Description"; Text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Target Indicator"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Achieved Target Description"; Text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Achieved Target Number"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; Output; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionMembers = OUTPUT;

            trigger OnLookup();
            begin
                TESTFIELD("Entry No.");
                TESTFIELD("Activity Description");
                TESTFIELD("Proposed Start Date");
                TESTFIELD("Proposed End Date");
                TESTFIELD("Target Description");
                TESTFIELD("Target Indicator");
            end;
        }
        field(18; "Line Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Objective,Outcome,Output,Activity';
            OptionMembers = Objective,Outcome,Output,Activity;
        }
        field(19; "G/L Account No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No." WHERE("Account Type" = CONST(Posting));
        }
        field(20; "G/L Account Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(21; "Transfered To Budget"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(22; "Amount Transfered"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(23; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = filter(false));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(24; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = filter(false));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(25; "Dimension Set ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(26; "External Partner Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(27; Expenditure; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Entry".Amount WHERE("Grant Code" = FIELD("Grant Code"),
                                                        "G/L Account No." = FIELD("G/L Account No"),
                                                        "Activity Code" = FIELD(Code),
                                                        "Partner Code" = FIELD("External Partner Code"),
                                                        Reversed = filter(false)));
            Editable = false;

        }
        field(28; IsTransferred; Boolean)
        {
        }
        field(30; "Partner Code"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          Blocked = filter(false));
        }
    }

    keys
    {
        key(Key1; "Grant Code", "Line Type", "Code", "Line No.", "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD("Grant Admin", TRUE);
    end;

    trigger OnInsert();
    begin
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD("Grant Admin", TRUE);
    end;

    trigger OnModify();
    begin
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD("Grant Admin", TRUE);
    end;

    trigger OnRename();
    begin
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD("Grant Admin", TRUE);
    end;

    var
        DimMgt: Codeunit "DimensionManagement";
        UserSetup: Record "User Setup";


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;


    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;


    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20]);
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;
}
