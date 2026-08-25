namespace TISolution.TISolution;
using Microsoft.Purchases.Vendor;

codeunit 4 ProcurementEntry
{
    trigger OnRun();
    begin
    end;

    var
        VendorTable: Record Vendor;
        "Procurement List": Record "Procurement Request";
        "Procurement Lines": record "Procurement Request Lines";
        VendorRegistrationDetailsTable: record "Vendor Registration Details";
        RFQVendorBids: record "Quotation Vendors Bids";
        VendorPersonnelTable: record "Vendor Personnel";
        VendorDirectorsTable: record "Vendor Company Directors";
        VendorClientsDetailsTable: record "Vendor Clients Details";
        SharePointTable: Record "SharePoint Intergration";
        Outputjson: JsonObject;
        JsonToken: JsonToken;

    procedure UpdateVendorEmails(): Text
    begin
        VendorRegistrationDetailsTable.Reset();
        if VendorRegistrationDetailsTable.Find('-') then
            repeat
                VendorTable.Reset();
                VendorTable.SetRange("No.", VendorRegistrationDetailsTable."Vendor ID");
                if VendorTable.Find('-') then begin
                    if VendorTable."E-Mail" = '' then begin
                        VendorTable."E-Mail" := VendorRegistrationDetailsTable."Email Address";
                        VendorTable.Modify();
                    end;
                end;
            until VendorRegistrationDetailsTable.Next() = 0;
    end;

    procedure SubmitNewInformation(args: Text): Text
    var
        RequestJson: JsonObject;

        SubmissionType: Text;
        ElementInformation: JsonObject;

        VendorID: Code[50];

    begin

        Clear(RequestJson);
        if not RequestJson.ReadFrom(args) then
            Error('Invalid JSON input');

        RequestJson.Get('submission_type', JsonToken);
        SubmissionType := JsonToken.AsValue().AsText();

        //Bid submission
        if (SubmissionType = 'vendor_bid_update') then begin
            RequestJson.Get('RFQLine', JsonToken);
            ElementInformation := JsonToken.AsObject();
            RequestJson.Get('vendor_id', JsonToken);
            exit(InsertRFQVendorBID(ElementInformation, JsonToken.AsValue().AsCode()));
        end;
        if (SubmissionType = 'vendor_bid_update_dpr') then begin
            RequestJson.Get('RFQLine', JsonToken);
            ElementInformation := JsonToken.AsObject();
            RequestJson.Get('vendor_id', JsonToken);
            exit(InsertDPRVendorBID(ElementInformation, JsonToken.AsValue().AsCode()));
        end;
        if (SubmissionType = 'vendor_bid_document_update') then begin
            RequestJson.Get('RFQFile', JsonToken);
            exit(UploadSubmissionFiles(JsonToken.AsObject()));
        end;
        //Leave Application
        if (SubmissionType = 'vendor_insertion') then begin
            RequestJson.Get('vendor_details', JsonToken);
            ElementInformation := JsonToken.AsObject();
            exit(InsertVendorDetails(ElementInformation));
        end;
        //Vendor Registration Details
        if (SubmissionType = 'vendor_registration') then begin
            RequestJson.Get('vendor_registration', JsonToken);
            ElementInformation := JsonToken.AsObject();
            exit(UpdateVendorRegistrationDetails(ElementInformation));
        end;
        //Vendor Document Uploads
        if (SubmissionType = 'vendor_document_upload') then begin
            RequestJson.Get('vendor_registration', JsonToken);
            ElementInformation := JsonToken.AsObject();
            exit(UpdateVendorDocumentUploads(ElementInformation));
        end;
        //Vendor Document Uploads
        if (SubmissionType = 'vendor_client_document_upload') then begin
            RequestJson.Get('client', JsonToken);
            ElementInformation := JsonToken.AsObject();
            RequestJson.Get('vendor_id', JsonToken);
            VendorID := JsonToken.AsValue().asCode();
            exit(UpdateVendorClientDocumentUploads(ElementInformation, VendorID));
        end;
        //Vendor Personnel Update
        if (SubmissionType = 'vendor_personnel_update') then begin
            RequestJson.Get('personnel', JsonToken);
            ElementInformation := JsonToken.AsObject();
            RequestJson.Get('vendor_id', JsonToken);
            VendorID := JsonToken.AsValue().asCode();
            exit(UpdateVendorPersonnel(ElementInformation, VendorID));
        end;
        //Vendor Personnel Delete
        if (SubmissionType = 'vendor_personnel_delete') then begin
            RequestJson.Get('vendor_id', JsonToken);
            VendorID := JsonToken.AsValue().asCode();
            RequestJson.Get('line_no', JsonToken);
            exit(DeleteVendorPersonnel(JsonToken.AsValue().AsInteger(), VendorID));
        end;
        //Vendor Director Delete
        if (SubmissionType = 'vendor_director_delete') then begin
            RequestJson.Get('vendor_id', JsonToken);
            VendorID := JsonToken.AsValue().asCode();
            RequestJson.Get('line_no', JsonToken);
            exit(DeleteVendorDirector(JsonToken.AsValue().AsInteger(), VendorID));
        end;
        //Vendor Client Delete
        if (SubmissionType = 'vendor_client_delete') then begin
            RequestJson.Get('vendor_id', JsonToken);
            VendorID := JsonToken.AsValue().asCode();
            RequestJson.Get('line_no', JsonToken);
            exit(DeleteVendorClient(JsonToken.AsValue().AsInteger(), VendorID));
        end;
        //Vendor Client Delete
        if (SubmissionType = 'vendor_bid_document_delete') then begin
            RequestJson.Get('vendor_id', JsonToken);
            VendorID := JsonToken.AsValue().asCode();
            RequestJson.Get('line_no', JsonToken);
            exit(DeleteVendorBidDocumentClient(JsonToken.AsValue().AsInteger(), VendorID));
        end;
        //Vendor Director Update
        if (SubmissionType = 'director_personnel_update') then begin
            RequestJson.Get('director', JsonToken);
            ElementInformation := JsonToken.AsObject();
            RequestJson.Get('vendor_id', JsonToken);
            VendorID := JsonToken.AsValue().asCode();
            exit(UpdateVendorDirector(ElementInformation, VendorID));
        end;
        //Vendor Director Update
        if (SubmissionType = 'client_experience_update') then begin
            RequestJson.Get('client', JsonToken);
            ElementInformation := JsonToken.AsObject();
            RequestJson.Get('vendor_id', JsonToken);
            VendorID := JsonToken.AsValue().asCode();
            exit(UpdateVendorClient(ElementInformation, VendorID));
        end;
        //Vendor Status Update
        if (SubmissionType = 'vendor_status_update') then begin
            RequestJson.Get('vendor_id', JsonToken);
            VendorID := JsonToken.AsValue().asCode();
            RequestJson.Get('status_code', JsonToken);
            exit(UpdateVendorStatus(VendorID, JsonToken.AsValue().AsInteger()));
        end;
        //Negotiated Bid Update
        if (SubmissionType = 'vendor_bid_negotiation_update') then begin
            RequestJson.Get('RFQLine', JsonToken);
            ElementInformation := JsonToken.AsObject();
            RequestJson.Get('vendor_id', JsonToken);
            exit(UpdateVendorNegotiatedBid(ElementInformation, JsonToken.AsValue().AsCode()));
        end;
        //Vendor Delivery Note Submission
        if (SubmissionType = 'vendor_delivery_note_submit') then begin
            RequestJson.Get('DeliveryNote', JsonToken);
            ElementInformation := JsonToken.AsObject();
            RequestJson.Get('vendor_id', JsonToken);
            exit(InsertVendorDeliveryNote(ElementInformation, JsonToken.AsValue().AsCode()));
        end;
        //Vendor Invoice Submission
        if (SubmissionType = 'vendor_invoice_submit') then begin
            RequestJson.Get('Invoice', JsonToken);
            ElementInformation := JsonToken.AsObject();
            RequestJson.Get('vendor_id', JsonToken);
            exit(InsertVendorInvoice(ElementInformation, JsonToken.AsValue().AsCode()));
        end;
        //Vendor Registration Payment
        if (SubmissionType = 'vendor_registration_payment') then begin
            RequestJson.Get('vendor_id', JsonToken);
            exit(UpdateVendorRegistrationPayment(RequestJson, JsonToken.AsValue().AsCode()));
        end;
    end;

    local procedure AddResponseHead(OutputJson: JsonObject; status: Boolean): JsonObject
    begin
        if status = true then begin
            OutputJson.add('response_status', 'true');
            OutputJson.add('response_code', 200);
            exit(OutputJson);
        end else begin
            OutputJson.add('response_status', 'false');
            OutputJson.add('response_code', 404);
            exit(OutputJson);
        end;
        ;
    end;

    procedure RetrieveInformation(args: Text): Text
    var
        RequestJson: JsonObject;
        OutputJson: JsonObject;
        JsonToken: JsonToken;

        RequestType: Text;
        VendorID: code[50];
        FilterID: code[50];

    begin
        Clear(RequestJson);
        if not RequestJson.ReadFrom(args) then
            Error('Invalid JSON input');

        if RequestJson.Get('request_type', JsonToken) then
            RequestType := JsonToken.AsValue().AsText();
        if RequestJson.Get('vendor_id', JsonToken) then
            VendorID := JsonToken.AsValue().AsText();


        if ((RequestType = 'tender_list')) then
            exit(GetVendorTenderList(VendorID));
        if ((RequestType = 'registration_details')) then
            exit(GetVendorRegistrationDetails(VendorID));
        if ((RequestType = 'rfq_details')) then begin
            if RequestJson.Get('filter_id', JsonToken) then
                FilterID := JsonToken.AsValue().AsText();
            exit(GetRFQDetails(FilterID, VendorID));
        end;
        if ((RequestType = 'awarded_orders_list')) then
            exit(GetVendorAwardedOrders(VendorID));
        if ((RequestType = 'delivery_notes_list')) then
            exit(GetVendorDeliveryNotes(VendorID));
        if ((RequestType = 'invoices_list')) then
            exit(GetVendorInvoices(VendorID));
    end;

    local procedure InsertVendorDetails(RequestJson: JsonObject): Text
    begin
        clear(Outputjson);

        if RequestJson.Get('vendor_uid', JsonToken) and not JsonToken.AsValue().IsNull() then begin
            VendorTable.Reset();
            if not VendorTable.Get(JsonToken.AsValue().AsText()) then begin
                VendorTable.Init();
                if RequestJson.Get('vendor_uid', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorTable."No." := JsonToken.AsValue().AsText();
                if RequestJson.Get('business_name', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorTable.Name := JsonToken.AsValue().AsText();
                if RequestJson.Get('CRN', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorTable."Certificate of Incorporation" := JsonToken.AsValue().AsText();
                if RequestJson.Get('KRAPin', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorTable."PIN No." := JsonToken.AsValue().AsText();
                if VendorTable.Insert() then
                    exit(Format(AddResponseHead(Outputjson, true)));
            end;
        end;

        exit(Format(AddResponseHead(Outputjson, false)));
    end;

    procedure UpdateProc(procID: Code[50]): Text
    begin
        "Procurement List".Reset();
        "Procurement List".SetRange("No.", procID);
        if "Procurement List".Find('-') then begin
            "Procurement List".Advertised := true;
            "Procurement List".Modify();
        end;
    end;

    local procedure GetVendorTenderList(VendorID: Code[50]): Text
    var
        jsonobject: JsonObject;
        jsonarray: JsonArray;
        SelectedVendors: Record "Quotation Bidders";
    begin
        Clear(Outputjson);
        VendorTable.Reset();
        VendorTable.SetRange("No.", VendorID);
        if VendorTable.Find('-') then begin
            "Procurement List".Reset();
            "Procurement List".SetRange("Vendor No", VendorID);
            "Procurement List".SetRange("Procurement Method", "Procurement List"."Procurement Method"::"Direct Procurement");
            "Procurement List".SetRange(Advertised, true);
            "Procurement List".SetFilter("Creation Date", '>%1', 20260101D);
            "Procurement List".SetFilter("RFQ Deadlne Date", '>=%1', Today);
            // "Procurement List".SetFilter("RFQ Deadline Time", '>=%1', Time);
            if "Procurement List".FindSet() then begin
                Clear(jsonarray);
                repeat
                    if (("Procurement List"."RFQ Deadlne Date" = Today) and ("Procurement List"."RFQ Deadline Time" < Time)) then begin
                    end else begin
                        Clear(jsonobject);
                        jsonobject.add('No', "Procurement List"."No.");
                        jsonobject.add('Status', Format("Procurement List".Status));
                        jsonobject.add('Title', "Procurement List".Title);
                        jsonobject.add('RequisitionNo', "Procurement List"."Requisiton No");
                        jsonobject.add('CreationDate', "Procurement List"."Creation Date");
                        jsonobject.add('DeadlineDate', CreateDateTime("Procurement List"."RFQ Deadlne Date", "Procurement List"."RFQ Deadline Time"));
                        jsonobject.add('expected_delivery_date', "Procurement List"."Expected Delivery Date");
                        jsonarray.Add(jsonobject);
                    end;
                until "Procurement List".Next() = 0;
                Outputjson.Add('ProcurementList', jsonarray);
                // exit(Format(AddResponseHead(Outputjson, true)));
            end;
            "Procurement List".Reset();
            // "Procurement List".SetRange("Vendor No", VendorID);
            // "Procurement List".SetRange("Supplier Category", VendorTable."Supplier Category");
            "Procurement List".SetFilter("Supplier Category", '%1|%2|%3', VendorTable."Supplier Category", VendorTable."Secondary Supplier Category 1", VendorTable."Secondary Supplier Category 2");
            "Procurement List".SetRange("Procurement Method", "Procurement List"."Procurement Method"::RFQ);
            "Procurement List".SetRange(Advertised, true);
            "Procurement List".SetFilter("Creation Date", '>%1', 20260101D);
            "Procurement List".SetFilter("RFQ Deadlne Date", '>=%1', Today);
            // "Procurement List".SetFilter("RFQ Deadline Time", '>=%1', Time);
            if "Procurement List".FindSet() then begin
                Clear(jsonarray);
                repeat
                    if (("Procurement List"."RFQ Deadlne Date" = Today) and ("Procurement List"."RFQ Deadline Time" < Time)) then begin
                    end else begin
                        SelectedVendors.Reset();
                        SelectedVendors.SetRange("Reference No", "Procurement List"."No.");
                        SelectedVendors.SetRange("Vendor Category", "Procurement List"."Supplier Category");
                        SelectedVendors.SetRange("Vendor No.", VendorTable."No.");
                        if SelectedVendors.FindFirst() then begin
                            Clear(jsonobject);
                            jsonobject.add('No', "Procurement List"."No.");
                            jsonobject.add('Status', Format("Procurement List".Status));
                            jsonobject.add('Title', "Procurement List".Title);
                            jsonobject.add('RequisitionNo', "Procurement List"."Requisiton No");
                            jsonobject.add('CreationDate', "Procurement List"."Creation Date");
                            jsonobject.add('DeadlineDate', CreateDateTime("Procurement List"."RFQ Deadlne Date", "Procurement List"."RFQ Deadline Time"));
                            jsonobject.add('expected_delivery_date', "Procurement List"."Expected Delivery Date");
                            jsonarray.Add(jsonobject);
                        end;
                    end;
                until "Procurement List".Next() = 0;
            end;
            "Procurement List".Reset();
            // "Procurement List".SetRange("Vendor No", VendorID);
            // "Procurement List".SetRange("Supplier Category", VendorTable."Supplier Category");
            "Procurement List".SetFilter("Supplier Category", '%1|%2|%3', VendorTable."Supplier Category", VendorTable."Secondary Supplier Category 1", VendorTable."Secondary Supplier Category 2");
            "Procurement List".SetRange("Procurement Method", "Procurement List"."Procurement Method"::RFQ);
            "Procurement List".SetRange(Advertised, true);
            // "Procurement List".SetFilter("Creation Date", '>%1', 20260101D);
            "Procurement List".SetFilter("RFQ Deadlne Date", '>=%1', Today);
            // "Procurement List".SetFilter("RFQ Deadline Time", '>=%1', Time);
            // "Procurement List".SetFilter("RFQ Deadlne Date", '%1..', Today);
            "Procurement List".SetRange("No.", 'QUOT002121');
            if "Procurement List".FindSet() then begin
                // Clear(jsonarray);
                repeat
                    if (("Procurement List"."RFQ Deadlne Date" = Today) and ("Procurement List"."RFQ Deadline Time" < Time)) then begin
                    end else begin
                        SelectedVendors.Reset();
                        SelectedVendors.SetRange("Reference No", "Procurement List"."No.");
                        SelectedVendors.SetRange("Vendor Category", "Procurement List"."Supplier Category");
                        SelectedVendors.SetRange("Vendor No.", VendorTable."No.");
                        if SelectedVendors.FindFirst() then begin
                            Clear(jsonobject);
                            jsonobject.add('No', "Procurement List"."No.");
                            jsonobject.add('Status', Format("Procurement List".Status));
                            jsonobject.add('Title', "Procurement List".Title);
                            jsonobject.add('RequisitionNo', "Procurement List"."Requisiton No");
                            jsonobject.add('CreationDate', "Procurement List"."Creation Date");
                            jsonobject.add('DeadlineDate', CreateDateTime("Procurement List"."RFQ Deadlne Date", "Procurement List"."RFQ Deadline Time"));
                            jsonobject.add('expected_delivery_date', "Procurement List"."Expected Delivery Date");
                            jsonarray.Add(jsonobject);
                        end;
                    end;
                until "Procurement List".Next() = 0;
                // exit(Format(AddResponseHead(Outputjson, true)));
            end;
            Outputjson.Add('RFQList', jsonarray);
            "Procurement List".Reset();
            "Procurement List".SetRange("Vendor No", VendorID);
            "Procurement List".SetRange("Procurement Method", "Procurement List"."Procurement Method"::Tender);
            "Procurement List".SetRange(Advertised, true);
            "Procurement List".SetFilter("Creation Date", '>%1', 20260101D);
            "Procurement List".SetFilter("RFQ Deadlne Date", '>=%1', Today);
            "Procurement List".SetFilter("RFQ Deadline Time", '>=%1', Time);
            if "Procurement List".FindSet() then begin
                Clear(jsonarray);
                repeat
                    Clear(jsonobject);
                    jsonobject.add('No', "Procurement List"."No.");
                    jsonobject.add('Status', Format("Procurement List".Status));
                    jsonobject.add('Title', "Procurement List".Title);
                    jsonobject.add('RequisitionNo', "Procurement List"."Requisiton No");
                    jsonobject.add('CreationDate', "Procurement List"."Creation Date");
                    jsonarray.Add(jsonobject);
                until "Procurement List".Next() = 0;
                Outputjson.Add('TenderList', jsonarray);
                // exit(Format(AddResponseHead(Outputjson, true)));
            end;
            exit(Format(AddResponseHead(Outputjson, true)));
        end;
        exit(Format(AddResponseHead(Outputjson, false)));
    end;

    local procedure GetVendorRegistrationDetails(VendorID: Code[50]): Text
    var
        datajson: JsonObject;
        jsonobject: JsonObject;
        subobject: JsonObject;
        jsonarray: JsonArray;
    begin
        Clear(Outputjson);
        VendorRegistrationDetailsTable.Reset();
        VendorRegistrationDetailsTable.SetRange("Vendor ID", VendorID);
        if VendorRegistrationDetailsTable.Find('-') then begin
            jsonobject.Add('BusinessName', VendorRegistrationDetailsTable."Business Name");
            jsonobject.Add('PostalAddress', VendorRegistrationDetailsTable."Postal Address");
            jsonobject.Add('Town', VendorRegistrationDetailsTable.Town);
            jsonobject.Add('Street', VendorRegistrationDetailsTable.Street);
            jsonobject.Add('BuildingName', VendorRegistrationDetailsTable."Buiding Name");
            jsonobject.Add('OfficeRoomNumber', VendorRegistrationDetailsTable."Office/Room Number");
            jsonobject.Add('FloorNumber', VendorRegistrationDetailsTable."Floor Number");
            jsonobject.Add('TelephoneNumber', VendorRegistrationDetailsTable."Telephone Number");
            jsonobject.Add('EmailAddress', VendorRegistrationDetailsTable."Email Address");
            jsonobject.Add('ManagementPersonnel', VendorRegistrationDetailsTable."Management Personnel");
            jsonobject.Add('ChiefExecutive', VendorRegistrationDetailsTable."Chief Executive");
            jsonobject.Add('Secretary', VendorRegistrationDetailsTable.Secretary);
            jsonobject.Add('GeneralManager', VendorRegistrationDetailsTable."General Manager");
            jsonobject.Add('BusinessFounded', VendorRegistrationDetailsTable."Founded On");
            jsonobject.Add('TechnologicalInnovation', VendorRegistrationDetailsTable."Technological Innovation");
            jsonobject.Add('Doc_OrganizationalChart', VendorRegistrationDetailsTable."Doc Organizational Chart");
            jsonobject.Add('OrganizationalChartPath', VendorRegistrationDetailsTable."Organizational Chart Path");
            jsonobject.Add('OrganizationalChartName', VendorRegistrationDetailsTable."Organizational Chart Name");
            jsonobject.Add('Status', VendorRegistrationDetailsTable.Status);
            datajson.Add('BusinessInfo', jsonobject);

            Clear(jsonobject);
            jsonobject.Add('BusinessPremises', VendorRegistrationDetailsTable."Business Premises");
            jsonobject.Add('PlotNumber', VendorRegistrationDetailsTable."Plot Number");
            jsonobject.Add('StreetRoad', VendorRegistrationDetailsTable."Street Road");
            jsonobject.Add('ProbityPostalAddress', VendorRegistrationDetailsTable."Probity Postal Address");
            jsonobject.Add('ProbityTelephone', VendorRegistrationDetailsTable."Probity Telephone");
            jsonobject.Add('ProbityEmail', VendorRegistrationDetailsTable."Probity Email");
            jsonobject.Add('NatureOfBusiness', VendorRegistrationDetailsTable."Nature of Business");
            jsonobject.Add('TradeLicenseNumber', VendorRegistrationDetailsTable."Trade License Number");
            jsonobject.Add('LicenseExpiry', VendorRegistrationDetailsTable."Trade License Expiry Date");
            jsonobject.Add('MaxBusinessValue', VendorRegistrationDetailsTable."Max Business Value");
            jsonobject.Add('BankName', VendorRegistrationDetailsTable."Bank Name");
            jsonobject.Add('AccountName', VendorRegistrationDetailsTable."Account Name");
            jsonobject.Add('AccountNumber', VendorRegistrationDetailsTable."Account Number");
            jsonobject.Add('BankBranch', VendorRegistrationDetailsTable."Bank Branch");
            jsonobject.Add('SwiftCode', VendorRegistrationDetailsTable."Swift Code");
            jsonobject.Add('BranchCode', VendorRegistrationDetailsTable."Branch Code");
            jsonobject.Add('BankCurrency', VendorRegistrationDetailsTable."Bank Currency");
            jsonobject.Add('PrivateCompany', VendorRegistrationDetailsTable."Private Company");
            jsonobject.Add('PublicCompany', VendorRegistrationDetailsTable."Public Company");
            jsonobject.Add('NominalCapital', VendorRegistrationDetailsTable."Nominal Capital");
            jsonobject.Add('IssuedCapital', VendorRegistrationDetailsTable."Issued Capital");


            VendorDirectorsTable.Reset();
            VendorDirectorsTable.SetRange(VendorID, VendorID);
            if VendorDirectorsTable.FindSet() then begin
                Clear(jsonarray);
                repeat
                    Clear(subobject);
                    subobject.add('line_no', VendorDirectorsTable.No);
                    subobject.add('DirectorName', VendorDirectorsTable."Full Name");
                    subobject.add('DirectorNationality', VendorDirectorsTable.Nationality);
                    subobject.add('DirectorCitizenship', VendorDirectorsTable.Citizenship);
                    subobject.add('DirectorShares', VendorDirectorsTable.Shares);
                    jsonarray.Add(subobject);
                until VendorDirectorsTable.Next() = 0;
                jsonobject.Add('Directors', jsonarray);
            end;

            datajson.Add('BusinessProbity', jsonobject);

            Clear(jsonobject);

            jsonobject.Add('Cat_A1_OfficeStationery', VendorRegistrationDetailsTable.Cat_A1_Office_Stationery);
            jsonobject.Add('Cat_A2_PrintedStationery', VendorRegistrationDetailsTable.Cat_A2_PrintedStationery);
            jsonobject.Add('Cat_A3_MineralWater', VendorRegistrationDetailsTable.Cat_A3_MineralWater);
            jsonobject.Add('Cat_A4_ComputerAccessories', VendorRegistrationDetailsTable.Cat_A4_ComputerAccessories);
            jsonobject.Add('Cat_A5_BrandedTShirts', VendorRegistrationDetailsTable.Cat_A5_BrandedTShirts);
            jsonobject.Add('Cat_A6_FurnitureFittings', VendorRegistrationDetailsTable.Cat_A6_FurnitureFittings);
            jsonobject.Add('Cat_A7_MetallicCabinets', VendorRegistrationDetailsTable.Cat_A7_MetallicCabinets);
            jsonobject.Add('Cat_A8_MoneyCountingMachines', VendorRegistrationDetailsTable.Cat_A8_MoneyCountingMachines);
            jsonobject.Add('Cat_A9_Photocopier', VendorRegistrationDetailsTable.Cat_A9_Photocopier);
            jsonobject.Add('Cat_A10_SupplyofPrinters', VendorRegistrationDetailsTable.Cat_A10_SupplyofPrinters);
            jsonobject.Add('Cat_A11_FirewallNetworkSwitches', VendorRegistrationDetailsTable.Cat_A11_FirewallNetwork);
            jsonobject.Add('Cat_A12_CallCenter', VendorRegistrationDetailsTable.Cat_A12_CallCenter);
            jsonobject.Add('Cat_B13_OfficeCleaning', VendorRegistrationDetailsTable.Cat_B13_OfficeCleaning);
            jsonobject.Add('Cat_B14_TimeLockServicing', VendorRegistrationDetailsTable.Cat_B14_TimeLockServicing);
            jsonobject.Add('Cat_B15_FireExtinguishers', VendorRegistrationDetailsTable.Cat_B15_FireExtinguishers);
            jsonobject.Add('Cat_B16_PhotocopierMachine', VendorRegistrationDetailsTable.Cat_B16_PhotocopierMachine);
            jsonobject.Add('Cat_B17_MotorVehicleBikes', VendorRegistrationDetailsTable.Cat_B17_MotorVehicleBikes);
            jsonobject.Add('Cat_B18_Printers', VendorRegistrationDetailsTable.Cat_B18_Printers);
            jsonobject.Add('Cat_B19_Generators', VendorRegistrationDetailsTable.Cat_B19_Generators);
            jsonobject.Add('Cat_B20_MoneyCountingMachines', VendorRegistrationDetailsTable.Cat_B20_MoneyCountingMachines);
            jsonobject.Add('Cat_B21_SanitaryDisposal', VendorRegistrationDetailsTable.Cat_B21_SanitaryDisposal);
            jsonobject.Add('Cat_B22_SecurityGuarding', VendorRegistrationDetailsTable.Cat_B22_SecurityGuarding);
            jsonobject.Add('Cat_B23_TeamBuilding', VendorRegistrationDetailsTable.Cat_B23_TeamBuilding);
            jsonobject.Add('Cat_B24_StructuredCabling', VendorRegistrationDetailsTable.Cat_B24_StructuredCabling);
            jsonobject.Add('Cat_B25_OfficePartitioning', VendorRegistrationDetailsTable.Cat_B25_OfficePartitioning);
            jsonobject.Add('Cat_B26_OutsideCatering', VendorRegistrationDetailsTable.Cat_B26_OutsideCatering);
            jsonobject.Add('Cat_B27_Electrical', VendorRegistrationDetailsTable.Cat_B27_Electrical);
            jsonobject.Add('Cat_B28_PlumbingDrainage', VendorRegistrationDetailsTable.Cat_B28_PlumbingDrainage);
            jsonobject.Add('Cat_B29_GeneralRepairs', VendorRegistrationDetailsTable.Cat_B29_GeneralRepairs);
            jsonobject.Add('Cat_B30_CarTracking', VendorRegistrationDetailsTable.Cat_B30_CarTracking);
            jsonobject.Add('Cat_B31_BulkSMS', VendorRegistrationDetailsTable.Cat_B31_BulkSMS);
            jsonobject.Add('Cat_B32_AssetTagging', VendorRegistrationDetailsTable.Cat_B32_AssetTagging);
            jsonobject.Add('Cat_B33_DesignArtwork', VendorRegistrationDetailsTable.Cat_B33_DesignArtwork);
            jsonobject.Add('Cat_B34_InsuranceCovers', VendorRegistrationDetailsTable.Cat_B34_InsuranceCovers);
            jsonobject.Add('Cat_C35_SystemAudit', VendorRegistrationDetailsTable.Cat_C35_SystemAudit);
            jsonobject.Add('Cat_C36_ExternalAuditors', VendorRegistrationDetailsTable.Cat_C36_ExternalAuditors);
            jsonobject.Add('Cat_C37_DebtCollectors', VendorRegistrationDetailsTable.Cat_C37_DebtCollectors);
            jsonobject.Add('Cat_C38_Valuers', VendorRegistrationDetailsTable.Cat_C38_Valuers);
            jsonobject.Add('Cat_C39_Auctioneers', VendorRegistrationDetailsTable.Cat_C39_Auctioneers);
            jsonobject.Add('Cat_C40_CashTransit', VendorRegistrationDetailsTable.Cat_C40_CashTransit);
            jsonobject.Add('Cat_C41_LegalServices', VendorRegistrationDetailsTable.Cat_C41_LegalServices);
            jsonobject.Add('Cat_C42_ProfessionalConsultancy', VendorRegistrationDetailsTable.Cat_C42_Consultancy);
            jsonobject.Add('Cat_C43_QuantitySurveyors', VendorRegistrationDetailsTable.Cat_C43_QuantitySurveyors);
            jsonobject.Add('Cat_C44_CCTVMaintenance', VendorRegistrationDetailsTable.Cat_C44_CCTVMaintenance);

            datajson.Add('SupplyCategories', jsonobject);

            Clear(jsonobject);
            jsonobject.Add('Doc_CertificateRegistration', VendorRegistrationDetailsTable."Doc Certificate Registration");
            jsonobject.Add('CertificateRegistrationPath', VendorRegistrationDetailsTable."Certificate Registration Path");
            jsonobject.Add('CertificateRegistrationName', VendorRegistrationDetailsTable."Certificate Registration Name");
            jsonobject.Add('Doc_CompanyProfile', VendorRegistrationDetailsTable."Doc Company Profile");
            jsonobject.Add('CompanyProfilePath', VendorRegistrationDetailsTable."Company Profile Path");
            jsonobject.Add('CompanyProfileName', VendorRegistrationDetailsTable."Company Profile Name");
            jsonobject.Add('Doc_TradeLicense', VendorRegistrationDetailsTable."Doc Trade License");
            jsonobject.Add('TradeLicensePath', VendorRegistrationDetailsTable."Trade License Path");
            jsonobject.Add('TradeLicenseName', VendorRegistrationDetailsTable."Trade License Name");
            jsonobject.Add('Doc_TaxCompliance', VendorRegistrationDetailsTable."Doc Tax Compliance");
            jsonobject.Add('TaxCompliancePath', VendorRegistrationDetailsTable."Tax Compliance Path");
            jsonobject.Add('TaxComplianceName', VendorRegistrationDetailsTable."Tax Compliance Name");
            jsonobject.Add('Doc_NCACertificate', VendorRegistrationDetailsTable."Doc NCA Certificate");
            jsonobject.Add('NCACertificatePath', VendorRegistrationDetailsTable."NCA Certificate Path");
            jsonobject.Add('NCACertificateName', VendorRegistrationDetailsTable."NCA Certificate Name");
            jsonobject.Add('Doc_BankStatements', VendorRegistrationDetailsTable."Doc Bank Statements");
            jsonobject.Add('BankStatementsPath', VendorRegistrationDetailsTable."Bank Statements Path");
            jsonobject.Add('BankStatementsName', VendorRegistrationDetailsTable."Bank Statements Name");
            jsonobject.Add('Doc_RecommendationLetters', VendorRegistrationDetailsTable."Doc Recommendation Letters");
            jsonobject.Add('RecommendationLettersPath', VendorRegistrationDetailsTable."Recommendation Letters Path");
            jsonobject.Add('RecommendationLettersName', VendorRegistrationDetailsTable."Recommendation Letters Name");
            jsonobject.Add('Doc_RegulatoryCertificates', VendorRegistrationDetailsTable."Doc Regulatory Certificates");
            jsonobject.Add('RegulatoryCertificatesPath', VendorRegistrationDetailsTable."Regulatory Certificates Path");
            jsonobject.Add('RegulatoryCertificatesName', VendorRegistrationDetailsTable."Regulatory Certificates Name");
            jsonobject.Add('Doc_RCKPaymentReceipt', VendorRegistrationDetailsTable."Doc RCK Payment Receipt");
            jsonobject.Add('RCKPaymentReceiptPath', VendorRegistrationDetailsTable."RCK Payment Receipt Path");
            jsonobject.Add('RCKPaymentReceiptName', VendorRegistrationDetailsTable."RCK Payment Receipt Name");
            jsonobject.Add('Doc_OrganizationalChart', VendorRegistrationDetailsTable."Doc Organizational Chart");
            jsonobject.Add('OrganizationalChartPath', VendorRegistrationDetailsTable."Organizational Chart Path");
            jsonobject.Add('OrganizationalChartName', VendorRegistrationDetailsTable."Organizational Chart Name");
            jsonobject.Add('Doc_AuditedAccounts', VendorRegistrationDetailsTable."Doc Audited Accounts");
            jsonobject.Add('AuditedAccountsPath', VendorRegistrationDetailsTable."Audited Accounts Path");
            jsonobject.Add('AuditedAccountsName', VendorRegistrationDetailsTable."Audited Accounts Name");
            jsonobject.Add('Doc_DeclarantID', VendorRegistrationDetailsTable."Doc Declarant ID");
            jsonobject.Add('DeclarantIDPath', VendorRegistrationDetailsTable."Declarant ID Path");
            jsonobject.Add('DeclarantIDName', VendorRegistrationDetailsTable."Declarant ID Name");
            jsonobject.Add('Doc_DeclarantPIN', VendorRegistrationDetailsTable."Doc Declarant PIN");
            jsonobject.Add('DeclarantPINPath', VendorRegistrationDetailsTable."Declarant PIN Path");
            jsonobject.Add('DeclarantPINName', VendorRegistrationDetailsTable."Declarant PIN Name");
            jsonobject.Add('Doc_ApplicantSignature', VendorRegistrationDetailsTable."Doc Applicant Signature");
            jsonobject.Add('ApplicantSignaturePath', VendorRegistrationDetailsTable."Applicant Signature Path");
            jsonobject.Add('ApplicantSignatureName', VendorRegistrationDetailsTable."Applicant Signature Name");
            jsonobject.Add('Doc_SwornSignature', VendorRegistrationDetailsTable."Doc Sworn Signature");
            jsonobject.Add('SwornSignaturePath', VendorRegistrationDetailsTable."Sworn Signature Path");
            jsonobject.Add('SwornSignatureName', VendorRegistrationDetailsTable."Sworn Signature Name");
            datajson.Add('DocumentUploads', jsonobject);

            VendorPersonnelTable.Reset();
            VendorPersonnelTable.SetRange(VendorID, VendorID);
            if vendorPersonnelTable.FindSet() then begin
                Clear(jsonarray);
                repeat
                    Clear(jsonobject);
                    jsonobject.add('line_no', VendorPersonnelTable.No);
                    jsonobject.add('FullName', VendorPersonnelTable."Full Name");
                    jsonobject.add('Academic_Qualification', VendorPersonnelTable."Academic Qualification");
                    jsonobject.add('LengthofService', VendorPersonnelTable."Length of Service");
                    jsonobject.add('PositionHeld', VendorPersonnelTable."Position Held");
                    jsonobject.add('Age', VendorPersonnelTable.Age);
                    jsonobject.add('ProfessionalQualification', VendorPersonnelTable."Professional Qualification");
                    jsonarray.Add(jsonobject);
                until VendorPersonnelTable.Next() = 0;
                datajson.Add('Personnel', jsonarray);
            end;

            Clear(jsonobject);
            jsonobject.Add('CreditPeriod', VendorRegistrationDetailsTable."Credit Period");
            jsonobject.Add('FinancialCapability', VendorRegistrationDetailsTable."Financial Capability");
            datajson.Add('FinancialDetails', jsonobject);

            VendorClientsDetailsTable.Reset();
            VendorClientsDetailsTable.SetRange(VendorID, VendorID);
            if VendorClientsDetailsTable.FindSet() then begin
                Clear(jsonarray);
                repeat
                    Clear(subobject);
                    subobject.add('ClientID', VendorClientsDetailsTable.No);
                    subobject.add('ClientOrganization', VendorClientsDetailsTable."Client Organization");
                    subobject.add('ClientAddress', VendorClientsDetailsTable."Client Addres");
                    subobject.add('ClientContactPerson', VendorClientsDetailsTable."Contact Person");
                    subobject.add('ClientTelephone', VendorClientsDetailsTable."Telephone");
                    subobject.add('ClientContractValue', VendorClientsDetailsTable."Value of Contract");
                    subobject.add('ClientContractDuration', VendorClientsDetailsTable."Contract Duration");
                    subobject.add('Doc_ClientContractEvidence', VendorClientsDetailsTable."Doc Contract Evidence");
                    subobject.add('ClientContractEvidencePath', VendorClientsDetailsTable."Contract Evidence Path");
                    subobject.add('ClientContractEvidenceName', VendorClientsDetailsTable."Contract Evidence Name");
                    jsonarray.Add(subobject);
                until VendorClientsDetailsTable.Next() = 0;
                datajson.Add('Clients', jsonarray);
            end;

            Clear(jsonobject);
            jsonobject.Add('CodeOfConduct', VendorRegistrationDetailsTable."Code of Conduct");
            jsonobject.Add('DeclarantName', VendorRegistrationDetailsTable."Declarant Name");
            jsonobject.Add('DeclarantPosition', VendorRegistrationDetailsTable."Declarant Position");
            jsonobject.Add('DeclarationDate', VendorRegistrationDetailsTable."Declaration Date");
            jsonobject.Add('SwornStatement', VendorRegistrationDetailsTable."Sworn Statement");
            jsonobject.Add('SwornDate', VendorRegistrationDetailsTable."Sworn Date");
            jsonobject.Add('ApplicantName', VendorRegistrationDetailsTable."Applicant Name");
            jsonobject.Add('RepresentedBy', VendorRegistrationDetailsTable."Represented By");
            datajson.Add('Declarations', jsonobject);


            Outputjson.Add('RegistrationDetails', datajson);
            exit(Format(AddResponseHead(Outputjson, true)));
        end;
    end;

    local procedure UpdateVendorPersonnel(RequestJson: JsonObject; VendorID: Code[50]): Text

    begin
        VendorPersonnelTable.Init();
        VendorPersonnelTable.VendorID := VendorID;
        if RequestJson.Get('FullName', JsonToken) and not JsonToken.AsValue().IsNull() then
            VendorPersonnelTable."Full Name" := JsonToken.AsValue().AsText();
        if RequestJson.Get('Academic_Qualification', JsonToken) and not JsonToken.AsValue().IsNull() then
            VendorPersonnelTable."Academic Qualification" := JsonToken.AsValue().AsText();
        if RequestJson.Get('LengthofService', JsonToken) and not JsonToken.AsValue().IsNull() then
            VendorPersonnelTable."Length of Service" := JsonToken.AsValue().AsText();
        if RequestJson.Get('PositionHeld', JsonToken) and not JsonToken.AsValue().IsNull() then
            VendorPersonnelTable."Position Held" := JsonToken.AsValue().AsText();
        if RequestJson.Get('Age', JsonToken) and not JsonToken.AsValue().IsNull() then
            VendorPersonnelTable.Age := JsonToken.AsValue().AsInteger();
        VendorPersonnelTable.Insert();
        exit(Format(AddResponseHead(Outputjson, true)));
    end;

    local procedure DeleteVendorPersonnel(LineNo: Integer; VendorID: Code[50]): Text

    begin
        VendorPersonnelTable.Reset();
        VendorPersonnelTable.SetRange(VendorID, VendorID);
        VendorPersonnelTable.SetRange(No, LineNo);
        if VendorPersonnelTable.FindFirst() then
            if VendorPersonnelTable.Delete() then
                exit(Format(AddResponseHead(Outputjson, true)));
        exit(Format(AddResponseHead(Outputjson, false)));
    end;

    local procedure UpdateVendorDirector(RequestJson: JsonObject; VendorID: Code[50]): Text

    begin
        VendorDirectorsTable.Init();
        VendorDirectorsTable.VendorID := VendorID;
        if RequestJson.Get('DirectorName', JsonToken) and not JsonToken.AsValue().IsNull() then
            VendorDirectorsTable."Full Name" := JsonToken.AsValue().AsText();
        if RequestJson.Get('DirectorNationality', JsonToken) and not JsonToken.AsValue().IsNull() then
            VendorDirectorsTable.Nationality := JsonToken.AsValue().AsText();
        if RequestJson.Get('DirectorCitizenship', JsonToken) and not JsonToken.AsValue().IsNull() then
            VendorDirectorsTable.Citizenship := JsonToken.AsValue().AsText();
        if RequestJson.Get('DirectorShares', JsonToken) and not JsonToken.AsValue().IsNull() then
            VendorDirectorsTable.Shares := JsonToken.AsValue().AsText();
        VendorDirectorsTable.Insert();
        exit(Format(AddResponseHead(Outputjson, true)));
    end;

    local procedure DeleteVendorDirector(LineNo: Integer; VendorID: Code[50]): Text

    begin
        VendorDirectorsTable.Reset();
        VendorDirectorsTable.SetRange(VendorID, VendorID);
        VendorDirectorsTable.SetRange(No, LineNo);
        if VendorDirectorsTable.FindFirst() then
            if VendorDirectorsTable.Delete() then
                exit(Format(AddResponseHead(Outputjson, true)));
        exit(Format(AddResponseHead(Outputjson, false)));
    end;

    local procedure DeleteVendorClient(LineNo: Integer; VendorID: Code[50]): Text

    begin
        VendorClientsDetailsTable.Reset();
        VendorClientsDetailsTable.SetRange(VendorID, VendorID);
        VendorClientsDetailsTable.SetRange(No, LineNo);
        if VendorClientsDetailsTable.FindFirst() then
            if VendorClientsDetailsTable.Delete() then
                exit(Format(AddResponseHead(Outputjson, true)));
        exit(Format(AddResponseHead(Outputjson, false)));
    end;

    local procedure DeleteVendorBidDocumentClient(LineNo: Integer; VendorID: Code[50]): Text

    begin
        SharePointTable.Reset();
        SharePointTable.SetRange(Owner, VendorID);
        SharePointTable.SetRange("Entry No", LineNo);
        if SharePointTable.FindFirst() then
            if SharePointTable.Delete() then
                exit(Format(AddResponseHead(Outputjson, true)));
        exit(Format(AddResponseHead(Outputjson, false)));
    end;

    local procedure UpdateVendorClient(RequestJson: JsonObject; VendorID: Code[50]): Text

    begin

        VendorClientsDetailsTable.Reset();
        if RequestJson.Get('ClientID', JsonToken) and not JsonToken.AsValue().IsNull() then begin
            VendorClientsDetailsTable.SetRange(No, JsonToken.AsValue().AsInteger());
            if VendorClientsDetailsTable.Find('-') then begin
                VendorClientsDetailsTable.VendorID := VendorID;
                if RequestJson.Get('ClientOrganization', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorClientsDetailsTable."Client Organization" := JsonToken.AsValue().AsText();
                if RequestJson.Get('ClientAddress', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorClientsDetailsTable."Client Addres" := JsonToken.AsValue().AsText();
                if RequestJson.Get('ClientTelephone', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorClientsDetailsTable."Telephone" := JsonToken.AsValue().AsText();
                if RequestJson.Get('ClientContactPerson', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorClientsDetailsTable."Contact Person" := JsonToken.AsValue().AsText();
                if RequestJson.Get('ClientContractValue', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorClientsDetailsTable."Value of Contract" := JsonToken.AsValue().AsDecimal();
                if RequestJson.Get('ClientContractDuration', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorClientsDetailsTable."Contract Duration" := JsonToken.AsValue().AsText();

                if ((RequestJson.Get('Doc_ClientContractEvidence', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                    VendorClientsDetailsTable."Doc Contract Evidence" := JsonToken.AsValue().AsBoolean();
                    if RequestJson.Get('ClientContractEvidencePath', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorClientsDetailsTable."Contract Evidence Path" := JsonToken.AsValue().AsText();
                    if RequestJson.Get('ClientContractEvidenceName', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorClientsDetailsTable."Contract Evidence Name" := JsonToken.AsValue().AsText;
                end;

                if VendorClientsDetailsTable.Modify() then begin
                    Outputjson.Add('ClientID', VendorClientsDetailsTable.No);
                    exit(Format(AddResponseHead(Outputjson, true)));
                end;
            end;
        end else begin
            VendorClientsDetailsTable.Init();
            VendorClientsDetailsTable.VendorID := VendorID;
            if RequestJson.Get('ClientOrganization', JsonToken) and not JsonToken.AsValue().IsNull() then
                VendorClientsDetailsTable."Client Organization" := JsonToken.AsValue().AsText();
            if RequestJson.Get('ClientAddress', JsonToken) and not JsonToken.AsValue().IsNull() then
                VendorClientsDetailsTable."Client Addres" := JsonToken.AsValue().AsText();
            if RequestJson.Get('ClientTelephone', JsonToken) and not JsonToken.AsValue().IsNull() then
                VendorClientsDetailsTable."Telephone" := JsonToken.AsValue().AsText();
            if RequestJson.Get('ClientContactPerson', JsonToken) and not JsonToken.AsValue().IsNull() then
                VendorClientsDetailsTable."Contact Person" := JsonToken.AsValue().AsText();
            if RequestJson.Get('ClientContractValue', JsonToken) and not JsonToken.AsValue().IsNull() then
                VendorClientsDetailsTable."Value of Contract" := JsonToken.AsValue().AsDecimal();
            if RequestJson.Get('ClientContractDuration', JsonToken) and not JsonToken.AsValue().IsNull() then
                VendorClientsDetailsTable."Contract Duration" := JsonToken.AsValue().AsText();

            if ((RequestJson.Get('Doc_ClientContractEvidence', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                VendorClientsDetailsTable."Doc Contract Evidence" := JsonToken.AsValue().AsBoolean();
                if RequestJson.Get('ClientContractEvidencePath', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorClientsDetailsTable."Contract Evidence Path" := JsonToken.AsValue().AsText();
                if RequestJson.Get('ClientContractEvidenceName', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorClientsDetailsTable."Contract Evidence Name" := JsonToken.AsValue().AsText;
            end;

            if VendorClientsDetailsTable.Insert() then begin
                Outputjson.Add('ClientID', VendorClientsDetailsTable.No);
                exit(Format(AddResponseHead(Outputjson, true)));
            end
        end;
        exit(Format(AddResponseHead(Outputjson, false)));
    end;

    local procedure UpdateVendorDocumentUploads(RequestJson: JsonObject): Text
    var
        jsonobject: jsonobject;
        jsonarray: jsonarray;
    begin
        if RequestJson.Get('DocumentUploads', JsonToken) then begin
            jsonobject := JsonToken.AsObject();

            if RequestJson.Get('VendorID', JsonToken) and not JsonToken.AsValue().IsNull() then begin
                VendorRegistrationDetailsTable.Reset();
                if VendorRegistrationDetailsTable.Get(JsonToken.AsValue().AsText()) then begin
                    if ((jsonobject.Get('Doc_CertificateRegistration', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc Certificate Registration" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('CertificateRegistrationPath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Certificate Registration Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('CertificateRegistrationName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Certificate Registration Name" := JsonToken.AsValue().AsText();
                    end;
                    if ((jsonobject.Get('Doc_CompanyProfile', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc Company Profile" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('CompanyProfilePath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Company Profile Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('CompanyProfileName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Company Profile Name" := JsonToken.AsValue().AsText();
                    end;
                    if ((jsonobject.Get('Doc_TradeLicense', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc Trade License" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('TradeLicensePath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Trade License Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('TradeLicenseName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Trade License Name" := JsonToken.AsValue().AsText();
                    end;
                    if ((jsonobject.Get('Doc_TaxCompliance', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc Tax Compliance" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('TaxCompliancePath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Tax Compliance Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('TaxComplianceName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Tax Compliance Name" := JsonToken.AsValue().AsText();
                    end;
                    if ((jsonobject.Get('Doc_NCACertificate', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc NCA Certificate" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('NCACertificatePath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."NCA Certificate Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('NCACertificateName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."NCA Certificate Name" := JsonToken.AsValue().AsText();
                    end;
                    if ((jsonobject.Get('Doc_BankStatements', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc Bank Statements" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('BankStatementsPath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Bank Statements Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('BankStatementsName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Bank Statements Name" := JsonToken.AsValue().AsText();
                    end;
                    if ((jsonobject.Get('Doc_RecommendationLetters', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc Recommendation Letters" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('RecommendationLettersPath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Recommendation Letters Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('RecommendationLettersName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Recommendation Letters Name" := JsonToken.AsValue().AsText();
                    end;
                    if ((jsonobject.Get('Doc_RegulatoryCertificates', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc Regulatory Certificates" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('RegulatoryCertificatesPath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Regulatory Certificates Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('RegulatoryCertificatesName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Regulatory Certificates Name" := JsonToken.AsValue().AsText();
                    end;
                    if ((jsonobject.Get('Doc_RCKPaymentReceipt', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc RCK Payment Receipt" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('RCKPaymentReceiptPath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."RCK Payment Receipt Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('RCKPaymentReceiptName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."RCK Payment Receipt Name" := JsonToken.AsValue().AsText();
                    end;
                    if ((jsonobject.Get('Doc_OrganizationalChart', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc Organizational Chart" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('OrganizationalChartPath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Organizational Chart Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('OrganizationalChartName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Organizational Chart Name" := JsonToken.AsValue().AsText();
                    end;
                    if ((jsonobject.Get('Doc_AuditedAccounts', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc Audited Accounts" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('AuditedAccountsPath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Audited Accounts Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('AuditedAccountsName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Audited Accounts Name" := JsonToken.AsValue().AsText();
                    end;
                    if ((jsonobject.Get('Doc_DeclarantID', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc Declarant ID" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('DeclarantIDPath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Declarant ID Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('DeclarantIDName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Declarant ID Name" := JsonToken.AsValue().AsText();
                    end;
                    if ((jsonobject.Get('Doc_DeclarantPIN', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc Declarant PIN" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('DeclarantPINPath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Declarant PIN Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('DeclarantPINName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Declarant PIN Name" := JsonToken.AsValue().AsText();
                    end;
                    if ((jsonobject.Get('Doc_ApplicantSignature', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc Applicant Signature" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('ApplicantSignaturePath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Applicant Signature Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('ApplicantSignatureName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Applicant Signature Name" := JsonToken.AsValue().AsText();
                    end;
                    if ((jsonobject.Get('Doc_SwornSignature', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc Sworn Signature" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('SwornSignaturePath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Sworn Signature Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('SwornSignatureName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Sworn Signature Name" := JsonToken.AsValue().AsText();
                    end;
                    if VendorRegistrationDetailsTable.Modify() then
                        exit(Format(AddResponseHead(Outputjson, true)));
                end else begin
                    VendorRegistrationDetailsTable.Init();
                    if RequestJson.Get('VendorID', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Vendor ID" := JsonToken.AsValue().AsText();
                    if ((jsonobject.Get('Doc_CertificateRegistration', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc Certificate Registration" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('CertificateRegistrationPath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Certificate Registration Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('CertificateRegistrationName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Certificate Registration Name" := JsonToken.AsValue().AsText();
                    end;
                    if ((jsonobject.Get('Doc_CompanyProfile', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc Company Profile" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('CompanyProfilePath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Company Profile Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('CompanyProfileName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Company Profile Name" := JsonToken.AsValue().AsText();
                    end;
                    if ((jsonobject.Get('Doc_TradeLicense', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc Trade License" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('TradeLicensePath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Trade License Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('TradeLicenseName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Trade License Name" := JsonToken.AsValue().AsText();
                    end;
                    if ((jsonobject.Get('Doc_TaxCompliance', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc Tax Compliance" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('TaxCompliancePath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Tax Compliance Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('TaxComplianceName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Tax Compliance Name" := JsonToken.AsValue().AsText();
                    end;
                    if ((jsonobject.Get('Doc_NCACertificate', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc NCA Certificate" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('NCACertificatePath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."NCA Certificate Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('NCACertificateName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."NCA Certificate Name" := JsonToken.AsValue().AsText();
                    end;
                    if ((jsonobject.Get('Doc_BankStatements', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc Bank Statements" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('BankStatementsPath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Bank Statements Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('BankStatementsName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Bank Statements Name" := JsonToken.AsValue().AsText();
                    end;
                    if ((jsonobject.Get('Doc_RecommendationLetters', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc Recommendation Letters" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('RecommendationLettersPath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Recommendation Letters Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('RecommendationLettersName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Recommendation Letters Name" := JsonToken.AsValue().AsText();
                    end;
                    if ((jsonobject.Get('Doc_RegulatoryCertificates', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc Regulatory Certificates" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('RegulatoryCertificatesPath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Regulatory Certificates Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('RegulatoryCertificatesName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Regulatory Certificates Name" := JsonToken.AsValue().AsText();
                    end;
                    if ((jsonobject.Get('Doc_RCKPaymentReceipt', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc RCK Payment Receipt" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('RCKPaymentReceiptPath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."RCK Payment Receipt Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('RCKPaymentReceiptName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."RCK Payment Receipt Name" := JsonToken.AsValue().AsText();
                    end;
                    if ((jsonobject.Get('Doc_OrganizationalChart', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc Organizational Chart" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('OrganizationalChartPath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Organizational Chart Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('OrganizationalChartName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Organizational Chart Name" := JsonToken.AsValue().AsText();
                    end;
                    if ((jsonobject.Get('Doc_AuditedAccounts', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc Audited Accounts" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('AuditedAccountsPath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Audited Accounts Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('AuditedAccountsName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Audited Accounts Name" := JsonToken.AsValue().AsText();
                    end;
                    if ((jsonobject.Get('Doc_DeclarantID', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc Declarant ID" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('DeclarantIDPath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Declarant ID Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('DeclarantIDName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Declarant ID Name" := JsonToken.AsValue().AsText();
                    end;
                    if ((jsonobject.Get('Doc_DeclarantPIN', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc Declarant PIN" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('DeclarantPINPath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Declarant PIN Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('DeclarantPINName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Declarant PIN Name" := JsonToken.AsValue().AsText();
                    end;
                    if ((jsonobject.Get('Doc_ApplicantSignature', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc Applicant Signature" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('ApplicantSignaturePath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Applicant Signature Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('ApplicantSignatureName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Applicant Signature Name" := JsonToken.AsValue().AsText();
                    end;
                    if ((jsonobject.Get('Doc_SwornSignature', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                        VendorRegistrationDetailsTable."Doc Sworn Signature" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('SwornSignaturePath', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Sworn Signature Path" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('SwornSignatureName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Sworn Signature Name" := JsonToken.AsValue().AsText();
                    end;
                    if VendorRegistrationDetailsTable.Insert() then
                        exit(Format(AddResponseHead(Outputjson, true)));
                end;
            end;
        end;
        exit(Format(AddResponseHead(Outputjson, false)));
    end;

    local procedure UpdateVendorClientDocumentUploads(RequestJson: JsonObject; VendorID: Code[50]): Text
    var
        // jsonobject: jsonobject;
        // jsonarray: jsonarray;
        ClientName: Text[500];
    begin

        if RequestJson.Get('ClientOrganization', JsonToken) and not JsonToken.AsValue().IsNull() then
            ClientName := JsonToken.AsValue().AsText();

        VendorClientsDetailsTable.Reset();
        VendorClientsDetailsTable.SetRange("Client Organization", ClientName);
        VendorClientsDetailsTable.SetRange(VendorID, VendorID);
        if VendorClientsDetailsTable.Find('-') then begin
            if ((RequestJson.Get('Doc_ClientContractEvidence', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                VendorClientsDetailsTable."Doc Contract Evidence" := JsonToken.AsValue().AsBoolean();
                if RequestJson.Get('ClientContractEvidencePath', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorClientsDetailsTable."Contract Evidence Path" := JsonToken.AsValue().AsText();
                if RequestJson.Get('ClientContractEvidenceName', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorClientsDetailsTable."Contract Evidence Name" := JsonToken.AsValue().AsText;
            end;

            if VendorClientsDetailsTable.Modify() then begin
                Outputjson.Add('ClientID', VendorClientsDetailsTable.No);
                exit(Format(AddResponseHead(Outputjson, true)));
            end;
        end else begin
            VendorClientsDetailsTable.Init();
            VendorClientsDetailsTable.VendorID := VendorID;
            VendorClientsDetailsTable."Client Organization" := ClientName;
            if ((RequestJson.Get('Doc_ClientContractEvidence', JsonToken)) and (JsonToken.AsValue().AsBoolean() = true)) then begin
                VendorClientsDetailsTable."Doc Contract Evidence" := JsonToken.AsValue().AsBoolean();
                if RequestJson.Get('ClientContractEvidencePath', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorClientsDetailsTable."Contract Evidence Path" := JsonToken.AsValue().AsText();
                if RequestJson.Get('ClientContractEvidenceName', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorClientsDetailsTable."Contract Evidence Name" := JsonToken.AsValue().AsText;
            end;

            if VendorClientsDetailsTable.Insert() then begin
                Outputjson.Add('ClientID', VendorClientsDetailsTable.No);
                exit(Format(AddResponseHead(Outputjson, true)));
            end
        end;
        exit(Format(AddResponseHead(Outputjson, false)));
    end;

    local procedure UpdateVendorRegistrationDetails(RequestJson: JsonObject): Text
    var
        jsonobject: jsonobject;
        jsonarray: jsonarray;

        VendorID: Code[50];
    begin
        if RequestJson.Get('BusinessInfo', JsonToken) then begin
            jsonobject := JsonToken.AsObject();

            if jsonobject.Get('VendorID', JsonToken) and not JsonToken.AsValue().IsNull() then begin
                VendorID := JsonToken.AsValue().AsText();
                VendorRegistrationDetailsTable.Reset();
                if VendorRegistrationDetailsTable.Get(VendorID) then begin
                    if jsonobject.Get('BusinessName', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Business Name" := JsonToken.AsValue().AsText();
                    if jsonobject.Get('PostalAddress', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Postal Address" := JsonToken.AsValue().AsText();
                    if jsonobject.Get('Town', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Town := JsonToken.AsValue().AsText();
                    if jsonobject.Get('Street', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Street := JsonToken.AsValue().AsText();
                    if jsonobject.Get('BuildingName', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Buiding Name" := JsonToken.AsValue().AsText();
                    if jsonobject.Get('OfficeRoomNumber', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Office/Room Number" := JsonToken.AsValue().AsText();
                    if jsonobject.Get('FloorNumber', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Floor Number" := JsonToken.AsValue().AsText();
                    if jsonobject.Get('TelephoneNumber', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Telephone Number" := JsonToken.AsValue().AsText();
                    if jsonobject.Get('EmailAddress', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Email Address" := JsonToken.AsValue().AsText();
                    if jsonobject.Get('ManagementPersonnel', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Management Personnel" := JsonToken.AsValue().AsText();
                    if jsonobject.Get('ChiefExecutive', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Chief Executive" := JsonToken.AsValue().AsText();
                    if jsonobject.Get('Secretary', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Secretary := JsonToken.AsValue().AsText();
                    if jsonobject.Get('GeneralManager', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."General Manager" := JsonToken.AsValue().AsText();
                    if jsonobject.Get('BusinessFounded', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Founded On" := JsonToken.AsValue().AsText();
                    if jsonobject.Get('TechnologicalInnovation', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Technological Innovation" := JsonToken.AsValue().AsText();

                    if RequestJson.Get('BusinessProbity', JsonToken) then begin
                        jsonobject := JsonToken.AsObject();
                        if jsonobject.Get('BusinessPremises', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Business Premises" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('PlotNumber', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Plot Number" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('StreetRoad', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Street Road" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('ProbityPostalAddress', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Probity Postal Address" := JsonToken.AsValue().AsText;
                        if jsonobject.Get('ProbityTelephone', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Probity Telephone" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('ProbityEmail', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Probity Email" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('NatureOfBusiness', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Nature of Business" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('TradeLicenseNumber', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Trade License Number" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('LicenseExpiry', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Trade License Expiry Date" := System.DT2Date(JsonToken.AsValue().AsDateTime());
                        if jsonobject.Get('MaxBusinessValue', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Max Business Value" := JsonToken.AsValue().AsDecimal();
                        if jsonobject.Get('BankName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Bank Name" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('AccountName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Account Name" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('AccountNumber', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Account Number" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('BankBranch', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Bank Branch" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('SwiftCode', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Swift Code" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('BranchCode', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Branch Code" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('BankCurrency', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Bank Currency" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('PrivateCompany', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Private Company" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('PublicCompany', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Public Company" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('NominalCapital', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Nominal Capital" := JsonToken.AsValue().AsDecimal();
                        if jsonobject.Get('IssuedCapital', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Issued Capital" := JsonToken.AsValue().AsDecimal();
                    end;



                    if RequestJson.Get('SupplyCategories', JsonToken) then begin
                        jsonobject := JsonToken.AsObject();
                        if jsonobject.Get('Cat_A1_OfficeStationery', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_A1_Office_Stationery := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_A2_PrintedStationery', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_A2_PrintedStationery := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_A3_MineralWater', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_A3_MineralWater := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_A4_ComputerAccessories', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_A4_ComputerAccessories := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_A5_BrandedTShirts', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_A5_BrandedTShirts := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_A6_FurnitureFittings', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_A6_FurnitureFittings := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_A7_MetallicCabinets', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_A7_MetallicCabinets := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_A8_MoneyCountingMachines', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_A8_MoneyCountingMachines := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_A9_Photocopier', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_A9_Photocopier := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_A10_SupplyofPrinters', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_A10_SupplyofPrinters := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_A11_FirewallNetworkSwitches', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_A11_FirewallNetwork := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_A12_CallCenter', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_A12_CallCenter := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_B13_OfficeCleaning', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_B13_OfficeCleaning := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_B14_TimeLockServicing', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_B14_TimeLockServicing := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_B15_FireExtinguishers', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_B15_FireExtinguishers := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_B16_PhotocopierMachine', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_B16_PhotocopierMachine := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_B17_MotorVehicleBikes', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_B17_MotorVehicleBikes := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_B18_Printers', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_B18_Printers := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_B19_Generators', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_B19_Generators := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_B20_MoneyCountingMachines', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_B20_MoneyCountingMachines := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_B21_SanitaryDisposal', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_B21_SanitaryDisposal := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_B22_SecurityGuarding', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_B22_SecurityGuarding := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_B23_TeamBuilding', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_B23_TeamBuilding := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_B24_StructuredCabling', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_B24_StructuredCabling := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_B25_OfficePartitioning', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_B25_OfficePartitioning := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_B26_OutsideCatering', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_B26_OutsideCatering := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_B27_Electrical', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_B27_Electrical := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_B28_PlumbingDrainage', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_B28_PlumbingDrainage := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_B29_GeneralRepairs', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_B29_GeneralRepairs := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_B30_CarTracking', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_B30_CarTracking := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_B31_BulkSMS', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_B31_BulkSMS := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_B32_AssetTagging', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_B32_AssetTagging := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_B33_DesignArtwork', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_B33_DesignArtwork := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_B34_InsuranceCovers', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_B34_InsuranceCovers := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_C35_SystemAudit', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_C35_SystemAudit := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_C36_ExternalAuditors', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_C36_ExternalAuditors := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_C37_DebtCollectors', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_C37_DebtCollectors := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_C38_Valuers', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_C38_Valuers := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_C39_Auctioneers', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_C39_Auctioneers := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_C40_CashTransit', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_C40_CashTransit := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_C41_LegalServices', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_C41_LegalServices := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_C42_ProfessionalConsultancy', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_C42_Consultancy := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_C43_QuantitySurveyors', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_C43_QuantitySurveyors := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('Cat_C44_CCTVMaintenance', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable.Cat_C44_CCTVMaintenance := JsonToken.AsValue().AsBoolean();
                    end;

                    if RequestJson.Get('FinancialDetails', JsonToken) then begin
                        jsonobject := JsonToken.AsObject();
                        if jsonobject.Get('CreditPeriod', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Credit Period" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('FinancialCapability', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Financial Capability" := JsonToken.AsValue().AsText();
                    end;

                    if RequestJson.Get('Declarations', JsonToken) then begin
                        jsonobject := JsonToken.AsObject();
                        if jsonobject.Get('CodeOfConduct', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Code of Conduct" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('DeclarantName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Declarant Name" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('DeclarantPosition', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Declarant Position" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('DeclarationDate', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Declaration Date" := System.DT2Date(JsonToken.AsValue().AsDateTime());
                        if jsonobject.Get('SwornStatement', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Sworn Statement" := JsonToken.AsValue().AsBoolean();
                        if jsonobject.Get('SwornDate', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Sworn Date" := System.DT2Date(JsonToken.AsValue().AsDateTime());
                        if jsonobject.Get('ApplicantName', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Applicant Name" := JsonToken.AsValue().AsText();
                        if jsonobject.Get('RepresentedBy', JsonToken) and not JsonToken.AsValue().IsNull() then
                            VendorRegistrationDetailsTable."Represented By" := JsonToken.AsValue().AsText();
                    end;

                    if VendorRegistrationDetailsTable.Modify() then
                        exit(Format(AddResponseHead(Outputjson, true)));
                end;
                VendorRegistrationDetailsTable.Init();
                if jsonobject.Get('VendorID', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorRegistrationDetailsTable."Vendor ID" := JsonToken.AsValue().AsText();
                if jsonobject.Get('BusinessName', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorRegistrationDetailsTable."Business Name" := JsonToken.AsValue().AsText();
                if jsonobject.Get('PostalAddress', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorRegistrationDetailsTable."Postal Address" := JsonToken.AsValue().AsText();
                if jsonobject.Get('Town', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorRegistrationDetailsTable.Town := JsonToken.AsValue().AsText();
                if jsonobject.Get('Street', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorRegistrationDetailsTable.Street := JsonToken.AsValue().AsText();
                if jsonobject.Get('BuildingName', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorRegistrationDetailsTable."Buiding Name" := JsonToken.AsValue().AsText();
                if jsonobject.Get('OfficeRoomNumber', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorRegistrationDetailsTable."Office/Room Number" := JsonToken.AsValue().AsText();
                if jsonobject.Get('FloorNumber', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorRegistrationDetailsTable."Floor Number" := JsonToken.AsValue().AsText();
                if jsonobject.Get('TelephoneNumber', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorRegistrationDetailsTable."Telephone Number" := JsonToken.AsValue().AsText();
                if jsonobject.Get('EmailAddress', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorRegistrationDetailsTable."Email Address" := JsonToken.AsValue().AsText();
                if jsonobject.Get('ManagementPersonnel', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorRegistrationDetailsTable."Management Personnel" := JsonToken.AsValue().AsText();
                if jsonobject.Get('ChiefExecutive', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorRegistrationDetailsTable."Chief Executive" := JsonToken.AsValue().AsText();
                if jsonobject.Get('Secretary', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorRegistrationDetailsTable.Secretary := JsonToken.AsValue().AsText();
                if jsonobject.Get('GeneralManager', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorRegistrationDetailsTable."General Manager" := JsonToken.AsValue().AsText();
                if jsonobject.Get('BusinessFounded', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorRegistrationDetailsTable."Founded On" := JsonToken.AsValue().AsText();
                if jsonobject.Get('TechnologicalInnovation', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorRegistrationDetailsTable."Technological Innovation" := JsonToken.AsValue().AsText();
                if RequestJson.Get('BusinessProbity', JsonToken) then begin
                    jsonobject := JsonToken.AsObject();
                    if jsonobject.Get('BusinessPremises', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Business Premises" := JsonToken.AsValue().AsText();
                    if jsonobject.Get('PlotNumber', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Plot Number" := JsonToken.AsValue().AsText();
                    if jsonobject.Get('StreetRoad', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Street Road" := JsonToken.AsValue().AsText();
                    if jsonobject.Get('ProbityPostalAddress', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Probity Postal Address" := JsonToken.AsValue().AsText;
                    if jsonobject.Get('ProbityTelephone', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Probity Telephone" := JsonToken.AsValue().AsText();
                    if jsonobject.Get('ProbityEmail', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Probity Email" := JsonToken.AsValue().AsText();
                    if jsonobject.Get('NatureOfBusiness', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Nature of Business" := JsonToken.AsValue().AsText();
                    if jsonobject.Get('TradeLicenseNumber', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Trade License Number" := JsonToken.AsValue().AsText();
                    if jsonobject.Get('LicenseExpiry', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Trade License Expiry Date" := System.DT2Date(JsonToken.AsValue().AsDateTime());
                    if jsonobject.Get('MaxBusinessValue', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Max Business Value" := JsonToken.AsValue().AsDecimal();
                    if jsonobject.Get('BankName', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Bank Name" := JsonToken.AsValue().AsText();
                    if jsonobject.Get('AccountName', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Account Name" := JsonToken.AsValue().AsText();
                    if jsonobject.Get('AccountNumber', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Account Number" := JsonToken.AsValue().AsText();
                    if jsonobject.Get('BankBranch', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Bank Branch" := JsonToken.AsValue().AsText();
                    if jsonobject.Get('SwiftCode', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Swift Code" := JsonToken.AsValue().AsText();
                    if jsonobject.Get('BranchCode', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Branch Code" := JsonToken.AsValue().AsText();
                    if jsonobject.Get('BankCurrency', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Bank Currency" := JsonToken.AsValue().AsText();
                    if jsonobject.Get('PrivateCompany', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Private Company" := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('PublicCompany', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Public Company" := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('NominalCapital', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Nominal Capital" := JsonToken.AsValue().AsDecimal();
                    if jsonobject.Get('IssuedCapital', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Issued Capital" := JsonToken.AsValue().AsDecimal();
                end;
                if RequestJson.Get('SupplyCategories', JsonToken) then begin
                    jsonobject := JsonToken.AsObject();
                    if jsonobject.Get('Cat_A1_OfficeStationery', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_A1_Office_Stationery := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_A2_PrintedStationery', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_A2_PrintedStationery := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_A3_MineralWater', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_A3_MineralWater := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_A4_ComputerAccessories', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_A4_ComputerAccessories := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_A5_BrandedTShirts', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_A5_BrandedTShirts := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_A6_FurnitureFittings', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_A6_FurnitureFittings := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_A7_MetallicCabinets', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_A7_MetallicCabinets := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_A8_MoneyCountingMachines', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_A8_MoneyCountingMachines := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_A9_Photocopier', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_A9_Photocopier := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_A10_SupplyofPrinters', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_A10_SupplyofPrinters := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_A11_FirewallNetworkSwitches', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_A11_FirewallNetwork := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_A12_CallCenter', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_A12_CallCenter := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_B13_OfficeCleaning', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_B13_OfficeCleaning := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_B14_TimeLockServicing', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_B14_TimeLockServicing := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_B15_FireExtinguishers', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_B15_FireExtinguishers := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_B16_PhotocopierMachine', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_B16_PhotocopierMachine := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_B17_MotorVehicleBikes', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_B17_MotorVehicleBikes := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_B18_Printers', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_B18_Printers := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_B19_Generators', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_B19_Generators := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_B20_MoneyCountingMachines', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_B20_MoneyCountingMachines := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_B21_SanitaryDisposal', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_B21_SanitaryDisposal := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_B22_SecurityGuarding', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_B22_SecurityGuarding := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_B23_TeamBuilding', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_B23_TeamBuilding := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_B24_StructuredCabling', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_B24_StructuredCabling := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_B25_OfficePartitioning', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_B25_OfficePartitioning := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_B26_OutsideCatering', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_B26_OutsideCatering := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_B27_Electrical', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_B27_Electrical := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_B28_PlumbingDrainage', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_B28_PlumbingDrainage := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_B29_GeneralRepairs', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_B29_GeneralRepairs := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_B30_CarTracking', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_B30_CarTracking := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_B31_BulkSMS', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_B31_BulkSMS := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_B32_AssetTagging', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_B32_AssetTagging := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_B33_DesignArtwork', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_B33_DesignArtwork := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_B34_InsuranceCovers', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_B34_InsuranceCovers := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_C35_SystemAudit', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_C35_SystemAudit := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_C36_ExternalAuditors', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_C36_ExternalAuditors := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_C37_DebtCollectors', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_C37_DebtCollectors := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_C38_Valuers', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_C38_Valuers := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_C39_Auctioneers', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_C39_Auctioneers := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_C40_CashTransit', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_C40_CashTransit := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_C41_LegalServices', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_C41_LegalServices := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_C42_ProfessionalConsultancy', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_C42_Consultancy := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_C43_QuantitySurveyors', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_C43_QuantitySurveyors := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('Cat_C44_CCTVMaintenance', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable.Cat_C44_CCTVMaintenance := JsonToken.AsValue().AsBoolean();
                end;
                if RequestJson.Get('FinancialDetails', JsonToken) then begin
                    jsonobject := JsonToken.AsObject();
                    if jsonobject.Get('CreditPeriod', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Credit Period" := JsonToken.AsValue().AsText();
                    if jsonobject.Get('FinancialCapability', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Financial Capability" := JsonToken.AsValue().AsText();
                end;

                if RequestJson.Get('Declarations', JsonToken) then begin
                    jsonobject := JsonToken.AsObject();
                    if jsonobject.Get('CodeOfConduct', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Code of Conduct" := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('DeclarantName', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Declarant Name" := JsonToken.AsValue().AsText();
                    if jsonobject.Get('DeclarantPosition', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Declarant Position" := JsonToken.AsValue().AsText();
                    if jsonobject.Get('DeclarationDate', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Declaration Date" := System.DT2Date(JsonToken.AsValue().AsDateTime());
                    if jsonobject.Get('SwornStatement', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Sworn Statement" := JsonToken.AsValue().AsBoolean();
                    if jsonobject.Get('SwornDate', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Sworn Date" := System.DT2Date(JsonToken.AsValue().AsDateTime());
                    if jsonobject.Get('ApplicantName', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Applicant Name" := JsonToken.AsValue().AsText();
                    if jsonobject.Get('RepresentedBy', JsonToken) and not JsonToken.AsValue().IsNull() then
                        VendorRegistrationDetailsTable."Represented By" := JsonToken.AsValue().AsText();
                end;
                if VendorRegistrationDetailsTable.Insert() then
                    exit(Format(AddResponseHead(Outputjson, true)));
            end;
        end;
        exit(Format(AddResponseHead(Outputjson, false)));
    end;

    local procedure UpdateVendorStatus(VendorID: Code[50]; Status: Integer): Text
    begin
        VendorRegistrationDetailsTable.Reset();
        if VendorRegistrationDetailsTable.Get(VendorID) then begin
            VendorRegistrationDetailsTable.Status := Status;
            if VendorRegistrationDetailsTable.Modify() then
                exit(Format(AddResponseHead(Outputjson, true)));
        end;
    end;



    local procedure GetRFQDetails(QuoteNo: Code[50]; VendorID: code[50]): Text
    var
        datajson: JsonObject;
        jsonobject: JsonObject;
        jsonarray: JsonArray;
    begin
        Clear(datajson);
        "Procurement List".Reset();
        "Procurement List".SetRange("No.", QuoteNo);
        if "Procurement List".Find('-') then begin
            datajson.Add('RFQNo', "Procurement List"."No.");
            datajson.Add('Title', "Procurement List".Title);
            datajson.Add('Status', Format("Procurement List".Status));
            datajson.Add('DeadlineDate', CreateDateTime("Procurement List"."RFQ Deadlne Date", "Procurement List"."RFQ Deadline Time"));
            datajson.Add('CreationDate', "Procurement List"."Creation Date");

            Clear(jsonarray);
            RFQVendorBids.Reset();
            RFQVendorBids.SetRange("Quote No", QuoteNo);
            RFQVendorBids.SetRange("Vendor No", VendorID);
            if RFQVendorBids.FindSet() then begin
                repeat
                    Clear(jsonobject);
                    jsonobject.Add('LineNo', RFQVendorBids."Line No");
                    jsonobject.Add('ItemDescription', RFQVendorBids.Description);
                    jsonobject.Add('Quantity', RFQVendorBids.Quantity);
                    jsonobject.Add('UnitPrice', RFQVendorBids."Unit Price");
                    jsonobject.Add('VATAmount', RFQVendorBids."VAT %");
                    jsonobject.Add('TotalAmount', RFQVendorBids."Quoted Amount");
                    jsonarray.Add(jsonobject);
                until RFQVendorBids.Next() = 0;
                datajson.Add('submitted', true);
                datajson.Add('RFQLines', jsonarray);
            end else begin
                "Procurement Lines".Reset();
                "Procurement Lines".SetRange("Procurement No", QuoteNo);
                if "Procurement Lines".FindSet() then begin
                    repeat
                        Clear(jsonobject);
                        jsonobject.Add('LineNo', "Procurement Lines"."Line No.");
                        jsonobject.Add('ItemDescription', "Procurement Lines".Description);
                        jsonobject.Add('Quantity', "Procurement Lines".Quantity);
                        jsonobject.Add('UnitPrice', 0);
                        jsonobject.Add('VATAmount', 0);
                        jsonobject.Add('TotalAmount', 0);
                        jsonarray.Add(jsonobject);
                    until "Procurement Lines".Next() = 0;
                    datajson.Add('RFQLines', jsonarray);
                end;
            end;

            Clear(jsonarray);
            SharePointTable.Reset();
            SharePointTable.SetRange(Owner, VendorID);
            SharePointTable.SetRange("Document No", QuoteNo);
            if SharePointTable.FindSet() then
                repeat
                    Clear(jsonobject);
                    jsonobject.Add('serverUploadPath', SharePointTable.Base_URL);
                    jsonobject.Add('line_no', SharePointTable."Entry No");
                    jsonobject.Add('FileName', SharePointTable."Original File Name");
                    jsonobject.Add('FileType', SharePointTable."File Extension");
                    jsonarray.Add(jsonobject);
                until SharePointTable.Next() = 0;
            datajson.Add('RFQfiles', jsonarray);

            Outputjson.Add('RFQDetails', datajson);
            exit(Format(AddResponseHead(Outputjson, true)));
        end;
        exit(Format(AddResponseHead(Outputjson, false)));
    end;

    local procedure InsertDPRVendorBID(Requestjson: JsonObject; vendorNumber: code[50]): Text
    var
        SelectedVendors: Record "Quotation Bidders";
    begin
        Clear(Outputjson);
        Requestjson.Get('QuoteNo', JsonToken);
        "Procurement List".SetRange("No.", JsonToken.AsValue().AsCode());
        if "Procurement List".Find('-') then begin
            RFQVendorBids.Reset();
            if Requestjson.Get('LineNo', JsonToken) then
                RFQVendorBids.SetRange("Line No", JsonToken.AsValue().AsInteger());
            RFQVendorBids.SetRange("Quote No", "Procurement List"."No.");
            RFQVendorBids.SetRange("Vendor No", vendorNumber);
            if RFQVendorBids.Find('-') then begin
                if Requestjson.Get('UnitPrice', JsonToken) then
                    RFQVendorBids."Unit Price" := JsonToken.AsValue().AsDecimal();
                if Requestjson.Get('VATAmount', JsonToken) then
                    RFQVendorBids."VAT %" := JsonToken.AsValue().AsDecimal();
                if Requestjson.Get('TotalAmount', JsonToken) then
                    RFQVendorBids."Quoted Amount" := JsonToken.AsValue().AsDecimal();
                if RFQVendorBids.Modify() then begin
                    SelectedVendors.Reset();
                    SelectedVendors.SetRange("Vendor No.", vendorNumber);
                    SelectedVendors.SetRange("Reference No", "Procurement List"."No.");
                    if not SelectedVendors.Find('-') then begin
                        SelectedVendors.Init();
                        SelectedVendors."Vendor No." := vendorNumber;
                        SelectedVendors."Reference No" := "Procurement List"."No.";
                        SelectedVendors.Validate("Vendor No.");
                        SelectedVendors.Insert();
                    end;
                    exit(Format(AddResponseHead(Outputjson, true)));
                end;
            end else begin
                if Requestjson.Get('LineNo', JsonToken) and not JsonToken.AsValue().IsNull then begin
                    if "Procurement Lines".Get("Procurement List"."No.", JsonToken.AsValue().AsInteger()) then begin
                        RFQVendorBids.INIT;
                        RFQVendorBids."Line No" := "Procurement Lines"."Line No.";
                        RFQVendorBids."Quote No" := "Procurement List"."No.";
                        RFQVendorBids."Vendor No" := vendorNumber;
                        RFQVendorBids.VALIDATE("Vendor No");
                        RFQVendorBids."Item No" := "Procurement Lines".No;
                        RFQVendorBids.VALIDATE("Item No");
                        RFQVendorBids.Description := COPYSTR("Procurement Lines".Description, 1, 250);
                        RFQVendorBids.Quantity := "Procurement Lines".Quantity;
                        if Requestjson.Get('UnitPrice', JsonToken) then
                            RFQVendorBids."Unit Price" := JsonToken.AsValue().AsDecimal();
                        if Requestjson.Get('VATAmount', JsonToken) then
                            RFQVendorBids."VAT %" := JsonToken.AsValue().AsDecimal();
                        if Requestjson.Get('TotalAmount', JsonToken) then
                            RFQVendorBids."Quoted Amount" := JsonToken.AsValue().AsDecimal();
                        if RFQVendorBids.INSERT then begin
                            SelectedVendors.Reset();
                            SelectedVendors.SetRange("Vendor No.", vendorNumber);
                            SelectedVendors.SetRange("Reference No", "Procurement List"."No.");
                            if not SelectedVendors.Find('-') then begin
                                SelectedVendors.Init();
                                SelectedVendors."Vendor No." := vendorNumber;
                                SelectedVendors."Reference No" := "Procurement List"."No.";
                                SelectedVendors.Validate("Vendor No.");
                                SelectedVendors.Insert();
                            end;
                            exit(Format(AddResponseHead(Outputjson, true)));
                        end;
                    end;
                end;
            end;
        end;
        exit(Format(AddResponseHead(Outputjson, false)));
    end;

    local procedure InsertRFQVendorBID(Requestjson: JsonObject; vendorNumber: code[50]): Text
    begin
        Clear(Outputjson);
        Requestjson.Get('QuoteNo', JsonToken);
        "Procurement List".SetRange("No.", JsonToken.AsValue().AsCode());
        if "Procurement List".Find('-') then begin
            RFQVendorBids.Reset();
            if Requestjson.Get('LineNo', JsonToken) then
                RFQVendorBids.SetRange("Line No", JsonToken.AsValue().AsInteger());
            RFQVendorBids.SetRange("Quote No", "Procurement List"."No.");
            RFQVendorBids.SetRange("Vendor No", vendorNumber);
            if RFQVendorBids.Find('-') then begin
                if Requestjson.Get('UnitPrice', JsonToken) then
                    RFQVendorBids."Unit Price" := JsonToken.AsValue().AsDecimal();
                if Requestjson.Get('VATAmount', JsonToken) then
                    RFQVendorBids."VAT %" := JsonToken.AsValue().AsDecimal();
                if Requestjson.Get('TotalAmount', JsonToken) then
                    RFQVendorBids."Quoted Amount" := JsonToken.AsValue().AsDecimal();
                if RFQVendorBids.Modify() then
                    exit(Format(AddResponseHead(Outputjson, true)));
            end else begin
                if Requestjson.Get('LineNo', JsonToken) and not JsonToken.AsValue().IsNull then begin
                    if "Procurement Lines".Get("Procurement List"."No.", JsonToken.AsValue().AsInteger()) then begin
                        RFQVendorBids.INIT;
                        RFQVendorBids."Line No" := "Procurement Lines"."Line No.";
                        RFQVendorBids."Quote No" := "Procurement List"."No.";
                        RFQVendorBids."Vendor No" := vendorNumber;
                        RFQVendorBids.VALIDATE("Vendor No");
                        RFQVendorBids."Item No" := "Procurement Lines".No;
                        RFQVendorBids.VALIDATE("Item No");
                        RFQVendorBids.Description := COPYSTR("Procurement Lines".Description, 1, 250);
                        RFQVendorBids.Quantity := "Procurement Lines".Quantity;
                        if Requestjson.Get('UnitPrice', JsonToken) then
                            RFQVendorBids."Unit Price" := JsonToken.AsValue().AsDecimal();
                        if Requestjson.Get('VATAmount', JsonToken) then
                            RFQVendorBids."VAT %" := JsonToken.AsValue().AsDecimal();
                        if Requestjson.Get('TotalAmount', JsonToken) then
                            RFQVendorBids."Quoted Amount" := JsonToken.AsValue().AsDecimal();
                        if RFQVendorBids.INSERT then
                            exit(Format(AddResponseHead(Outputjson, true)));
                    end;
                end;
            end;
        end;
        exit(Format(AddResponseHead(Outputjson, false)));
    end;

    local procedure UpdateVendorNegotiatedBid(Requestjson: JsonObject; vendorNumber: code[50]): Text
    begin
        Clear(Outputjson);
        Requestjson.Get('QuoteNo', JsonToken);
        "Procurement List".Reset();
        "Procurement List".SetRange("No.", JsonToken.AsValue().AsCode());
        if "Procurement List".Find('-') then begin
            RFQVendorBids.Reset();
            if Requestjson.Get('LineNo', JsonToken) then
                RFQVendorBids.SetRange("Line No", JsonToken.AsValue().AsInteger());
            RFQVendorBids.SetRange("Quote No", "Procurement List"."No.");
            RFQVendorBids.SetRange("Vendor No", vendorNumber);
            if RFQVendorBids.Find('-') then begin
                // if not RFQVendorBids."Negotiation Requested" then begin
                //     Outputjson.Add('response_message', 'Negotiation has not been opened for this item.');
                //     exit(Format(AddResponseHead(Outputjson, false)));
                // end;

                // if Requestjson.Get('NegotiatedUnitPrice', JsonToken) then
                //     RFQVendorBids."Negotiated Unit Price" := JsonToken.AsValue().AsDecimal();
                // if Requestjson.Get('NegotiatedVATAmount', JsonToken) then
                //     RFQVendorBids."Negotiated VAT %" := JsonToken.AsValue().AsDecimal();
                // if Requestjson.Get('NegotiatedTotalAmount', JsonToken) then
                //     RFQVendorBids."Negotiated Amount" := JsonToken.AsValue().AsDecimal();
                // RFQVendorBids."Negotiated Submitted" := true;
                // RFQVendorBids."Negotiation Date" := CurrentDateTime;
                // if RFQVendorBids.Modify() then
                //     exit(Format(AddResponseHead(Outputjson, true)));
            end else begin
                Outputjson.Add('response_message', 'No existing bid found for this item.');
                exit(Format(AddResponseHead(Outputjson, false)));
            end;
        end;
        exit(Format(AddResponseHead(Outputjson, false)));
    end;

    local procedure InsertVendorDeliveryNote(RequestJson: JsonObject; VendorID: Code[50]): Text
    var
        VendorDeliveryNoteTable: Record "Vendor Delivery Note";
        VendorDeliveryNoteLineTable: Record "Vendor Delivery Note Line";
        ProcurementRequestRec: Record "Procurement Request";
        QuotationBiddersRec: Record "Quotation Bidders";
        LinesToken: JsonToken;
        LinesArray: JsonArray;
        LineToken: JsonToken;
        LineObject: JsonObject;
        ProcurementNo: Code[30];
        IsAwarded: Boolean;
        i: Integer;
        lineno: Integer;
    begin
        Clear(Outputjson);
        if not (RequestJson.Get('ProcurementNo', JsonToken) and not JsonToken.AsValue().IsNull()) then
            exit(Format(AddResponseHead(Outputjson, false)));
        ProcurementNo := JsonToken.AsValue().AsCode();

        ProcurementRequestRec.Reset();
        if not ProcurementRequestRec.Get(ProcurementNo) then
            exit(Format(AddResponseHead(Outputjson, false)));
        if ProcurementRequestRec."Generated Order No" = '' then
            exit(Format(AddResponseHead(Outputjson, false)));

        IsAwarded := (ProcurementRequestRec."Vendor No" = VendorID);
        if not IsAwarded then begin
            QuotationBiddersRec.Reset();
            QuotationBiddersRec.SetRange("Reference No", ProcurementNo);
            QuotationBiddersRec.SetRange("Vendor No.", VendorID);
            QuotationBiddersRec.SetRange("Award Vendor", true);
            IsAwarded := QuotationBiddersRec.FindFirst();
        end;
        if not IsAwarded then
            exit(Format(AddResponseHead(Outputjson, false)));

        VendorDeliveryNoteTable.Init();
        VendorDeliveryNoteTable."Procurement No" := ProcurementNo;
        VendorDeliveryNoteTable."Purchase Order No." := ProcurementRequestRec."Generated Order No";
        VendorDeliveryNoteTable."Vendor No" := VendorID;
        VendorDeliveryNoteTable.Validate("Vendor No");
        if RequestJson.Get('DeliveryNoteDate', JsonToken) and not JsonToken.AsValue().IsNull() then
            VendorDeliveryNoteTable."Delivery Note Date" := System.DT2Date(JsonToken.AsValue().AsDateTime());
        if RequestJson.Get('DocumentName', JsonToken) and not JsonToken.AsValue().IsNull() then
            VendorDeliveryNoteTable."Document Name" := JsonToken.AsValue().AsText();
        if RequestJson.Get('DocumentPath', JsonToken) and not JsonToken.AsValue().IsNull() then
            VendorDeliveryNoteTable."Document Path" := JsonToken.AsValue().AsText();
        VendorDeliveryNoteTable.Insert(true);

        if RequestJson.Get('Lines', LinesToken) then begin
            LinesArray := LinesToken.AsArray();
            for i := 0 to LinesArray.Count() - 1 do begin
                LinesArray.Get(i, LineToken);
                LineObject := LineToken.AsObject();
                VendorDeliveryNoteLineTable.Reset();
                if VendorDeliveryNoteLineTable.FindLast() then
                    lineno := VendorDeliveryNoteLineTable."Line No." + 10
                else
                    lineno := 10;
                VendorDeliveryNoteLineTable.Init();
                VendorDeliveryNoteLineTable."Line No." := lineno;
                VendorDeliveryNoteLineTable."Delivery Note No." := VendorDeliveryNoteTable."No.";
                if LineObject.Get('Description', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorDeliveryNoteLineTable.Description := CopyStr(JsonToken.AsValue().AsText(), 1, 250);
                if LineObject.Get('QuantityDelivered', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorDeliveryNoteLineTable."Quantity Delivered" := JsonToken.AsValue().AsDecimal();
                if LineObject.Get('UnitOfMeasure', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorDeliveryNoteLineTable."Unit of Measure" := JsonToken.AsValue().AsCode();
                VendorDeliveryNoteLineTable.Insert(true);
            end;
        end;

        Outputjson.Add('No', VendorDeliveryNoteTable."No.");
        exit(Format(AddResponseHead(Outputjson, true)));
    end;

    local procedure InsertVendorInvoice(RequestJson: JsonObject; VendorID: Code[50]): Text
    var
        VendorInvoiceTable: Record "Vendor Invoice";
        VendorInvoiceLineTable: Record "Vendor Invoice Line";
        ProcurementRequestRec: Record "Procurement Request";
        QuotationBiddersRec: Record "Quotation Bidders";
        LinesToken: JsonToken;
        LinesArray: JsonArray;
        LineToken: JsonToken;
        LineObject: JsonObject;
        ProcurementNo: Code[30];
        IsAwarded: Boolean;
        i: Integer;
        lineno: Integer;
    begin
        Clear(Outputjson);
        if not (RequestJson.Get('ProcurementNo', JsonToken) and not JsonToken.AsValue().IsNull()) then
            exit(Format(AddResponseHead(Outputjson, false)));
        ProcurementNo := JsonToken.AsValue().AsCode();

        ProcurementRequestRec.Reset();
        if not ProcurementRequestRec.Get(ProcurementNo) then
            exit(Format(AddResponseHead(Outputjson, false)));
        if ProcurementRequestRec."Generated Order No" = '' then
            exit(Format(AddResponseHead(Outputjson, false)));

        IsAwarded := (ProcurementRequestRec."Vendor No" = VendorID);
        if not IsAwarded then begin
            QuotationBiddersRec.Reset();
            QuotationBiddersRec.SetRange("Reference No", ProcurementNo);
            QuotationBiddersRec.SetRange("Vendor No.", VendorID);
            QuotationBiddersRec.SetRange("Award Vendor", true);
            IsAwarded := QuotationBiddersRec.FindFirst();
        end;
        if not IsAwarded then
            exit(Format(AddResponseHead(Outputjson, false)));

        VendorInvoiceTable.Init();
        VendorInvoiceTable."Procurement No" := ProcurementNo;
        VendorInvoiceTable."Purchase Order No." := ProcurementRequestRec."Generated Order No";
        VendorInvoiceTable."Vendor No" := VendorID;
        VendorInvoiceTable.Validate("Vendor No");
        if RequestJson.Get('DeliveryNoteNo', JsonToken) and not JsonToken.AsValue().IsNull() then
            VendorInvoiceTable."Delivery Note No." := JsonToken.AsValue().AsCode();
        if RequestJson.Get('VendorInvoiceNo', JsonToken) and not JsonToken.AsValue().IsNull() then
            VendorInvoiceTable."Vendor Invoice No." := JsonToken.AsValue().AsText();
        if RequestJson.Get('InvoiceDate', JsonToken) and not JsonToken.AsValue().IsNull() then
            VendorInvoiceTable."Invoice Date" := System.DT2Date(JsonToken.AsValue().AsDateTime());
        if RequestJson.Get('InvoiceAmount', JsonToken) and not JsonToken.AsValue().IsNull() then
            VendorInvoiceTable."Invoice Amount" := JsonToken.AsValue().AsDecimal();
        if RequestJson.Get('VATAmount', JsonToken) and not JsonToken.AsValue().IsNull() then
            VendorInvoiceTable."VAT Amount" := JsonToken.AsValue().AsDecimal();
        if RequestJson.Get('TotalAmount', JsonToken) and not JsonToken.AsValue().IsNull() then
            VendorInvoiceTable."Total Amount" := JsonToken.AsValue().AsDecimal();
        if RequestJson.Get('DocumentName', JsonToken) and not JsonToken.AsValue().IsNull() then
            VendorInvoiceTable."Document Name" := JsonToken.AsValue().AsText();
        if RequestJson.Get('DocumentPath', JsonToken) and not JsonToken.AsValue().IsNull() then
            VendorInvoiceTable."Document Path" := JsonToken.AsValue().AsText();
        VendorInvoiceTable.Insert(true);

        if RequestJson.Get('Lines', LinesToken) then begin
            LinesArray := LinesToken.AsArray();
            for i := 0 to LinesArray.Count() - 1 do begin
                LinesArray.Get(i, LineToken);
                LineObject := LineToken.AsObject();
                VendorInvoiceLineTable.Reset();
                if VendorInvoiceLineTable.FindLast() then
                    lineno := VendorInvoiceLineTable."Line No." + 10
                else
                    lineno := 10;
                VendorInvoiceLineTable.Init();
                VendorInvoiceLineTable."Line No." := lineno;
                VendorInvoiceLineTable."Invoice No." := VendorInvoiceTable."No.";
                if LineObject.Get('Description', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorInvoiceLineTable.Description := CopyStr(JsonToken.AsValue().AsText(), 1, 250);
                if LineObject.Get('Quantity', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorInvoiceLineTable.Quantity := JsonToken.AsValue().AsDecimal();
                if LineObject.Get('UnitPrice', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorInvoiceLineTable."Unit Price" := JsonToken.AsValue().AsDecimal();
                if LineObject.Get('Amount', JsonToken) and not JsonToken.AsValue().IsNull() then
                    VendorInvoiceLineTable.Amount := JsonToken.AsValue().AsDecimal();
                VendorInvoiceLineTable.Insert(true);
            end;
        end;

        Outputjson.Add('No', VendorInvoiceTable."No.");
        exit(Format(AddResponseHead(Outputjson, true)));
    end;

    local procedure GetVendorAwardedOrders(VendorID: Code[50]): Text
    var
        ProcurementRequestRec: Record "Procurement Request";
        QuotationBiddersRec: Record "Quotation Bidders";
        jsonobject: JsonObject;
        jsonarray: JsonArray;
        Added: Dictionary of [Code[30], Boolean];
    begin
        Clear(Outputjson);
        Clear(jsonarray);

        ProcurementRequestRec.Reset();
        ProcurementRequestRec.SetRange("Vendor No", VendorID);
        ProcurementRequestRec.SetRange("Procurement Method", ProcurementRequestRec."Procurement Method"::"Direct Procurement");
        ProcurementRequestRec.SetRange("Direct Procurement Status", ProcurementRequestRec."Direct Procurement Status"::"Order Created");
        if ProcurementRequestRec.FindSet() then
            repeat
                Clear(jsonobject);
                jsonobject.Add('No', ProcurementRequestRec."No.");
                jsonobject.Add('Title', ProcurementRequestRec.Title);
                jsonobject.Add('GeneratedOrderNo', ProcurementRequestRec."Generated Order No");
                jsonobject.Add('ProcurementMethod', Format(ProcurementRequestRec."Procurement Method"));
                jsonobject.Add('DateAwarded', ProcurementRequestRec."Date Awarded");
                jsonarray.Add(jsonobject);
                Added.Add(ProcurementRequestRec."No.", true);
            until ProcurementRequestRec.Next() = 0;

        QuotationBiddersRec.Reset();
        QuotationBiddersRec.SetRange("Vendor No.", VendorID);
        QuotationBiddersRec.SetRange("Award Vendor", true);
        if QuotationBiddersRec.FindSet() then
            repeat
                if not Added.ContainsKey(QuotationBiddersRec."Reference No") then begin
                    ProcurementRequestRec.Reset();
                    if ProcurementRequestRec.Get(QuotationBiddersRec."Reference No") then
                        if ProcurementRequestRec."Quotation Status" = ProcurementRequestRec."Quotation Status"::"Order Created" then begin
                            Clear(jsonobject);
                            jsonobject.Add('No', ProcurementRequestRec."No.");
                            jsonobject.Add('Title', ProcurementRequestRec.Title);
                            jsonobject.Add('GeneratedOrderNo', ProcurementRequestRec."Generated Order No");
                            jsonobject.Add('ProcurementMethod', Format(ProcurementRequestRec."Procurement Method"));
                            jsonobject.Add('DateAwarded', ProcurementRequestRec."Date Awarded");
                            jsonarray.Add(jsonobject);
                            Added.Add(ProcurementRequestRec."No.", true);
                        end;
                end;
            until QuotationBiddersRec.Next() = 0;

        Outputjson.Add('AwardedOrders', jsonarray);
        exit(Format(AddResponseHead(Outputjson, true)));
    end;

    local procedure GetVendorDeliveryNotes(VendorID: Code[50]): Text
    var
        VendorDeliveryNoteTable: Record "Vendor Delivery Note";
        VendorDeliveryNoteLineTable: Record "Vendor Delivery Note Line";
        jsonobject: JsonObject;
        jsonarray: JsonArray;
        linesarray: JsonArray;
        linesobject: JsonObject;
    begin
        Clear(Outputjson);
        Clear(jsonarray);
        VendorDeliveryNoteTable.Reset();
        VendorDeliveryNoteTable.SetRange("Vendor No", VendorID);
        if VendorDeliveryNoteTable.FindSet() then
            repeat
                Clear(jsonobject);
                jsonobject.Add('No', VendorDeliveryNoteTable."No.");
                jsonobject.Add('ProcurementNo', VendorDeliveryNoteTable."Procurement No");
                jsonobject.Add('PurchaseOrderNo', VendorDeliveryNoteTable."Purchase Order No.");
                jsonobject.Add('DeliveryNoteDate', VendorDeliveryNoteTable."Delivery Note Date");
                jsonobject.Add('DateSubmitted', VendorDeliveryNoteTable."Date Submitted");
                jsonobject.Add('Status', Format(VendorDeliveryNoteTable.Status));
                jsonobject.Add('Remarks', VendorDeliveryNoteTable.Remarks);
                jsonobject.Add('ApprovedDate', VendorDeliveryNoteTable."Approved Date");
                jsonobject.Add('DocumentName', VendorDeliveryNoteTable."Document Name");
                jsonobject.Add('DocumentPath', VendorDeliveryNoteTable."Document Path");

                Clear(linesarray);
                VendorDeliveryNoteLineTable.Reset();
                VendorDeliveryNoteLineTable.SetRange("Delivery Note No.", VendorDeliveryNoteTable."No.");
                if VendorDeliveryNoteLineTable.FindSet() then
                    repeat
                        Clear(linesobject);
                        linesobject.Add('Description', VendorDeliveryNoteLineTable.Description);
                        linesobject.Add('QuantityDelivered', VendorDeliveryNoteLineTable."Quantity Delivered");
                        linesobject.Add('UnitOfMeasure', VendorDeliveryNoteLineTable."Unit of Measure");
                        linesobject.Add('QuantityConfirmed', VendorDeliveryNoteLineTable."Quantity Confirmed");
                        linesobject.Add('QuantityVariance', VendorDeliveryNoteLineTable."Quantity Variance");
                        linesobject.Add('Condition', Format(VendorDeliveryNoteLineTable.Condition));
                        linesobject.Add('ConfirmationRemarks', VendorDeliveryNoteLineTable.Remarks);
                        linesarray.Add(linesobject);
                    until VendorDeliveryNoteLineTable.Next() = 0;
                jsonobject.Add('Lines', linesarray);

                jsonarray.Add(jsonobject);
            until VendorDeliveryNoteTable.Next() = 0;

        Outputjson.Add('DeliveryNotes', jsonarray);
        exit(Format(AddResponseHead(Outputjson, true)));
    end;

    local procedure GetVendorInvoices(VendorID: Code[50]): Text
    var
        VendorInvoiceTable: Record "Vendor Invoice";
        VendorInvoiceLineTable: Record "Vendor Invoice Line";
        jsonobject: JsonObject;
        jsonarray: JsonArray;
        linesarray: JsonArray;
        linesobject: JsonObject;
    begin
        Clear(Outputjson);
        Clear(jsonarray);
        VendorInvoiceTable.Reset();
        VendorInvoiceTable.SetRange("Vendor No", VendorID);
        if VendorInvoiceTable.FindSet() then
            repeat
                Clear(jsonobject);
                jsonobject.Add('No', VendorInvoiceTable."No.");
                jsonobject.Add('ProcurementNo', VendorInvoiceTable."Procurement No");
                jsonobject.Add('PurchaseOrderNo', VendorInvoiceTable."Purchase Order No.");
                jsonobject.Add('DeliveryNoteNo', VendorInvoiceTable."Delivery Note No.");
                jsonobject.Add('VendorInvoiceNo', VendorInvoiceTable."Vendor Invoice No.");
                jsonobject.Add('InvoiceDate', VendorInvoiceTable."Invoice Date");
                jsonobject.Add('DateSubmitted', VendorInvoiceTable."Date Submitted");
                jsonobject.Add('InvoiceAmount', VendorInvoiceTable."Invoice Amount");
                jsonobject.Add('VATAmount', VendorInvoiceTable."VAT Amount");
                jsonobject.Add('TotalAmount', VendorInvoiceTable."Total Amount");
                jsonobject.Add('Status', Format(VendorInvoiceTable.Status));
                jsonobject.Add('Remarks', VendorInvoiceTable.Remarks);
                jsonobject.Add('DocumentName', VendorInvoiceTable."Document Name");
                jsonobject.Add('DocumentPath', VendorInvoiceTable."Document Path");

                Clear(linesarray);
                VendorInvoiceLineTable.Reset();
                VendorInvoiceLineTable.SetRange("Invoice No.", VendorInvoiceTable."No.");
                if VendorInvoiceLineTable.FindSet() then
                    repeat
                        Clear(linesobject);
                        linesobject.Add('Description', VendorInvoiceLineTable.Description);
                        linesobject.Add('Quantity', VendorInvoiceLineTable.Quantity);
                        linesobject.Add('UnitPrice', VendorInvoiceLineTable."Unit Price");
                        linesobject.Add('Amount', VendorInvoiceLineTable.Amount);
                        linesarray.Add(linesobject);
                    until VendorInvoiceLineTable.Next() = 0;
                jsonobject.Add('Lines', linesarray);

                jsonarray.Add(jsonobject);
            until VendorInvoiceTable.Next() = 0;

        Outputjson.Add('Invoices', jsonarray);
        exit(Format(AddResponseHead(Outputjson, true)));
    end;

    local procedure UpdateVendorRegistrationPayment(RequestJson: JsonObject; VendorID: Code[50]): Text
    begin
        Clear(Outputjson);
        VendorRegistrationDetailsTable.Reset();
        if not VendorRegistrationDetailsTable.Get(VendorID) then
            exit(Format(AddResponseHead(Outputjson, false)));

        if RequestJson.Get('PaymentAmount', JsonToken) and not JsonToken.AsValue().IsNull() then
            VendorRegistrationDetailsTable."Payment Amount" := JsonToken.AsValue().AsDecimal();
        if RequestJson.Get('PaymentPhoneNumber', JsonToken) and not JsonToken.AsValue().IsNull() then
            VendorRegistrationDetailsTable."Payment Phone Number" := JsonToken.AsValue().AsText();
        if RequestJson.Get('MpesaReceiptNumber', JsonToken) and not JsonToken.AsValue().IsNull() then
            VendorRegistrationDetailsTable."Mpesa Receipt Number" := JsonToken.AsValue().AsText();
        if RequestJson.Get('PaymentDate', JsonToken) and not JsonToken.AsValue().IsNull() then
            VendorRegistrationDetailsTable."Payment Date" := System.DT2Date(JsonToken.AsValue().AsDateTime());
        if RequestJson.Get('CategoryCount', JsonToken) and not JsonToken.AsValue().IsNull() then
            VendorRegistrationDetailsTable."Category Count" := JsonToken.AsValue().AsInteger();
        VendorRegistrationDetailsTable."Payment Status" := VendorRegistrationDetailsTable."Payment Status"::Paid;

        if VendorRegistrationDetailsTable.Modify() then
            exit(Format(AddResponseHead(Outputjson, true)));
        exit(Format(AddResponseHead(Outputjson, false)));
    end;

    procedure UpdateVendorList()
    begin
        VendorRegistrationDetailsTable.Reset();
        if VendorRegistrationDetailsTable.Find('-') then
            repeat
                if VendorTable.get(VendorRegistrationDetailsTable."Vendor ID") then begin
                    VendorTable."E-Mail" := VendorRegistrationDetailsTable."Email Address";
                    VendorTable."Reg Status" := vendorRegistrationDetailsTable.Status;
                    VendorTable."Supplier Category" := '';
                    VendorTable."Secondary Supplier Category 1" := '';
                    VendorTable."Secondary Supplier Category 2" := '';
                    if VendorRegistrationDetailsTable.Cat_A1_Office_Stationery or VendorRegistrationDetailsTable.Cat_A2_PrintedStationery or VendorRegistrationDetailsTable.Cat_A3_MineralWater or VendorRegistrationDetailsTable.Cat_A4_ComputerAccessories or VendorRegistrationDetailsTable.Cat_A5_BrandedTShirts or VendorRegistrationDetailsTable.Cat_A6_FurnitureFittings or VendorRegistrationDetailsTable.Cat_A7_MetallicCabinets or VendorRegistrationDetailsTable.Cat_A8_MoneyCountingMachines or VendorRegistrationDetailsTable.Cat_A9_Photocopier or VendorRegistrationDetailsTable.Cat_A10_SupplyofPrinters or VendorRegistrationDetailsTable.Cat_A11_FirewallNetwork or VendorRegistrationDetailsTable.Cat_A12_CallCenter then begin
                        if VendorTable."Supplier Category" = '' then begin
                            if ((VendorTable."Secondary Supplier Category 1" <> 'CATEGORY A') AND ((VendorTable."Secondary Supplier Category 2" <> 'CATEGORY A'))) then
                                VendorTable."Supplier Category" := 'CATEGORY A';
                        end else begin
                            if VendorTable."Secondary Supplier Category 1" = '' then begin
                                if ((VendorTable."Supplier Category" <> 'CATEGORY A') AND ((VendorTable."Secondary Supplier Category 2" <> 'CATEGORY A'))) then
                                    VendorTable."Secondary Supplier Category 1" := 'CATEGORY A'
                            end else begin
                                if VendorTable."Secondary Supplier Category 2" = '' then
                                    if ((VendorTable."Supplier Category" <> 'CATEGORY A') AND ((VendorTable."Secondary Supplier Category 1" <> 'CATEGORY A'))) then
                                        VendorTable."Secondary Supplier Category 2" := 'CATEGORY A'
                            end;
                        end;
                    end;
                    if VendorRegistrationDetailsTable.Cat_B13_OfficeCleaning or VendorRegistrationDetailsTable.Cat_B14_TimeLockServicing or VendorRegistrationDetailsTable.Cat_B15_FireExtinguishers or VendorRegistrationDetailsTable.Cat_B16_PhotocopierMachine or VendorRegistrationDetailsTable.Cat_B17_MotorVehicleBikes or VendorRegistrationDetailsTable.Cat_B18_Printers or VendorRegistrationDetailsTable.Cat_B19_Generators or VendorRegistrationDetailsTable.Cat_B20_MoneyCountingMachines or VendorRegistrationDetailsTable.Cat_B21_SanitaryDisposal or VendorRegistrationDetailsTable.Cat_B22_SecurityGuarding or VendorRegistrationDetailsTable.Cat_B23_TeamBuilding or VendorRegistrationDetailsTable.Cat_B24_StructuredCabling or VendorRegistrationDetailsTable.Cat_B25_OfficePartitioning or VendorRegistrationDetailsTable.Cat_B26_OutsideCatering or VendorRegistrationDetailsTable.Cat_B27_Electrical or VendorRegistrationDetailsTable.Cat_B28_PlumbingDrainage or VendorRegistrationDetailsTable.Cat_B29_GeneralRepairs or VendorRegistrationDetailsTable.Cat_B30_CarTracking or VendorRegistrationDetailsTable.Cat_B31_BulkSMS or VendorRegistrationDetailsTable.Cat_B32_AssetTagging or VendorRegistrationDetailsTable.Cat_B33_DesignArtwork or VendorRegistrationDetailsTable.Cat_B34_InsuranceCovers then begin
                        if VendorTable."Supplier Category" = '' then begin
                            if ((VendorTable."Secondary Supplier Category 1" <> 'CATEGORY B') AND ((VendorTable."Secondary Supplier Category 2" <> 'CATEGORY B'))) then
                                VendorTable."Supplier Category" := 'CATEGORY B'
                        end else begin
                            if VendorTable."Secondary Supplier Category 1" = '' then begin
                                if ((VendorTable."Supplier Category" <> 'CATEGORY B') AND ((VendorTable."Secondary Supplier Category 2" <> 'CATEGORY B'))) then
                                    VendorTable."Secondary Supplier Category 1" := 'CATEGORY B'
                            end else begin
                                if VendorTable."Secondary Supplier Category 2" = '' then
                                    if ((VendorTable."Supplier Category" <> 'CATEGORY B') AND ((VendorTable."Secondary Supplier Category 1" <> 'CATEGORY B'))) then
                                        VendorTable."Secondary Supplier Category 2" := 'CATEGORY B'
                            end;
                        end;
                    end;
                    if VendorRegistrationDetailsTable.Cat_C35_SystemAudit or VendorRegistrationDetailsTable.Cat_C36_ExternalAuditors or VendorRegistrationDetailsTable.Cat_C37_DebtCollectors or VendorRegistrationDetailsTable.Cat_C38_Valuers or VendorRegistrationDetailsTable.Cat_C39_Auctioneers or VendorRegistrationDetailsTable.Cat_C40_CashTransit or VendorRegistrationDetailsTable.Cat_C41_LegalServices or VendorRegistrationDetailsTable.Cat_C42_Consultancy or VendorRegistrationDetailsTable.Cat_C43_QuantitySurveyors or VendorRegistrationDetailsTable.Cat_C44_CCTVMaintenance then begin
                        if VendorTable."Supplier Category" = '' then begin
                            if ((VendorTable."Secondary Supplier Category 1" <> 'CATEGORY C') AND ((VendorTable."Secondary Supplier Category 2" <> 'CATEGORY C'))) then
                                VendorTable."Supplier Category" := 'CATEGORY C'
                        end else begin
                            if VendorTable."Secondary Supplier Category 1" = '' then begin
                                if ((VendorTable."Supplier Category" <> 'CATEGORY C') AND ((VendorTable."Secondary Supplier Category 2" <> 'CATEGORY C'))) then
                                    VendorTable."Secondary Supplier Category 1" := 'CATEGORY C'
                            end else begin
                                if VendorTable."Secondary Supplier Category 2" = '' then
                                    if ((VendorTable."Supplier Category" <> 'CATEGORY C') AND ((VendorTable."Secondary Supplier Category 1" <> 'CATEGORY C'))) then
                                        VendorTable."Secondary Supplier Category 2" := 'CATEGORY C'
                            end;
                        end;
                    end;
                    VendorTable.Validate("Supplier Category");
                    VendorTable.Validate("Secondary Supplier Category 1");
                    VendorTable.Validate("Secondary Supplier Category 2");
                    VendorTable.Modify();
                end;
            until VendorRegistrationDetailsTable.Next() = 0;
    end;

    local procedure UploadSubmissionFiles(RequestJson: JsonObject): Text
    begin
        Clear(Outputjson);
        SharePointTable.Reset();
        SharePointTable.Init();
        if RequestJson.Get('serverUploadPath', JsonToken) and not JsonToken.AsValue().IsNull then
            SharePointTable.Base_URL := JsonToken.AsValue().AsText();
        if RequestJson.Get('elementNumber', JsonToken) and not JsonToken.AsValue().IsNull then
            SharePointTable."Document No" := JsonToken.AsValue().AsText();
        if RequestJson.Get('FileName', JsonToken) and not JsonToken.AsValue().IsNull then
            SharePointTable."Original File Name" := JsonToken.AsValue().AsText();
        if RequestJson.Get('FileType', JsonToken) and not JsonToken.AsValue().IsNull then
            SharePointTable."File Extension" := JsonToken.AsValue().AsText();
        if RequestJson.Get('FileOwner', JsonToken) and not JsonToken.AsValue().IsNull then
            SharePointTable.Owner := JsonToken.AsValue().AsText();
        if SharePointTable.Insert(true) then
            exit(Format(AddResponseHead(Outputjson, true)));
        exit(Format(AddResponseHead(Outputjson, false)));
    end;
}
