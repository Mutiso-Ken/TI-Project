report 65005 "Payment Voucher Document"
{
    Caption = 'Payment Voucher';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PaymentVoucherDocument.rdlc';

    dataset
    {
        dataitem("Payment Voucher"; "Payment Voucher")
        {
            CalcFields = "Net Amount(LCY)";
            RequestFilterFields = "No.";

            column(CompanyName; CompanyInformation.Name)
            {
            }
            column(CompanyPicture; CompanyInformation.Picture)
            {
            }
            column(CompanyAddress; CompanyInformation.Address)
            {
            }
            column(CompanyPhone; CompanyInformation."Phone No.")
            {
            }
            column(CompanyLocation; CompanyInformation.City)
            {
            }
            column(CompanyEmail; CompanyInformation."E-Mail")
            {
            }
            column(CompanyWebsite; CompanyInformation."Home Page")
            {
            }
            column(CompanyPostCode; CompanyInformation."Post Code")
            {
            }
            column(SenderID; SenderID)
            {
            }
            column(DateTimeSend; DateTimeSend)
            {
            }
            column(SenderSignature; SenderEmployee.Signature)
            {
            }
            column(FirstApproverID; ApproverID[1])
            {
            }
            column(DateTimeFirstApprove; ApproveDateTime[1])
            {
            }
            column(FirstApproveSignature; ApproverEmployee1.Signature)
            {
            }
            column(SecondApproverID; ApproverID[2])
            {
            }
            column(DateTimeSecondApprove; ApproveDateTime[2])
            {
            }
            column(SecondApproveSignature; ApproverEmployee2.Signature)
            {
            }
            column(ThirdApproverID; ApproverID[3])
            {
            }
            column(DateTimeThirdApprove; ApproveDateTime[3])
            {
            }
            column(ThirdApproveSignature; ApproverEmployee3.Signature)
            {
            }
            column(FourthApproverID; ApproverID[4])
            {
            }
            column(DateTimeFourthApprove; ApproveDateTime[4])
            {
            }
            column(FourthApproveSignature; ApproverEmployee4.Signature)
            {
            }
            column(FifthApproverID; ApproverID[5])
            {
            }
            column(DateTimeFifthApprove; ApproveDateTime[5])
            {
            }
            column(FifthApproveSignature; ApproverEmployee5.Signature)
            {
            }
            column(No_PaymentVoucher; "No.")
            {
            }
            column(VoucherDate_PaymentVoucher; "Voucher Date")
            {
            }
            column(PayingBank_PaymentVoucher; "Paying Bank")
            {
            }
            column(PayingBankName_PaymentVoucher; "Paying Bank Name")
            {
            }
            column(PaymentFor_PaymentVoucher; "Payment For")
            {
            }
            column(Payee_PaymentVoucher; Payee)
            {
            }
            column(GrossAmount_PaymentVoucher; "Gross Amount")
            {
            }
            column(NetAmount_PaymentVoucher; "Net Amount")
            {
            }
            column(AmountLCY_PaymentVoucher; "Amount(LCY)")
            {
            }
            column(NetAmountLCY_PaymentVoucher; "Net Amount(LCY)")
            {
            }
            column(PostingDate_PaymentVoucher; "Posting Date")
            {
            }
            column(PaymentMethod_PaymentVoucher; "Payment Method")
            {
            }
            column(ChequeNo_PaymentVoucher; "Cheque No.")
            {
            }
            column(EFTNo_PaymentVoucher; "EFT No.")
            {
            }
            column(Status_PaymentVoucher; Status)
            {
            }
            column(Posted_PaymentVoucher; Posted)
            {
            }
            column(CurrencyCode_PaymentVoucher; "Currency Code")
            {
            }
            column(ExchangeRate_PaymentVoucher; "Exchange Rate")
            {
            }
            column(GlobalDimension1Code_PaymentVoucher; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code_PaymentVoucher; "Global Dimension 2 Code")
            {
            }
            column(CreatedBy_PaymentVoucher; "Created By")
            {
            }
            column(CreatedOn_PaymentVoucher; "Created On")
            {
            }
            column(NoSeries_PaymentVoucher; "No. Series")
            {
            }
            column(BankBalance_PaymentVoucher; "Bank Balance")
            {
            }
            column(PostedOn_PaymentVoucher; "Posted On")
            {
            }
            column(PostedBy_PaymentVoucher; "Posted By")
            {
            }
            column(TimePosted_PaymentVoucher; "Time Posted")
            {
            }
            column(Amount_in_Words; AmountInWords)
            {
            }
            column(shortcutdim1; ShortcutDimName[1])
            {
            }
            column(shortcutdim2; ShortcutDimName[2])
            {
            }
            column(shortcutdim3; ShortcutDimName[3])
            {
            }
            column(shortcutdim4; ShortcutDimName[4])
            {
            }
            column(shortcutdim5; ShortcutDimName[5])
            {
            }
            dataitem("Payment Voucher Lines"; "Payment Voucher Lines")
            {
                DataItemLink = "Voucher No." = field("No.");
                DataItemTableView = sorting("Voucher No.", "Line No.");

                column(AccountType_PaymentVoucherLines; "Account Type")
                {
                }
                column(AccountNo_PaymentVoucherLines; "Account No")
                {
                }
                column(AccountName_PaymentVoucherLines; "Account Name")
                {
                }
                column(Description_PaymentVoucherLines; Description)
                {
                }
                column(Amount_PaymentVoucherLines; Amount)
                {
                }
                column(AppliestoDocNo_PaymentVoucherLines; "Applies to Doc. No")
                {
                }
                column(RemainingAmount_PaymentVoucherLines; "Remaining Amount")
                {
                }
                column(WTaxCode_PaymentVoucherLines; "W/Tax Code")
                {
                }
                column(WVATCode_PaymentVoucherLines; "W/VAT Code")
                {
                }
                column(RetentionCode_PaymentVoucherLines; "Retention Code")
                {
                }
                column(WTaxAmount_PaymentVoucherLines; "W/Tax Amount")
                {
                }
                column(WVATAmount_PaymentVoucherLines; "W/VAT Amount")
                {
                }
                column(RetentionAmount_PaymentVoucherLines; "Retention Amount")
                {
                }
                column(VATCode_PaymentVoucherLines; "VAT Code")
                {
                }
                column(VATAmount_PaymentVoucherLines; "VAT Amount")
                {
                }
                column(NetAmount_PaymentVoucherLines; "Net Amount")
                {
                }
                column(LineNo_PaymentVoucherLines; "Line No.")
                {
                }
                column(VendorInvoiceNo_PaymentVoucherLines; "Vendor Invoice No.")
                {
                }
                column(Percentage; Percentage)
                {
                }
                column(NetAmountLCY_PaymentVoucherLines; "Net Amount(LCY)")
                {
                }
                column(V_Inv; VendorInvoiceNo)
                {
                }
                column(Global_Dimension_1_Code; "Global Dimension 1 Code")
                {
                }
                column(Global_Dimension_2_Code; "Global Dimension 2 Code")
                {
                }
                column(Shortcut_Dimension_3_Code; "Shortcut Dimension 3 Code")
                {
                }
                column(Shortcut_Dimension_4_Code; "Shortcut Dimension 4 Code")
                {
                }
                column(ShortcutDimCode_5_; "ShortcutDimCode[5]")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Percentage := 100;
                    if "Percentage to Pay" <> 0 then
                        Percentage := "Percentage to Pay";

                    VendorInvoiceNo := "Vendor Invoice No.";
                    if PurchInvHeader.Get("Applies to Doc. No") then
                        VendorInvoiceNo := PurchInvHeader."Vendor Invoice No.";

                    Clear(ShortcutDimName);
                    ShortcutDimName[1] := GetDimValueName(1, "Global Dimension 1 Code", false);
                    ShortcutDimName[2] := GetDimValueName(2, "Global Dimension 2 Code", false);
                    ShortcutDimName[3] := GetDimValueName(3, "Shortcut Dimension 3 Code", false);
                    ShortcutDimName[4] := GetDimValueName(4, "Shortcut Dimension 4 Code", false);
                    ShortcutDimName[5] := GetDimValueName(5, "ShortcutDimCode[5]", true);
                end;
            }

            trigger OnPreDataItem()
            begin
                CompanyInformation.Get();
                CompanyInformation.CalcFields(Picture);
            end;

            trigger OnAfterGetRecord()
            var
                PVLines: Record "Payment Voucher Lines";
                ApprovalEntry: Record "Approval Entry";
                CheckReport: Report "Check for Million";
                NoText: array[2] of Text[80];
                Seq: Integer;
            begin
                Clear(SenderID);
                Clear(DateTimeSend);
                Clear(ApproverID);
                Clear(ApproveDateTime);
                Clear(SenderEmployee);
                Clear(ApproverEmployee1);
                Clear(ApproverEmployee2);
                Clear(ApproverEmployee3);
                Clear(ApproverEmployee4);
                Clear(ApproverEmployee5);

                ApprovalEntry.SetRange("Table ID", Database::"Payment Voucher");
                ApprovalEntry.SetRange("Document No.", "No.");
                if ApprovalEntry.FindFirst() then begin
                    SenderID := ApprovalEntry."Sender ID";
                    DateTimeSend := Format(ApprovalEntry."Date-Time Sent for Approval");
                    GetEmployeeSignature(SenderID, SenderEmployee);
                end;

                ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
                for Seq := 1 to 5 do begin
                    ApprovalEntry.SetRange("Sequence No.", Seq);
                    if ApprovalEntry.FindFirst() then begin
                        ApproverID[Seq] := ApprovalEntry."Approver ID";
                        ApproveDateTime[Seq] := Format(ApprovalEntry."Last Date-Time Modified");
                    end;
                end;
                GetEmployeeSignature(ApproverID[1], ApproverEmployee1);
                GetEmployeeSignature(ApproverID[2], ApproverEmployee2);
                GetEmployeeSignature(ApproverID[3], ApproverEmployee3);
                GetEmployeeSignature(ApproverID[4], ApproverEmployee4);
                GetEmployeeSignature(ApproverID[5], ApproverEmployee5);

                AmountInWords := '';
                PVLines.SetRange("Voucher No.", "No.");
                PVLines.CalcSums("Net Amount");
                if PVLines."Net Amount" <> 0 then begin
                    CheckReport.InitTextVariable();
                    CheckReport.FormatNoText(NoText, Round(PVLines."Net Amount"), "Currency Code");
                    AmountInWords := DelChr(NoText[1] + ' ' + NoText[2], '<>', ' *');
                end;
            end;
        }
    }

    var
        CompanyInformation: Record "Company Information";
        PurchInvHeader: Record "Purch. Inv. Header";
        SenderEmployee: Record "HR Employees";
        ApproverEmployee1: Record "HR Employees";
        ApproverEmployee2: Record "HR Employees";
        ApproverEmployee3: Record "HR Employees";
        ApproverEmployee4: Record "HR Employees";
        ApproverEmployee5: Record "HR Employees";
        SenderID: Code[50];
        DateTimeSend: Text;
        ApproverID: array[5] of Code[50];
        ApproveDateTime: array[5] of Text;
        Percentage: Decimal;
        AmountInWords: Text;
        VendorInvoiceNo: Code[50];
        ShortcutDimName: array[5] of Text;

    local procedure GetEmployeeSignature(UserID: Code[50]; var HREmployee: Record "HR Employees")
    begin
        Clear(HREmployee);
        if UserID = '' then
            exit;
        HREmployee.SetRange("User ID", UserID);
        if HREmployee.FindFirst() then
            HREmployee.CalcFields(Signature);
    end;

    local procedure GetDimValueName(GlobalDimNo: Integer; DimValueCode: Code[20]; UsePartnerCode: Boolean): Text
    var
        DimValue: Record "Dimension Value";
    begin
        if DimValueCode = '' then
            exit('');
        DimValue.SetRange("Global Dimension No.", GlobalDimNo);
        DimValue.SetRange(Code, DimValueCode);
        if not DimValue.FindFirst() then
            exit('');
        if UsePartnerCode then
            exit(DimValue."Unique Partner");
        exit(DimValue.Name);
    end;
}
