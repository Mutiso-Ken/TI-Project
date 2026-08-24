page 51089 "Partner Scoring"
{
    Editable = false;
    PageType = ListPart;
    SourceTable = "Partner Bids";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Bid Code"; Rec."Bid Code")
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
                field("Total Awarded Score"; Rec."Total Awarded Score")
                {
                    Caption = 'Total Score Awarded';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Score)
            {
                Image = AdjustEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    ObjRfa.GET(Rec.RFA);
                    ObjRFACriteria.RESET;
                    ObjRFACriteria.SETRANGE(ObjRFACriteria.RFA, Rec.RFA);
                    IF ObjRFACriteria.FIND('-') THEN BEGIN
                        REPEAT
                            ObjScores.RESET;
                            ObjScores.SETRANGE("RFA Criteria Code", ObjRFACriteria.Code);
                            IF NOT ObjScores.FIND('-') THEN BEGIN
                                ObjScores.INIT;
                                ObjScores."RFA Criteria Code" := ObjRFACriteria.Code;
                                ObjScores.Partner := Rec.Partner;
                                ObjScores.RFA := Rec.RFA;
                                ObjScores.Score := 0;
                                ObjScores.INSERT;
                            END;
                        UNTIL ObjRFACriteria.NEXT = 0;
                    END;
                    ObjScores.RESET;
                    ObjScores.SETRANGE(Partner, Rec.Partner);
                    ObjScores.SETRANGE(RFA, Rec.RFA);
                    IF ObjScores.FIND('-') THEN
                        PAGE.RUN(51090, ObjScores);
                end;
            }
        }
    }

    var
        ObjRfa: Record "RFA";
        ObjRFACriteria: Record "RFA Criteria";
        ObjScores: Record "Partner Criteria Awards";
}
