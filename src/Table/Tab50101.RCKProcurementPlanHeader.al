#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
table 50101 "RCK Procurement Plan Header"
{
    Caption = 'Procurement Plan Header';
    DataCaptionFields = "No.";
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Created DateTime"; DateTime)
        {
            Caption = 'Created DateTime';
        }
        field(3; "Sub-Office Code"; Code[50])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                Dimensionvalues.Reset();
                Dimensionvalues.SetRange(Code, "Sub-Office Code");
                if Dimensionvalues.FindSet() then begin
                    "Sub-Office Name" := Dimensionvalues.Name
                end;
            end;
        }
        field(4; "Sub-Office Name"; Text[50])
        {
            Editable = false;
        }
        field(5; "Donor Code"; Code[50])
        {
            Caption = 'Donor Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                Dimensionvalues.Reset();
                Dimensionvalues.SetRange("Global Dimension No.", 1);
                Dimensionvalues.SetRange(Code, "Donor Code");
                if Dimensionvalues.FindSet() then begin
                    "Donor Name" := Dimensionvalues.Name
                end;
            end;
        }
        field(6; "Donor Name"; Text[50])
        {
            Caption = 'Donor Name';
            Editable = false;
        }
        field(7; "Grant Code"; Code[50])
        {
            Caption = 'Grant Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                Dimensionvalues.Reset();
                Dimensionvalues.SetRange("Global Dimension No.", 1);
                Dimensionvalues.SetRange(Code, "Grant Code");
                if Dimensionvalues.FindSet() then begin
                    "Grant Name" := Dimensionvalues.Name
                end;
            end;
        }
        field(8; "Grant Name"; Text[50])
        {
            Caption = 'Grant Name';
            Editable = false;
        }
        field(9; "Start Date"; Date)
        {
            Caption = 'Start Date';

            trigger OnValidate()
            begin
                AccountingPeriod.Reset();
                AccountingPeriod.SetRange(Closed, true);
                if AccountingPeriod.FindLast() then begin
                    if "Start Date" < AccountingPeriod."Starting Date" then begin
                        Error('The date is already closed');
                    end;
                end;
            end;
        }
        field(10; "End Date"; Date)
        {
            Caption = 'End Date';
        }
        field(11; "Total Plan Amount"; Decimal)
        {
            Caption = 'Total Plan Amount';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("The Procurement Plan".Total where("Plan No." = field("No.")));
        }
        field(12; "Status"; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Pending,Approved';
            OptionMembers = Open,Pending,Approved;
        }
        field(13; "Approval Step SN"; Integer)
        {
            Caption = 'Approval Step SN';
        }
        field(14; "Period"; Code[250])
        {
            Caption = 'Period';
            TableRelation = "Procurement Years"."FY Code";
        }
        field(15; "Posted"; Boolean)
        {
            Caption = 'Posted';
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
    }

    trigger OnInsert()
    begin
        "Created DateTime" := CurrentDateTime;
        ProcurementSetup.Reset();
        ProcurementSetup.Get();
        ProcurementSetup.TestField("Procurement Plan  Nos");
        "No." := NoSeriesMgt.GetNextNo(ProcurementSetup."Procurement Plan  Nos", 0D, true);
        Validate("No.");
    end;

    var
        Dimensionvalues: Record "Dimension Value";
        Employee: Record Employee;
        ProcurementSetup: Record "Procurement Setup";
        NoSeriesMgt: Codeunit "No. Series";
        AccountingPeriod: Record "Accounting Period";
}
