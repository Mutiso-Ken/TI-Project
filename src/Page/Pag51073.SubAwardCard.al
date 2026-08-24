page 51073 "Sub Award Card"
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

                    trigger OnValidate();
                    begin
                        IF Rec.Type = Rec.Type::"Non-Competitive" THEN BEGIN
                            AwardedPartnerVisible := TRUE;
                            AwardPartnersAction := FALSE;
                        END ELSE BEGIN
                            AwardedPartnerVisible := FALSE;
                            AwardPartnersAction := TRUE;
                        END;
                        CurrPage.UPDATE;
                    end;
                }
                field(Stage; Rec.Stage)
                {
                }
                field("Awarded Partner"; Rec."Awarded Partner")
                {
                    Visible = AwardedPartnerVisible;
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
            part(Guidelines; "RFA Instructions")
            {
                Caption = 'Guidelines';
                SubPageLink = "RFA No" = FIELD(No);
            }
            part("Project Actvities"; "RFA Activities")
            {
                Caption = 'Project Actvities';
                SubPageLink = "RFA Code" = FIELD(No);
            }
            part("Expected Outcomes"; "RFA Outcomes")
            {
                Caption = 'Expected Outcomes';
                SubPageLink = RFA = FIELD(No);
            }
            part(Criteria; "RFA Criteria")
            {
                Caption = 'Criteria';
                SubPageLink = RFA = FIELD(No);
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Uploads")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Document Number" = FIELD("No");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Partner Bids")
            {
                Image = AddWatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction();
                begin
                    PartnerBids.SETFILTER(RFA, Rec.No);
                    PAGE.RUN(51078, PartnerBids);
                end;
            }
            action(Publish)
            {
                Image = Production;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    IF Rec.Type = Rec.Type::"Non-Competitive" THEN Rec.TESTFIELD("Awarded Partner");
                    DocAttachments.RESET;
                    DocAttachments.SETRANGE("No.", Rec.No);
                    IF DocAttachments.FIND('-') THEN
                        IF NOT DocAttachments."Document Reference ID".HASVALUE THEN ERROR('Kindly attach the Request for Application');
                    Rec."Publish to Portal" := TRUE;
                    Rec.Stage := Rec.Stage::Bidding;
                    Rec."Start Date" := TODAY;
                    Rec."End Date" := TODAY + 14;
                    Rec.MODIFY;
                    MESSAGE('Success. Bidding ends on ' + FORMAT(TODAY + 14));
                end;
            }
            action("Revoke Publish")
            {
                Image = Cancel;

                trigger OnAction();
                begin
                    Rec."Publish to Portal" := FALSE;
                    Rec.Stage := Rec.Stage::New;
                    Rec.MODIFY;
                    CurrPage.UPDATE;
                    MESSAGE('Success');
                end;
            }


            action("Select Partners")
            {
                Image = SelectEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Selected RFA Partners";
                RunPageLink = RFA = FIELD(No);
                Visible = AwardPartnersAction;
            }
        }
    }

    trigger OnOpenPage();
    begin
        IF Rec.Type = Rec.Type::"Non-Competitive" THEN BEGIN
            AwardedPartnerVisible := TRUE;
            AwardPartnersAction := FALSE;
        END ELSE BEGIN
            AwardedPartnerVisible := FALSE;
            AwardPartnersAction := TRUE;
        END;
    end;

    var
        docname: Text;
        FileName2: Text;
        RFARec: Record "RFA";
        PartnerBids: Record "Partner Bids";
        AwardedPartnerVisible: Boolean;
        AwardPartnersAction: Boolean;
        DocAttachments: Record "Document Attachment";
}
