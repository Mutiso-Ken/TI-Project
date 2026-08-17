#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 80410 "Fund Budget"
{
    Caption = 'Dimension Values';
    DataCaptionFields = "Dimension Code";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Dimension Value";
    SourceTableView = sorting("Dimension Value ID")
                      order(ascending);

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                IndentationColumn = NameIndent;
                IndentationControls = Name;
                field("Fund Code";Rec."Fund Code")
                {
                    ApplicationArea = Basic;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Dimensions;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies the code for the dimension value.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Dimensions;
                    Style = Strong;
                    StyleExpr = Emphasize;
                    ToolTip = 'Specifies a descriptive name for the dimension value.';
                }
                field("Dimension Value Type"; Rec."Dimension Value Type")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the purpose of the dimension value.';
                }
                field(Totaling; Rec.Totaling)
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies an account interval or a list of account numbers. The entries of the account will be totaled to give a total balance. How entries are totaled depends on the value in the Account Type field.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        DimVal: Record "Dimension Value";
                        DimValList: Page "Dimension Value List";
                    begin
                        DimVal := Rec;
                        DimVal.SetRange("Dimension Code", Rec."Dimension Code");
                        DimValList.SetTableview(DimVal);
                        DimValList.LookupMode := true;
                        if DimValList.RunModal = Action::LookupOK then begin
                            DimValList.GetRecord(DimVal);
                            Text := DimVal.Code;
                            exit(true);
                        end;
                        exit(false);
                    end;
                }
                // field("G/L Account"; "G/L Account")
                // {
                //     ApplicationArea = Basic;
                // }
                // field("Budget Amount"; "Budget Amount")
                // {
                //     ApplicationArea = Basic;
                // }
                // field("Actual Spent"; "Actual Spent")
                // {
                //     ApplicationArea = Basic;
                //     Editable = false;
                // }
                // field(Variance; "Budget Amount" - "Actual Spent")
                // {
                //     ApplicationArea = Basic;
                //     Editable = false;
                // }
                // field("Date filter"; "Date filter")
                // {
                //     ApplicationArea = Basic;
                // }
                // field("%Utilisation"; BudgetPercent)
                // {
                //     ApplicationArea = Basic;
                // }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Indent Dimension Values")
                {
                    ApplicationArea = Dimensions;
                    Caption = 'Indent Dimension Values';
                    Image = Indent;
                    RunObject = Codeunit "Dimension Value-Indent";
                    RunPageOnRec = true;
                    ToolTip = 'Indent dimension values between a Begin-Total and the matching End-Total one level to make the list easier to read.';
                }
                // action("&Print")
                // {
                //     ApplicationArea = Basic;
                //     Caption = '&Print';
                //     Ellipsis = true;
                //     Image = Print;
                //     Promoted = true;
                //     PromotedCategory = Process;

                //     trigger OnAction()
                //     begin
                //           DimensionValue.Reset;
                //           DimensionValue.SetFilter(DimensionValue."Project Code","Project Code") ;
                //           if DimensionValue.Find('-') then
                //           Report.Run(80063,true,true,DimensionValue);
                //         // IF LinesCommitted THENDimension Code=CONST(BUDGETLINE),Project Code=FIELD(Code)
                //         //   ERROR('All Lines should be committed');
                //         //  RESET;
                //         //  SETRANGE("No.","No.");
                //         //  REPORT.RUN(80036,TRUE,TRUE,Rec);
                //         //  RESET;
                //         //DocPrint.PrintPurchHeader(Rec);
                //     end;
                // }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        NameIndent := 0;
        FormatLine;

        // if "Budget Amount" <> 0 then begin
        //     //IF ("Budget Amount"-"Actual Spent")<>0 THEN BEGIN
        //     BudgetPercent := ("Actual Spent" / "Budget Amount") * 100
        // end else begin
        //     BudgetPercent := 0;
        //     //END;
        // end;

        /*IF "Dimension Value Type"="Dimension Value Type"::"End-Total" THEN BEGIN
          DimensionValue.RESET;
          DimensionValue.SETFILTER(Code,Totaling);
          IF DimensionValue.FINDSET THEN BEGIN
            DimensionValue.CALCSUMS("Budget Amount","Actual Spent");
            "Budget Amount":=DimensionValue."Budget Amount";
            //"Actual Spent":=DimensionValue."Actual Spent";
            END;
        // //  END;*/
        // //  BudgetAmounts.RESET;
        // //  BudgetAmounts.SETRANGE("Budget Line Code",Code);
        // //  BudgetAmounts.SETFILTER(Date,'..%1',CALCDATE('1Y',TODAY));
        // //  IF BudgetAmounts.FIND('-') THEN BEGIN
        // //    "Year budget Amount":=BudgetAmounts."Budget Amount";
        // //      MODIFY;
        // //
        // //  END;

    end;

    trigger OnOpenPage()
    var
        DimensionCode: Code[20];
    begin
        if Rec.GetFilter("Dimension Code") <> '' then
            DimensionCode := Rec.GetRangeMin("Dimension Code");
        if DimensionCode <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Dimension Code", DimensionCode);
            Rec.FilterGroup(0);
        end;
    end;

    var
        [InDataSet]
        Emphasize: Boolean;
        [InDataSet]
        NameIndent: Integer;
        BudgetPercent: Decimal;
        "BudgetPercent(OtherCurrency)": Decimal;
        DimensionValue: Record "Dimension Value";
    //BudgetAmounts: Record UnknownRecord172058;

    local procedure FormatLine()
    begin
        // Emphasize := "Dimension Value Type" <> "dimension value type"::Standard;
        // NameIndent := Indentation;
    end;
}

