page 51081 "Approved Bids ListPart"
{
    Caption = 'Placed Bids';
    PageType = ListPart;
    SourceTable = "Partner Bids";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Partner; Rec.Partner)
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(Email; Rec.Email)
                {
                }
                field(Phone; Rec.Phone)
                {
                }
                field(State; Rec.State)
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
                field("Approved Amount(LCY)"; Rec."Approved Amount(LCY)")
                {
                }
                field("Total Awarded Score"; Rec."Total Awarded Score")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Recommended for Funding")
            {
                Image = Certificate;

                trigger OnAction();
                begin
                    IF CONFIRM('Are you sure you want to recommend ' + Rec.Name + ' for funding?') = TRUE THEN BEGIN
                        PartnerBid.RESET;
                        PartnerBid.SETRANGE(Partner, Rec.Partner);
                        PartnerBid.SETRANGE(RFA, Rec.RFA);
                        IF PartnerBid.FIND('-') THEN BEGIN
                            PartnerBid.State := PartnerBid.State::"Recommend for Funding";
                            PartnerBid.MODIFY;
                        END;
                        MESSAGE('Success');
                    END ELSE
                        ERROR('Process Aborted');

                end;
            }
            action("Not Recommended for Funding")
            {
                Image = Cancel;

                trigger OnAction();
                begin
                    IF CONFIRM('Are you sure you do not want to recommend ' + Rec.Name + ' for funding?') = TRUE THEN BEGIN
                        PartnerBid.RESET;
                        PartnerBid.SETRANGE(Partner, Rec.Partner);
                        PartnerBid.SETRANGE(RFA, Rec.RFA);
                        IF PartnerBid.FIND('-') THEN BEGIN
                            PartnerBid.State := PartnerBid.State::"Not Recommend for Funding";
                            PartnerBid.MODIFY;
                        END;
                    END ELSE
                        ERROR('Process Aborted');

                end;
            }
            action("Record Scores")
            {
                Image = SerialNo;
            }
        }
    }

    var
        PartnerBid: Record "Partner Bids";
        ObjRfa: Record "RFA";
}
