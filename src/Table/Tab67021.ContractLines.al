#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
table 67021 "Contract Lines"
{
    // Adapted from RCK: the legacy "Requisition Header" table and "Proc & Store
    // Management" codeunit do not exist here (this app already replaced Requisition
    // Header/Lines with Purchase Header/Line, and Cod50004 was rewritten as
    // "Procurement Process Mgmt."). The "No." OnValidate trigger below computes the
    // planned/requisitioned quantities directly against "Procurement Plan Lines" and
    // "Purchase Line" instead of calling into the retired legacy codeunit.

    fields
    {
        field(1; "Contract No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'G/L Account,Fixed Asset,Item';
            OptionMembers = "G/L Account","Fixed Asset",Item;
        }
        field(3; No; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            var
                ProcurementPlanLine: Record "Procurement Plan Lines";
                PurchLine: Record "Purchase Line";
            begin
                IF ContractHeader.GET("Contract No.") THEN BEGIN
                    ProcurementPlanLine.RESET;
                    ProcurementPlanLine.SETRANGE("Global Dimension 2 Code", "Global Dimension 1 Code");
                    ProcurementPlanLine.SETRANGE(Type, Type);
                    ProcurementPlanLine.SETRANGE(No, No);
                    ProcurementPlanLine.SETRANGE("Plan No.", "Plan No.");
                    IF ProcurementPlanLine.FINDSET THEN BEGIN
                        ProcurementPlanLine.CALCSUMS(Quantity, "Total Amount");
                        "Planned Quantity" := ProcurementPlanLine.Quantity;
                        "Planned Amount" := ProcurementPlanLine."Total Amount";
                    END;

                    PurchLine.RESET;
                    PurchLine.SETRANGE("Shortcut Dimension 1 Code", "Global Dimension 1 Code");
                    PurchLine.SETRANGE(Type, Type);
                    PurchLine.SETRANGE("No.", No);
                    PurchLine.SETRANGE("Procurement Plan", "Plan No.");
                    IF PurchLine.FINDSET THEN BEGIN
                        PurchLine.CALCSUMS(Quantity, "Total Amount");
                        "Requisitioned Quantity" := PurchLine.Quantity;
                        "Used Amount" := PurchLine."Total Amount";
                    END;

                    "Available Quantity" := "Planned Quantity" - "Requisitioned Quantity";
                    "Available Amount" := "Planned Amount" - "Used Amount";
                END;
            end;
        }
        field(4; Name; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6; Quantity; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                "Total Amount" := Quantity * "Unit Price";
                VALIDATE("Total Amount");
            end;
        }
        field(7; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                "Total Amount" := Quantity * "Unit Price";
                VALIDATE("Total Amount");
            end;
        }
        field(8; "Total Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                IF "Total Amount" > "Available Amount" THEN
                    UnPlanned := TRUE
                ELSE
                    UnPlanned := FALSE;
            end;
        }
        field(9; "Unit of Measure"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure".Code;
        }
        field(10; "Plan No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Planned Quantity"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Requisitioned Quantity"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Planned Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Used Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; UnPlanned; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Available Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Available Quantity"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(18; Location; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location.Code;
        }
        field(19; Approved; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Global Dimension 1 Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Global Dimension 2 Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Line No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(70001; "Car Repair/Maintenance"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70002; "Vehicle Reg. No"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Asset"."No.";
        }
    }

    keys
    {
        key(Key1; "Contract No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        IF ContractHeader.GET("Contract No.") THEN BEGIN
            "Plan No." := ContractHeader."Requisition No";
        END;
    end;

    var
        ContractHeader: Record "Contract Header";
}
