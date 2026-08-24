page 51083 "Partner Evaluation Card"
{
    SourceTable = RFA;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; Rec.No)
                {
                    Editable = false;
                }
                field(Title; Rec.Title)
                {
                }
                field(Currency; Rec.Currency)
                {
                }
                field(Type; Rec.Type)
                {
                }
                field(Stage; Rec.Stage)
                {
                }
                field("Awarded Amount"; Rec."Awarded Amount")
                {
                }
                field("Awarded Amount(LCY)"; Rec."Awarded Amount(LCY)")
                {
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                }
                field("Approved Amount (LCY)"; Rec."Approved Amount (LCY)")
                {
                }
                field("Created By"; Rec."Created By")
                {
                }
                field("Created On"; Rec."Created On")
                {
                }
                field("Published on Portal"; Rec."Publish to Portal")
                {
                    Editable = false;
                }
                field("Start Date"; Rec."Start Date")
                {
                }
                field("End Date"; Rec."End Date")
                {
                }
            }
            group("Grantor Information")
            {
                field(Donor; Rec.Donor)
                {
                }
                field("Name of Donor"; Rec."Name of Donor")
                {
                }
                field("Email of Donor"; Rec."Email of Donor")
                {
                }
                field("Address of Donor"; Rec."Address of Donor")
                {
                }
                field("Phone Number"; Rec."Phone Number")
                {
                }
            }
            part("Partner Scoring"; "Partner Scoring")
            {
                SubPageLink = RFA = FIELD(No);
            }
            part("Partner Bids"; "Approved Bids ListPart")
            {
                SubPageLink = RFA = FIELD(No);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Analysis Report")
            {
                Image = AnalysisView;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Report 18;
            }
            action("Send to Peer Review")
            {
                Image = SendTo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = AtPeerReview;

                trigger OnAction();
                begin
                    IF CONFIRM('Are you sure you want to send this RFA to peer review?', FALSE) = TRUE THEN BEGIN
                        Rec.Stage := Rec.Stage::"Peer Review";
                        Rec.MODIFY;
                        MESSAGE('RFA Successfully sent to the peer review stage');
                        CurrPage.CLOSE
                    END ELSE
                        ERROR('Process Aborted');
                end;
            }
            action("Send for Technical Review")
            {
                Image = SendTo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = AtTechnicalReview;

                trigger OnAction();
                begin
                    IF CONFIRM('Are you sure you want to send this RFA for Technical review?', FALSE) = TRUE THEN BEGIN
                        Rec.Stage := Rec.Stage::"Technical Review";
                        Rec.MODIFY;
                        MESSAGE('RFA Successfully sent to the technical review stage');
                        CurrPage.CLOSE
                    END ELSE
                        ERROR('Process Aborted');
                end;
            }
            action(Recommendations)
            {
                Image = Comment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "RFA Recommendation";
                RunPageLink = Stage = FIELD(Stage),
                              RFA = FIELD(No);
            }
        }
    }

    trigger OnOpenPage();
    begin
        AtPeerReview := FALSE;
        AtTechnicalReview := FALSE;
        IF Rec.Stage = Rec.Stage::Evaluation THEN AtPeerReview := TRUE;
        IF Rec.Stage = Rec.Stage::"Peer Review" THEN AtTechnicalReview := TRUE;
    end;

    var
        docname: Text;
        FileName2: Text;
        RFARec: Record "RFA";
        PartnerBids: Record "Partner Bids";
        AtPeerReview: Boolean;
        AtTechnicalReview: Boolean;
}
