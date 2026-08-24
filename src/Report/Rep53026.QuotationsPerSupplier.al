report 53026 "Quotations Per Supplier"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Quotations Per Supplier.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Procurement Request"; "Procurement Request")
        {
            DataItemTableView = WHERE("Procurement Method" = CONST(RFQ));
            PrintOnlyIfDetail = true;
            column(TotalAmount_ProcurementRequest; "Procurement Request"."Total Amount")
            {
            }
            column(No_ProcurementRequest; "Procurement Request"."No.")
            {
            }
            column(RequisitonNo_ProcurementRequest; "Procurement Request"."Requisiton No")
            {
            }
            column(SupplierCategory_ProcurementRequest; "Procurement Request"."Supplier Category")
            {
            }
            dataitem("Procurement Request Lines"; "Procurement Request Lines")
            {
                DataItemLink = "Procurement No" = FIELD("No.");
                RequestFilterFields = "Vendor To Award";
                column(CompanyName; CompanyInformation.Name)
                {
                }
                column(CompanyPicture; CompanyInformation.Picture)
                {
                }
                column(CompanyAddress; CompanyInformation.Address)
                {
                }
                column(CompanyPhone; CompanyInformation."Phone No.")
                {
                }
                column(CompanyLocation; CompanyInformation."Location Code")
                {
                }
                column(CompanyEmail; CompanyInformation."E-Mail")
                {
                }
                column(CompanyWebsite; CompanyInformation."Home Page")
                {
                }
                column(CompanyPostCode; CompanyInformation."Post Code")
                {
                }
                column(Vendor_Name; VendorName)
                {
                }
                column(CarRepairMaintenance_ProcurementRequestLines; "Procurement Request Lines"."Car Repair/Maintenance")
                {
                }
                column(VendorToAward_ProcurementRequestLines; "Procurement Request Lines"."Vendor To Award")
                {
                }
                column(TotalAmount_ProcurementRequestLines; "Procurement Request Lines"."Total Amount")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    IF Vendor.GET("Procurement Request Lines"."Vendor To Award") THEN
                        VendorName := Vendor.Name;
                end;

                trigger OnPreDataItem();
                begin
                    CompanyInformation.GET;
                    CompanyInformation.CALCFIELDS(Picture);
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        CompanyInformation: Record "Company Information";
        Vendor: Record "Vendor";
        VendorName: Text;
}

