#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80025 LPO
{
    WordLayout = 'Layouts/LPO.docx';
    DefaultLayout = Word;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = sorting("No.", "Document Type") where("Document Type" = filter(Order));
            RequestFilterFields = "No.", "Document Type";

            column(Purchase_Header_No_; "Purchase Header"."No.")
            {
            }
            column(OrderDate_PurchaseHeader; "Purchase Header"."Order Date")
            {
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                column(CompanyInfo_Picture; CompanyInfo.Picture)
                {
                }
                column(CompanyInfo__Country_Region_Code_; CompanyInfo."Country/Region Code")
                {
                }
                column(CompanyInfo_City; CompanyInfo.City)
                {
                }
                column(CompanyInfo__Address_2_; CompanyInfo."Address 2")
                {
                }
                column(CompanyInfo_Address; CompanyInfo.Address)
                {
                }
                column(CompanyInfo_Name; CompanyInfo.Name)
                {
                }
                column(CompanyInfo__Phone_No__; CompanyInfo."Phone No.")
                {
                }
                column(CompanyInfo__Fax_No__; CompanyInfo."Fax No.")
                {
                }
                column(CompanyInfo__E_Mail_; CompanyInfo."E-Mail")
                {
                }
                column(CompanyInfo__Home_Page_; CompanyInfo."Home Page")
                {
                }
                column(Purchase_Header___Buy_from_Vendor_Name_; "Purchase Header"."Buy-from Vendor Name")
                {
                }
                column(VendorAddr; VendorAddr)
                {
                }
                column(VendorCity; VendorCity)
                {
                }
                column(VendorPostCod; VendorPostCod)
                {
                }
                column(Purchase_Line_Quantity; "Purchase Line".Quantity)
                {
                }
                column(Description2_PurchaseLine; "Purchase Line"."Description 2")
                {
                }
                column(Purchase_Line__Unit_Cost_; "Purchase Line"."Unit Cost")
                {
                }
                column(Purchase_Line_Amount; "Purchase Line".Amount)
                {
                }
                column(Purchase_Header___Created_By_; "Purchase Header"."User ID")
                {
                }
                column(Tel_Caption; Tel_CaptionLbl)
                {
                }
                column(Fax_Caption; Fax_CaptionLbl)
                {
                }
                column(Email_Caption; Email_CaptionLbl)
                {
                }
                column(Web_Caption; Web_CaptionLbl)
                {
                }
                column(Unit_CostCaption; Unit_CostCaptionLbl)
                {
                }
                column(Total_Unit_CostCaption; Total_Unit_CostCaptionLbl)
                {
                }
                column(DescriptionCaption; DescriptionCaptionLbl)
                {
                }
                column(TotalCaption; TotalCaptionLbl)
                {
                }
                column(TERMS_AND_CONDITIONSCaption; TERMS_AND_CONDITIONSCaptionLbl)
                {
                }
                column(V1__This_LPO_is_valid_for_30_daysCaption; V1__This_LPO_is_valid_for_30_daysCaptionLbl)
                {
                }
                column(V3__TI_Kenya_reserves_the_right_to_return_all_the_goods_which_may_be_found_defective_during_consumptionCaption; V3__TI_Kenya_reserves_the_right_to_return_all_the_goods_which_may_be_found_defective_during_consumptionCaptionLbl)
                {
                }
                column(V2__All_the_goods_services_supplied_MUST_be_as_per_order_and_MUST_meet_all_the_specified_conditionsCaption; V2__All_the_goods_services_supplied_MUST_be_as_per_order_and_MUST_meet_all_the_specified_conditionsCaptionLbl)
                {
                }
                column(V5__All_payment_will_be_by_crossed_cheques_issued_by_TI_Kenya_and_in_line_with_stated_terms_Caption; V5__All_payment_will_be_by_crossed_cheques_issued_by_TI_Kenya_and_in_line_with_stated_terms_CaptionLbl)
                {
                }
                column(V4__Goods_services_are_received_subject_to_verification_in_due_courseCaption; V4__Goods_services_are_received_subject_to_verification_in_due_courseCaptionLbl)
                {
                }
                column(where_such_conditions_could_not_be_verified_or_established_during_receipt_of_the_goods_Caption; where_such_conditions_could_not_be_verified_or_established_during_receipt_of_the_goods_CaptionLbl)
                {
                }
                column(V6__The_prices_on_the_LPO_include_delivery_costs_to_the_specified_delivery_receiving_pointCaption; V6__The_prices_on_the_LPO_include_delivery_costs_to_the_specified_delivery_receiving_pointCaptionLbl)
                {
                }
                column(Date_Caption; Date_CaptionLbl)
                {
                }
                column(Signature_Caption; Signature_CaptionLbl)
                {
                }
                column(V7__Payment_Terms__Payment_shall_be_made_30_days_after_the_invoice_dateCaption; V7__Payment_Terms__Payment_shall_be_made_30_days_after_the_invoice_dateCaptionLbl)
                {
                }
                column(FUND; "Purchase Line"."Shortcut Dimension 1 Code")
                {
                }
                trigger OnPreDataItem();
                begin
                    LastFieldNo := FieldNo("Document Type");

                end;

                trigger OnAfterGetRecord();
                begin
                    if VendorInfo.Get("Purchase Header"."Buy-from Vendor No.") then
                        VendorAddr := VendorInfo.Address;
                    VendorCity := VendorInfo.City;
                    VendorPostCod := VendorInfo."Post Code";
                    VendorTel := VendorInfo."Phone No.";
                end;

            }
            trigger OnPreDataItem();
            begin

            end;
        }
    }
    requestpage
    {
        SaveValues = false;
        layout
        {
        }

    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);

    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        VendorInfo: Record Vendor;
        CompanyInfo: Record "Company Information";
        VendorAddr: Text[30];
        VendorCity: Text[30];
        VendorPostCod: Code[10];
        VendorTel: Variant;
        BankAccount: Code[10];
        PurchLine: Record "Purchase Line";
        Tel_CaptionLbl: label 'Tel:';
        Fax_CaptionLbl: label 'Fax:';
        Email_CaptionLbl: label 'Email:';
        Web_CaptionLbl: label 'Web:';
        PURCHASE_ORDERCaptionLbl: label 'PURCHASE ORDER';
        Order_DateCaptionLbl: label 'Order Date';
        Order_No_CaptionLbl: label 'Order No.';
        SUPPLIER_CaptionLbl: label 'SUPPLIER:';
        QuantityCaptionLbl: label 'Quantity';
        Unit_CostCaptionLbl: label 'Unit Cost';
        Total_Unit_CostCaptionLbl: label 'Total Unit Cost';
        DescriptionCaptionLbl: label 'Description';
        TotalCaptionLbl: label 'Total';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        TERMS_AND_CONDITIONSCaptionLbl: label 'TERMS AND CONDITIONS';
        V1__This_LPO_is_valid_for_30_daysCaptionLbl: label '1. This LPO is valid for 30 days';
        V3__TI_Kenya_reserves_the_right_to_return_all_the_goods_which_may_be_found_defective_during_consumptionCaptionLbl: label '3. TI-Kenya reserves the right to return all the goods which may be found defective during consumption';
        V2__All_the_goods_services_supplied_MUST_be_as_per_order_and_MUST_meet_all_the_specified_conditionsCaptionLbl: label '2. All the goods/services supplied MUST be as per order and MUST meet all the specified conditions';
        V5__All_payment_will_be_by_crossed_cheques_issued_by_TI_Kenya_and_in_line_with_stated_terms_CaptionLbl: label '5. All payment will be by crossed cheques issued by TI-Kenya and in line with stated terms.';
        V4__Goods_services_are_received_subject_to_verification_in_due_courseCaptionLbl: label '4. Goods/services are received subject to verification in due course';
        where_such_conditions_could_not_be_verified_or_established_during_receipt_of_the_goods_CaptionLbl: label '   where such conditions could not be verified or established during receipt of the goods.';
        V6__The_prices_on_the_LPO_include_delivery_costs_to_the_specified_delivery_receiving_pointCaptionLbl: label '6. The prices on the LPO include delivery costs to the specified delivery/receiving point';
        Date_CaptionLbl: label 'Date:';
        Date_Caption_Control1000000025Lbl: label 'Date:';
        Date_Caption_Control1000000027Lbl: label 'Date:';
        Signature_CaptionLbl: label 'Signature:';
        Signature_Caption_Control1000000030Lbl: label 'Signature:';
        Signature_Caption_Control1000000031Lbl: label 'Signature:';
        EmptyStringCaptionLbl: label '__________________________';
        EmptyStringCaption_Control1000000034Lbl: label '__________________________';
        EmptyStringCaption_Control1000000035Lbl: label '__________________________';
        EmptyStringCaption_Control1000000037Lbl: label '__________________________';
        EmptyStringCaption_Control1000000038Lbl: label '__________________________';
        EmptyStringCaption_Control1000000039Lbl: label '__________________________';
        EmptyStringCaption_Control1000000040Lbl: label '__________________________';
        V7__Payment_Terms__Payment_shall_be_made_30_days_after_the_invoice_dateCaptionLbl: label '7. Payment Terms: Payment shall be made 30 days after the invoice date';
        Prepared_By_Finance_Officer__CaptionLbl: label 'Prepared By Finance Officer: ';
        Checked_By_Head_of_Finance__CaptionLbl: label 'Checked By Head of Finance: ';
        Authorised_By_Executive_Director_CaptionLbl: label 'Authorised By Executive Director:';

    trigger OnPreReport();
    begin

    end;

}