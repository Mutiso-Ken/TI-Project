namespace TISolution.TISolution;

page 57 "Vendor Quoted Amount Per Item"
{
    // version Procurement Iansoft

    PageType = List;
    SourceTable = "Quotation Vendors Bids";
    SourceTableView = SORTING("Quoted Amount")
                      ORDER(Ascending);
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vendor No"; Rec."Vendor No")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field("Line No"; Rec."Line No")
                {
                }
                field("Item No"; Rec."Item No")
                {
                }
                field("Item Name"; Rec."Item Name")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Unit Price"; Rec."Unit Price")
                {
                }
                field("Quoted Amount"; Rec."Quoted Amount")
                {
                    Editable = false;
                }
                field("VAT Inclusive"; Rec."VAT Inclusive")
                {
                }
                field("VAT Amount"; Rec."VAT %")
                {
                    Caption = 'VAT Amount';
                }
                field("Lead Time"; Rec."Lead Time")
                {
                }
                field("Quote No"; Rec."Quote No")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Populate Item Lines")
            {
                Image = GetLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin

                    QuotationVendorsBids.RESET;
                    QuotationVendorsBids.SETRANGE("Quote No", Rec."Quote No");
                    QuotationVendorsBids.SETRANGE("Vendor No", Rec."Vendor No");
                    IF QuotationVendorsBids.FINDFIRST THEN BEGIN
                        IF NOT CONFIRM('There are entries in the document that will be reset. Do you want to continue?') THEN
                            EXIT;
                        QuotationVendorsBids.DELETEALL;
                    END;

                    QuotationBidders.RESET;
                    QuotationBidders.SETRANGE("Reference No", Rec."Quote No");
                    QuotationBidders.SETRANGE("Vendor No.", Rec."Vendor No");
                    IF QuotationBidders.FINDFIRST THEN BEGIN
                        ProcurementRequestLines.RESET;
                        ProcurementRequestLines.SETRANGE("Procurement No", QuotationBidders."Reference No");
                        IF ProcurementRequestLines.FINDSET THEN BEGIN
                            REPEAT
                                QuotationVendorsBids.INIT;
                                QuotationVendorsBids."Line No" := ProcurementRequestLines."Line No.";
                                QuotationVendorsBids."Quote No" := QuotationBidders."Reference No";
                                QuotationVendorsBids."Vendor No" := QuotationBidders."Vendor No.";
                                QuotationVendorsBids.VALIDATE("Vendor No");
                                QuotationVendorsBids."Item No" := ProcurementRequestLines.No;
                                QuotationVendorsBids.VALIDATE("Item No");
                                QuotationVendorsBids.Description := COPYSTR(ProcurementRequestLines.Description, 1, 250);
                                QuotationVendorsBids.Quantity := ProcurementRequestLines.Quantity;
                                QuotationVendorsBids.INSERT;
                            UNTIL ProcurementRequestLines.NEXT = 0;
                        END;
                    END;
                end;
            }
        }
    }

    var
        ProcurementRequest: Record "Procurement Request";
        QuoteAmountEditable: Boolean;
        QuotationVendorsBids: Record "Quotation Vendors Bids";
        ProcurementRequestLines: Record "Procurement Request Lines";
        QuotationBidders: Record "Quotation Bidders";

    local procedure IanSetControlAppearance();
    begin
        IF ProcurementRequest.GET(Rec."Quote No") THEN BEGIN
            IF NOT (ProcurementRequest."Quotation Status" IN [ProcurementRequest."Quotation Status"::"Quote Submission"]) THEN
                QuoteAmountEditable := FALSE
            ELSE
                QuoteAmountEditable := TRUE;
        END;
    end;
}

