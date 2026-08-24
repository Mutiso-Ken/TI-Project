#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
page 66003 "Procurement Setup"
{
    PageType = Card;
    SourceTable = "Procurement Setup";
    ApplicationArea = All;
    UsageCategory = Administration;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Procurement Officer User Id"; Rec."Procurement Officer User Id")
                {
                    ApplicationArea = All;
                }
            }
            group(Numbering)
            {
                field("Procurement Plan  Nos"; Rec."Procurement Plan  Nos")
                {
                    ApplicationArea = All;
                }
                field("Purchase Requisition Nos"; Rec."Purchase Requisition Nos")
                {
                    ApplicationArea = All;
                }
                field("Tender Nos"; Rec."Tender Nos")
                {
                    ApplicationArea = All;
                }
                field("Contract Nos"; Rec."Contract Nos")
                {
                }
                field("Quotation Nos"; Rec."Quotation Nos")
                {
                    ApplicationArea = All;
                }
                field("RFP Nos"; Rec."RFP Nos")
                {
                    ApplicationArea = All;
                }
                field("Direct Procurement Nos"; Rec."Direct Procurement Nos")
                {
                    ApplicationArea = All;
                }
            }
            group(Thresholds)
            {
                field("Tender Threshold"; Rec."Tender Threshold")
                {
                    ApplicationArea = All;
                }
                field("RFQ Threshold"; Rec."RFQ Threshold")
                {
                    ApplicationArea = All;
                }
                field("RFP Threshold"; Rec."RFP Threshold")
                {
                    ApplicationArea = All;
                }
                field("Direct Threshold"; Rec."Direct Threshold")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
