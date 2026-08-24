#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
table 66093 "Technical Specifications"
{
    // version Procurement Iansoft


    fields
    {
        field(1; "Reference No."; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Requirement Code"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Requirement Specification"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Max Weigth"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                IF "Max Weigth" = 0 THEN
                    EXIT;
                IF ProcurementRequest.GET("Reference No.") THEN BEGIN
                    ProcurementRequest.TESTFIELD("Tender Max Score");
                END;
            end;
        }
    }

    keys
    {
        key(Key1; "Reference No.", "Requirement Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        IF ProcurementRequest.GET("Reference No.") THEN BEGIN
            ProcurementRequest.TESTFIELD("Tender Status", ProcurementRequest."Tender Status"::New);
        END;
    end;

    var
        ProcurementRequest: Record "Procurement Request";
}
