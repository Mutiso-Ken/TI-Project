table 64025 "Payment Voucher Lines"
{
    Caption = 'Payment Voucher Lines';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Voucher No."; Code[30])
        {
            Caption = 'Voucher No.';
            TableRelation = "Payment Voucher"."No.";
        }
        field(2; "Account Type"; Option)
        {
            Caption = 'Account Type';
            InitValue = Vendor;
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        }
        field(3; "Account No"; Code[20])
        {
            Caption = 'Account No';
            TableRelation = if ("Account Type" = const(Vendor)) Vendor."No." where(Blocked = const(" "))
            else
            if ("Account Type" = const(Customer)) Customer."No."
            else
            if ("Account Type" = const("G/L Account")) "G/L Account"."No." where(Blocked = const(false),
                                                                                 "Direct Posting" = const(true))
            else
            if ("Account Type" = const(Employee)) Employee."No."
            else
            if ("Account Type" = const("Bank Account")) "Bank Account"."No.";

            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                IanSoftFactory.FnDirectPostingControl("Account No");
                "Account Name" := '';
                case "Account Type" of
                    "Account Type"::Vendor:
                        if Vendor.Get("Account No") then
                            "Account Name" := Vendor.Name;
                    "Account Type"::Customer:
                        if Customer.Get("Account No") then
                            "Account Name" := Customer.Name;
                    "Account Type"::"G/L Account":
                        if GLAccount.Get("Account No") then
                            "Account Name" := GLAccount.Name;
                    "Account Type"::"Bank Account":
                        if BankAccount.Get("Account No") then
                            "Account Name" := BankAccount.Name;
                    "Account Type"::Employee:
                        if Employee.Get("Account No") then
                            "Account Name" := Employee.FullName();
                end;

                // When expensing, pick the budget figures for the voucher dimensions
                LinesAmounts := 0;
                if "Account Type" = "Account Type"::"G/L Account" then begin
                    GLSetup.Get();
                    if PV.Get("Voucher No.") then begin
                        if PV."Paying Bank" = "Account No" then
                            Error(SameCashbookErr, "Account No");
                        PV.TestField("Global Dimension 1 Code");
                        PV.TestField("Global Dimension 2 Code");
                        "Budget G/L Account" := "Account No";
                        "Budgeted Amount" := IanSoftFactory.IanGetBudgetedAmount("Budget G/L Account", GLSetup."Current Budget", PV."Global Dimension 2 Code", PV."Global Dimension 1 Code");
                        "Committed Amount" := IanSoftFactory.IanGetCommittedAmount("Account No", GLSetup."Current Budget", PV."Global Dimension 2 Code", PV."Global Dimension 1 Code");
                        "Total Expenditure" := IanSoftFactory.IanGetTotalExpenditure("Budget G/L Account", GLSetup."Current Budget", PV."Global Dimension 2 Code", PV."Global Dimension 1 Code");
                    end;

                    PVLines.Reset();
                    PVLines.SetRange("Voucher No.", "Voucher No.");
                    PVLines.SetRange("Budget G/L Account", "Budget G/L Account");
                    PVLines.SetFilter("Line No.", '<>%1', "Line No.");
                    PVLines.CalcSums("Amount (LCY)");
                    LinesAmounts := PVLines."Amount (LCY)";
                end;

                "Balance Before Entry" := "Budgeted Amount" - ("Total Expenditure" + LinesAmounts);
                Unbudgeted := "Balance Before Entry" <= 0;
                Validate("Balance Before Entry");
            end;
        }
        field(4; "Account Name"; Text[500])
        {
            Caption = 'Account Name';
        }
        field(5; Description; Text[500])
        {
            Caption = 'Description';
        }
        field(6; Amount; Decimal)
        {
            Caption = 'Amount';

            trigger OnValidate()
            begin
                if "Account Type" = "Account Type"::Vendor then
                    if ("Percentage to Pay" <> 0) and (xRec."Percentage to Pay" <> Rec."Percentage to Pay") then
                        Amount := ("Percentage to Pay" / 100) * Amount;

                CalculateDeductions();
                UpdateLCYAmounts();
            end;
        }
        field(7; "Applies to Doc. No"; Code[50])
        {
            Caption = 'Applies to Doc. No';

            trigger OnLookup()
            var
                VendLedger: Record "Vendor Ledger Entry";
            begin
                if PV.Get(Rec."Voucher No.") then
                    if PV.Posted then
                        Error(PostedDocumentErr);

                if "Account Type" <> "Account Type"::Vendor then
                    exit;

                VendLedger.Reset();
                VendLedger.SetCurrentKey("Vendor No.", Open);
                VendLedger.SetRange("Vendor No.", "Account No");
                VendLedger.SetRange("Document Type", VendLedger."Document Type"::Invoice);
                VendLedger.SetRange(Open, true);
                if Page.RunModal(0, VendLedger) <> Action::LookupOK then
                    exit;

                VendLedger.CalcFields(Amount, "Remaining Amount");
                "Applies to Doc. No" := VendLedger."Document No.";
                "Remaining Amount" := Abs(VendLedger."Remaining Amount");
                "Vendor Invoice No." := VendLedger."External Document No.";
                Description := VendLedger.Description;
                "Global Dimension 1 Code" := VendLedger."Global Dimension 1 Code";
                "Global Dimension 2 Code" := VendLedger."Global Dimension 2 Code";
                "Dimension Set ID" := VendLedger."Dimension Set ID";
                "VAT Amount" := GetInvoiceVATAmount("Applies to Doc. No");
                "Vatable Amount" := GetInvoiceVatableAmount("Applies to Doc. No");
                if PV.Get("Voucher No.") then
                    PV.ValidateMultipleInvoiceSelections("Applies to Doc. No");
                Validate(Amount, Abs(VendLedger."Remaining Amount"));
            end;

            trigger OnValidate()
            var
                VendLedger: Record "Vendor Ledger Entry";
            begin
                if ("Account Type" <> "Account Type"::Vendor) or ("Applies to Doc. No" = '') then
                    exit;

                VendLedger.Reset();
                VendLedger.SetRange("Vendor No.", "Account No");
                VendLedger.SetRange(Open, true);
                VendLedger.SetRange("Document No.", "Applies to Doc. No");
                if VendLedger.FindFirst() then begin
                    VendLedger.CalcFields("Remaining Amount");
                    "Remaining Amount" := Abs(VendLedger."Remaining Amount");
                    "Vendor Invoice No." := VendLedger."External Document No.";
                    "VAT Amount" := GetInvoiceVATAmount("Applies to Doc. No");
                    "Vatable Amount" := GetInvoiceVatableAmount("Applies to Doc. No");
                    Description := VendLedger.Description;
                    "Global Dimension 1 Code" := VendLedger."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := VendLedger."Global Dimension 2 Code";
                    "Dimension Set ID" := VendLedger."Dimension Set ID";
                end;
                if PV.Get("Voucher No.") then
                    PV.ValidateMultipleInvoiceSelections("Applies to Doc. No");
            end;
        }
        field(8; "Remaining Amount"; Decimal)
        {
            Caption = 'Remaining Amount';
            Editable = false;
        }
        field(9; "W/Tax Code"; Code[20])
        {
            Caption = 'W/Tax Code';
            TableRelation = "VAT Product Posting Group" where("WT/WV" = const(Tax));

            trigger OnValidate()
            begin
                Validate(Amount);
            end;
        }
        field(10; "W/VAT Code"; Code[20])
        {
            Caption = 'W/VAT Code';
            TableRelation = "VAT Product Posting Group" where("WT/WV" = const(VAT));

            trigger OnValidate()
            begin
                Validate(Amount);
            end;
        }
        field(11; "Retention Code"; Code[20])
        {
            Caption = 'Retention Code';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            begin
                Validate(Amount);
            end;
        }
        field(12; "W/Tax Amount"; Decimal)
        {
            Caption = 'W/Tax Amount';
            Editable = false;
        }
        field(13; "W/VAT Amount"; Decimal)
        {
            Caption = 'W/VAT Amount';
            Editable = false;
        }
        field(14; "Retention Amount"; Decimal)
        {
            Caption = 'Retention Amount';
            Editable = false;
        }
        field(15; "VAT Code"; Code[50])
        {
            Caption = 'VAT Code';
        }
        field(16; "VAT Amount"; Decimal)
        {
            Caption = 'VAT Amount';
        }
        field(17; "Net Amount"; Decimal)
        {
            Caption = 'Net Amount';
            Editable = false;
        }
        field(18; "Line No."; Integer)
        {
            Caption = 'Line No.';
            AutoIncrement = true;
        }
        field(19; "Vendor Invoice No."; Code[50])
        {
            Caption = 'Vendor Invoice No.';
        }
        field(20; "Vatable Amount"; Decimal)
        {
            Caption = 'Vatable Amount';
        }
        field(21; "Budgeted Amount"; Decimal)
        {
            Caption = 'Budgeted Amount';
            Editable = false;
        }
        field(22; "Committed Amount"; Decimal)
        {
            Caption = 'Committed Amount';
            Editable = false;
        }
        field(23; Unbudgeted; Boolean)
        {
            Caption = 'Unbudgeted';
            Editable = false;
        }
        field(24; "Balance Less Entry"; Decimal)
        {
            Caption = 'Balance Less Entry';
            Editable = false;
        }
        field(25; "Percentage to Pay"; Decimal)
        {
            Caption = 'Percentage to Pay';
            MinValue = 0;
            MaxValue = 100;

            trigger OnValidate()
            begin
                if "Percentage to Pay" > 100 then
                    Error(PercentageErr);
                if xRec."Percentage to Pay" <> Rec."Percentage to Pay" then
                    Validate(Amount);
            end;
        }
        field(26; Additional; Boolean)
        {
            Caption = 'Additional';
        }
        field(30; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
            Editable = false;

            trigger OnValidate()
            begin
                "Balance Less Entry" := "Balance Before Entry" - "Amount (LCY)";
                Unbudgeted := "Balance Less Entry" <= 0;
                UpdateBudgetDepletion();
            end;
        }
        field(31; "Net Amount(LCY)"; Decimal)
        {
            Caption = 'Net Amount (LCY)';
            Editable = false;
        }
        field(32; "Budget Depletion"; Option)
        {
            Caption = 'Budget Depletion';
            Editable = false;
            OptionCaption = ' ,75,90,100';
            OptionMembers = " ","75","90","100";
        }
        field(33; "Budget G/L Account"; Code[30])
        {
            Caption = 'Budget G/L Account';
            Editable = false;
            TableRelation = "G/L Account";
        }
        field(34; "Total Expenditure"; Decimal)
        {
            Caption = 'Total Expenditure';
            Editable = false;
        }
        field(35; "Balance Before Entry"; Decimal)
        {
            Caption = 'Balance Before Entry';
            Editable = false;

            trigger OnValidate()
            begin
                UpdateBudgetDepletion();
            end;
        }
        field(36; "M-PESA Withdrawal"; Boolean)
        {
            Caption = 'M-PESA Withdrawal';
        }
        field(37; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(38; "Global Dimension 2 Code"; Code[20])
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
        field(39; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(40; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(41; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4),
                                                          Blocked = const(false),
                                                          Grant = field("Shortcut Dimension 3 Code"));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
            end;
        }
        field(42; "Donor No."; Code[20])
        {
            Caption = 'Donor No.';
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                "Donor Name" := '';
                if Customer.Get("Donor No.") then
                    "Donor Name" := Customer.Name;
            end;
        }
        field(43; "Grant No."; Code[20])
        {
            Caption = 'Grant No.';
            TableRelation = "Grant Header"."No." where(Blocked = const(false));
        }
        field(44; "Objective Code"; Code[20])
        {
            Caption = 'Objective Code';
            TableRelation = "Grant Lines".Code where("Line Type" = const(Objective),
                                                      "Grant No" = field("Grant No."));
        }
        field(45; "Output Code"; Code[20])
        {
            Caption = 'Output Code';
            TableRelation = "Grant Lines".Code where("Line Type" = const(Output),
                                                      "Grant No" = field("Grant No."));
        }
        field(46; Status; Option)
        {
            Caption = 'Status';
            CalcFormula = lookup("Payment Voucher".Status where("No." = field("Voucher No.")));
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(47; "Outcome Code"; Code[20])
        {
            Caption = 'Outcome Code';
            TableRelation = "Grant Lines".Code where("Line Type" = const(Outcome),
                                                      "Grant No" = field("Grant No."));
        }
        field(48; "Activity Code"; Code[20])
        {
            Caption = 'Activity Code';
            TableRelation = "Grant Lines".Code where("Line Type" = const(Activity),
                                                      "Grant No" = field("Grant No."));
        }
        field(49; "Donor Name"; Text[100])
        {
            Caption = 'Donor Name';
            Editable = false;
        }
        field(50; "Partner Code"; Code[20])
        {
            Caption = 'Partner Code';

            trigger OnLookup()
            var
                GrantDetailLines: Record "Grant Detail Lines";
            begin
                GrantDetailLines.Reset();
                GrantDetailLines.SetRange("Grant Code", "Grant No.");
                GrantDetailLines.SetRange("G/L Account No", "Account No");
                GrantDetailLines.SetRange(Code, "Activity Code");
                if Page.RunModal(0, GrantDetailLines) = Action::LookupOK then
                    Validate("Partner Code", GrantDetailLines."External Partner Code");
            end;
        }
        field(51; "Budget Amount"; Decimal)
        {
            Caption = 'Budget Amount';
            Editable = false;
        }
        field(52; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            CalcFormula = lookup("Payment Voucher"."Posting Date" where("No." = field("Voucher No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(53; Posted; Boolean)
        {
            Caption = 'Posted';
            CalcFormula = lookup("Payment Voucher".Posted where("No." = field("Voucher No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(54; "ShortcutDimCode[5]"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5),
                                                          Blocked = const(false),
                                                          Activity = field("Shortcut Dimension 4 Code"));

            trigger OnValidate()
            var
                GrantLines: Record "Grant Detail Lines";
            begin
                ValidateShortcutDimCode(5, "ShortcutDimCode[5]");
                GrantLines.Reset();
                GrantLines.SetRange("Partner Code", Rec."ShortcutDimCode[5]");
                if GrantLines.FindFirst() then
                    "Budget Amount" := GrantLines."Total Cost" - GrantLines.Expenditure;
            end;
        }
        field(55; "ShortcutDimCode[6]"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(6, "ShortcutDimCode[6]");
            end;
        }
        field(56; "ShortcutDimCode[7]"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(7, "ShortcutDimCode[7]");
            end;
        }
        field(57; "ShortcutDimCode[8]"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(8, "ShortcutDimCode[8]");
            end;
        }
    }

    keys
    {
        key(Key1; "Voucher No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = Amount, "Net Amount", "Amount (LCY)", "Net Amount(LCY)";
        }
        key(Key2; "Applies to Doc. No")
        {
        }
    }

    trigger OnInsert()
    begin
        TestHeaderIsOpen();
    end;

    trigger OnModify()
    begin
        TestHeaderIsOpen();
    end;

    trigger OnDelete()
    begin
        TestHeaderIsOpen();
    end;

    var
        Vendor: Record Vendor;
        Customer: Record Customer;
        GLAccount: Record "G/L Account";
        VATSetup: Record "VAT Posting Setup";
        BankAccount: Record "Bank Account";
        PurchSetup: Record "Purchases & Payables Setup";
        PV: Record "Payment Voucher";
        GLSetup: Record "General Ledger Setup";
        PVLines: Record "Payment Voucher Lines";
        IanSoftFactory: Codeunit IanSoftFactory;
        LinesAmounts: Decimal;
        SameCashbookErr: Label 'Kindly specify another cashbook other than %1.', Comment = '%1 = account no.';
        PostedDocumentErr: Label 'You cannot select invoices for a posted document.';
        PercentageErr: Label 'Percentage to pay can only be up to 100%.';
        PostedLineErr: Label 'You cannot change lines of posted payment voucher %1.', Comment = '%1 = voucher no.';

    local procedure TestHeaderIsOpen()
    begin
        if PV.Get("Voucher No.") then
            if PV.Posted then
                Error(PostedLineErr, PV."No.");
    end;

    /// <summary>
    /// Recalculates retention, withholding VAT, withholding tax and the net amount for the line.
    /// Vendor lines use the vendor's VAT Bus. Posting Group; G/L and employee lines use the
    /// "Expense VAT Bus. Posting Group" from Purchases &amp; Payables Setup.
    /// </summary>
    local procedure CalculateDeductions()
    var
        VATBusPostingGroup: Code[20];
        BaseAmount: Decimal;
    begin
        "Retention Amount" := 0;
        "W/VAT Amount" := 0;
        "W/Tax Amount" := 0;

        case "Account Type" of
            "Account Type"::Vendor:
                begin
                    if not Vendor.Get("Account No") then begin
                        "Net Amount" := Amount;
                        exit;
                    end;
                    VATBusPostingGroup := Vendor."VAT Bus. Posting Group";

                    // Retention is calculated on the VAT-inclusive amount
                    if "Retention Code" <> '' then
                        if VATSetup.Get(VATBusPostingGroup, "Retention Code") then
                            if VATSetup."VAT %" <> 0 then
                                "Retention Amount" := Round(Amount / (1 + VATSetup."VAT %" / 100) * VATSetup."VAT %" / 100);

                    // Withholding is calculated on the vatable amount of the applied invoice
                    BaseAmount := "Vatable Amount";
                    if "Percentage to Pay" <> 0 then
                        BaseAmount := ("Percentage to Pay" / 100) * "Vatable Amount";

                    if ("W/VAT Code" <> '') and ("VAT Amount" <> 0) then
                        if VATSetup.Get(VATBusPostingGroup, "W/VAT Code") then
                            "W/VAT Amount" := Round(BaseAmount * VATSetup."VAT %" / 100, 1, '>');

                    if "W/Tax Code" <> '' then
                        if VATSetup.Get(VATBusPostingGroup, "W/Tax Code") then
                            "W/Tax Amount" := Round(BaseAmount * VATSetup."VAT %" / 100, 1, '>');
                end;
            "Account Type"::"G/L Account",
            "Account Type"::Employee:
                begin
                    PurchSetup.Get();
                    VATBusPostingGroup := PurchSetup."Expense VAT Bus. Posting Group";

                    if "W/VAT Code" <> '' then
                        if VATSetup.Get(VATBusPostingGroup, "W/VAT Code") then
                            "W/VAT Amount" := Round(Amount * VATSetup."VAT %" / 100, 1, '>');

                    if "W/Tax Code" <> '' then
                        if VATSetup.Get(VATBusPostingGroup, "W/Tax Code") then
                            "W/Tax Amount" := Round(Amount * VATSetup."VAT %" / 100, 1, '>');
                end;
        end;

        "Net Amount" := Amount - ("W/Tax Amount" + "Retention Amount" + "W/VAT Amount");
    end;

    local procedure UpdateLCYAmounts()
    var
        ExchangeRate: Decimal;
    begin
        ExchangeRate := 1;
        if PV.Get("Voucher No.") then
            ExchangeRate := PV.GetExchangeRate();
        "Amount (LCY)" := Amount * ExchangeRate;
        "Net Amount(LCY)" := "Net Amount" * ExchangeRate;
        Validate("Amount (LCY)");
    end;

    local procedure UpdateBudgetDepletion()
    var
        Balance75: Decimal;
        Balance90: Decimal;
    begin
        PurchSetup.Get();
        Balance75 := "Budgeted Amount" * PurchSetup."Budget Balance 25%";
        Balance90 := "Budgeted Amount" * PurchSetup."Budget Balance 10%";

        "Budget Depletion" := "Budget Depletion"::" ";
        if "Balance Less Entry" < Balance75 then
            "Budget Depletion" := "Budget Depletion"::"75";
        if "Balance Less Entry" < Balance90 then
            "Budget Depletion" := "Budget Depletion"::"90";
        if Unbudgeted then
            "Budget Depletion" := "Budget Depletion"::"100";
    end;

    /// <summary>VAT amount on the posted purchase invoice being paid.</summary>
    local procedure GetInvoiceVATAmount(AppliesToDocNo: Code[50]): Decimal
    var
        PurchInvLine: Record "Purch. Inv. Line";
    begin
        if AppliesToDocNo = '' then
            exit(0);
        PurchInvLine.Reset();
        PurchInvLine.SetRange("Document No.", AppliesToDocNo);
        PurchInvLine.CalcSums(Amount, "Amount Including VAT");
        exit(PurchInvLine."Amount Including VAT" - PurchInvLine.Amount);
    end;

    /// <summary>VAT base of the posted purchase invoice lines that carry VAT.</summary>
    local procedure GetInvoiceVatableAmount(AppliesToDocNo: Code[50]): Decimal
    var
        PurchInvLine: Record "Purch. Inv. Line";
    begin
        if AppliesToDocNo = '' then
            exit(0);
        PurchInvLine.Reset();
        PurchInvLine.SetRange("Document No.", AppliesToDocNo);
        PurchInvLine.SetFilter("VAT %", '<>%1', 0);
        PurchInvLine.CalcSums("VAT Base Amount");
        exit(PurchInvLine."VAT Base Amount");
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;
}
