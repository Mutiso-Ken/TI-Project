page 51079 "Partner Bids Card"
{
    SourceTable = "Partner Bids";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(RFA; Rec.RFA)
                {
                }
                field("RFA Description"; Rec."RFA Description")
                {
                    Editable = false;
                }
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
                field("Approval Status"; Rec."Approval Status")
                {
                }
            }
            group("Application Details")
            {
            }
            part("Partenr Activities Schedule"; "Partenr Activities Schedule")
            {
                SubPageLink = RFA = FIELD(RFA),
                              Partner = FIELD(Partner);
            }
            group("Budget Guidelines")
            {
                Caption = 'Budget Guidelines';
            }

        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Uploads")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Document Number" = FIELD("Bid Code");
            }
        }
    }

    actions
    {
        area(processing)
        {

            action("Place Bid")
            {
                Image = BinLedger;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    Rec."Approval Status" := Rec."Approval Status"::Approved;
                    Rec.MODIFY;
                    CurrPage.UPDATE;
                    MESSAGE('Success');
                end;
            }
        }
    }
}
