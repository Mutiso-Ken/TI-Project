page 51065 "Proposals Card"
{

    PageType = Card;
    SourceTable = "Grant Funding Application";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Application No"; Rec."Application No")
                {
                    Editable = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field(Concept; Rec.Concept)
                {
                }
                field("FOA ID"; Rec."FOA ID")
                {
                }
                field("External Document No"; Rec."External Document No")
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                }
                field("Opportunity  Title"; Rec."Opportunity  Title")
                {
                    Editable = false;
                }
                field("Call Type"; Rec."Call Type")
                {
                    Editable = false;
                }
                field("Grant Type"; Rec."Grant Type")
                {
                }
                field("Justification for Application"; Rec."Justification for Application")
                {
                }
                field("Research Center"; Rec."Research Center")
                {
                }
                field("Primary Research Program ID"; Rec."Primary Research Program ID")
                {
                }
                field("Primary Research Area"; Rec."Primary Research Area")
                {
                }
                field("Grant Admin Team Code"; Rec."Grant Admin Team Code")
                {
                }
                field("Application Status"; Rec."Application Status")
                {
                    Editable = false;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                }
                field("Created By"; Rec."Created By")
                {
                    Editable = false;
                }
                field("Created On"; Rec."Created On")
                {
                    Editable = false;
                }
                field("Closed Date"; Rec."Closed Date")
                {
                }
            }
            group("Award Info")
            {
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Currency Code"; Rec."Currency Code")
                {

                    trigger OnAssistEdit();
                    begin
                        CLEAR(ChangeExchangeRate);
                        IF Rec."Posting Date" <> 0D THEN
                            ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", Rec."Posting Date")
                        ELSE
                            ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", WORKDATE);
                        IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                            Rec.VALIDATE("Currency Factor", ChangeExchangeRate.GetParameter);
                            CurrPage.UPDATE;
                        END;
                        CLEAR(ChangeExchangeRate);
                    end;

                    trigger OnValidate();
                    begin
                        CurrPage.SAVERECORD;
                    end;
                }
                field("Requested Grant Amount"; Rec."Requested Grant Amount")
                {
                }
                field("Requested Grant Amount(LCY)"; Rec."Requested Grant Amount(LCY)")
                {
                }
                field("Awarded Grant Amount"; Rec."Awarded Grant Amount")
                {
                }
                field("Awarded Grant Amount (LCY)"; Rec."Awarded Grant Amount (LCY)")
                {
                }
            }
            group("Deadlines && Dates")
            {
                field("Application Due Date"; Rec."Application Due Date")
                {
                }
                field("Application Submitted Date"; Rec."Application Submitted Date")
                {
                }
                field("Estimated Award Date"; Rec."Estimated Award Date")
                {
                }
            }
            group("Grantor Information")
            {
                field("Grantor No."; Rec."Grantor No.")
                {
                }
                field("Grantor Name"; Rec."Grantor Name")
                {
                    Editable = false;
                }
                field(Address; Rec.Address)
                {
                }
                field(Address2; Rec.Address2)
                {
                }
                field("Post Code"; Rec."Post Code")
                {
                }
                field(City; Rec.City)
                {
                }
                field("Phone No"; Rec."Phone No")
                {
                }
                field("Mobile Phone No"; Rec."Mobile Phone No")
                {
                }
                field("Grantor Research Contact ID"; Rec."Grantor Research Contact ID")
                {
                }
                field("Grantor Research Reviewer"; Rec."Grantor Research Reviewer")
                {
                    Editable = false;
                }
                field("Grantor Admin Contact ID"; Rec."Grantor Admin Contact ID")
                {
                }
                field("Grantor Admin Name"; Rec."Grantor Admin Name")
                {
                    Editable = false;
                }
                field("Grantor Finance Contact ID"; Rec."Grantor Finance Contact ID")
                {
                }
                field("Grantor Finance Contact"; Rec."Grantor Finance Contact")
                {
                    Editable = false;
                }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Uploads")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Document Number" = FIELD("Application No");
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Research Approval Committees")
            {
            }
        }
    }

    var
        ChangeExchangeRate: Page "Change Exchange Rate";
}
