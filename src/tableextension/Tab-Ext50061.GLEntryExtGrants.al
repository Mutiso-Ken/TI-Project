tableextension 50061 "G/L Entry Ext Grants" extends "G/L Entry"
{
    fields
    {
        field(80004; "Grant Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Grant Header"."No.";
        }
        field(80005; "Objective Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Grant Lines".Code WHERE("Grant No" = FIELD("Grant Code"),
                                                      "Line Type" = CONST(Objective));
        }
        field(80006; "Outcome Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Grant Lines".Code WHERE("Grant No" = FIELD("Grant Code"),
                                                      "Line Type" = CONST(Outcome));
        }
        field(80007; "Output Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Grant Lines".Code WHERE("Grant No" = FIELD("Grant Code"),
                                                      "Line Type" = CONST(Output));
        }
        field(80008; "Activity Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Grant Lines".Code WHERE("Grant No" = FIELD("Grant Code"),
                                                      "Line Type" = CONST(Activity));
        }
        field(80009; "Partner Code"; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup();
            var
                GrantDetailLines: Record "Grant Detail Lines";
            begin
            end;
        }
        field(80010; "Account Category"; Option)
        {
            BlankZero = true;
            CalcFormula = Lookup("G/L Account"."Account Category" WHERE("No." = FIELD("G/L Account No.")));
            Caption = 'Account Category';
            FieldClass = FlowField;
            OptionCaption = '" ,Assets,Liabilities,Equity,Income,Cost of Goods Sold,Expense"';
            OptionMembers = " ",Assets,Liabilities,Equity,Income,"Cost of Goods Sold",Expense;
        }
        field(8006; "Budget Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key11Grants; "Grant Code", "Objective Code", "Activity Code", "Partner Code", "Output Code", "Outcome Code")
        {
        }
    }
}
