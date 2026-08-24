report 53061 "Quotation Per Suppliers"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Quotation Per Suppliers.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Quotation Bidders"; "Quotation Bidders")
        {
            column(ReferenceNo_QuotationBidders; "Quotation Bidders"."Reference No")
            {
            }
            column(VendorNo_QuotationBidders; "Quotation Bidders"."Vendor No.")
            {
            }
            column(VendorName_QuotationBidders; "Quotation Bidders"."Vendor Name")
            {
            }
            column(EmailAddress_QuotationBidders; "Quotation Bidders"."E-mail Address")
            {
            }
            column(PhoneNo_QuotationBidders; "Quotation Bidders"."Phone No")
            {
            }
            column(VendorCategory_QuotationBidders; "Quotation Bidders"."Vendor Category")
            {
            }
            column(TotalQuotedAmount_QuotationBidders; "Quotation Bidders"."Total Quoted Amount")
            {
            }
            column(RequisitionNo_QuotationBidders; "Quotation Bidders"."Requisition No.")
            {
            }
            column(RequisitionDate; RequisitionDate)
            {
            }
            column(RequestedBy; RequestedBy)
            {
            }
            column(RequestFor; RequestFor)
            {
            }
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
            column(Winning_Vendor; Winner)
            {
            }
            column(ReasonForAward; ReasonForAward)
            {
            }
            column(ReasonText; ReasonText)
            {
            }
            dataitem("RFQ Committee Members"; "RFQ Committee Members")
            {
                DataItemLink = "RFQ No." = FIELD("Reference No");
                column(RFQNo_RFQCommitteeMembers; "RFQ Committee Members"."RFQ No.")
                {
                }
                column(EmployeeNo_RFQCommitteeMembers; "RFQ Committee Members"."Employee No.")
                {
                }
                column(CommitteeUserID_RFQCommitteeMembers; "RFQ Committee Members"."Committee UserID")
                {
                }
                column(CommitteeMemberName_RFQCommitteeMembers; "RFQ Committee Members"."Committee Member Name")
                {
                }
                column(LineNo_RFQCommitteeMembers; "RFQ Committee Members"."Line No.")
                {
                }
                column(EmailSent_RFQCommitteeMembers; "RFQ Committee Members"."Email Sent")
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                ReasonText := '';
                ReasonForAward := '';
                ProcurementRequestLines.RESET;
                ProcurementRequestLines.SETRANGE("Procurement No", "Quotation Bidders"."Reference No");
                ProcurementRequestLines.SETFILTER("Vendor To Award", "Quotation Bidders"."Vendor No.");
                IF ProcurementRequestLines.FINDFIRST THEN BEGIN
                    Winner := 'WINNING BID/VENDOR';
                    ProcurementRequest.RESET;
                    ProcurementRequest.SETRANGE("No.", ProcurementRequestLines."Procurement No");
                    IF ProcurementRequest.FINDFIRST THEN BEGIN
                        ReasonText := 'Reason For Award :';
                        ReasonForAward := ProcurementRequest."Reason For Vendor Selection";
                    END;
                END ELSE BEGIN
                    Winner := '';
                END;
                "Quotation Bidders".CALCFIELDS("Requisition No.");
                ApprovalEntry.RESET;
                ApprovalEntry.SETRANGE("Document No.", "Quotation Bidders"."Requisition No.");
                ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Approved);
                ApprovalEntry.SETFILTER("Sequence No.", '%1', 1);
                IF ApprovalEntry.FINDFIRST THEN BEGIN
                    RequisitionDate := ApprovalEntry."Date-Time Sent for Approval";
                    RequestedBy := ApprovalEntry."Sender ID";
                END;
                RequisitionHeader.RESET;
                RequisitionHeader.SETRANGE("No.", "Quotation Bidders"."Requisition No.");
                IF RequisitionHeader.FINDFIRST THEN BEGIN
                    RequestFor := RequisitionHeader.Title;
                END;
            end;

            trigger OnPreDataItem();
            begin
                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(Picture);
            end;
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
        Winner: Text;
        ProcurementRequest: Record "Procurement Request";
        ProcurementRequestLines: Record "Procurement Request Lines";
        ReasonForAward: Text;
        ReasonText: Text;
        RequisitionHeader: Record "Purchase Header";
        RequisitionDate: DateTime;
        ApprovalEntry: Record "Approval Entry";
        RequestedBy: Code[50];
        RequestFor: Text;
}

