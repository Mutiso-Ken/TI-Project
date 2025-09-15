#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 80067 "Mission Proposal Card"
{
    Caption = 'Mission Proposal Card';
    DeleteAllowed = true;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Category6_caption,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    RefreshOnActivate = true;
    SourceTable = "Purchase Header";
    SourceTableView = where("Document Type" = const(Quote),
                            MP = const(true));

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
                    Editable = false;
                    Importance = Promoted;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Strategic Focus Area"; Rec."Strategic Focus Area")
                {
                    ApplicationArea = Basic;
                }
                field("Sub Pillar"; Rec."Sub Pillar")
                {
                    ApplicationArea = Basic;
                }
                field("Project Title"; Rec."Project Title")
                {
                    ApplicationArea = Basic;
                }
                field(Country; Rec.Country)
                {
                    ApplicationArea = Basic;
                }
                field(County; Rec.County)
                {
                    ApplicationArea = Basic;
                }
                field("Date(s) of Activity"; Rec."Date(s) of Activity")
                {
                    ApplicationArea = Basic;
                }
                field("Mission Team"; Rec."Mission Team")
                {
                    ApplicationArea = Basic;
                }
                field("Invited Members/Partners"; Rec."Invited Members/Partners")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Visible = true;
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
                    Editable = false;
                    Importance = Promoted;
                    OptionCaption = 'Open,Released,Pending Approval';
                }
                field("Employee No"; Rec."Employee No")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Background)
            {
                Caption = 'Background';
                Editable = statuseditable;
                field(Control24; Rec.Background)
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                }
            }
            part("Mission Objectives"; "Mission Objectives")
            {
                Editable = statuseditable;
                ApplicationArea = all;
                SubPageLink = "Document No." = field("No."),
                              "Line Type" = filter(Objectives);
            }
            group("Contribution to TI KENYA Strategic Focus")
            {
                Caption = 'Contribution to TI KENYA Strategic Focus';
                Editable = statuseditable;
                field("Contribution to focus"; Rec."Contribution to focus")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                }
            }
            group("Main Outcome - as per DIP/LOGFRAME")
            {
                Caption = 'Main Outcome - as per DIP/LOGFRAME';
                Editable = statuseditable;
                field("Main Outcome"; Rec."Main Outcome")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                }
            }
            part("Team Roles and Responsibilities"; "Team Roles and Responsibility")
            {
                Editable = statuseditable;
                ApplicationArea = all;
                SubPageLink = "Document No." = field("No."),
                              "Line Type" = filter("Team Roles");
            }
            part(Activities; Activities)
            {
                Editable = statuseditable;
                ApplicationArea = all;
                SubPageLink = "Document No." = field("No."),
                              "Line Type" = filter(Activity);
            }
            part("Budget Information"; "Budget Information")
            {
                Editable = statuseditable;
                ApplicationArea = all;
                SubPageLink = "Document No." = field("No."),
                              "Line Type" = filter("Budget Info");
            }
            field("Budget Balance"; Rec."Budget Balance")
            {
                ApplicationArea = Basic;
            }
            field("Mission Total"; Rec."Mission Total")
            {
                ApplicationArea = Basic;
            }
            field("Balance Carried Forward"; Rec."Budget Balance" - Rec."Mission Total")
            {
                ApplicationArea = Basic;
            }
            field("Imprest Amount"; Rec."Imprest Amount")
            {
                ApplicationArea = Basic;
            }
            field("Imprest Holder"; Rec."Imprest Holder")
            {
                ApplicationArea = Basic;
            }
            part("Budget Notes"; "Budget Notes")
            {
                Editable = statuseditable;
                SubPageLink = "Document No." = field("No."),
                              "Line Type" = filter("Budget Notes");
            }
            group(Finance)
            {
                Caption = 'Finance';
                Editable = statuseditable;
                field("Previous Imprest Accounted"; Rec."Previous Imprest Accounted")
                {
                    ApplicationArea = Basic;
                }
                field("No of Days Outstanding"; Rec."No of Days Outstanding")
                {
                    ApplicationArea = Basic;
                }
                field("Finance Action"; Rec."Finance Action")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control18; Notes)
            {
                Visible = true;
            }
            systempart(Control19; Links)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(Attachments)
                {
                    ApplicationArea = Basic;
                    Ellipsis = true;
                    Image = Attachments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page Documents;
                    RunPageLink = "Doc No." = field("No.");
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
                        if Confirm('Are you sure you want to archive the mission proposal') then begin
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
                        // if ApprovalsMgmt.CheckPurchaseApprovalPossible(Rec) then
                        //     ApprovalsMgmt.OnSendPurchaseDocForApproval(Rec);
                        rec.Status := rec.Status::Released;
                        Rec.Modify();
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel A&pproval Request';
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Request approval of the document.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin

                        Rec.TestField(Status, Rec.Status::"Pending Approval");
                        //IF ApprovalsMgmt.CheckPurchaseApprovalPossible(Rec) THEN
                        ApprovalsMgmt.OnCancelPurchaseApprovalRequest(Rec);
                    end;
                }
                separator(Action10)
                {
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
                action(Print)
                {
                    ApplicationArea = Basic, Suite;
                    Image = PrintVoucher;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        PurchHeader.Reset;
                        PurchHeader.SetRange("No.", Rec."No.");
                        if PurchHeader.FindFirst then
                            Report.Run(80033, true, false, PurchHeader);
                    end;
                }
                action("Mark as Completed")
                {
                    ApplicationArea = Basic, Suite;
                    Image = ProdBOMMatrixPerVersion;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if Confirm('Mark mission as completed') then begin
                            Rec.Completed := true;
                            Rec.Modify;
                        end;
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
        PurchLine.Init;
        PurchLine."Document No." := Rec."No.";
        PurchLine.Insert;
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

        Rec."Doc Type" := Rec."doc type"::"Mission Proposal";
        Rec."No." := NoSeriesManagement.GetNextNo(PurchasesPayablesSetup."Mission Proposal Nos.", Today, true);
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter;
        Rec."Assigned User ID" := UserId;
        Rec."User ID" := UserId;
        Rec."Requested Receipt Date" := Today;



        Rec.MP := true;



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

        Rec."Doc Type" := Rec."doc type"::"Mission Proposal";
        Rec."Assigned User ID" := UserId;
        Rec.MP := true;
        //SETRANGE("User ID",USERID);
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

