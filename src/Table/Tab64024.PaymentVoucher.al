table 64024 "Payment Voucher"
{
    Caption = 'Payment Voucher';
    DataClassification = CustomerContent;
    LookupPageId = "Payment Vouchers List";
    DrillDownPageId = "Payment Vouchers List";

    fields
    {
        field(1; "No."; Code[30])
        {
            Caption = 'No.';
        }
        field(2; "Voucher Date"; Date)
        {
            Caption = 'Voucher Date';
        }
        field(3; "Paying Bank"; Code[50])
        {
            Caption = 'Paying Bank';
            TableRelation = if ("Account Type" = const("Bank Account")) "Bank Account"."No."
            else
            if ("Account Type" = const("G/L Account")) "G/L Account"."No." where("Account Type" = const(Posting),
                                                                                 "Income/Balance" = const("Balance Sheet"),
                                                                                 "Direct Posting" = const(true),
                                                                                 Blocked = const(false));

            trigger OnValidate()
            begin
                if BankAccount.Get("Paying Bank") then begin
                    "Paying Bank Name" := BankAccount.Name;
                    "Currency Code" := BankAccount."Currency Code";
                end else
                    if GLAccount.Get("Paying Bank") then begin
                        "Paying Bank Name" := GLAccount.Name;
                        "Currency Code" := '';
                    end else
                        "Paying Bank Name" := '';

                Validate("Currency Code");
            end;
        }
        field(4; "Paying Bank Name"; Text[100])
        {
            Caption = 'Paying Bank Name';
        }
        field(5; "Payment For"; Text[250])
        {
            Caption = 'Payment For';
        }
        field(6; "Gross Amount"; Decimal)
        {
            Caption = 'Gross Amount';
            CalcFormula = sum("Payment Voucher Lines".Amount where("Voucher No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Net Amount"; Decimal)
        {
            Caption = 'Net Amount';
            CalcFormula = sum("Payment Voucher Lines"."Net Amount" where("Voucher No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(10; "Payment Method"; Code[40])
        {
            Caption = 'Payment Method';
            TableRelation = "Payment Method".Code;

            trigger OnValidate()
            begin
                // Re-create the additional charge lines for the selected payment method
                PVLine.Reset();
                PVLine.SetRange("Voucher No.", "No.");
                PVLine.SetRange(Additional, true);
                if not PVLine.IsEmpty() then
                    PVLine.DeleteAll();

                AdditionalCharges.Reset();
                AdditionalCharges.SetRange(Method, "Payment Method");
                if AdditionalCharges.FindSet() then
                    repeat
                        PVLines.Reset();
                        PVLines.SetRange("Voucher No.", "No.");
                        if PVLines.FindLast() then begin
                            PVLine.Init();
                            PVLine."Voucher No." := PVLines."Voucher No.";
                            PVLine."Line No." := PVLines."Line No." + 1000;
                            PVLine."Account Type" := PVLine."Account Type"::"G/L Account";
                            PVLine.Validate("Account No", AdditionalCharges."G/L Account");
                            PVLine.Description := AdditionalCharges.Description;
                            PVLine.Validate(Amount, AdditionalCharges.Amount);
                            if PaymentMethod.Get("Payment Method") then
                                if PaymentMethod."M-PESA" then begin
                                    CalcFields("Net Amount");
                                    MPESACharges.Reset();
                                    MPESACharges.SetFilter("No.", '<>%1', '');
                                    if MPESACharges.FindSet() then
                                        repeat
                                            if ("Net Amount" > MPESACharges.Minimum) and ("Net Amount" < MPESACharges.Maximum) then
                                                PVLine.Validate(Amount, MPESACharges."Transaction Charge");
                                        until MPESACharges.Next() = 0;
                                end;
                            PVLine.Additional := true;
                            PVLine.Insert();
                        end;
                    until AdditionalCharges.Next() = 0;
            end;
        }
        field(11; "Cheque No."; Code[15])
        {
            Caption = 'Cheque No.';
        }
        field(12; "EFT No."; Code[50])
        {
            Caption = 'EFT No.';
        }
        field(13; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(14; Posted; Boolean)
        {
            Caption = 'Posted';
        }
        field(15; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency.Code;

            trigger OnValidate()
            begin
                if BankAccount.Get("Paying Bank") then
                    TestField("Currency Code", BankAccount."Currency Code");

                if "Currency Code" = '' then
                    "Exchange Rate" := 1
                else begin
                    CurrencyExchangeRate.Reset();
                    CurrencyExchangeRate.SetCurrentKey("Starting Date");
                    CurrencyExchangeRate.SetRange("Currency Code", "Currency Code");
                    if CurrencyExchangeRate.FindLast() then
                        "Exchange Rate" := CurrencyExchangeRate."Relational Exch. Rate Amount";
                end;

                Validate("Exchange Rate");
            end;
        }
        field(16; "Exchange Rate"; Decimal)
        {
            Caption = 'Exchange Rate';
            Editable = false;

            trigger OnValidate()
            begin
                if "Exchange Rate" <> 0 then
                    "Exchange Rate Factor" := 1 / "Exchange Rate";
            end;
        }
        field(17; "Global Dimension 1 Code"; Code[50])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false),
                                                          "Dimension Value Type" = const(Standard));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(18; "Global Dimension 2 Code"; Code[50])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(19; "Created By"; Code[70])
        {
            Caption = 'Created By';
            Editable = false;
        }
        field(20; "Created On"; Date)
        {
            Caption = 'Created On';
            Editable = false;
        }
        field(21; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(22; "Bank Balance"; Decimal)
        {
            Caption = 'Bank Balance';
            Editable = false;
        }
        field(23; "Posted On"; Date)
        {
            Caption = 'Posted On';
            Editable = false;
        }
        field(24; "Posted By"; Code[70])
        {
            Caption = 'Posted By';
            Editable = false;
        }
        field(25; "Time Posted"; Time)
        {
            Caption = 'Time Posted';
            Editable = false;
        }
        field(26; "Exchange Rate Factor"; Decimal)
        {
            Caption = 'Exchange Rate Factor';

            trigger OnValidate()
            begin
                if "Exchange Rate Factor" <> 0 then
                    "Exchange Rate" := 1 / "Exchange Rate Factor";
            end;
        }
        field(27; "Budget Code"; Code[100])
        {
            Caption = 'Budget Code';
            TableRelation = "G/L Budget Name".Name;
        }
        field(28; "Picked for EFT"; Boolean)
        {
            Caption = 'Picked for EFT';
        }
        field(29; "Cheque Date"; Date)
        {
            Caption = 'Cheque Date';

            trigger OnValidate()
            begin
                if "Cheque Date" > Today then
                    Error(FutureChequeDateErr);
            end;
        }
        field(30; "Payment Type"; Option)
        {
            Caption = 'Payment Type';
            OptionCaption = 'Payment Voucher,Petty Cash Re-Imbursement,Bankers';
            OptionMembers = "Payment Voucher","Petty Cash Re-Imbursement",Bankers;

            trigger OnValidate()
            begin
                if xRec."Payment Type" <> Rec."Payment Type" then begin
                    "Paying Bank" := '';
                    "Paying Bank Name" := '';
                end;

                case "Payment Type" of
                    "Payment Type"::"Payment Voucher",
                    "Payment Type"::Bankers:
                        "Account Type" := "Account Type"::"Bank Account";
                end;
            end;
        }
        field(31; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        }
        field(32; "Approval Entries"; Integer)
        {
            Caption = 'Approval Entries';
            CalcFormula = count("Approval Entry" where("Table ID" = const(64024),
                                                        "Document No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee where(Status = const(Active));

            trigger OnValidate()
            begin
                if "Employee No." = '' then
                    "Employee Name" := '';
                if Employee.Get("Employee No.") then
                    "Employee Name" := CopyStr(Employee.FullName(), 1, MaxStrLen("Employee Name"));
            end;
        }
        field(34; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
        }
        field(35; "Amount(LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
            CalcFormula = sum("Payment Voucher Lines"."Amount (LCY)" where("Voucher No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(36; "Net Amount(LCY)"; Decimal)
        {
            Caption = 'Net Amount (LCY)';
            CalcFormula = sum("Payment Voucher Lines"."Net Amount(LCY)" where("Voucher No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(37; "Withdrawal Fee"; Boolean)
        {
            Caption = 'Withdrawal Fee';

            trigger OnValidate()
            begin
                if not Confirm(IncludeWithdrawalChargeQst, true) then
                    exit;
                InsertMpesaWithdrawalLines();
            end;
        }
        field(38; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(43; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
        }
        field(44; "Applies To Doc No."; Code[50])
        {
            Caption = 'Applies To Doc No.';
            CalcFormula = lookup("Payment Voucher Lines"."Applies to Doc. No" where("Voucher No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(45; "Rejection Comments"; Text[200])
        {
            Caption = 'Rejection Comments';
        }
        field(46; "Approval Status"; Enum "Approval Status")
        {
            Caption = 'Approval Status';
            CalcFormula = min("Approval Entry".Status where("Table ID" = const(64024),
                                                            "Document No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(47; Archived; Boolean)
        {
            Caption = 'Archived';
        }
        field(48; Payee; Text[450])
        {
            Caption = 'Payee';
        }
        field(51; "Payment Configuration"; Option)
        {
            Caption = 'Payment Configuration';
            OptionMembers = SDMC,SDSC;
            OptionCaption = 'Single debit multiple credit,Single Debit Single Credit';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Paying Bank Name", "Payment For", "Cheque No.")
        {
        }
    }

    trigger OnDelete()
    begin
        Error(DeleteNotAllowedErr);
    end;

    trigger OnInsert()
    var
        ExistingPV: Record "Payment Voucher";
    begin
        GLSetup.Get();
        if "No." = '' then begin
            PurchasesPayablesSetup.Get();
            PurchasesPayablesSetup.TestField("Payment Voucher Nos.");
            "No. Series" := PurchasesPayablesSetup."Payment Voucher Nos.";
            "No." := NoSeries.GetNextNo("No. Series", WorkDate());
        end;

        ExistingPV.Reset();
        ExistingPV.SetRange("Created By", UserId());
        ExistingPV.SetRange("Payment Type", "Payment Type");
        ExistingPV.SetRange(Status, ExistingPV.Status::New);
        ExistingPV.SetRange(Posted, false);
        if ExistingPV.Count() > 3 then
            Error(TooManyOpenDocsErr);

        "Created By" := CopyStr(UserId(), 1, MaxStrLen("Created By"));
        "Created On" := Today;
        "Voucher Date" := Today;
        "Budget Code" := GLSetup."Current Budget";
    end;

    trigger OnModify()
    begin
        if Status = Status::New then begin
            PVLines.Reset();
            PVLines.SetRange("Voucher No.", "No.");
            if PVLines.FindSet() then
                repeat
                    PVLines."Amount (LCY)" := PVLines.Amount * GetExchangeRate();
                    PVLines."Net Amount(LCY)" := PVLines."Net Amount" * GetExchangeRate();
                    PVLines.Modify();
                until PVLines.Next() = 0;
        end;
    end;

    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        GLSetup: Record "General Ledger Setup";
        BankAccount: Record "Bank Account";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        AdditionalCharges: Record "Additional Charges";
        PVLines: Record "Payment Voucher Lines";
        PVLine: Record "Payment Voucher Lines";
        GLAccount: Record "G/L Account";
        Employee: Record Employee;
        MPESACharges: Record "M-PESA Charges";
        PaymentMethod: Record "Payment Method";
        MPESAWithdrawalCharges: Record "M-PESA Withdrawal Charges";
        NoSeries: Codeunit "No. Series";
        DeleteNotAllowedErr: Label 'You can only delete the PV Lines.';
        TooManyOpenDocsErr: Label 'You can not create more than 3 payment vouchers. Kindly re-use the old ones.';
        FutureChequeDateErr: Label 'The cheque date can not be a future date.';
        IncludeWithdrawalChargeQst: Label 'Are you sure you want to include the M-PESA withdrawal charge?';
        InvoiceAlreadySelectedErr: Label 'The invoice No. %1 is already selected in PV No. %2. Consolidate all payments to PV No. %3.', Comment = '%1 = invoice no., %2 = other PV no., %3 = this PV no.';
        AmountExceedsInvoiceErr: Label 'Application amount can not be more than the invoice amount of %1.', Comment = '%1 = remaining amount';

    procedure GetExchangeRate(): Decimal
    begin
        if ("Currency Code" = '') or ("Exchange Rate" = 0) then
            exit(1);
        exit("Exchange Rate");
    end;

    procedure ValidateMultipleInvoiceSelections(AppliesToDocNo: Code[50])
    var
        PaymentLine: Record "Payment Voucher Lines";
        OtherPV: Record "Payment Voucher";
    begin
        if AppliesToDocNo = '' then
            exit;
        if (Status = Status::Rejected) or Posted then
            exit;

        PaymentLine.Reset();
        PaymentLine.SetRange("Account Type", PaymentLine."Account Type"::Vendor);
        PaymentLine.SetFilter("Voucher No.", '<>%1', "No.");
        PaymentLine.SetRange("Applies to Doc. No", AppliesToDocNo);
        if PaymentLine.FindSet() then
            repeat
                if OtherPV.Get(PaymentLine."Voucher No.") then
                    if (OtherPV.Status <> OtherPV.Status::Rejected) and (not OtherPV.Posted) then
                        Error(InvoiceAlreadySelectedErr, AppliesToDocNo, OtherPV."No.", "No.");
            until PaymentLine.Next() = 0;
    end;

    procedure ControlPaymentAmount()
    var
        VendLedger: Record "Vendor Ledger Entry";
        Lines: Record "Payment Voucher Lines";
    begin
        Lines.Reset();
        Lines.SetRange("Voucher No.", "No.");
        Lines.SetRange("Account Type", Lines."Account Type"::Vendor);
        Lines.SetFilter("Applies to Doc. No", '<>%1', '');
        if Lines.FindSet() then
            repeat
                VendLedger.Reset();
                VendLedger.SetRange("Vendor No.", Lines."Account No");
                VendLedger.SetRange("Document No.", Lines."Applies to Doc. No");
                if VendLedger.FindFirst() then begin
                    VendLedger.CalcFields("Remaining Amount");
                    if Abs(VendLedger."Remaining Amount") < Lines.Amount then
                        Error(AmountExceedsInvoiceErr, Abs(VendLedger."Remaining Amount"));
                end;
            until Lines.Next() = 0;
    end;

    local procedure InsertMpesaWithdrawalLines()
    begin
        if not "Withdrawal Fee" then
            exit;

        PVLines.Reset();
        PVLines.SetRange("Voucher No.", "No.");
        PVLines.SetRange("M-PESA Withdrawal", true);
        if not PVLines.IsEmpty() then
            PVLines.DeleteAll();

        AdditionalCharges.Reset();
        AdditionalCharges.SetRange(Method, "Payment Method");
        if AdditionalCharges.FindSet() then
            repeat
                PVLines.Reset();
                PVLines.SetRange("Voucher No.", "No.");
                PVLines.SetRange(Additional, false);
                if PVLines.FindSet() then
                    repeat
                        PVLine.Reset();
                        PVLine.SetRange("Voucher No.", "No.");
                        if PVLine.FindLast() then
                            PVLine."Line No." := PVLine."Line No." + 10000
                        else
                            PVLine."Line No." := 10000;
                        PVLine.Init();
                        PVLine."Voucher No." := "No.";
                        PVLine.Description := 'M-PESA Withdrawal Fee';
                        PVLine.Validate("Account Type", PVLine."Account Type"::"G/L Account");
                        PVLine.Validate("Account No", AdditionalCharges."G/L Account");
                        PVLine.Validate(Amount, AdditionalCharges.Amount);
                        PVLine."M-PESA Withdrawal" := true;
                        MPESAWithdrawalCharges.Reset();
                        if MPESAWithdrawalCharges.FindSet() then
                            repeat
                                if (PVLines.Amount >= MPESAWithdrawalCharges.Minimum) and (PVLines.Amount <= MPESAWithdrawalCharges.Maximum) then
                                    PVLine.Validate(Amount, MPESAWithdrawalCharges."Transaction Charge");
                            until MPESAWithdrawalCharges.Next() = 0;
                        PVLine.Additional := true;
                        PVLine.Insert();
                    until PVLines.Next() = 0;
            until AdditionalCharges.Next() = 0;
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[50])
    var
        DimMgt: Codeunit DimensionManagement;
        DimCode: Code[20];
    begin
        DimCode := CopyStr(ShortcutDimCode, 1, MaxStrLen(DimCode));
        DimMgt.ValidateShortcutDimValues(FieldNumber, DimCode, "Dimension Set ID");
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;
}
