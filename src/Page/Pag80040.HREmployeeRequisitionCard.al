#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 80040 "HR Employee Requisition Card"
{
    DeleteAllowed = false;
    InsertAllowed = true;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Functions,Job';
    SourceTable = "HR Employee Requisitions";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Requisition No."; Rec."Requisition No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                }
                field("Requisition Date"; Rec."Requisition Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                }
                field(Requestor; Rec.Requestor)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Job ID"; Rec."Job ID")
                {
                    ApplicationArea = Basic;
                    Editable = "Job IDEditable";
                    Importance = Promoted;
                }
                field("Job Description"; Rec."Job Description")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Job Grade"; Rec."Job Grade")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
                field("Reason For Request"; Rec."Reason For Request")
                {
                    ApplicationArea = Basic;
                    Editable = "Reason For RequestEditable";
                }
                field("Type of Contract Required"; Rec."Type of Contract Required")
                {
                    ApplicationArea = Basic;
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = Basic;
                    Editable = PriorityEditable;
                    Visible = false;
                }
                field("Vacant Positions"; Rec."Vacant Positions")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Required Positions"; Rec."Required Positions")
                {
                    ApplicationArea = Basic;
                    Editable = "Required PositionsEditable";
                    Importance = Promoted;
                }
                field("Closing Date"; Rec."Closing Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Required By';
                    Editable = "Closing DateEditable";
                    Importance = Promoted;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Editable = "Responsibility CenterEditable";
                    Importance = Promoted;
                    Visible = false;
                }
                field("Requisition Type"; Rec."Requisition Type")
                {
                    ApplicationArea = Basic;
                    Editable = "Requisition TypeEditable";
                    Importance = Promoted;
                    Visible = false;
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field("Type of Advertisement"; Rec."Type of Advertisement")
                {
                    ApplicationArea = Basic;
                }
                field("Advertise Externally"; Rec.Advertise)
                {
                    ApplicationArea = Basic;
                    Caption = 'Advertise Externally';
                    Editable = false;
                    Visible = true;
                }
                field("Advertise Internally"; Rec."Advertise Internally")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("No. of Interviews"; Rec."No. of Interviews")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Additional Information")
            {
                Caption = 'Additional Information';
                field("Any Additional Information"; Rec."Any Additional Information")
                {
                    ApplicationArea = Basic;
                    Editable = AnyAdditionalInformationEditab;
                }
                field("Reason for Request(Other)"; Rec."Reason for Request(Other)")
                {
                    ApplicationArea = Basic;
                    Editable = ReasonforRequestOtherEditable;
                }
            }
        }
        area(factboxes)
        {
            part(Control1000000000; "HR Employee Req. Factbox")
            {
                SubPageLink = "Job ID" = field("Job ID");
                Visible = false;
            }
            systempart(Control1102755020; Outlook)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Fu&nctions")
            {
                Caption = 'Fu&nctions';
                action(Advertise)
                {
                    ApplicationArea = Basic;
                    Caption = 'Advertise';
                    Image = Salutation;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        Rec.TestField("Type of Advertisement");
                        if Rec.Status <> Rec.Status::Approved then Error('The job position should first be approved');
                        if Confirm('Advertise the job') then begin
                            if Rec."Type of Advertisement" = Rec."type of advertisement"::"Internal&External" then begin
                                Rec.Advertise := true;
                                Rec."Advertise Internally" := true;
                                //mercy
                                Rec.Status := Rec.Status::Advertised;
                                PurchaseHeader.SetRange("Document Date", Rec."Requisition Date");
                                //PAGE.RUN(PAGE::"Task Order Card",PurchaseHeader);
                                //endmercy
                                Rec.Modify;
                            end;
                            if Rec."Type of Advertisement" = Rec."type of advertisement"::Internal then begin
                                Rec."Advertise Internally" := true;
                                //mercy
                                Rec.Status := Rec.Status::Advertised;
                                PurchaseHeader.SetRange("Document Date", Rec."Requisition Date");
                                //PAGE.RUN(PAGE::"Task Order Card",PurchaseHeader);
                                //endmercy
                                Rec.Modify;
                            end;

                        end;
                        /*
                        
                        HREmp.RESET;
                        HREmp.SETRANGE(HREmp."No.");
                        REPEAT
                        HREmp.TESTFIELD(HREmp."Company E-Mail");
                        SMTP.CreateMessage('Job Advertisement','info@leventis.com',HREmp."Company E-Mail",
                        'Leventis Job Vacancy','A vacancy with the job description' +"Job Description"+'is open for applications',TRUE);
                        SMTP.Send();
                        UNTIL HREmp.NEXT=0;
                        
                        TESTFIELD("Requisition Type","Requisition Type"::Internal);
                        
                        HREmp.SETRANGE(HREmp.Status,HREmp.Status::Active);
                        IF HREmp.FIND('-') THEN
                        
                        //GET E-MAIL PARAMETERS FOR JOB APPLICATIONS
                        HREmailParameters.RESET;
                        HREmailParameters.SETRANGE(HREmailParameters."Associate With",HREmailParameters."Associate With"::"0");
                        IF HREmailParameters.FIND('-') THEN
                        BEGIN
                             REPEAT
                             HREmp.TESTFIELD(HREmp."Company E-Mail");
                             SMTP.CreateMessage(HREmailParameters."Sender Name",HREmailParameters."Sender Address",HREmp."Company E-Mail",
                             HREmailParameters.Subject,'Dear'+' '+ HREmp."First Name" +' '+
                             HREmailParameters.Body+' '+ "Job Description" +' '+ HREmailParameters."Body 2"+' '+ FORMAT("Closing Date")+'. '+
                             HREmailParameters."Body 3",TRUE);
                             SMTP.Send();
                             UNTIL HREmp.NEXT=0;
                             */
                        //MESSAGE('All Employees have been notified about this vacancy');

                    end;
                }
                action("Mark as Closed/Open")
                {
                    ApplicationArea = Basic;
                    Caption = 'Mark as Closed/Open';
                    Image = ReopenCancelled;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        if Rec.Closed then begin
                            if not Confirm('Are you sure you want to Re-Open this Document', false) then exit;
                            Rec.Closed := false;
                            Rec.Modify;
                            Message('Employee Requisition %1 has been Re-Opened', Rec."Requisition No.");

                        end else begin
                            if not Confirm('Are you sure you want to close this Document', false) then exit;
                            Rec.Closed := true;
                            Rec.Modify;
                            Message('Employee Requisition %1 has been marked as Closed', Rec."Requisition No.");
                        end;
                    end;
                }
                action("&Print")
                {
                    ApplicationArea = Basic;
                    Caption = '&Print';
                    Image = PrintReport;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        HREmpReq.Reset;
                        HREmpReq.SetRange(HREmpReq."Requisition No.", Rec."Requisition No.");
                        if HREmpReq.Find('-') then
                            Report.Run(51516169, true, true, HREmpReq);
                    end;
                }
                action("&Send Mail to HR to add vacant position")
                {
                    ApplicationArea = Basic;
                    Caption = '&Send Mail to HR to add vacant position';
                    Image = Email;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = false;

                    trigger OnAction()
                    begin
                        objEmp.Reset;
                        objEmp.SetRange(objEmp."Global Dimension 2 Code", Rec."Global Dimension 2 Code");
                        objEmp.SetRange(objEmp.HR, true);
                        if objEmp.Find('-') then begin
                            if objEmp."Company E-Mail" = '' then Error('THe HR doesnt have an email Account');
                            //**********************send mail**********************************

                            Message('EMail Sent');
                        end else begin
                            Message('There is no employee marked as HR in that department');
                        end;
                    end;
                }
                action("Re-Open")
                {
                    ApplicationArea = Basic;
                    Caption = 'Re-Open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Category5;
                    Visible = false;

                    trigger OnAction()
                    begin
                        Rec.Status := Rec.Status::New;
                        Rec.Modify;
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
            }
            action(Approval)
            {
                ApplicationArea = Basic;
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    ApprovalEntries: Page "Approval Entries";
                begin
                    DocumentType := Documenttype::" ";
                    ApprovalEntries.SetRecordFilters(Database::"HR Employee Requisitions", DocumentType, Rec."Requisition No.");
                    ApprovalEntries.Run;
                end;
            }
            action("Send Approval Request")
            {
                ApplicationArea = Basic;
                Caption = 'Send Approval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    Text001: label 'This request is already pending approval';
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    if Rec.Status <> Rec.Status::New then
                        Error('Record has already been sent for approval');

                    if Rec."Vacant Positions" = 0 then
                        Error('There are no vacant positions for this position');
                    //IF ApprovalsMgmt.CheckJRApprovalsWorkflowEnabled(Rec) THEN
                    // ApprovalsMgmt.OnSendJRForApproval(Rec);
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = Basic;
                Caption = 'Cancel Approval Request';
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    Approvalmgt: Codeunit "Approvals Mgmt.";
                begin
                    if Confirm('Are you sure you want to cancel this approval request', false) = true then
                        //ApprovalsMgmt.OnCancelJRApprovalRequest(Rec);
                        Rec.Status := Rec.Status::New;
                    Rec.Modify;
                end;
            }
            group(Job)
            {
                Caption = 'Job';
                action(Requirements)
                {
                    ApplicationArea = Basic;
                    Caption = 'Requirements';
                    Image = JobListSetup;
                    Promoted = true;
                    PromotedCategory = Category5;
                }
                action(Responsibilities)
                {
                    ApplicationArea = Basic;
                    Caption = 'Responsibilities';
                    Image = JobResponsibility;
                    Promoted = true;
                    PromotedCategory = Category5;

                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateControls;

        HRLookupValues.SetRange(HRLookupValues.Code, Rec."Type of Contract Required");
        if HRLookupValues.Find('-') then
            ContractDesc := HRLookupValues.Description;
    end;

    trigger OnInit()
    begin
        TypeofContractRequiredEditable := true;
        AnyAdditionalInformationEditab := true;
        "Required PositionsEditable" := true;
        "Requisition TypeEditable" := true;
        "Closing DateEditable" := true;
        PriorityEditable := true;
        ReasonforRequestOtherEditable := true;
        "Reason For RequestEditable" := true;
        "Responsibility CenterEditable" := true;
        "Job IDEditable" := true;
        "Requisition DateEditable" := true;
        "Requisition No.Editable" := true;
    end;



    trigger OnOpenPage()
    begin
        UserSetup.Get(UserId);
        //IF UserSetup."Ass Hr"=TRUE THEN
        Advert := true;

        //IF UserSetup."Hr Manager"=TRUE THEN
        Advert := true;
    end;

    var
        DocumentType: Option " ",Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Bank Slip",Grant,"Grant Surrender","Employee Requisition","Leave Application","Training Requisition","Transport Requisition",JV,"Grant Task","Concept Note",Proposal,"Job Approval","Disciplinary Approvals",GRN,Clearence,Donation,Transfer,PayChange,Budget,GL;
        ApprovalEntries: Page "Approval Entries";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        HREmpReq: Record "HR Employee Requisitions";

        HRSetup: Record "HR Setup";
        CTEXTURL: Text[30];
        HREmp: Record "HR Employees";
        ContractDesc: Text[30];
        HRLookupValues: Record "HR Job Qualifications";
        "Requisition No.Editable": Boolean;
        "Requisition DateEditable": Boolean;
        "Job IDEditable": Boolean;
        "Responsibility CenterEditable": Boolean;
        "Reason For RequestEditable": Boolean;
        ReasonforRequestOtherEditable: Boolean;
        PriorityEditable: Boolean;
        "Closing DateEditable": Boolean;
        "Requisition TypeEditable": Boolean;
        "Required PositionsEditable": Boolean;
        AnyAdditionalInformationEditab: Boolean;
        TypeofContractRequiredEditable: Boolean;
        DimValue: Record "Dimension Value";
        objEmp: Record "HR Employees";
        DocumentType2: Option ,"1";
        Advert: Boolean;
        UserSetup: Record "User Setup";
        PurchaseHeader: Record "Purchase Header";


    procedure TESTFIELDS()
    begin
        Rec.TestField("Job ID");
        Rec.TestField("Closing Date");
        Rec.TestField("Type of Contract Required");
        Rec.TestField("Requisition Type");
        Rec.TestField("Required Positions");
        if Rec."Reason For Request" = Rec."reason for request"::Other then
            Rec.TestField("Reason for Request(Other)");
    end;


    procedure UpdateControls()
    begin

        if Rec.Status = Rec.Status::New then begin
            "Requisition No.Editable" := true;
            "Requisition DateEditable" := true;
            "Job IDEditable" := true;
            "Responsibility CenterEditable" := true;
            "Reason For RequestEditable" := true;
            ReasonforRequestOtherEditable := true;
            PriorityEditable := true;
            "Closing DateEditable" := true;
            "Requisition TypeEditable" := true;
            "Required PositionsEditable" := true;
            "Required PositionsEditable" := true;
            AnyAdditionalInformationEditab := true;
            TypeofContractRequiredEditable := true;
        end else begin
            "Requisition No.Editable" := false;
            "Requisition DateEditable" := false;
            "Job IDEditable" := false;
            "Responsibility CenterEditable" := false;
            "Reason For RequestEditable" := false;
            ReasonforRequestOtherEditable := false;
            PriorityEditable := false;
            "Closing DateEditable" := false;
            "Requisition TypeEditable" := false;
            "Required PositionsEditable" := false;
            "Required PositionsEditable" := false;
            AnyAdditionalInformationEditab := false;

            TypeofContractRequiredEditable := false;
        end;
    end;
}

