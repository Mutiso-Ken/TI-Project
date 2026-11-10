page 64041 "Payment Voucher Card"
{
    Caption = 'Payment Voucher Card';
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Payment Voucher";
    PromotedActionCategories = 'New,Process,Report,Approvals,Attachments';
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Voucher Date"; Rec."Voucher Date")
                {
                    ApplicationArea = All;
                    Editable = HeaderEditable;
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Paying Bank"; Rec."Paying Bank")
                {
                    ApplicationArea = All;
                    Editable = NotPosted;
                    ShowMandatory = true;
                }
                field("Paying Bank Name"; Rec."Paying Bank Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Payment For"; Rec."Payment For")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Narration';
                    Editable = HeaderEditable;
                }
                field(Payee; Rec.Payee)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Editable = NotPosted;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    Editable = HeaderEditable;
                }
                field("Gross Amount"; Rec."Gross Amount")
                {
                    ApplicationArea = All;
                }
                field("Amount(LCY)"; Rec."Amount(LCY)")
                {
                    ApplicationArea = All;
                }
                field("Net Amount"; Rec."Net Amount")
                {
                    ApplicationArea = All;
                }
                field("Net Amount(LCY)"; Rec."Net Amount(LCY)")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    Editable = HeaderEditable;

                    trigger OnAssistEdit()
                    var
                        ChangeExchangeRate: Page "Change Exchange Rate";
                    begin
                        ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Exchange Rate Factor", Rec."Voucher Date");
                        if ChangeExchangeRate.RunModal() = Action::OK then
                            Rec.Validate("Exchange Rate Factor", ChangeExchangeRate.GetParameter());
                    end;
                }
                field("Exchange Rate"; Rec."Exchange Rate")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Editable = HeaderEditable;
                    ShowMandatory = true;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Editable = HeaderEditable;
                    ShowMandatory = true;
                }
                field("Approval Entries"; Rec."Approval Entries")
                {
                    ApplicationArea = All;
                }
                field("Rejection Comments"; Rec."Rejection Comments")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("Exchange Rate Factor"; Rec."Exchange Rate Factor")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Applies To Doc No."; Rec."Applies To Doc No.")
                {
                    ApplicationArea = All;
                }
                field("Payment Configuration"; Rec."Payment Configuration")
                {
                    ApplicationArea = All;
                    Editable = HeaderEditable;
                }
            }
            group("Posting Details")
            {
                Caption = 'Posting Details';
                Editable = NotPosted;
                Visible = PostingDetailsVisible;

                group("M-Pesa Withdrawal")
                {
                    Caption = 'M-Pesa Withdrawal';
                    Visible = MpesaVisible;

                    field("Withdrawal Fee"; Rec."Withdrawal Fee")
                    {
                        ApplicationArea = All;
                    }
                    field("EFT No."; Rec."EFT No.")
                    {
                        ApplicationArea = All;
                        Visible = false;
                    }
                }
                group("Cheque Details")
                {
                    Caption = 'Cheque Details';
                    Visible = ChequeNoVisible;

                    field("Cheque No."; Rec."Cheque No.")
                    {
                        ApplicationArea = All;
                    }
                    field("Cheque Date"; Rec."Cheque Date")
                    {
                        ApplicationArea = All;
                    }
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Payment Method"; Rec."Payment Method")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        SetPaymentMethodVisibility();
                    end;
                }
            }
            part("Payment Voucher Subform"; "Payment Voucher Subform")
            {
                ApplicationArea = All;
                Editable = NotPosted;
                SubPageLink = "Voucher No." = field("No.");
                UpdatePropagation = Both;
            }
            group(Trail)
            {
                Caption = 'Audit Trail';

                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                field("Created On"; Rec."Created On")
                {
                    ApplicationArea = All;
                }
                field("Posted On"; Rec."Posted On")
                {
                    ApplicationArea = All;
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = All;
                }
                field("Time Posted"; Rec."Time Posted")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(64024),
                              "No." = field("No.");
            }
            part("Pending Approval FactBox"; "Pending Approval FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Table ID" = const(64024),
                              "Document No." = field("No.");
            }
            part("Approval Comments"; "Approval Comments FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Caption = 'Send Approval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    VariantRec: Variant;
                begin
                    Rec.TestField(Status, Rec.Status::New);
                    Rec.TestField("Global Dimension 1 Code");
                    Rec.TestField("Global Dimension 2 Code");
                    Rec.TestField("Paying Bank");
                    CheckLinesBeforeApproval();

                    if not Confirm(SendForApprovalQst) then
                        exit;

                    VariantRec := Rec;
                    if CustomApprovals.CheckApprovalsWorkflowEnabled(VariantRec) then
                        CustomApprovals.OnSendDocForApproval(VariantRec);
                    CurrPage.Close();
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Caption = 'Cancel Approval Request';
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    VariantRec: Variant;
                begin
                    Rec.TestField(Status, Rec.Status::"Pending Approval");
                    Rec.TestField("Rejection Comments");
                    if not Confirm(CancelApprovalQst) then
                        exit;

                    VariantRec := Rec;
                    if CustomApprovals.CheckApprovalsWorkflowEnabled(VariantRec) then begin
                        CustomApprovals.OnCancelDocApprovalRequest(VariantRec);
                        Rec.Get(Rec."No.");
                        Rec.Status := Rec.Status::New;
                        Rec.Modify();
                    end;
                    CurrPage.Close();
                end;
            }
            action(Approvals)
            {
                AccessByPermission = TableData "Approval Entry" = R;
                ApplicationArea = All;
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'View the approval entries for this payment voucher.';

                trigger OnAction()
                begin
                    ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                end;
            }
            action(Approve)
            {
                ApplicationArea = All;
                Caption = 'Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Approve the requested changes.';
                Visible = OpenApprovalEntriesExistForCurrUser;

                trigger OnAction()
                begin
                    if not Confirm(ApproveQst) then
                        exit;
                    ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                    CurrPage.Close();
                end;
            }
            action(Reject)
            {
                ApplicationArea = All;
                Caption = 'Reject';
                Image = Reject;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Reject the approval request.';
                Visible = OpenApprovalEntriesExistForCurrUser;

                trigger OnAction()
                begin
                    if not Confirm(RejectQst) then
                        exit;
                    ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                    CurrPage.Close();
                end;
            }
            action(Delegate)
            {
                ApplicationArea = All;
                Caption = 'Delegate';
                Image = Delegate;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Delegate the approval to a substitute approver.';
                Visible = OpenApprovalEntriesExistForCurrUser;

                trigger OnAction()
                begin
                    if not Confirm(DelegateQst) then
                        exit;
                    ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);
                    CurrPage.Close();
                end;
            }
            action(Comment)
            {
                ApplicationArea = All;
                Caption = 'Comments';
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'View or add comments for the record.';
                Visible = OpenApprovalEntriesExistForCurrUser;

                trigger OnAction()
                begin
                    ApprovalsMgmt.GetApprovalComment(Rec);
                end;
            }
            action("Re-Open")
            {
                ApplicationArea = All;
                Caption = 'Re-Open';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                begin
                    case Rec.Status of
                        Rec.Status::"Pending Approval":
                            begin
                                ApprovalEntry.Reset();
                                ApprovalEntry.SetRange("Table ID", Database::"Payment Voucher");
                                ApprovalEntry.SetRange("Document No.", Rec."No.");
                                if not ApprovalEntry.IsEmpty() then
                                    ApprovalEntry.DeleteAll();

                                Rec.Status := Rec.Status::New;
                                Rec.Modify(true);
                                Commit();
                                CurrPage.Update(false);
                                Message(ReopenedMsg);
                            end;
                        Rec.Status::Approved:
                            Error(AlreadyApprovedErr);
                        Rec.Status::Rejected:
                            Error(AlreadyRejectedErr);
                        else
                            Error(OnlyPendingErr);
                    end;
                end;
            }
            action(Post)
            {
                ApplicationArea = All;
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    PostVoucher();
                end;
            }
            action(Archive)
            {
                ApplicationArea = All;
                Caption = 'Archive';
                Image = Archive;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    if not Confirm(ArchiveQst) then
                        exit;
                    Rec.Archived := true;
                    Rec.Modify(true);
                    Message(ArchivedMsg);
                end;
            }
            action(Print)
            {
                ApplicationArea = All;
                Caption = 'Print';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    PaymentVoucher: Record "Payment Voucher";
                begin
                    PaymentVoucher.SetRange("No.", Rec."No.");
                    Report.Run(Report::"Payment Voucher Document", true, false, PaymentVoucher);
                end;
            }
            action("Print Purchase Invoice")
            {
                ApplicationArea = All;
                Caption = 'Print Purchase Invoice';
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                var
                    PurchInvHeader: Record "Purch. Inv. Header";
                    PaymentVoucherLines: Record "Payment Voucher Lines";
                begin
                    TestAppliesToDocNo();
                    PaymentVoucherLines.SetRange("Voucher No.", Rec."No.");
                    if PaymentVoucherLines.FindFirst() then begin
                        PurchInvHeader.SetRange("No.", PaymentVoucherLines."Applies to Doc. No");
                        if not PurchInvHeader.IsEmpty() then
                            Report.RunModal(Report::"Purchase - Invoice", true, false, PurchInvHeader);
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance();
    end;

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Payment Type" := Rec."Payment Type"::"Payment Voucher";
        Rec.Validate("Payment Type");
    end;

    trigger OnOpenPage()
    begin
        SetControlAppearance();
    end;

    trigger OnClosePage()
    begin
        if Rec."No." = '' then
            exit;
        if not Rec.Get(Rec."No.") then
            exit;
        Rec.CalcFields("Approval Status");
        if (Rec."Approval Status" = Rec."Approval Status"::Approved) and (Rec.Status <> Rec.Status::Approved) then begin
            Rec.Status := Rec.Status::Approved;
            Rec.Modify();
        end;
    end;

    var
        CustomApprovals: Codeunit "Custom Approvals Codeunit";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        PaymentVoucherManagement: Codeunit "Payment Voucher Management";
        PaymentMethod: Record "Payment Method";
        HeaderEditable: Boolean;
        NotPosted: Boolean;
        PostingDetailsVisible: Boolean;
        ChequeNoVisible: Boolean;
        MpesaVisible: Boolean;
        OpenApprovalEntriesExist: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        SendForApprovalQst: Label 'Are you sure you want to send it for approval?';
        CancelApprovalQst: Label 'Are you sure you want to cancel the approval request?';
        ApproveQst: Label 'Are you sure you want to approve the document?';
        RejectQst: Label 'Are you sure you want to reject the document?';
        DelegateQst: Label 'Are you sure you want to delegate the document?';
        PostQst: Label 'Are you sure you want to post payment voucher %1?', Comment = '%1 = voucher no.';
        ArchiveQst: Label 'Are you sure you want to archive this document?';
        ArchivedMsg: Label 'Document has been archived successfully.';
        PostedMsg: Label 'Payment voucher %1 has been posted.', Comment = '%1 = voucher no.';
        AlreadyPostedMsg: Label 'Payment voucher %1 already has bank ledger entries. It has been marked as posted.', Comment = '%1 = voucher no.';
        ReopenedMsg: Label 'The approval request has been canceled, and the status is set to New.';
        AlreadyApprovedErr: Label 'The document is already approved and cannot be re-opened.';
        AlreadyRejectedErr: Label 'The document has been rejected and cannot be re-opened.';
        OnlyPendingErr: Label 'Only documents with Pending Approval status can be re-opened.';
        OverpayTaxErr: Label 'You can not pay more tax/VAT on account %1 than you owe.', Comment = '%1 = G/L account';
        DuplicateChequeErr: Label 'Cheque No. %1 has already been used.', Comment = '%1 = cheque no.';

    local procedure SetControlAppearance()
    begin
        HeaderEditable := Rec.Status in [Rec.Status::New, Rec.Status::"Pending Approval"];
        NotPosted := not Rec.Posted;
        PostingDetailsVisible := Rec.Status = Rec.Status::Approved;
        SetPaymentMethodVisibility();

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;

    local procedure SetPaymentMethodVisibility()
    begin
        ChequeNoVisible := false;
        MpesaVisible := false;
        if PaymentMethod.Get(Rec."Payment Method") then begin
            ChequeNoVisible := PaymentMethod."Is Check";
            MpesaVisible := PaymentMethod."M-PESA";
        end;
    end;

    local procedure CheckLinesBeforeApproval()
    var
        PVLines: Record "Payment Voucher Lines";
        VATSetup: Record "VAT Posting Setup";
        GLAccount: Record "G/L Account";
    begin
        // Do not over-pay withholding tax / VAT liabilities
        PVLines.SetRange("Voucher No.", Rec."No.");
        PVLines.SetRange("Account Type", PVLines."Account Type"::"G/L Account");
        if PVLines.FindSet() then
            repeat
                VATSetup.Reset();
                VATSetup.SetRange("Payables Credit Account", PVLines."Account No");
                if not VATSetup.IsEmpty() then
                    if GLAccount.Get(PVLines."Account No") then begin
                        GLAccount.CalcFields(Balance);
                        if Abs(GLAccount.Balance) < PVLines.Amount then
                            Error(OverpayTaxErr, PVLines."Account No");
                    end;
            until PVLines.Next() = 0;
    end;

    local procedure PostVoucher()
    var
        PVLines: Record "Payment Voucher Lines";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        ChequeLedgerEntries: Record "Cheque Ledger Entries";
    begin
        Rec.TestField(Status, Rec.Status::Approved);
        Rec.TestField(Posted, false);
        Rec.TestField("Paying Bank");
        Rec.TestField("Posting Date");
        Rec.TestField("Payment Method");
        Rec.TestField("Global Dimension 1 Code");
        Rec.TestField("Global Dimension 2 Code");
        Rec.TestField(Payee);

        PVLines.SetRange("Voucher No.", Rec."No.");
        if PVLines.FindSet() then
            repeat
                PVLines.TestField(Amount);
            until PVLines.Next() = 0;

        if PaymentMethod.Get(Rec."Payment Method") then
            if PaymentMethod."Is Check" then begin
                Rec.TestField("Cheque No.");
                Rec.TestField("Cheque Date");
                ChequeLedgerEntries.SetFilter("Original Cheque No.", '%1', Rec."Cheque No.");
                if not ChequeLedgerEntries.IsEmpty() then
                    Error(DuplicateChequeErr, Rec."Cheque No.");
                ChequeLedgerEntries.Reset();
                ChequeLedgerEntries.SetFilter("New Cheque No.", '%1', Rec."Cheque No.");
                if not ChequeLedgerEntries.IsEmpty() then
                    Error(DuplicateChequeErr, Rec."Cheque No.");
            end;

        // Already posted (e.g. the status update was lost after posting)
        BankAccountLedgerEntry.SetRange("Document No.", Rec."No.");
        if not BankAccountLedgerEntry.IsEmpty() then begin
            Rec.Posted := true;
            Rec."Posted By" := CopyStr(UserId(), 1, MaxStrLen(Rec."Posted By"));
            Rec."Posted On" := Today;
            Rec."Time Posted" := Time;
            Rec.Modify();
            Message(AlreadyPostedMsg, Rec."No.");
            exit;
        end;

        if not Confirm(PostQst, false, Rec."No.") then
            exit;

        PaymentVoucherManagement.PostPaymentVoucher(Rec);
        Message(PostedMsg, Rec."No.");
        CurrPage.Close();
    end;

    local procedure TestAppliesToDocNo()
    var
        PaymentVoucherLines: Record "Payment Voucher Lines";
    begin
        PaymentVoucherLines.SetRange("Voucher No.", Rec."No.");
        if PaymentVoucherLines.FindSet() then
            repeat
                PaymentVoucherLines.TestField("Applies to Doc. No");
            until PaymentVoucherLines.Next() = 0;
    end;
}
