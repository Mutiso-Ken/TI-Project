codeunit 50011 "Payment Voucher Management"
{
    var
        BatchHasOtherLinesErr: Label 'Journal batch %1 / %2 already contains lines for other documents. Post or clear them, or set up a dedicated batch for payment vouchers in User Setup.', Comment = '%1 = template, %2 = batch';
        OverdrawalErr: Label 'The system can not allow overdrawing of cash book %1 by %2.', Comment = '%1 = bank name, %2 = shortfall';
        NoLinesErr: Label 'Payment voucher %1 has no lines to post.', Comment = '%1 = voucher no.';
        CreditAccountMissingErr: Label 'Set up the Payables Credit Account in VAT Posting Setup %1 / %2 before posting payment voucher %3.', Comment = '%1 = VAT Bus. group, %2 = VAT Prod. group, %3 = voucher no.';

    /// <summary>
    /// Posts an approved payment voucher through the current user's general journal batch.
    /// Credits the paying bank with the net amount, debits each line account with the gross
    /// amount and credits withholding tax, withholding VAT and retention to the
    /// "Payables Credit Account" of the matching VAT Posting Setup.
    /// </summary>
    procedure PostPaymentVoucher(var PaymentVoucher: Record "Payment Voucher")
    var
        PaymentVoucherLines: Record "Payment Voucher Lines";
        JTemplate: Code[10];
        JBatch: Code[10];
        LineNo: Integer;
        AppliesToDocType: Enum "Gen. Journal Document Type";
        LineAccountType: Enum "Gen. Journal Account Type";
        BankAccountType: Enum "Gen. Journal Account Type";
    begin
        OnBeforePostPaymentVoucher(PaymentVoucher);

        PaymentVoucher.CalcFields("Net Amount");
        CheckOverdrawal(PaymentVoucher."Paying Bank", PaymentVoucher."Net Amount");

        PaymentVoucherLines.SetRange("Voucher No.", PaymentVoucher."No.");
        if PaymentVoucherLines.IsEmpty() then
            Error(NoLinesErr, PaymentVoucher."No.");

        GetUserJournalBatch(JTemplate, JBatch);
        PrepareJournalBatch(JTemplate, JBatch, PaymentVoucher."No.");

        // Paying bank (credit, net amount)
        BankAccountType := Enum::"Gen. Journal Account Type".FromInteger(PaymentVoucher."Account Type");
        LineNo := 10000;
        CreateJournalLine(JTemplate, JBatch, PaymentVoucher, LineNo, BankAccountType, PaymentVoucher."Paying Bank",
            -PaymentVoucher."Net Amount", PaymentVoucher."Payment For", AppliesToDocType::" ", '',
            PaymentVoucher."Global Dimension 1 Code", PaymentVoucher."Global Dimension 2 Code", '', '', '', '',
            PaymentVoucher."Dimension Set ID");

        if PaymentVoucherLines.FindSet() then
            repeat
                LineAccountType := Enum::"Gen. Journal Account Type".FromInteger(PaymentVoucherLines."Account Type");
                if PaymentVoucherLines."Applies to Doc. No" <> '' then
                    AppliesToDocType := AppliesToDocType::Invoice
                else
                    AppliesToDocType := AppliesToDocType::" ";

                // Line account (debit, gross amount)
                LineNo += 10000;
                CreateJournalLineFromPVLine(JTemplate, JBatch, PaymentVoucher, PaymentVoucherLines, LineNo, LineAccountType,
                    PaymentVoucherLines."Account No", PaymentVoucherLines.Amount, AppliesToDocType, PaymentVoucherLines."Applies to Doc. No");

                // Deductions (credit)
                if PaymentVoucherLines."Retention Amount" <> 0 then begin
                    LineNo += 10000;
                    CreateJournalLineFromPVLine(JTemplate, JBatch, PaymentVoucher, PaymentVoucherLines, LineNo, LineAccountType::"G/L Account",
                        GetDeductionAccount(PaymentVoucher, PaymentVoucherLines, PaymentVoucherLines."Retention Code"),
                        -PaymentVoucherLines."Retention Amount", AppliesToDocType::" ", '');
                end;

                if PaymentVoucherLines."W/VAT Amount" <> 0 then begin
                    LineNo += 10000;
                    CreateJournalLineFromPVLine(JTemplate, JBatch, PaymentVoucher, PaymentVoucherLines, LineNo, LineAccountType::"G/L Account",
                        GetDeductionAccount(PaymentVoucher, PaymentVoucherLines, PaymentVoucherLines."W/VAT Code"),
                        -PaymentVoucherLines."W/VAT Amount", AppliesToDocType::" ", '');
                end;

                if PaymentVoucherLines."W/Tax Amount" <> 0 then begin
                    LineNo += 10000;
                    CreateJournalLineFromPVLine(JTemplate, JBatch, PaymentVoucher, PaymentVoucherLines, LineNo, LineAccountType::"G/L Account",
                        GetDeductionAccount(PaymentVoucher, PaymentVoucherLines, PaymentVoucherLines."W/Tax Code"),
                        -PaymentVoucherLines."W/Tax Amount", AppliesToDocType::" ", '');
                end;
            until PaymentVoucherLines.Next() = 0;

        if PaymentVoucher."Currency Code" <> '' then
            AdjustJournalRounding(JTemplate, JBatch, PaymentVoucher."No.");
        PostJournal(JTemplate, JBatch, PaymentVoucher."No.");

        PaymentVoucher.Get(PaymentVoucher."No.");
        PaymentVoucher.Posted := true;
        PaymentVoucher."Posted By" := CopyStr(UserId(), 1, MaxStrLen(PaymentVoucher."Posted By"));
        PaymentVoucher."Posted On" := Today;
        PaymentVoucher."Time Posted" := Time;
        PaymentVoucher.Modify();

        OnAfterPostPaymentVoucher(PaymentVoucher);
    end;

    procedure CheckOverdrawal(BankNo: Code[50]; AmountToPay: Decimal)
    var
        BankAccount: Record "Bank Account";
    begin
        if not BankAccount.Get(BankNo) then
            exit;
        BankAccount.CalcFields(Balance);
        if BankAccount.Balance < AmountToPay then
            Error(OverdrawalErr, BankAccount.Name, AmountToPay - BankAccount.Balance);
    end;

    local procedure GetUserJournalBatch(var JTemplate: Code[10]; var JBatch: Code[10])
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId());
        UserSetup.TestField("Journal Template Name");
        UserSetup.TestField("Journal Batch Name");
        JTemplate := UserSetup."Journal Template Name";
        JBatch := UserSetup."Journal Batch Name";
    end;

    local procedure PrepareJournalBatch(JTemplate: Code[10]; JBatch: Code[10]; DocumentNo: Code[30])
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJournalLine: Record "Gen. Journal Line";
    begin
        if not GenJournalBatch.Get(JTemplate, JBatch) then begin
            GenJournalBatch.Init();
            GenJournalBatch."Journal Template Name" := JTemplate;
            GenJournalBatch.Name := JBatch;
            GenJournalBatch.Description := CopyStr('Batch For ' + JBatch, 1, MaxStrLen(GenJournalBatch.Description));
            GenJournalBatch.Insert(true);
        end;

        // Remove leftovers from an earlier failed attempt for this voucher only
        GenJournalLine.SetRange("Journal Template Name", JTemplate);
        GenJournalLine.SetRange("Journal Batch Name", JBatch);
        GenJournalLine.SetRange("Document No.", DocumentNo);
        if not GenJournalLine.IsEmpty() then
            GenJournalLine.DeleteAll(true);

        // Never post somebody else's lines together with the voucher
        GenJournalLine.SetRange("Document No.");
        if not GenJournalLine.IsEmpty() then
            Error(BatchHasOtherLinesErr, JTemplate, JBatch);
    end;

    local procedure CreateJournalLineFromPVLine(JTemplate: Code[10]; JBatch: Code[10]; PaymentVoucher: Record "Payment Voucher"; PaymentVoucherLines: Record "Payment Voucher Lines"; LineNo: Integer; AccountType: Enum "Gen. Journal Account Type"; AccountNo: Code[50]; LineAmount: Decimal; AppliesToDocType: Enum "Gen. Journal Document Type"; AppliesToDocNo: Code[50])
    var
        Dim1: Code[20];
        Dim2: Code[20];
        DimSetID: Integer;
    begin
        // Fall back to the header dimensions when the line has none
        if (PaymentVoucherLines."Global Dimension 1 Code" = '') and (PaymentVoucherLines."Global Dimension 2 Code" = '') then begin
            Dim1 := CopyStr(PaymentVoucher."Global Dimension 1 Code", 1, MaxStrLen(Dim1));
            Dim2 := CopyStr(PaymentVoucher."Global Dimension 2 Code", 1, MaxStrLen(Dim2));
            DimSetID := PaymentVoucher."Dimension Set ID";
        end else begin
            Dim1 := PaymentVoucherLines."Global Dimension 1 Code";
            Dim2 := PaymentVoucherLines."Global Dimension 2 Code";
            DimSetID := PaymentVoucherLines."Dimension Set ID";
        end;

        CreateJournalLine(JTemplate, JBatch, PaymentVoucher, LineNo, AccountType, AccountNo, LineAmount,
            PaymentVoucherLines.Description, AppliesToDocType, AppliesToDocNo,
            Dim1, Dim2, PaymentVoucherLines."Shortcut Dimension 3 Code", PaymentVoucherLines."Shortcut Dimension 4 Code",
            PaymentVoucherLines."ShortcutDimCode[5]", PaymentVoucherLines."ShortcutDimCode[6]", DimSetID);
    end;

    local procedure CreateJournalLine(JTemplate: Code[10]; JBatch: Code[10]; PaymentVoucher: Record "Payment Voucher"; LineNo: Integer; AccountType: Enum "Gen. Journal Account Type"; AccountNo: Code[50]; LineAmount: Decimal; LineDescription: Text; AppliesToDocType: Enum "Gen. Journal Document Type"; AppliesToDocNo: Code[50]; Dim1: Code[50]; Dim2: Code[50]; Dim3: Code[20]; Dim4: Code[20]; Dim5: Code[20]; Dim6: Code[20]; DimSetID: Integer)
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        if LineAmount = 0 then
            exit;

        GenJournalLine.Init();
        GenJournalLine."Journal Template Name" := JTemplate;
        GenJournalLine."Journal Batch Name" := JBatch;
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Document Type" := GenJournalLine."Document Type"::Payment;
        GenJournalLine."Document No." := PaymentVoucher."No.";
        GenJournalLine."Posting Date" := PaymentVoucher."Posting Date";
        GenJournalLine."Document Date" := PaymentVoucher."Voucher Date";
        GenJournalLine."Account Type" := AccountType;
        GenJournalLine.Validate("Account No.", AccountNo);
        GenJournalLine.Description := CopyStr(LineDescription, 1, MaxStrLen(GenJournalLine.Description));
        GenJournalLine.Validate("Currency Code", PaymentVoucher."Currency Code");
        if (PaymentVoucher."Currency Code" <> '') and (PaymentVoucher."Exchange Rate Factor" <> 0) then
            GenJournalLine.Validate("Currency Factor", PaymentVoucher."Exchange Rate Factor");
        GenJournalLine.Validate(Amount, LineAmount);
        GenJournalLine."External Document No." := CopyStr(PaymentVoucher."External Document No.", 1, MaxStrLen(GenJournalLine."External Document No."));
        if PaymentVoucher."Cheque No." <> '' then
            GenJournalLine."External Document No." := PaymentVoucher."Cheque No.";
        GenJournalLine."Payment Method Code" := CopyStr(PaymentVoucher."Payment Method", 1, MaxStrLen(GenJournalLine."Payment Method Code"));
        GenJournalLine."Applies-to Doc. Type" := AppliesToDocType;
        GenJournalLine."Applies-to Doc. No." := CopyStr(AppliesToDocNo, 1, MaxStrLen(GenJournalLine."Applies-to Doc. No."));

        if DimSetID <> 0 then
            GenJournalLine.Validate("Dimension Set ID", DimSetID);
        GenJournalLine.Validate("Shortcut Dimension 1 Code", CopyStr(Dim1, 1, 20));
        GenJournalLine.Validate("Shortcut Dimension 2 Code", CopyStr(Dim2, 1, 20));
        if Dim3 <> '' then
            GenJournalLine.ValidateShortcutDimCode(3, Dim3);
        if Dim4 <> '' then
            GenJournalLine.ValidateShortcutDimCode(4, Dim4);
        if Dim5 <> '' then
            GenJournalLine.ValidateShortcutDimCode(5, Dim5);
        if Dim6 <> '' then
            GenJournalLine.ValidateShortcutDimCode(6, Dim6);

        OnBeforeInsertPVJournalLine(GenJournalLine, PaymentVoucher);
        GenJournalLine.Insert(true);
    end;

    local procedure GetDeductionAccount(PaymentVoucher: Record "Payment Voucher"; PaymentVoucherLines: Record "Payment Voucher Lines"; VATProdPostingGroup: Code[20]): Code[20]
    var
        Vendor: Record Vendor;
        PurchSetup: Record "Purchases & Payables Setup";
        VATSetup: Record "VAT Posting Setup";
        VATBusPostingGroup: Code[20];
    begin
        if (PaymentVoucherLines."Account Type" = PaymentVoucherLines."Account Type"::Vendor) and Vendor.Get(PaymentVoucherLines."Account No") then
            VATBusPostingGroup := Vendor."VAT Bus. Posting Group"
        else begin
            PurchSetup.Get();
            VATBusPostingGroup := PurchSetup."Expense VAT Bus. Posting Group";
        end;

        if not VATSetup.Get(VATBusPostingGroup, VATProdPostingGroup) then
            Error(CreditAccountMissingErr, VATBusPostingGroup, VATProdPostingGroup, PaymentVoucher."No.");
        if VATSetup."Payables Credit Account" = '' then
            Error(CreditAccountMissingErr, VATBusPostingGroup, VATProdPostingGroup, PaymentVoucher."No.");
        exit(VATSetup."Payables Credit Account");
    end;

    local procedure AdjustJournalRounding(JTemplate: Code[10]; JBatch: Code[10]; DocumentNo: Code[30])
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange("Journal Template Name", JTemplate);
        GenJournalLine.SetRange("Journal Batch Name", JBatch);
        GenJournalLine.SetRange("Document No.", DocumentNo);
        if GenJournalLine.FindFirst() then
            Codeunit.Run(Codeunit::"Adjust Gen. Journal Balance", GenJournalLine);
    end;

    local procedure PostJournal(JTemplate: Code[10]; JBatch: Code[10]; DocumentNo: Code[30])
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange("Journal Template Name", JTemplate);
        GenJournalLine.SetRange("Journal Batch Name", JBatch);
        GenJournalLine.SetRange("Document No.", DocumentNo);
        if GenJournalLine.FindFirst() then
            Codeunit.Run(Codeunit::"Gen. Jnl.-Post Batch", GenJournalLine);
    end;

    // Let the attachment factbox store attachments against the voucher "No."
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document Attachment Mgmt", 'OnAfterTableHasNumberFieldPrimaryKey', '', false, false)]
    local procedure OnAfterTableHasNumberFieldPrimaryKey(TableNo: Integer; var Result: Boolean; var FieldNo: Integer)
    var
        PaymentVoucher: Record "Payment Voucher";
    begin
        if TableNo <> Database::"Payment Voucher" then
            exit;
        Result := true;
        FieldNo := PaymentVoucher.FieldNo("No.");
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostPaymentVoucher(var PaymentVoucher: Record "Payment Voucher")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostPaymentVoucher(var PaymentVoucher: Record "Payment Voucher")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertPVJournalLine(var GenJournalLine: Record "Gen. Journal Line"; PaymentVoucher: Record "Payment Voucher")
    begin
    end;
}
