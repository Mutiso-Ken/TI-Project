page 90202 "Grant Lines"
{
    PageType = ListPart;
    SourceTable = "Grant Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                IndentationColumn = LineIndent;
                IndentationControls = "External Partner Code";
                field("Line Type"; Rec."Line Type")
                {
                    Style = Strong;
                    StyleExpr = isHeading;
                }
                field(Code; Rec.Code)
                {
                    Style = Strong;
                    StyleExpr = isHeading;
                }
                field("External Partner Code"; Rec."External Partner Code")
                {
                    Style = Strong;
                    StyleExpr = isHeading;
                }
                field(Description; Rec.Description)
                {
                    Style = Strong;
                    StyleExpr = isHeading;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
                field(ShortcutDimCode3; ShortcutDimCode[3])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = filter(false));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        Rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                }
                field(ShortcutDimCode5; ShortcutDimCode[5])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = filter(false));
                    Visible = DimVisible5;

                    trigger OnValidate();
                    begin
                        Rec.ValidateShortcutDimCode(5, ShortcutDimCode[5]);
                    end;
                }
                field(ShortcutDimCode6; ShortcutDimCode[6])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = filter(false));
                    Visible = DimVisible6;

                    trigger OnValidate();
                    begin
                        Rec.ValidateShortcutDimCode(6, ShortcutDimCode[6]);
                    end;
                }
                field(ShortcutDimCode7; ShortcutDimCode[7])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = filter(false));
                    Visible = DimVisible7;

                    trigger OnValidate();
                    begin
                        Rec.ValidateShortcutDimCode(7, ShortcutDimCode[7]);
                    end;
                }
                field(ShortcutDimCode8; ShortcutDimCode[8])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = filter(false));
                    Visible = DimVisible8;

                    trigger OnValidate();
                    begin
                        Rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);
                    end;
                }
                field(Budgeted; Rec.Budgeted)
                {
                    Style = Unfavorable;
                    StyleExpr = IsNotBudgeted;
                }
                field("Proposed Start Date"; Rec."Proposed Start Date")
                {
                }
                field("Proposed End Date"; Rec."Proposed End Date")
                {
                }
                field("Total Budget"; Rec."Total Budget")
                {
                }
                field(Totaling; Rec.Totaling)
                {
                }
                field("Target Description"; Rec."Target Description")
                {
                    ShowMandatory = IsActivity;
                    Style = Attention;
                    StyleExpr = IsActivity;
                }
                field("Target Indicator"; Rec."Target Indicator")
                {
                    ShowMandatory = IsActivity;
                    Style = Attention;
                    StyleExpr = IsActivity;
                }
                field("Achieved Target Description"; Rec."Achieved Target Description")
                {
                    ShowMandatory = IsActivity;
                    Style = Attention;
                    StyleExpr = IsActivity;
                }
                field("Achieved Target Number"; Rec."Achieved Target Number")
                {
                    ShowMandatory = IsActivity;
                    Style = Attention;
                    StyleExpr = IsActivity;
                }
                field("Objective Total"; Rec."Objective Total")
                {
                    Style = Favorable;
                    StyleExpr = TRUE;
                }
                field("Outcome Total"; Rec."Outcome Total")
                {
                    Style = Favorable;
                    StyleExpr = TRUE;
                }
                field("Output Total"; Rec."Output Total")
                {
                    Style = Favorable;
                    StyleExpr = TRUE;
                }
                field("Activity Total"; Rec."Activity Total")
                {
                    Style = Favorable;
                    StyleExpr = TRUE;
                }
                field("Available Budget"; AvailableBalance)
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Expenditure (%)"; Ratio)
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Import)
            {
                ApplicationArea = Basic;
                Caption = 'Import';
                Image = ImportExcel;
                RunObject = XMLport "Import Grants";

            }
            action(ExportToExcel)
            {
                ApplicationArea = All;
                Caption = 'Export';
                Image = ExportToExcel;
                Visible = false;
                trigger OnAction()
                var
                    ExcelBuffer: Record "Excel Buffer";
                    GrantsRec: Record "Grant Lines";
                begin
                    ExcelBuffer.Reset();
                    ExcelBuffer.DeleteAll();


                    ExcelBuffer.AddColumn('Line No', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('Line Type', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Grant No', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('Code', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn('External Partner Code', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Description', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

                    if GrantsRec.FindSet() then
                        repeat
                            ExcelBuffer.NewRow();
                            ExcelBuffer.AddColumn('Line No', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn('Line Type', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn('Grant No', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn('Code', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn('External Partner Code', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn('Description', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                        until GrantsRec.Next() = 0;
                    ExcelBuffer.CreateBookAndOpenExcel('Grants Export.xlsx', 'Grant Template', '', '', '');
                end;
            }

        }
    }

    trigger OnAfterGetRecord();
    begin
        LineIndent := Rec."Line Type";
        isHeading := (Rec."Line Type" <> Rec."Line Type"::Activity);
        Rec.CALCFIELDS(Budgeted);
        IF NOT isHeading THEN
            IsNotBudgeted := NOT Rec.Budgeted
        ELSE
            IsNotBudgeted := FALSE;
        CalculateAvailabilityRatios;
    end;

    trigger OnOpenPage();
    begin
        SetDimensionsVisibility;
    end;

    var
        LineIndent: Integer;
        isHeading: Boolean;
        IsNotBudgeted: Boolean;
        DimVisible1: Boolean;
        DimVisible2: Boolean;
        DimVisible3: Boolean;
        DimVisible4: Boolean;
        DimVisible5: Boolean;
        DimVisible6: Boolean;
        DimVisible7: Boolean;
        DimVisible8: Boolean;
        ShortcutDimCode: array[8] of Code[20];
        AvailableBalance: Decimal;
        Ratio: Decimal;
        IsActivity: Boolean;

    local procedure SetDimensionsVisibility();
    var
        DimMgt: Codeunit "DimensionManagement";
    begin
        DimVisible1 := FALSE;
        DimVisible2 := FALSE;
        DimVisible3 := FALSE;
        DimVisible4 := FALSE;
        DimVisible5 := FALSE;
        DimVisible6 := FALSE;
        DimVisible7 := FALSE;
        DimVisible8 := FALSE;

        DimMgt.UseShortcutDims(
          DimVisible1, DimVisible2, DimVisible3, DimVisible4, DimVisible5, DimVisible6, DimVisible7, DimVisible8);

        CLEAR(DimMgt);
    end;

    local procedure CalculateAvailabilityRatios();
    var
        BGT: Decimal;
    begin
        AvailableBalance := 0;
        IsActivity := FALSE;
        Ratio := 0;
        Rec.CALCFIELDS("Total Budget", "Activity Total", "Objective Total", "Outcome Total", "Output Total");
        BGT := Rec."Total Budget";
        IF BGT = 0 THEN
            BGT := 1;
        CASE Rec."Line Type" OF
            Rec."Line Type"::Objective:
                BEGIN
                    AvailableBalance := Rec."Total Budget" - Rec."Objective Total";
                    Ratio := Rec."Objective Total" / BGT;
                END;
            Rec."Line Type"::Outcome:
                BEGIN
                    AvailableBalance := Rec."Total Budget" - Rec."Outcome Total";
                    Ratio := Rec."Outcome Total" / BGT;
                END;
            Rec."Line Type"::Output:
                BEGIN
                    AvailableBalance := Rec."Total Budget" - Rec."Output Total";
                    Ratio := Rec."Output Total" / BGT;
                END;
            Rec."Line Type"::Activity:
                BEGIN
                    AvailableBalance := Rec."Total Budget" - Rec."Activity Total";
                    Ratio := Rec."Activity Total" / BGT;
                    IsActivity := TRUE;
                END;
        END;
        Ratio *= 100;
    end;
}
