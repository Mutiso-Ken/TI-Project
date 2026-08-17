namespace TISolution.TISolution;

using Microsoft.Purchases.Vendor;

tableextension 2 VendorExt extends Vendor
{
    fields
    {
        field(80023; "Reg Status"; Option)
        {
            Caption = 'Status';
            OptionMembers = New,"In Review",Approved,Rejected;
        }
        field(70006; "PIN No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(70007; "Certificate of Incorporation"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(70001; "Supplier Category"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Supplier Category"."Category Code";

            trigger OnValidate();
            begin
                IF SupplierCategory.GET("Supplier Category") THEN BEGIN

                    "Category of Service" := SupplierCategory.Description;
                END ELSE
                    IF "Supplier Category" = '' THEN BEGIN
                        "Category of Service" := '';
                    END;
            end;
        }
        field(70002; "Category of Service"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(80019; "Secondary Supplier Category 1"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Supplier Category"."Category Code";

            trigger OnValidate();
            begin
                IF SupplierCategory.GET("Secondary Supplier Category 1") THEN BEGIN
                    "Secondary Category of Service1" := SupplierCategory.Description;
                END ELSE
                    IF "Secondary Supplier Category 1" = '' THEN BEGIN
                        "Secondary Category of Service1" := '';
                    END;
            end;
        }

        field(80021; "Secondary Supplier Category 2"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Supplier Category"."Category Code";

            trigger OnValidate();
            begin
                IF SupplierCategory.GET("Secondary Supplier Category 2") THEN BEGIN
                    "Secondary Category of Service2" := SupplierCategory.Description;
                END ELSE
                    IF "Secondary Supplier Category 2" = '' THEN BEGIN
                        "Secondary Category of Service2" := '';
                    END;
            end;
        }
        field(80020; "Secondary Category of Service1"; Text[2001])
        {
            DataClassification = ToBeClassified;
        }
        field(80022; "Secondary Category of Service2"; Text[2001])
        {
            DataClassification = ToBeClassified;
        }
    }
    var
        SupplierCategory: Record "Supplier Category";
}
