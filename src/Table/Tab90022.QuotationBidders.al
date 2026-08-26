table 90022 "Quotation Bidders"
{
    fields
    {
        field(1; "Reference No"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Vendor No."; Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No.";// where ("Supplier Category" = vend);

            trigger OnValidate();
            begin
                IF Vendor.GET("Vendor No.") THEN BEGIN
                    // Vendor.TESTFIELD("PIN No.");
                    "Vendor Name" := Vendor.Name;
                    "E-mail Address" := Vendor."E-Mail";
                    "Phone No" := Vendor."Phone No.";
                END ELSE BEGIN
                    "Vendor Name" := '';
                    "E-mail Address" := '';
                    "Phone No" := '';
                END;
            end;
        }
        field(3; "Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "E-mail Address"; Text[70])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Phone No"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Vendor Category"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Total Quoted Amount"; Decimal)
        {
            CalcFormula = Sum("Quotation Vendors Bids"."Quoted Amount" WHERE("Vendor No" = FIELD("Vendor No."),
                                                                              "Quote No" = FIELD("Reference No")));
            FieldClass = FlowField;
        }
        field(8; "Email Sent"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Requisition No."; Code[20])
        {
            CalcFormula = Lookup("Procurement Request"."Requisiton No" WHERE("No." = FIELD("Reference No")));
            FieldClass = FlowField;
        }
        field(10; "Award Vendor"; Boolean)
        {
            trigger OnValidate()
            var
                QuotationBidders: Record "Quotation Bidders";
                QuotationBidders2: Record "Quotation Bidders";
            begin
                QuotationBidders.Reset();
                QuotationBidders.SetRange("Reference No", "Reference No");
                QuotationBidders.SetRange("Award Vendor", true);
                if QuotationBidders.FindFirst() then
                    if Confirm('Quotation No. %1 has already been awarded to vendor %2. Do you wish to replace the award?', false, "Reference No", QuotationBidders."Vendor Name") = true then begin
                        QuotationBidders."Award Vendor" := false;
                        QuotationBidders.Modify();
                        Commit();
                        QuotationBidders2.Reset();
                        QuotationBidders2.SetRange("Reference No", "Reference No");
                        QuotationBidders2.SetRange("Vendor No.", "Vendor No.");
                        if QuotationBidders2.Find('-') then
                            QuotationBidders2."Award Vendor" := true;
                        QuotationBidders2.Modify;
                    end else
                        exit;
            end;

        }
    }

    keys
    {
        key(Key1; "Reference No", "Vendor No.", "Vendor Category")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Vendor: Record "Vendor";
}

