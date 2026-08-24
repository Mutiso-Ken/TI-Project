table 67035 "RFQ Committee Evaluation"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "RFQ No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Quoted Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Committee Member ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID";
        }
        field(6; "Committee Member No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "Committee Member Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; Award; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                RFQCommitteeEvaluation: Record "RFQ Committee Evaluation";
            begin
                if Award then begin
                    RFQCommitteeEvaluation.Reset();
                    RFQCommitteeEvaluation.SetRange("RFQ No.", "RFQ No.");
                    RFQCommitteeEvaluation.SetRange("Proc. Line No.", "Proc. Line No.");
                    RFQCommitteeEvaluation.SetRange("Committee Member No", "Committee Member No");
                    RFQCommitteeEvaluation.SetRange(Award, true);
                    if RFQCommitteeEvaluation.FindFirst() then
                        Error('You have already picked a vendor, un-select the vendor to pick a different one.');
                end;
            end;
        }
        field(9; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; Remarks; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(11; No; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(12; Description; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; "Unit Price"; Decimal)
        {
            CalcFormula = lookup("Quotation Vendors Bids"."Unit Price" where("Quote No" = field("RFQ No."), "Vendor No" = field("Vendor No.")));
            FieldClass = FlowField;
        }
        field(14; "Proc. Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Description 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "RFQ No.", "Line No.")
        {
        }
    }
}
