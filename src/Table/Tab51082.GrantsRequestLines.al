table 51082 "Grants Request Lines"
{
    fields
    {
        field(1; "Request No"; Code[35])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Account No"; Code[35])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No." WHERE("Account Type" = CONST(Posting),
                                                     "Direct Posting" = filter(true),
                                                     "Income/Balance" = FILTER("Income Statement"));

            trigger OnValidate();
            begin
                IanSoftFactory.FnDirectPostingControl("Account No");
                IF ("Account No" <> '') AND (Rec.ISEMPTY) THEN
                    Rec.INSERT;
                IF (xRec."Account No" <> Rec."Account No") THEN BEGIN
                    "Account Name" := '';
                    Unbudgeted := FALSE;
                    "Available Amount" := 0;
                    "Budgeted Amount" := 0;
                    "Total Expenditure" := 0;
                    "Commited Amount" := 0;
                END;

                IF GLAccount.GET("Account No") THEN BEGIN
                    "Account Name" := GLAccount.Name;
                    VALIDATE("Budget G/L Account", "Account No");
                END;
                IF RequestHeader.GET("Request No") THEN BEGIN
                    "Budget Code" := RequestHeader."Budget Code";

                    "Budgeted Amount" := IanSoftFactory.IanGetBudgetedAmount("Budget G/L Account", "Budget Code", '',
                                                                            RequestHeader."Global Dimension 1 Code");

                    "Total Expenditure" := IanSoftFactory.IanGetTotalExpenditure("Budget G/L Account", "Budget Code", '',
                                                                            RequestHeader."Global Dimension 1 Code");


                    "Commited Amount" := IanSoftFactory.IanGetCommittedAmount("Budget G/L Account", "Budget Code", '',
                                                                           RequestHeader."Global Dimension 1 Code") + AmountFromPreviousLines;
                    "Available Amount" := "Budgeted Amount" - ("Total Expenditure" + "Commited Amount");
                    AmountFromPreviousLines := 0;
                    RequestLines.RESET;
                    RequestLines.SETRANGE("Request No", "Request No");
                    RequestLines.SETRANGE("Account No", "Account No");
                    RequestLines.SETFILTER("Line No", '<>%1', "Line No");
                    IF RequestLines.FINDSET THEN BEGIN
                        RequestLines.CALCSUMS("Amount (LCY)");
                        AmountFromPreviousLines := RequestLines."Amount (LCY)";
                    END;
                    "Balance Before Entry" := "Budgeted Amount" - ("Total Expenditure" + AmountFromPreviousLines);

                    IF "Available Amount" < 0 THEN
                        "Available Amount" := 0;
                END ELSE BEGIN
                    "Account Name" := '';
                    Unbudgeted := FALSE;
                    "Available Amount" := 0;
                    "Budgeted Amount" := 0;
                    "Total Expenditure" := 0;
                    "Commited Amount" := 0;
                END;
                AmountFromPreviousLines := 0;
                RequestLines.RESET;
                RequestLines.SETRANGE("Request No", "Request No");
                RequestLines.SETRANGE("Account No", "Budget G/L Account");
                RequestLines.SETFILTER("Line No", '<>%1', "Line No");
                IF RequestLines.FINDFIRST THEN BEGIN
                    RequestLines.CALCSUMS("Amount (LCY)");
                    AmountFromPreviousLines := RequestLines."Amount (LCY)";
                END;

            end;
        }
        field(3; "Account Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Amount; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin

                IF Surrender THEN BEGIN
                    IF Amount > "Imprest Amount" THEN
                        ERROR('Amount cannot be higher than %1', "Imprest Amount");
                END;
                IF NOT Surrender THEN BEGIN

                    IF GLAccount.GET("Account No") THEN BEGIN
                        "Account Name" := GLAccount.Name;
                        IF RequestHeader.GET("Request No") THEN BEGIN
                            IF RequestHeader."Request Type" <> RequestHeader."Request Type"::Accounting THEN
                                RequestHeader.TESTFIELD("Global Dimension 1 Code");
                            RequestHeader.TESTFIELD("Budget Code");
                            "Budget Code" := RequestHeader."Budget Code";
                        END;
                        "Account Name" := GLAccount.Name;
                        AmountFromPreviousLines := 0;
                        "Budgeted Amount" := IanSoftFactory.IanGetBudgetedAmount("Account No", "Budget Code", '',
                                                                                RequestHeader."Global Dimension 1 Code");
                        "Total Expenditure" := ABS(IanSoftFactory.IanGetTotalExpenditure("Account No", "Budget Code", '',
                                                                                RequestHeader."Global Dimension 1 Code"));

                        AmountFromPreviousLines := IanGetAmountFromPreviousLines("Account No", "Request No", "Line No");

                        "Commited Amount" := IanSoftFactory.IanGetCommittedAmount("Account No", "Budget Code", '',
                                                                               RequestHeader."Global Dimension 1 Code") + AmountFromPreviousLines;
                        "Balance Before Entry" := "Budgeted Amount" - ("Total Expenditure" + AmountFromPreviousLines);
                        "Available Amount" := "Budgeted Amount" - ("Total Expenditure" + "Commited Amount");
                        IF "Available Amount" < 0 THEN
                            "Available Amount" := 0;
                    END;

                END;

                IF RequestHeader.GET("Request No") THEN BEGIN
                    IF RequestHeader."Currency Code" = '' THEN
                        "Amount (LCY)" := Amount;
                    IF RequestHeader."Currency Code" <> '' THEN
                        "Amount (LCY)" := Amount * RequestHeader."Exchange Rate";
                END;

                VALIDATE("Amount (LCY)");
                "Balance Less Entry" := "Balance Before Entry" - "Amount (LCY)";
            end;
        }
        field(6; "Amount (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin

                IF NOT Surrender THEN BEGIN
                    IF "Amount (LCY)" > "Available Amount" THEN BEGIN
                        Unbudgeted := TRUE;
                    END;
                END;

                IF "PD Transaction Code" <> '' THEN BEGIN

                    "Net Allowance Amount" := Amount;

                END;
            end;
        }
        field(7; "Exchange Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; Surrender; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Line No"; Integer)
        {
            AutoIncrement = false;
            DataClassification = ToBeClassified;
        }
        field(10; "Budget Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Available Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Budgeted Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Commited Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Total Expenditure"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; Unbudgeted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "From Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "To Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Imprest Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "From Imprest"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Transaction Type"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Types".Code WHERE("Source Type" = CONST(Imprest));

            trigger OnValidate();
            begin
                IF PTypes.GET("Transaction Type") THEN BEGIN
                    VALIDATE("Account No", PTypes."G/L Account");
                END;
            end;
        }
        field(21; "Tax Code"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Allowance Tax Set Up"."Tax Code";

            trigger OnValidate();
            begin
                IF "Tax Code" <> '' THEN
                    TESTFIELD(Taxable, TRUE);
                IF AllowanceTaxSetUp.GET("Tax Code") THEN BEGIN
                    AllowanceTaxSetUp.TESTFIELD("Tax Percentage");
                    AllowanceTaxSetUp.TESTFIELD("Tax Account");
                    "Tax Percentage" := AllowanceTaxSetUp."Tax Percentage";
                    "Tax Amount" := ROUND(("Taxable Amount" * ("Tax Percentage" / 100)), 0.01, '=');
                    "Net Allowance Amount" := "Amount (LCY)";
                END;
            end;
        }
        field(22; "Tax Percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Net Allowance Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Tax Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Employee No"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";

            trigger OnValidate();
            begin
                IF Employee.GET("Employee No") THEN BEGIN
                    "Employee Name" := Employee."Full Name";
                    "Payroll Scale" := Employee.Grade;
                    "Board Member" := Employee."Nature Of Employment";
                    "CBS Member Id" := Employee."CBS Member Id";
                END ELSE
                    "Employee Name" := '';
            end;
        }
        field(26; "Employee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(27; "PD Transaction Code"; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup();
            begin
                PTypes.RESET;
                PTypes.SETRANGE("Source Type", PTypes."Source Type"::Payment);
                IF PAGE.RUNMODAL(PAGE::"Requisition Rates", PTypes) = ACTION::LookupOK THEN BEGIN
                    "PD Transaction Code" := PTypes.Code;
                    Description := PTypes.Description;
                    VALIDATE("Account No", PTypes."G/L Account");
                    "Daily Tax Relief" := PTypes."Exemption Amount";
                    "Tax Relief" := "Daily Tax Relief" * "No of Days";
                    Amount := "No of Days" * "Daily Rate";
                END;
                VALIDATE("Account No");
            end;

            trigger OnValidate();
            begin
                IF PTypes.GET("PD Transaction Code") THEN BEGIN
                    VALIDATE("Account No", PTypes."G/L Account");
                    IF PTypes.Taxable THEN
                        VALIDATE("Daily Tax Relief", PTypes."Exemption Amount");
                END;
            end;
        }
        field(28; Taxable; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Taxable Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Payroll Scale"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Tax Relief"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(32; "No of Days"; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin

                VALIDATE(Amount, ("No of Days" * "Daily Rate"));
                VALIDATE("Tax Relief", ("Daily Tax Relief" * "No of Days"));
                VALIDATE("Taxable Amount", (Amount - "Tax Relief"));
                Amount := "No of Days" * "Daily Rate";
                VALIDATE(Amount);
            end;
        }
        field(33; "Daily Rate"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                VALIDATE("No of Days");
            end;
        }
        field(34; "Relief Days"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Daily Tax Relief"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(36; "CBS Processed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(37; "CBS Member Id"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(38; "Board Member"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = '" ,Contract,Permanent,Board"';
            OptionMembers = " ",Contract,Permanent,Board;
        }
        field(39; "Allow Edit"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Balance Less Entry"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate();
            begin
                PurchSetup.GET;
                BudgetDep := 0;
                HalfDep := 0;
                AlmDEp := 0;
                Bless := 0;
                HalfDep := "Budgeted Amount" * PurchSetup."Budget Balance 25%";
                AlmDEp := "Budgeted Amount" * PurchSetup."Budget Balance 10%";
                BudgetDep := "Budgeted Amount" - "Balance Less Entry";
                Bless := "Balance Before Entry" - "Amount (LCY)";
                IF Bless < HalfDep THEN BEGIN
                    "Budget Depletion" := "Budget Depletion"::"75";
                END;
                IF Bless < AlmDEp THEN BEGIN
                    "Budget Depletion" := "Budget Depletion"::"90";
                END;
                IF Unbudgeted = TRUE THEN BEGIN
                    "Budget Depletion" := "Budget Depletion"::"100";
                END;
            end;
        }
        field(41; "Budget Depletion"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = '" ,75,90,100"';
            OptionMembers = " ","75","90","100";
        }
        field(42; "Balance Before Entry"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate();
            begin
                PurchSetup.GET;
                BudgetDep := 0;
                HalfDep := 0;
                AlmDEp := 0;
                Bless := 0;
                HalfDep := "Budgeted Amount" * PurchSetup."Budget Balance 25%";
                AlmDEp := "Budgeted Amount" * PurchSetup."Budget Balance 10%";
                BudgetDep := "Budgeted Amount" - "Balance Less Entry";
                Bless := "Balance Before Entry" - Amount;
                IF "Balance Less Entry" < HalfDep THEN BEGIN
                    "Budget Depletion" := "Budget Depletion"::"75";
                END;
                IF "Balance Less Entry" < AlmDEp THEN BEGIN
                    "Budget Depletion" := "Budget Depletion"::"90";
                END;
                IF Unbudgeted = TRUE THEN BEGIN
                    "Budget Depletion" := "Budget Depletion"::"100";
                END;
                IF ("Balance Less Entry" > HalfDep) OR ("Balance Less Entry" > AlmDEp) THEN
                    "Budget Depletion" := "Budget Depletion"::" ";
            end;
        }
        field(43; "Budget G/L Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";

            trigger OnValidate();
            begin
                IF RequestHeader.GET("Request No") THEN BEGIN
                    IanBudgetedAmt("Budget G/L Account", "Budget Code", '', RequestHeader."Global Dimension 1 Code");
                END;
            end;
        }
        field(44; Additional; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(45; "M-pesa Withdrawal"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(46; "M-pesa Transaction"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(47; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = filter(false));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(48; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = filter(false));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(49; "Sortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = filter(false));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(3, "Sortcut Dimension 3 Code");
            end;
        }
        field(50; "Dimension Set ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50000; "Donor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";

            trigger OnValidate();
            begin
                IF Customer.GET("Donor No.") THEN BEGIN
                    "Donor Name" := Customer.Name;
                END;
            end;
        }
        field(50001; "Grant No."; Code[20])
        {
            Caption = 'Grant No.';
            DataClassification = ToBeClassified;
            TableRelation = "Grant Header"."No." WHERE(Blocked = const(false));

            trigger OnValidate();
            begin
                IF GrantHeader.GET("Grant No.") THEN BEGIN
                    "Donor No." := GrantHeader."Donor No.";
                    VALIDATE("Donor No.");
                END;
            end;
        }
        field(50002; "Objective Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Grant Lines".Code WHERE("Line Type" = CONST(Objective),
                                                      "Grant No" = FIELD("Grant No."));
        }
        field(50003; "Output Code"; Code[20])
        {
            Caption = 'Output Code';
            DataClassification = ToBeClassified;
            TableRelation = "Grant Lines".Code WHERE("Line Type" = CONST(Output),
                                                      "Grant No" = FIELD("Grant No."));
        }
        field(50004; "Outcome Code"; Code[20])
        {
            Caption = 'Outcome Code';
            DataClassification = ToBeClassified;
            TableRelation = "Grant Lines".Code WHERE("Line Type" = CONST(Outcome),
                                                      "Grant No" = FIELD("Grant No."));
        }
        field(50005; "Activity Code"; Code[20])
        {
            TableRelation = "Grant Lines".Code WHERE("Line Type" = CONST(Activity),
                                                      "Grant No" = FIELD("Grant No."));
        }
        field(50006; Posted; Boolean)
        {
            CalcFormula = Lookup("Purchase Header".Posted WHERE("No." = FIELD("Request No")));
            FieldClass = FlowField;
        }
        field(50007; "Donor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50008; "Partner Code"; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup();
            var
                GrantDetailLines: Record "Grant Detail Lines";
            begin
                GrantDetailLines.RESET;
                GrantDetailLines.SETRANGE("Grant Code", "Grant No.");
                GrantDetailLines.SETRANGE("G/L Account No", "Account No");
                GrantDetailLines.SETRANGE(Code, "Activity Code");
                IF GrantDetailLines.FINDSET THEN BEGIN
                    IF PAGE.RUNMODAL(90203, GrantDetailLines) = ACTION::LookupOK THEN BEGIN
                        VALIDATE("Partner Code", GrantDetailLines."External Partner Code");
                    END;
                END;
            end;
        }
        field(50009; "Document Type"; Option)
        {
            OptionCaption = '" ,Disbursement,Accounting';
            OptionMembers = " ",Disbursement,Accounting;

            trigger OnValidate();
            begin
            end;
        }
        field(50010; Status; Option)
        {
            CalcFormula = Lookup("Purchase Header".Status WHERE("No." = FIELD("Request No")));
            FieldClass = FlowField;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
    }

    keys
    {
        key(Key1; "Request No", "Line No")
        {
        }
        key(Key2; "Employee No", "PD Transaction Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
    end;

    trigger OnInsert();
    begin
        IF RequestHeader.GET("Request No") THEN BEGIN
            RequestHeader.TESTFIELD("Global Dimension 1 Code");
            RequestHeader.TESTFIELD("Budget Code");
            "Budget Code" := RequestHeader."Budget Code";
            Description := RequestHeader.Purpose;
            "Line No" += 1000;
        END;
    end;

    trigger OnModify();
    begin
        IF "PD Transaction Code" <> '' THEN
            VALIDATE("Account No");
    end;

    var
        GLAccount: Record "G/L Account";
        RequestHeader: Record "Grants Request Header";
        IanSoftFactory: Codeunit "IanSoftFactory";
        AmountFromPreviousLines: Decimal;
        PTypes: Record "Payment Types";
        AllowanceTaxSetUp: Record "Allowance Tax Set Up";
        Employee: Record Employee;
        PerDiemRates: Record "Per Diem Rates";
        PerDiemScalesPage: Page "Per Diem Scales LookUp";
        PurchSetup: Record "Purchases & Payables Setup";
        LinesAmounts: Decimal;
        BudgetDep: Decimal;
        HalfDep: Decimal;
        AlmDEp: Decimal;
        Bless: Decimal;
        RequestLines: Record "Grants Request Lines";
        DimMgt: Codeunit "DimensionManagement";
        Job: Record "Job";
        Customer: Record Customer;
        GrantHeader: Record "Grant Header";

    local procedure IanGetAmountFromPreviousLines(AccountNo: Code[20]; ReqNo: Code[20]; LineN: Integer): Decimal;
    var
        RequestLines: Record "Purchase Line";
    begin
        RequestLines.RESET;
        RequestLines.SETRANGE("Document No.", ReqNo);
        RequestLines.SETRANGE("No.", AccountNo);
        RequestLines.SETFILTER("Line No.", '<>%1', LineN);
        IF RequestLines.FINDSET THEN BEGIN
            RequestLines.CALCSUMS("Amount (LCY)");
            EXIT(RequestLines."Amount (LCY)");
        END;
    end;

    local procedure IanBudgetedAmt(GLA: Code[20]; YearB: Code[20]; Depart: Code[20]; Programx: Code[20]): Decimal;
    begin
        "Budgeted Amount" := IanSoftFactory.IanGetBudgetedAmount(GLA, YearB, Depart, Programx);
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20]);
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;
}
