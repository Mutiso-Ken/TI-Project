table 51095 "Partner Implem. Activitie"
{

    fields
    {
        field(1; EntryNo; Integer)
        {
            AutoIncrement = true;
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
        field(4; "From Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "To Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                Duration := "To Date" - "From Date";
            end;
        }
        field(6; Resposibility; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Duration; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(8; Partner; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
        }
        field(9; RFA; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = RFA.No;
        }
        field(10; Activity; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "RFA Activities"."Activity Code" WHERE("RFA Code" = FIELD(RFA));
        }
        field(11; Budget; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Activity Name"; Text[250])
        {
            CalcFormula = Lookup("RFA Activities"."Activity Description" WHERE("Activity Code" = FIELD(Activity)));
            FieldClass = FlowField;
        }
        field(13; "Partner Name"; Text[250])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD(Partner)));
            FieldClass = FlowField;
        }
        field(14; "Total Budget Amount"; Decimal)
        {
            CalcFormula = Sum("Partner Implem. Activitie".Budget WHERE(Partner = FIELD(Partner),
                                                                        RFA = FIELD(RFA)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; EntryNo, Partner, RFA)
        {
        }
        key(Key2; Budget)
        {
        }
    }

    fieldgroups
    {
    }
}
