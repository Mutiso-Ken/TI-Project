#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
table 66092 "Mandatory Requirements"
{
    // version Procurement Iansoft


    fields
    {
        field(1; "Reference No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Requirement Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Tender Mandatory Requirements"."Mandatory Code";

            trigger OnValidate();
            begin
                IF TenderMandatoryRequirements.GET("Requirement Code") THEN BEGIN
                    "Requirement Description" := TenderMandatoryRequirements."Requirement Description";
                END;
            end;
        }
        field(3; "Requirement Description"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Reference No", "Requirement Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        IF ProcurementRequest.GET("Reference No") THEN BEGIN
            ProcurementRequest.TESTFIELD("Tender Status", ProcurementRequest."Tender Status"::New);
        END;
    end;

    var
        ProcurementRequest: Record "Procurement Request";
        TenderMandatoryRequirements: Record "Tender Mandatory Requirements";
}
