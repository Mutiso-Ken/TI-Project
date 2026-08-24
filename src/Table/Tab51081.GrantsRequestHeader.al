table 51081 "Grants Request Header"
{
    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Partner No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";

            trigger OnValidate();
            begin
                SalesReceivablesSetup.GET;
                SalesReceivablesSetup.TESTFIELD("Max No of Imprests");
                RequestHeader.RESET;
                RequestHeader.SETRANGE("Partner No.", "Partner No.");
                RequestHeader.SETRANGE(Status, RequestHeader.Status::New);
                RequestHeader.SETRANGE("Request Type", "Request Type");
                IF RequestHeader.FINDSET THEN BEGIN
                    IF RequestHeader.COUNT > SalesReceivablesSetup."Max No of Imprests" THEN
                        ERROR('You cannot create more than %1 Documents,kindly re-use the old ones', SalesReceivablesSetup."Max No of Imprests");
                END;
                IF Partner.GET("Partner No.") THEN BEGIN
                    "Partner Name" := Partner.Name;

                    VALIDATE("Global Dimension 1 Code", Partner."Global Dimension 1 Code");
                    VALIDATE("Global Dimension 2 Code", Partner."Global Dimension 2 Code");
                END;

                SalesReceivablesSetup.GET;
                SalesReceivablesSetup.TESTFIELD("Max No of Disbursements");
                IF "Request Type" IN ["Request Type"::Disbursement] THEN BEGIN
                    RequestHeader.RESET;
                    RequestHeader.SETRANGE("Partner No.", Rec."Partner No.");
                    RequestHeader.SETRANGE("Request Type", RequestHeader."Request Type"::Disbursement);
                    RequestHeader.SETRANGE(Posted, TRUE);
                    RequestHeader.SETRANGE(Surrendered, FALSE);
                    IF RequestHeader.FINDSET THEN BEGIN
                        IF RequestHeader.COUNT >= SalesReceivablesSetup."Max No of Disbursements" THEN
                            ERROR('You have %1 unsurrendered imprest', RequestHeader.COUNT);
                    END;
                END;

                SalesReceivablesSetup.GET;
                SalesReceivablesSetup.TESTFIELD("Max No of Disbursements");
                IF "Request Type" IN ["Request Type"::Disbursement] THEN BEGIN
                    RequestHeader.RESET;
                    RequestHeader.SETRANGE("Partner No.", Rec."Partner No.");
                    RequestHeader.SETRANGE("Request Type", RequestHeader."Request Type"::Disbursement);
                    RequestHeader.SETRANGE(Posted, FALSE);
                    RequestHeader.SETRANGE(Surrendered, FALSE);
                    IF RequestHeader.FINDFIRST THEN BEGIN
                        IF RequestHeader.COUNT >= SalesReceivablesSetup."Max No of Disbursements" THEN
                            ERROR('You have %1 Open Imprests kindly go to Imprest List and Re use one of them.', RequestHeader.COUNT);
                    END;
                END;
            end;
        }
        field(3; "Partner Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Request For"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Self,Other';
            OptionMembers = Self,Other;
        }
        field(5; "Request Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = '" ,Disbursement,Accounting';
            OptionMembers = " ","Disbursement","Accounting";

            trigger OnValidate();
            begin

                IF "Request Type" <> "Request Type"::" " THEN
                    "Account Type" := "Account Type"::"Bank Account";
            end;
        }
        field(6; Purpose; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Paying Bank"; Code[30])
        {
            DataClassification = ToBeClassified;
            Description = '// Changed to gl account for imprest';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"."No." WHERE("Account Type" = CONST(Posting))
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"."No." WHERE("Currency Code" = FIELD("Currency Code"));

            trigger OnValidate();
            begin
                IF BankAccount.GET("Paying Bank") THEN BEGIN
                    "Paying Bank Name" := COPYSTR(BankAccount.Name, 1, 30);

                    BankAccount.CALCFIELDS("Balance (LCY)");
                    "Bank Balance" := BankAccount."Balance (LCY)";
                END ELSE BEGIN
                    "Paying Bank Name" := '';
                END;

                IF GLAccount.GET("Paying Bank") THEN BEGIN
                    "Paying Bank Name" := GLAccount.Name;
                END;

            end;
        }
        field(8; "Paying Bank Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; "Bank Balance"; Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(10; "Partner Balance"; Decimal)
        {
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" where("Customer No." = field("Partner No.")));
            FieldClass = FlowField;
        }
        field(11; "Imprest Amount"; Decimal)
        {
            CalcFormula = Sum("Grants Request Lines".Amount WHERE("Request No" = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(12; "Petty Cash Amount"; Decimal)
        {
            CalcFormula = Sum("Grants Request Lines".Amount WHERE("Request No" = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(13; "Claim Amount"; Decimal)
        {
            CalcFormula = Sum("Grants Request Lines".Amount WHERE("Request No" = FIELD("No."),
                                                            Surrender = filter(false)));
            FieldClass = FlowField;
        }
        field(14; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(15; "No. Series"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Created On"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Created By"; Code[70])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(19; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Posted By"; Code[70])
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Posted On"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Global Dimension 3 Code"; Code[40])
        {
            CaptionClass = '1,1,3';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          Blocked = filter(false));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(3, "Global Dimension 3 Code");
            end;
        }
        field(23; "Global Dimension 2 Code"; Code[40])
        {
            CaptionClass = '1,1,2';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = filter(false));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(24; "Surrender Amount"; Decimal)
        {
            CalcFormula = Sum("Grants Request Lines".Amount WHERE("Request No" = FIELD("No."),
                                                            Surrender = filter(true)));
            FieldClass = FlowField;
        }
        field(25; "Imprest No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Grants Request Header"."No." WHERE("Partner No." = FIELD("Partner No."),
                                                        Surrendered = const(false),
                                                        "Request Type" = CONST(Disbursement),
                                                        Posted = const(true),
                                                        "Surrender Booked" = const(false));

            trigger OnValidate();
            begin
                IF Rec."Imprest No." <> '' THEN BEGIN
                    RequestHeaderCopy.RESET;
                    RequestHeaderCopy.SETRANGE("Imprest No.", Rec."Imprest No.");
                    RequestHeaderCopy.SETRANGE("Request Type", RequestHeaderCopy."Request Type"::Accounting);
                    RequestHeaderCopy.SETFILTER(Status, '%1|%2', RequestHeaderCopy.Status::"Pending Approval", RequestHeaderCopy.Status::Approved);
                    IF RequestHeaderCopy.FINDFIRST THEN BEGIN
                        ERROR('The Imprest No. %1 has already been used in the Surrender %2 : Status %3', RequestHeaderCopy."Imprest No.", RequestHeaderCopy."No.", RequestHeaderCopy.Status);
                    END;
                END;


                IF RequestHeader.GET("Imprest No.") THEN BEGIN
                    Rec.Purpose := RequestHeader.Purpose;
                    Rec."Global Dimension 1 Code" := RequestHeader."Global Dimension 1 Code";
                    Rec."Global Dimension 2 Code" := RequestHeader."Global Dimension 2 Code";
                    Rec."Currency Code" := RequestHeader."Currency Code";
                    Rec."Exchange Rate" := RequestHeader."Exchange Rate";
                    Rec."Exchange Rate Factor" := RequestHeader."Exchange Rate Factor";

                END;

                RequestLines.RESET;
                RequestLines.SETRANGE("Request No", "No.");
                IF RequestLines.FINDSET THEN
                    RequestLines.DELETEALL;



                RequestLines.RESET;
                RequestLines.SETRANGE("Request No", "Imprest No.");
                IF RequestLines.FINDSET THEN BEGIN
                    REPEAT
                        RequestLinesCopy.TRANSFERFIELDS(RequestLines);
                        RequestLinesCopy."Request No" := "No.";
                        RequestLinesCopy."Imprest Amount" := RequestLines.Amount;
                        RequestLinesCopy.VALIDATE(Amount);
                        IF "Currency Code" <> '' THEN
                            RequestLinesCopy."Amount (LCY)" := RequestLines.Amount * "Exchange Rate";
                        IF "Currency Code" = '' THEN
                            RequestLinesCopy."Amount (LCY)" := RequestLines.Amount;

                        RequestLinesCopy.Surrender := TRUE;
                        RequestLinesCopy."From Imprest" := TRUE;
                        RequestLinesCopy."Donor No." := RequestLines."Donor No.";
                        RequestLinesCopy."Objective Code" := RequestLines."Objective Code";
                        RequestLinesCopy."Output Code" := RequestLines."Output Code";
                        RequestLinesCopy."Outcome Code" := RequestLines."Outcome Code";
                        RequestLinesCopy."Activity Code" := RequestLines."Activity Code";
                        RequestLinesCopy.INSERT;
                    UNTIL RequestLines.NEXT = 0;
                END;
            end;
        }
        field(26; Surrendered; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Surrender Booked"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Surrender No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Expected Date of Surrender"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(30; "Pay Mode"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Method".Code;

            trigger OnValidate();
            begin
                IF PaymentMethod.GET("Pay Mode") THEN
                    IF PaymentMethod."M-PESA" THEN
                        IF BankAccount.GET("Paying Bank") THEN
                            IF NOT BankAccount."M-Pesa Cashbook" THEN
                                ERROR('You can not use %1 for Payment Method %2', BankAccount.Name, "Pay Mode");

                IF (Rec."Pay Mode" <> xRec."Pay Mode") THEN BEGIN
                    PVLine.RESET;
                    PVLine.SETRANGE("Request No", "No.");
                    PVLine.SETRANGE(Additional, TRUE);
                    PVLine.SETRANGE("M-pesa Transaction", TRUE);
                    IF PVLine.FINDSET THEN BEGIN
                        PVLine.DELETEALL;
                    END;
                    IF "Currency Code" = '' THEN
                        IanMpesaCharge;
                END;
            end;
        }
        field(31; "Cheque No"; Code[15])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                IF (xRec."Cheque No" <> Rec."Cheque No") AND (xRec."Cheque No" <> '') THEN BEGIN
                    ChequeLedgerEntries.RESET;
                    Rec.RESET;
                    Rec.SETFILTER("Cheque No", '%1|%2|%3', Rec."Cheque No", ChequeLedgerEntries."Original Cheque No.", ChequeLedgerEntries."New Cheque No.");
                    IF Rec.FINDFIRST THEN
                        ERROR('You can not use the same Cheque No. twice');
                END;
            end;
        }
        field(32; "EFT No"; Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Currency Code"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency.Code;

            trigger OnValidate();
            begin
                CurrencyExchangeRate.RESET;
                CurrencyExchangeRate.SETRANGE("Currency Code", Rec."Currency Code");
                CurrencyExchangeRate.SETCURRENTKEY("Starting Date");
                IF CurrencyExchangeRate.FINDLAST THEN
                    "Exchange Rate" := CurrencyExchangeRate."Relational Exch. Rate Amount";

                VALIDATE("Exchange Rate");
            end;
        }
        field(34; "Exchange Rate"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                "Exchange Rate Factor" := 1 / "Exchange Rate";
            end;
        }
        field(35; "Budget Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(36; "Exchange Rate Factor"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                "Exchange Rate" := 1 / "Exchange Rate Factor";
            end;
        }
        field(37; "Requesting Partner"; Code[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                IF Partner.GET("Requesting Partner") THEN BEGIN
                    "Requesting Partner Name" := Partner.Name;
                END;
            end;
        }
        field(38; "Requesting Partner Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(39; "Transfered To Payroll"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Date of Transfer"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(41; "Purpose Code"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Imprest Purpose"."Purpose Code";

            trigger OnValidate();
            begin
                IF ImprestPurpose.GET("Purpose Code") THEN
                    Purpose := ImprestPurpose."Purpose Desscription";
            end;
        }
        field(42; "To Recover From Payroll"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(43; "Receipt No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Receipt Header"."No." WHERE("Imprest No" = FIELD("Imprest No."),
                                                        "Used for Surrender" = filter(false));

            trigger OnValidate();
            begin
                IF ReceiptHeader.GET("Receipt No") THEN BEGIN
                    ReceiptHeader.CALCFIELDS("Net Amount");
                    "Receipt Amount" := ReceiptHeader."Net Amount";
                END ELSE
                    "Receipt Amount" := 0;
            end;
        }
        field(44; "Receipt Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(45; "Actual Imprest Amount"; Decimal)
        {
            CalcFormula = Sum("Grants Request Lines"."Imprest Amount" WHERE("Request No" = FIELD("No."),
                                                                      Surrender = filter(true)));
            FieldClass = FlowField;
        }
        field(46; "Date Approved"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(47; "Global Dimension 1 Code"; Code[50])
        {
            CaptionClass = '1,1,1';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = filter(false));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(48; "Payroll Period"; Date)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payroll Calender_AU"."Date Opened";
        }
        field(49; "Gross Allowance"; Decimal)
        {
            CalcFormula = Sum("Grants Request Lines".Amount WHERE("Request No" = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(50; "Net Allowance(LCY)"; Decimal)
        {
            CalcFormula = Sum("Grants Request Lines"."Net Allowance Amount" WHERE("Request No" = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(51; "Total Tax"; Decimal)
        {
            CalcFormula = Sum("Grants Request Lines"."Tax Amount" WHERE("Request No" = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(52; "Account Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Partner;
        }
        field(53; "CBS Member Id"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(54; "Approval Entries"; Integer)
        {
            CalcFormula = Count("Approval Entry" WHERE("Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(55; "Loan Type"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Staff Loans".Code;

            trigger OnValidate();
            begin
                IF StaffLoans.GET("Loan Type") THEN BEGIN
                    "Repayment Period" := StaffLoans."Repayment Period";
                END;
            end;
        }
        field(56; "Repayment Period"; DateFormula)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(57; Instalments; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(58; "Basic Pay"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(59; "1/3 of Basic"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60; "Take Home"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(61; "Amount Requested"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(62; "Months Paid"; DateFormula)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(63; "Current Net Pay"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(64; "Imprest Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = '" ,Local,International"';
            OptionMembers = " ","Local",International;

            trigger OnValidate();
            begin
                IF Rec."Imprest Type" <> xRec."Imprest Type" THEN BEGIN
                    RequestLines.RESET;
                    RequestLines.SETRANGE("Request No", "No.");
                    IF RequestLines.FINDFIRST THEN
                        RequestLines.DELETEALL;
                END;
            end;
        }
        field(65; "Amount(LCY)"; Decimal)
        {
            CalcFormula = Sum("Grants Request Lines"."Amount (LCY)" WHERE("Request No" = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(66; "M-PESA Withdrawal Fee"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                IanMpesawithdrawal;
            end;
        }
        field(67; "Dimension Set ID"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(68; "Charge as a Single Transaction"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(69; "Picked for EFT"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70; "Taxable Amout"; Decimal)
        {
            CalcFormula = Sum("Grants Request Lines"."Taxable Amount" WHERE("Request No" = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(71; "Rejection Comments"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        ERROR('You cannot Delete this Document');
    end;

    trigger OnInsert();
    begin

        IF "No." = '' THEN BEGIN
            IF "Request Type" IN ["Request Type"::Disbursement] THEN BEGIN
                SalesReceivablesSetup.GET;
                SalesReceivablesSetup.TESTFIELD("Grants Request Nos");
                NoSeriesManagement.InitSeries(SalesReceivablesSetup."Grants Request Nos", "No. Series", 0D, "No.", "No. Series");
            END;

            IF "Request Type" IN ["Request Type"::Accounting] THEN BEGIN
                SalesReceivablesSetup.GET;
                SalesReceivablesSetup.TESTFIELD("Grants Surrender Nos");
                NoSeriesManagement.InitSeries(SalesReceivablesSetup."Grants Surrender Nos", "No. Series", 0D, "No.", "No. Series");
            END;


        END;



        GeneralLedgerSetup.GET;
        GeneralLedgerSetup.TESTFIELD("Current Budget");
        GeneralLedgerSetup.TESTFIELD("Current Budget End Date");
        GeneralLedgerSetup.TESTFIELD("Current Budget Start Date");
        "Budget Code" := GeneralLedgerSetup."Current Budget";
        "Created By" := USERID;
        "Created On" := TODAY;

    end;

    trigger OnModify();
    begin
        RequestLines.RESET;
        RequestLines.SETRANGE("Request No", "No.");
        IF RequestLines.FINDSET THEN
            REPEAT
                IF "Currency Code" <> '' THEN
                    RequestLines."Amount (LCY)" := RequestLines.Amount * "Exchange Rate";
                RequestLines."Net Allowance Amount" := RequestLines."Amount (LCY)";
                IF "Currency Code" = '' THEN
                    RequestLines."Amount (LCY)" := RequestLines.Amount;
                RequestLines."Net Allowance Amount" := RequestLines."Amount (LCY)";
                RequestLines.MODIFY;
            UNTIL RequestLines.NEXT = 0;
    end;

    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        UserSetup: Record "User Setup";
        Partner: Record Customer;
        RequestLines: Record "Grants Request Lines";
        RequestLinesCopy: Record "Grants Request Lines";
        RequestHeader: Record "Grants Request Header";
        BankAccount: Record "Bank Account";
        GeneralLedgerSetup: Record "General Ledger Setup";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        ImprestPurpose: Record "Imprest Purpose";
        ReceiptHeader: Record "Receipt Header";
        GLAccount: Record "G/L Account";
        StaffLoans: Record "Staff Loans";
        PayrollPeriods: Record "Payroll Calender_AU";

        PVLine: Record "Grants Request Lines";
        AdditionalCharges: Record "Additional Charges";
        PVLines: Record "Grants Request Lines";
        PaymentMethod: Record "Payment Method";
        MPESACharges: Record "M-PESA Charges";
        PV: Record "Grants Request Header";
        PVLinez: Record "Grants Request Lines";
        MPESAWithdrawalCharges: Record "M-PESA Withdrawal Charges";
        ConfirmManagement: Codeunit "Confirm Management";
        IanSoftFactory: Codeunit "IanSoftFactory";
        Hallowance: Decimal;
        ChequeLedgerEntries: Record "Cheque Ledger Entries";
        PayrollVitalSetup: Record "Payroll Vital Setup";
        RequestHeaderCopy: Record "Grants Request Header";
        Paye: Decimal;
        NSSF: Decimal;
        NHIF: Decimal;



    local procedure IsOnLongTermContract(EmpNo: Code[20]);
    begin
    end;

    local procedure IanMpesaCharge();
    begin
        IF NOT "Charge as a Single Transaction" THEN BEGIN
            IF Rec."Pay Mode" <> xRec."Pay Mode" THEN
                IF PaymentMethod.GET("Pay Mode") THEN
                    IF PaymentMethod."M-PESA" THEN BEGIN
                        AdditionalCharges.RESET;
                        AdditionalCharges.SETRANGE(Method, "Pay Mode");
                        IF AdditionalCharges.FINDSET THEN
                            REPEAT
                                PVLines.RESET;
                                PVLines.SETRANGE("Request No", "No.");
                                PVLines.SETFILTER("PD Transaction Code", '<>%1', '');
                                PVLines.SETRANGE(Additional, FALSE);
                                IF PVLines.FINDSET THEN
                                    REPEAT
                                        PVLine.RESET;
                                        PVLine.SETRANGE("Request No", "No.");
                                        IF NOT PVLine.FINDLAST THEN
                                            PVLine."Line No" := 10000
                                        ELSE
                                            PVLine."Line No" := PVLine."Line No" + 10000;
                                        PVLine."Request No" := PVLines."Request No";
                                        PVLine.Description := AdditionalCharges.Description;
                                        PVLine."No of Days" := 1;
                                        PVLine.VALIDATE("Daily Rate", AdditionalCharges.Amount);
                                        PVLine.VALIDATE("PD Transaction Code", 'M-PESA');
                                        PVLine.VALIDATE("Account No", AdditionalCharges."G/L Account");
                                        PVLine.VALIDATE("M-pesa Transaction", TRUE);
                                        PVLine.VALIDATE("Global Dimension 1 Code", PVLines."Global Dimension 1 Code");
                                        PVLine.VALIDATE("Global Dimension 2 Code", PVLines."Global Dimension 2 Code");
                                        PVLine.VALIDATE("Sortcut Dimension 3 Code", PVLines."Sortcut Dimension 3 Code");
                                        PVLine.VALIDATE("Dimension Set ID", PVLines."Dimension Set ID");
                                        MPESACharges.RESET;
                                        IF MPESACharges.FINDSET THEN
                                            REPEAT
                                                IF ((PVLines.Amount > MPESACharges.Minimum) OR (PVLines.Amount = MPESACharges.Minimum)) AND ((PVLines.Amount < MPESACharges.Maximum) OR (PVLines.Amount = MPESACharges.Maximum)) THEN
                                                    PVLine.VALIDATE("Daily Rate", MPESACharges."Transaction Charge");
                                            UNTIL MPESACharges.NEXT = 0;
                                        PVLine.Additional := TRUE;
                                        PVLine.INSERT;
                                    UNTIL PVLines.NEXT = 0;
                            UNTIL AdditionalCharges.NEXT = 0;

                    END;
        END;
        IF "Charge as a Single Transaction" THEN BEGIN
            IF Rec."Pay Mode" <> xRec."Pay Mode" THEN
                IF PaymentMethod.GET("Pay Mode") THEN
                    IF PaymentMethod."M-PESA" THEN BEGIN
                        AdditionalCharges.RESET;
                        AdditionalCharges.SETRANGE(Method, "Pay Mode");
                        IF AdditionalCharges.FINDSET THEN
                            REPEAT
                                PVLines.RESET;
                                PVLines.SETRANGE("Request No", "No.");
                                PVLines.SETFILTER("PD Transaction Code", '<>%1', '');
                                PVLines.SETRANGE(Additional, FALSE);
                                IF PVLines.FINDLAST THEN BEGIN
                                    PVLine.RESET;
                                    PVLine.SETRANGE("Request No", "No.");
                                    IF NOT PVLine.FINDLAST THEN
                                        PVLine."Line No" := 10000
                                    ELSE
                                        PVLine."Line No" := PVLine."Line No" + 10000;
                                    PVLine."Request No" := PVLines."Request No";
                                    PVLine.Description := AdditionalCharges.Description;
                                    PVLine."No of Days" := 1;
                                    PVLine.VALIDATE("Daily Rate", AdditionalCharges.Amount);
                                    PVLine.VALIDATE("PD Transaction Code", 'M-PESA');
                                    PVLine.VALIDATE("Account No", AdditionalCharges."G/L Account");
                                    PVLine.VALIDATE("M-pesa Transaction", TRUE);
                                    PVLine.VALIDATE("Global Dimension 1 Code", PVLines."Global Dimension 1 Code");
                                    PVLine.VALIDATE("Global Dimension 2 Code", PVLines."Global Dimension 2 Code");
                                    PVLine.VALIDATE("Dimension Set ID", PVLines."Dimension Set ID");
                                    MPESACharges.RESET;
                                    IF MPESACharges.FINDSET THEN
                                        REPEAT
                                            PV.GET("No.");
                                            PV.CALCFIELDS("Net Allowance(LCY)");
                                            IF ((PV."Net Allowance(LCY)" > MPESACharges.Minimum) OR (PV."Net Allowance(LCY)" = MPESACharges.Minimum)) AND ((PV."Net Allowance(LCY)" < MPESACharges.Maximum) OR (PV."Net Allowance(LCY)" = MPESACharges.Maximum)) THEN
                                                PVLine.VALIDATE("Daily Rate", MPESACharges."Transaction Charge");
                                        UNTIL MPESACharges.NEXT = 0;
                                    PVLine.Additional := TRUE;
                                    PVLine.INSERT;
                                END;
                            UNTIL AdditionalCharges.NEXT = 0;
                    END;
        END;
    end;

    local procedure IanMpesawithdrawal();
    begin
        IF NOT "Charge as a Single Transaction" THEN BEGIN
            IF Rec."M-PESA Withdrawal Fee" = FALSE THEN
                EXIT;
            PVLines.RESET;
            PVLines.SETRANGE("Request No", "No.");
            PVLines.SETRANGE("M-pesa Withdrawal", TRUE);
            IF PVLines.FINDSET THEN
                PVLines.DELETEALL;


            AdditionalCharges.RESET;
            AdditionalCharges.SETRANGE(Method, "Pay Mode");
            IF AdditionalCharges.FINDSET THEN
                REPEAT
                    PVLines.RESET;
                    PVLines.SETRANGE("Request No", "No.");
                    PVLines.SETFILTER("PD Transaction Code", '<>%1', '');
                    PVLines.SETRANGE(Additional, FALSE);
                    IF PVLines.FINDSET THEN
                        REPEAT
                            PVLine.RESET;
                            PVLine.SETRANGE("Request No", "No.");
                            IF NOT PVLine.FINDLAST THEN
                                PVLine."Line No" := 10000
                            ELSE
                                PVLine."Line No" := PVLine."Line No" + 10000;
                            PVLine."Request No" := PVLines."Request No";
                            PVLine.Description := 'M-PESA Withdrawal Fee';
                            PVLine."No of Days" := 1;
                            PVLine.VALIDATE("Daily Rate", AdditionalCharges.Amount);
                            PVLine.VALIDATE("PD Transaction Code", 'M-PESA');
                            PVLine.VALIDATE("Account No", AdditionalCharges."G/L Account");
                            PVLine.VALIDATE("M-pesa Withdrawal", TRUE);
                            PVLine.VALIDATE("Global Dimension 1 Code", PVLines."Global Dimension 1 Code");
                            PVLine.VALIDATE("Global Dimension 2 Code", PVLines."Global Dimension 2 Code");
                            PVLine.VALIDATE("Sortcut Dimension 3 Code", PVLines."Sortcut Dimension 3 Code");
                            PVLine.VALIDATE("Dimension Set ID", PVLines."Dimension Set ID");
                            MPESAWithdrawalCharges.RESET;
                            IF MPESAWithdrawalCharges.FINDSET THEN
                                REPEAT
                                    IF ((PVLines.Amount = MPESAWithdrawalCharges.Minimum) OR (PVLines.Amount > MPESAWithdrawalCharges.Minimum)) AND ((PVLines.Amount = MPESAWithdrawalCharges.Maximum) OR (PVLines.Amount < MPESAWithdrawalCharges.Maximum)) THEN
                                        PVLine.VALIDATE("Daily Rate", MPESAWithdrawalCharges."Transaction Charge");
                                UNTIL MPESAWithdrawalCharges.NEXT = 0;
                            PVLine.Additional := TRUE;
                            PVLine.INSERT;
                        UNTIL PVLines.NEXT = 0;
                UNTIL AdditionalCharges.NEXT = 0;
        END ELSE BEGIN
            IF Rec."M-PESA Withdrawal Fee" = FALSE THEN
                EXIT;
            PVLines.RESET;
            PVLines.SETRANGE("Request No", "No.");
            PVLines.SETRANGE("M-pesa Withdrawal", TRUE);
            IF PVLines.FINDSET THEN
                PVLines.DELETEALL;


            AdditionalCharges.RESET;
            AdditionalCharges.SETRANGE(Method, "Pay Mode");
            IF AdditionalCharges.FINDSET THEN
                REPEAT
                    PVLines.RESET;
                    PVLines.SETRANGE("Request No", "No.");
                    PVLines.SETFILTER("PD Transaction Code", '<>%1', '');
                    PVLines.SETRANGE(Additional, FALSE);
                    IF PVLines.FINDLAST THEN BEGIN
                        PVLine.RESET;
                        PVLine.SETRANGE("Request No", "No.");
                        IF NOT PVLine.FINDLAST THEN
                            PVLine."Line No" := 10000
                        ELSE
                            PVLine."Line No" := PVLine."Line No" + 10000;
                        PVLine."Request No" := PVLines."Request No";
                        PVLine.Description := 'M-PESA Withdrawal Fee';
                        PVLine."No of Days" := 1;
                        PVLine.VALIDATE("Daily Rate", AdditionalCharges.Amount);
                        PVLine.VALIDATE("PD Transaction Code", 'M-PESA');
                        PVLine.VALIDATE("Account No", AdditionalCharges."G/L Account");
                        PVLine.VALIDATE("M-pesa Withdrawal", TRUE);
                        PVLine.VALIDATE("Global Dimension 1 Code", PVLines."Global Dimension 1 Code");
                        PVLine.VALIDATE("Global Dimension 2 Code", PVLines."Global Dimension 2 Code");
                        PVLine.VALIDATE("Dimension Set ID", PVLines."Dimension Set ID");
                        MPESAWithdrawalCharges.RESET;
                        IF MPESAWithdrawalCharges.FINDSET THEN
                            REPEAT
                                PV.GET("No.");
                                PV.CALCFIELDS("Net Allowance(LCY)");
                                IF ((PV."Net Allowance(LCY)" = MPESAWithdrawalCharges.Minimum) OR (PV."Net Allowance(LCY)" > MPESAWithdrawalCharges.Minimum)) AND ((PV."Net Allowance(LCY)" = MPESAWithdrawalCharges.Maximum) OR
                                  (PV."Net Allowance(LCY)" < MPESAWithdrawalCharges.Maximum)) THEN
                                    PVLine.VALIDATE("Daily Rate", MPESAWithdrawalCharges."Transaction Charge");
                            UNTIL MPESAWithdrawalCharges.NEXT = 0;
                        PVLine.Additional := TRUE;
                        PVLine.INSERT;
                    END;
                UNTIL AdditionalCharges.NEXT = 0;
        END;
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    var
        DimMgt: Codeunit "DimensionManagement";
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;


    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20]);
    var
        DimMgt: Codeunit "DimensionManagement";
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

}
