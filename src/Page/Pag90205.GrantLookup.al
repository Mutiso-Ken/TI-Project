page 90205 "Grant Lookup"
{
    CardPageID = "Grant Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Grant Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field(Title; Rec.Title)
                {
                }
                field(Narration; Rec.Narration)
                {
                }
                field("Donor No."; Rec."Donor No.")
                {
                }
                field("Donor Name"; Rec."Donor Name")
                {
                }
                field("Created By"; Rec."Created By")
                {
                }
                field("Created Date"; Rec."Created Date")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    begin
        IF CloseAction IN [ACTION::OK, ACTION::LookupOK] THEN BEGIN
            GrantHeader.RESET;
            CurrPage.SETSELECTIONFILTER(GrantHeader);
            IF GrantHeader.FINDSET THEN BEGIN
                REPEAT
                    GrantLines.RESET;
                    GrantLines.SETRANGE("Grant No", GrantHeader."No.");
                    IF GrantLines.FINDSET THEN BEGIN
                        REPEAT
                            GrantLines1.INIT;
                            GrantLines1.TRANSFERFIELDS(GrantLines, FALSE);
                            GrantLines1."Grant No" := NewGrantNo;
                            GrantLines1.Code := GrantLines.Code;
                            GrantLines1."Line Type" := GrantLines."Line Type";
                            GrantLines1."Line No" := GrantLines."Line No";
                            Ok := GrantLines1.INSERT;
                        UNTIL GrantLines.NEXT = 0;
                    END;
                    GrantDetailLines.RESET;
                    GrantDetailLines.SETRANGE("Grant Code", GrantHeader."No.");
                    IF GrantDetailLines.FINDSET THEN BEGIN
                        REPEAT
                            GrantDetailLines1.INIT;
                            GrantDetailLines1.TRANSFERFIELDS(GrantDetailLines, FALSE);
                            GrantDetailLines1."Grant Code" := NewGrantNo;
                            GrantDetailLines1."Line Type" := GrantDetailLines."Line Type";
                            GrantDetailLines1.Code := GrantDetailLines.Code;
                            GrantDetailLines1."Line No." := GrantDetailLines."Line No.";
                            GrantDetailLines1."Entry No." := GrantDetailLines."Entry No.";
                            GrantDetailLines1."Transfered To Budget" := FALSE;
                            Ok := GrantDetailLines1.INSERT;
                        UNTIL GrantDetailLines.NEXT = 0;
                    END;
                    Message('Successfully transferred %1 lines', Format(GrantDetailLines.Count));
                UNTIL GrantHeader.NEXT = 0;
            END;
        END;
    end;

    var
        NewGrantNo: Code[20];
        GrantHeader: Record "Grant Header";
        GrantLines: Record "Grant Lines";
        GrantDetailLines: Record "Grant Detail Lines";
        GrantLines1: Record "Grant Lines";
        GrantDetailLines1: Record "Grant Detail Lines";
        Ok: Boolean;

    procedure SetGrantNo(GrantNo: Code[20]);
    begin
        NewGrantNo := GrantNo;
    end;
}
