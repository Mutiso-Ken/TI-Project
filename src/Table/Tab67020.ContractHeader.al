#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
table 67020 "Contract Header"
{

    DrillDownPageID = "Signed Contract List";
    LookupPageID = "Signed Contract List";

    fields
    {
        field(1; "No."; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Requisition No"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Vendor No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Tender No."; Code[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                IF ProcurementRequest.GET("Tender No.") THEN BEGIN
                    "Tender Title" := ProcurementRequest.Title;
                    ProcurementRequest.CALCFIELDS("Total Amount");
                    "Tender Amount" := ProcurementRequest."Total Amount"
                END;
            end;
        }
        field(5; "Tender Title"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Agreement Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Contract Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Contract period"; DateFormula)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                IF FORMAT("Contract period") <> '' THEN
                    "Contract End Date" := CALCDATE("Contract period", "Contract Start Date");
            end;
        }
        field(9; "Contract End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Tender Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Contract Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'New,Signed';
            OptionMembers = New,Signed;
        }
        field(12; "Contract Signing Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(13; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(14; "Contract Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Extended By"; DateFormula)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                IF FORMAT("Extended By") <> '' THEN BEGIN
                    Status := Status::New;
                    "original expiry period" := Rec."New Expiry Date";
                    "Original extension period" := Rec."Extended By";
                    "Original Date of Extension" := Rec."Date of Extension";
                    "New Expiry Date" := CALCDATE("Extended By", "Contract End Date");
                    "No. Of Extension" += 1;
                    "Date of Extension" := TODAY;
                    "Contract Extended" := TRUE;
                END;
            end;
        }
        field(16; "New Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Contract Extended"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Date of Extension"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "No. Of Extension"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Original extension period"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "original expiry period"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Original Date of Extension"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Total Milestone Amount"; Decimal)
        {
            CalcFormula = Sum("Contract Milestone".Amount WHERE("Contract No" = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(24; "Approval Entries"; Integer)
        {
            CalcFormula = Count("Approval Entry" WHERE("Document No." = FIELD("No.")));
            FieldClass = FlowField;
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

    var
        ProcurementRequest: Record "Procurement Request";
}
