table 90201 "Grant Lines"
{
    DataCaptionFields = "Grant No", "Code", Description, "Line Type", "Proposed Start Date";
    DrillDownPageID = "Grant Lines Lookup";
    LookupPageID = "Grant Lines Lookup";

    fields
    {
        field(1; "Grant No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Line Type"; Option)
        {
            Caption = 'Line Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'Objective,Outcome,Output,Activity';
            OptionMembers = Objective,Outcome,Output,Activity;

            trigger OnValidate();
            begin
            end;
        }
        field(5; "Proposed Start Date"; Date)
        {
            CalcFormula = Max("Grant Detail Lines"."Proposed Start Date" WHERE("Grant Code" = FIELD("Grant No"),
                                                                                Code = FIELD(Code),
                                                                                Code = FIELD(FILTER(Totaling))));
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup();
            begin
            end;
        }
        field(6; "Proposed End Date"; Date)
        {
            CalcFormula = Min("Grant Detail Lines"."Proposed Start Date" WHERE("Grant Code" = FIELD("Grant No"),
                                                                                Code = FIELD(Code),
                                                                                Code = FIELD(FILTER(Totaling))));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Total Budget"; Decimal)
        {
            CalcFormula = Sum("Grant Detail Lines"."Total Cost" WHERE("Grant Code" = FIELD("Grant No"),
                                                                       Code = FIELD(Code),
                                                                       Code = FIELD(FILTER(Totaling))));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Input Link"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Objective,Activity';
            OptionMembers = Objective,Activity;

            trigger OnLookup();
            begin
            end;
        }
        field(9; "Line No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(10; "External Partner Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(11; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; Budgeted; Boolean)
        {
            CalcFormula = Exist("Grant Detail Lines" WHERE("Grant Code" = FIELD("Grant No"),
                                                            "Line Type" = FIELD("Line Type"),
                                                            "Line No." = FIELD("Line No"),
                                                            Code = FIELD(Code),
                                                            Code = FIELD(FILTER(Totaling))));
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; Totaling; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(15; "Objective Total"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Posting Date" = FIELD("Date Filter"),
                                                        "Grant Code" = FIELD("Grant No"),
                                                        "Objective Code" = FIELD(Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Outcome Total"; Decimal)
        {

            FieldClass = FlowField;
            CalcFormula = Sum("G/L Entry".Amount WHERE("Outcome Code" = FIELD(Code),
                                                        "Posting Date" = FIELD("Date Filter"),
                                                        "Grant Code" = FIELD("Grant No")));
            Editable = false;
        }
        field(17; "Output Total"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Output Code" = FIELD(Code),
                                                        "Posting Date" = FIELD("Date Filter"),
                                                        "Grant Code" = FIELD("Grant No")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Activity Total"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Shortcut Dimension 4 Code" = FIELD("Shortcut Dimension 4 Code"),
                                                        "Posting Date" = FIELD("Date Filter"),
                                                        "Global Dimension 1 Code" = FIELD("Shortcut Dimension 1 Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "Shortcut Dimension 1 Code"; Code[20])
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
        field(20; "Shortcut Dimension 2 Code"; Code[20])
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
        field(21; "Dimension Set ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(22; "Target Description"; Text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Target Indicator"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Achieved Target Description"; Text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Achieved Target Number"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Transfered"; Boolean)
        {

        }
        field(27; "Shortcut Dimension 4 Code"; Code[20])
        {

            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = filter(false), Grant = field("Grant No"));



        }
    }

    keys
    {
        key(Key1; "Grant No", "Code", "Line Type", "Line No")
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
        CALCFIELDS("Total Budget");
        TESTFIELD("Total Budget", 0);
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
