#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 80072 "Imprest Request Card"
{
    Caption = 'Imprest Request Card';
    DeleteAllowed = true;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Category6_caption,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    RefreshOnActivate = true;
    SourceTable = "Purchase Header";
    SourceTableView = where("Document Type" = const(Quote),
                            IM = filter(true));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = statuseditable;
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                }

                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Date';
                }
                field("Posting Description"; Rec."Posting Description")
                {
                    ApplicationArea = Basic;
                    Caption = 'Description';
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = Basic;
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = Basic;
                }
                field("Requisition No"; Rec."Requisition No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Requisition No';
                }
                field("Paying Account No"; Rec."Paying Account No")
                {
                    ApplicationArea = Basic;
                }

                field("Paying Account Name"; Rec."Paying Account Name")
                {
                    ApplicationArea = Basic;
                }
                field(Narration; Rec.Narration)
                {
                    ApplicationArea = all;
                    MultiLine = true;

                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field("Employee No"; Rec."Employee No")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field("Mission Proposal No"; Rec."Mission Proposal No")
                {
                    ApplicationArea = Basic;
                }
                field(Surrendered; Rec.Surrendered)
                {
                    ApplicationArea = Basic;
                }
            }
            group("Foreign Trade")
            {

                Caption = 'Foreign Trade';
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        Clear(ChangeExchangeRate);
                        ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", WorkDate);
                        if ChangeExchangeRate.RunModal = Action::OK then begin
                            Rec.Validate("Currency Factor", ChangeExchangeRate.GetParameter);
                            CurrPage.Update;
                        end;
                        Clear(ChangeExchangeRate);
                    end;

                    trigger OnValidate()
                    begin
                        CurrencyCodeOnAfterValidate;
                    end;
                }
            }
            part(ImprestLines; "Imprest Subform")
            {
                Editable = statuseditable;
                SubPageLink = "Document No." = field("No.");
                ApplicationArea = All;
            }
        }
        area(factboxes)
        {
            systempart(Control5; Notes)
            {
                Visible = true;
            }
            part(Control20; "Approval FactBox")
            {
                SubPageLink = "Table ID" = const(38),
                              "Document Type" = field("Document Type"),
                              "Document No." = field("No.");
                Visible = false;
            }
            systempart(Control17; Links)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Quote")
            {
                Caption = '&Quote';
                Image = Quote;
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        Rec.CalcInvDiscForHeader;
                        Commit;
                        Page.RunModal(Page::"Purchase Statistics", Rec);
                    end;
                }
                action(Vendor)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor';
                    Image = Vendor;
                    RunObject = Page "Vendor Card";
                    RunPageLink = "No." = field("Buy-from Vendor No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Purch. Comment Sheet";
                    RunPageLink = "Document Type" = field("Document Type"),
                                  "No." = field("No."),
                                  "Document Line No." = const(0);
                }
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDocDim;
                        CurrPage.SaveRecord;
                    end;
                }
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        ApprovalEntries.SetRecordFilters(Database::"Purchase Header", Rec."Document Type", Rec."No.");
                        ApprovalEntries.Run;
                    end;
                }
            }
        }
        area(processing)
        {
            action(Attachments)
            {
                ApplicationArea = Basic;
                Ellipsis = true;
                Image = Attachments;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Document Uploads";
                RunPageLink = "Document Number" = field("No.");
            }
            action("&Print")
            {
                ApplicationArea = Basic;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin

                    if LinesCommitted then
                        Error('All Lines should be committed');
                    Rec.Reset;
                    Rec.SetRange("No.", Rec."No.");
                    Report.Run(80027, true, true, Rec);
                    Rec.Reset;
                    //DocPrint.PrintPurchHeader(Rec);
                end;
            }
            action("Fix Dimensions")
            {
                ApplicationArea = Basic;
                Caption = 'Fix Dimensions';
                Ellipsis = true;
                Image = RefreshLines;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    BudgetCat := '';
                    Dep := '';
                    BudgetCat := Rec."Shortcut Dimension 4 Code";
                    Dep := Rec."Shortcut Dimension 5 Code";
                    Rec.Modify;
                    Message('Fixed');
                end;
            }
            group(ActionGroup3)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                separator(Action148)
                {
                }
                action(Release)
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';
                    Visible = false;

                    trigger OnAction()
                    var
                        ReleasePurchDoc: Codeunit "Release Purchase Document";
                    begin
                        ReleasePurchDoc.PerformManualRelease(Rec);
                    end;
                }

                action("Re&open")
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&open';
                    Image = ReOpen;
                    Visible = false;

                    trigger OnAction()
                    var
                        ReleasePurchDoc: Codeunit "Release Purchase Document";
                    begin
                        ReleasePurchDoc.PerformManualReopen(Rec);
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Calculate &Invoice Discount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Calculate &Invoice Discount';
                    Image = CalculateInvoiceDiscount;

                    trigger OnAction()
                    begin
                        ApproveCalcInvDisc;
                    end;
                }
                separator(Action144)
                {
                }
                action("Get St&d. Vend. Purchase Codes")
                {
                    ApplicationArea = Basic;
                    Caption = 'Get St&d. Vend. Purchase Codes';
                    Ellipsis = true;
                    Image = VendorCode;

                    trigger OnAction()
                    var
                        StdVendPurchCode: Record "Standard Vendor Purchase Code";
                    begin
                        StdVendPurchCode.InsertPurchLines(Rec);
                    end;
                }
                separator(Action146)
                {
                }
                action(Post)
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Imprest';
                    Ellipsis = true;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        LineNo: Integer;
                    begin
                        if Confirm('Are you sure you want to Post this imprest') then begin
                            Rec.TestField(Status, Rec.Status::Released);
                            GenJnlLine2.RESET;
                            GenJnlLine2.SETRANGE("Journal Template Name", 'PAYMENTS');
                            GenJnlLine2.SETRANGE("Journal Batch Name", 'IMPREST');
                            IF GenJnlLine2.FIND THEN begin
                                GenJnlLine2.DELETE;
                            end;

                            LineNo := LineNo + 1000;
                            GenJnlLine.Init;
                            GenJnlLine."Journal Template Name" := 'PAYMENTS';
                            GenJnlLine."Journal Batch Name" := 'IMPREST';
                            GenJnlLine."Line No." := LineNo;

                            GenJnlLine."Source Code" := 'PAYMENTJNL';
                            GenJnlLine."Posting Date" := Today;
                            GenJnlLine."Document Type" := GenJnlLine."document type"::Invoice;
                            GenJnlLine."Document No." := Rec."No.";
                            GenJnlLine."External Document No." := Rec."Cheque No";
                            GenJnlLine."Account Type" := GenJnlLine."account type"::Customer;
                            GenJnlLine."Account No." := Rec."Account No";
                            GenJnlLine.Validate(GenJnlLine."Account No.");
                            GenJnlLine.Description := 'Imprest Request to: ' + Rec."Account No";
                            Amt := 0;
                            PurchLine.Reset;
                            PurchLine.SetRange("Document No.", Rec."No.");
                            if PurchLine.FindSet then begin
                                repeat
                                    Amt := Amt + PurchLine."Line Amount";
                                until PurchLine.Next = 0;
                            end;
                            if Amt = 0 then Error('Imprest cannot have 0 amount');
                            GenJnlLine.Amount := Amt;
                            GenJnlLine.Validate(GenJnlLine.Amount);
                            GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"Bank Account";
                            GenJnlLine."Bal. Account No." := Rec."Paying Account No";
                            GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                            //Added for Currency Codes
                            GenJnlLine."Currency Code" := Rec."Currency Code";
                            GenJnlLine.Validate("Currency Code");
                            GenJnlLine."Currency Factor" := Rec."Currency Factor";
                            GenJnlLine.Validate("Currency Factor");
                            GenJnlLine."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
                            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                            GenJnlLine."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                            GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                            GenJnlLine.ValidateShortcutDimCode(3, Rec."Shortcut Dimension 3 Code");
                            GenJnlLine.ValidateShortcutDimCode(4, Rec."Shortcut Dimension 4 Code");
                            GenJnlLine.ValidateShortcutDimCode(5, Rec."Shortcut Dimension 5 Code");
                            if GenJnlLine.Amount <> 0 then
                                GenJnlLine.Insert;


                            // GenJnlLine.RESET;
                            // GenJnlLine.SETRANGE(GenJnlLine."Journal Template Name", 'PAYMENTS');
                            // GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", 'IMPREST');
                            // CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Line", GenJnlLine);


                            Rec.Completed := true;
                            Rec.Status := Rec.Status::Released;
                            PurchaseHeader2.Reset;
                            PurchaseHeader2.SetRange("No.", Rec."Mission Proposal No");
                            if PurchaseHeader2.FindFirst then begin
                                PurchaseHeader2.Completed := true;
                                PurchaseHeader2."Imprest No" := Rec."No.";
                                PurchaseHeader2.Modify;
                            end;

                            Rec.Modify;

                            /* GenJnlLine2.RESET;
                              GenJnlLine2.SETRANGE("Journal Template Name",'PAYMENTS');
                              GenJnlLine2.SETRANGE("Journal Batch Name",'IMPREST');
                              IF GenJnlLine2.FIND THEN
                              GenJnlLine2.DELETE;*/

                            Message('Imprest Request Posted Successfully');


                            GenJnlLine2.Reset;
                            GenJnlLine2.SetRange("Journal Template Name", 'PAYMENTS');
                            GenJnlLine2.SetRange("Journal Batch Name", 'IMPREST');
                            if GenJnlLine2.FindSet() then begin
                                PAGE.Run(PAGE::"General Journal", GenJnlLine2);
                            end;

                        end;

                    end;
                }
                action(CopyDocument)
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy Document';
                    Ellipsis = true;
                    Image = CopyDocument;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CopyPurchDoc.SetPurchHeader(Rec);
                        CopyPurchDoc.RunModal;
                        Clear(CopyPurchDoc);
                    end;
                }
                action("Archive Document")
                {
                    ApplicationArea = Basic;
                    Caption = 'Archi&ve Document';
                    Image = Archive;

                    trigger OnAction()
                    begin
                        //ArchiveManagement.ArchivePurchDocument(Rec);
                        //CurrPage.UPDATE(FALSE);
                        if Confirm('Are you sure you want to archive the imprest proposal') then begin
                            Rec.Archived := true;
                            Rec.Modify;
                        end;
                        Message('Document Archived');
                    end;
                }
                separator(Action147)
                {
                }
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Request approval of the document.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        //if ApprovalsMgmt.CheckPurchaseApprovalPossible(Rec) then
                        ApprovalsMgmt.OnSendPurchaseDocForApproval(Rec);
                    end;
                }
                separator(Action10)
                {
                }
            }
            group("Make OrderII")
            {
                Caption = 'Make Order';
                Image = MakeOrder;
                action("Make Order")
                {
                    ApplicationArea = Basic;
                    Caption = 'Make &Order';
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = false;

                    trigger OnAction()
                    var
                        SalesHeader: Record "Sales Header";
                    begin
                        //IF ApprovalMgt.PrePostApprovalCheck(SalesHeader,Rec) THEN
                        //CODEUNIT.RUN(CODEUNIT::"Purch.-Quote to Order (Yes/No)",Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        /*   UpdateControls;
        PurchHeader.RESET;
        PurchHeader.SETRANGE("User ID",USERID);
        PurchHeader.SETRANGE(PurchHeader.Status,PurchHeader.Status::Open);
        //PurchHeader.SETRANGE(SHeader."Request date",TODAY);
         IF PurchHeader.COUNT>1 THEN
           ERROR('You have unused requisition records under your account,Please utilize/release them for approval'+
             ' before creating a new record');
           */

    end;

    trigger OnAfterGetRecord()
    begin
        CurrPageUpdate;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord;
        exit(Rec.ConfirmDeletion);
        Error('Not Allowed!');
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        Rec.IM := true;
        Rec."Document Type" := Rec."Document Type"::Quote;
        rec.Insert();
        PurchasesPayablesSetup.Get;

        Rec."No." := NoSeriesManagement.GetNextNo(PurchasesPayablesSetup."Imprest Nos.", Today, true);

        /*SHeader.RESET;
        SHeader.SETRANGE("User ID",USERID);
        SHeader.SETRANGE(SHeader.Status,SHeader.Status::Open);
       // SHeader.SETRANGE(SHeader."Request date",TODAY);
        IF SHeader.COUNT>1 THEN
          ERROR('You have unused requisition records under your account,please utilize/release them for approval'+
            ' before creating a new record');
            */

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        PurchasesPayablesSetup.Get;
        Rec."No." := NoSeriesManagement.GetNextNo(PurchasesPayablesSetup."Imprest Nos.", Today, true);
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter;
        Rec."Assigned User ID" := UserId;
        Rec."User ID" := UserId;
        Rec."Requested Receipt Date" := Today;
        Rec."Document Type" := Rec."document type"::Quote;
        Rec.IM := true;
        Rec."Buy-from Vendor No." := 'FM-V00123';
        Rec."Vendor Posting Group" := 'TRADERS';
        Rec."Posting Description" := '';

        UpdateControls;
    end;



    trigger OnNextRecord(Steps: Integer): Integer
    begin
        UpdateControls;
    end;

    trigger OnOpenPage()
    begin

        if UserMgt.GetPurchasesFilter <> '' then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Responsibility Center", UserMgt.GetPurchasesFilter);
            Rec.FilterGroup(0);
        end;
        Rec."Document Type" := Rec."document type"::Quote;
        Rec."Buy-from Vendor No." := 'FM-V00123';
        Rec."Vendor Posting Group" := 'TRADERS';
        Rec."Assigned User ID" := UserId;
        Rec.IM := true;
    end;

    var
        ChangeExchangeRate: Page "Change Exchange Rate";
        CopyPurchDoc: Report "Copy Purchase Document";
        DocPrint: Codeunit "Document-Print";
        UserMgt: Codeunit "User Setup Management";
        ArchiveManagement: Codeunit ArchiveManagement;
        PurchLine: Record "Purchase Line";
        StatusEditable: Boolean;
        Vendor: Record Vendor;
        PurchHeader: Record "Purchase Header";
        SHeader: Record "Purchase Header";
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        UserSetup: Record "User Setup";
        HREmployees: Record "HR Employees";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        PurchLine2: Record "Purchase Line";
        PurchaseLine3: Record "Purchase Line";
        PurchaseHeader: Record "Purchase Header";
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        GenJnlLine: Record "Gen. Journal Line";
        Amt: Decimal;
        PurchaseHeader2: Record "Purchase Header";
        GenJnlLine2: Record "Gen. Journal Line";
        BudgetCat: Code[100];
        Dep: Code[100];

    local procedure ApproveCalcInvDisc()
    begin
        //CurrPage.PurchLines.PAGE.ApproveCalcInvDisc;
    end;

    local procedure BuyfromVendorNoOnAfterValidate()
    begin
        if Rec.GetFilter("Buy-from Vendor No.") = xRec."Buy-from Vendor No." then
            if Rec."Buy-from Vendor No." <> xRec."Buy-from Vendor No." then
                Rec.SetRange("Buy-from Vendor No.");
        CurrPage.Update;
    end;

    local procedure PurchaserCodeOnAfterValidate()
    begin
        //CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure PaytoVendorNoOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        //CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        //CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
    end;

    local procedure PricesIncludingVATOnAfterValid()
    begin
        CurrPage.Update;
    end;

    local procedure CurrencyCodeOnAfterValidate()
    begin
        //CurrPage.PurchLines.PAGE.UpdateForm(TRUE);
    end;


    procedure LinesCommitted() Exists: Boolean
    var
        PurchLines: Record "Purchase Line";
    begin

    end;


    procedure SomeLinesCommitted() Exists: Boolean
    var
        PurchLines: Record "Purchase Line";
    begin
    end;


    procedure UpdateControls()
    begin
        if Rec.Status = Rec.Status::Open then
            StatusEditable := true
        else
            StatusEditable := false;
    end;


    procedure CurrPageUpdate()
    begin
        xRec := Rec;
        UpdateControls;
        CurrPage.Update;
    end;
}

