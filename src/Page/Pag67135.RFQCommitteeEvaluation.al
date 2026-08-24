page 67135 "RFQ Committee Evaluation"
{
    PageType = List;
    AutoSplitKey = true;
    SourceTable = "RFQ Committee Evaluation";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("RFQ No."; Rec."RFQ No.")
                {
                    ApplicationArea = All;
                }
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Committee Member Name"; Rec."Committee Member Name")
                {
                    ApplicationArea = All;
                }
                field("Quoted Amount"; Rec."Quoted Amount")
                {
                    ApplicationArea = All;
                }
                field(Award; Rec.Award)
                {
                    ApplicationArea = All;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Get Bidders & Committee Members")
            {
                ApplicationArea = All;
                Image = Users;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    RFQCommitteeEvaluation: Record "RFQ Committee Evaluation";
                    RFQCommitteeMembers: Record "RFQ Committee Members";
                    ProcurementRequest: Record "Procurement Request";
                    QuotationBidders: Record "Quotation Bidders";
                begin
                    RFQCommitteeEvaluation.SetRange("RFQ No.", Rec."RFQ No.");
                    if RFQCommitteeEvaluation.FindSet() then
                        RFQCommitteeEvaluation.DeleteAll();

                    if not ProcurementRequest.Get(Rec."RFQ No.") then
                        exit;

                    QuotationBidders.SetRange("Reference No", ProcurementRequest."No.");
                    if not QuotationBidders.FindSet() then
                        exit;
                    repeat
                        RFQCommitteeMembers.SetRange("RFQ No.", QuotationBidders."Reference No");
                        if not RFQCommitteeMembers.FindSet() then
                            Error('The Procurement Committee List has not been filled for %1.', QuotationBidders."Reference No");
                        repeat
                            QuotationBidders.CalcFields("Total Quoted Amount");
                            RFQCommitteeEvaluation.Init();
                            RFQCommitteeEvaluation."RFQ No." := Rec."RFQ No.";
                            RFQCommitteeEvaluation."Line No." += 10;
                            RFQCommitteeEvaluation.No := Rec."RFQ No.";
                            RFQCommitteeEvaluation.Description := ProcurementRequest.Title;
                            RFQCommitteeEvaluation."Vendor No." := QuotationBidders."Vendor No.";
                            RFQCommitteeEvaluation."Vendor Name" := QuotationBidders."Vendor Name";
                            RFQCommitteeEvaluation."Quoted Amount" := QuotationBidders."Total Quoted Amount";
                            RFQCommitteeEvaluation."Committee Member ID" := RFQCommitteeMembers."Committee UserID";
                            RFQCommitteeEvaluation."Committee Member No" := RFQCommitteeMembers."Employee No.";
                            RFQCommitteeEvaluation."Committee Member Name" := RFQCommitteeMembers."Committee Member Name";
                            RFQCommitteeEvaluation.Insert();
                        until RFQCommitteeMembers.Next() = 0;
                    until QuotationBidders.Next() = 0;
                end;
            }
        }
    }
}
