#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 80008 "Custom Approvals Codeunit"
{

    trigger OnRun()
    begin
    end;

    var

        WorkflowManagement: Codeunit "Workflow Management";

        UnsupportedRecordTypeErr: label 'Record type %1 is not supported by this workflow response.', Comment = 'Record type Customer is not supported by this workflow response.';
        NoWorkflowEnabledErr: label 'This record is not supported by related approval workflow.';

        OnSendHRJobsApprovalRequestTxt: label 'Approval of a HR Job is requested';
        RunWorkflowOnSendHRJobsForApprovalCode: label 'RUNWORKFLOWONSENDHRJOBSFORAPPROVAL';
        OnCancelHRJobsApprovalRequestTxt: label 'Approval of a HR Job is canceled';
        RunWorkflowOnCancelHRJobsForApprovalCode: label 'RUNWORKFLOWONCANCELHRJOBSFORAPPROVAL';

        OnSendEmpReqApprovalRequestTxt: label 'Approval of an Employee Requsition is requested';
        RunWorkflowOnSendEmpReqForApprovalCode: label 'RUNWORKFLOWONSENDEMPREQFORAPPROVAL';
        OnCancelEmpReqApprovalRequestTxt: label 'Approval of an Employee Requsition is canceled';
        RunWorkflowOnCancelEmpReqForApprovalCode: label 'RUNWORKFLOWONCANCELEMPREQFORAPPROVAL';

        OnSendEmployeesApprovalRequestTxt: label 'Approval of an Employee is requested';
        RunWorkflowOnSendEmployeesForApprovalCode: label 'RUNWORKFLOWONSENDEMPLOYEESFORAPPROVAL';
        OnCancelEmployeesApprovalRequestTxt: label 'Approval of an Employee is canceled';
        RunWorkflowOnCancelEmployeesForApprovalCode: label 'RUNWORKFLOWONCANCELEMPLOYEESFORAPPROVAL';

        OnSendEmpConfApprovalRequestTxt: label 'Approval of an Employee Confirmation is requested';
        RunWorkflowOnSendEmpConfForApprovalCode: label 'RUNWORKFLOWONSENDEMPCONFFORAPPROVAL';
        OnCancelEmpConfApprovalRequestTxt: label 'Approval of an Employee Confirmation is canceled';
        RunWorkflowOnCancelEmpConfForApprovalCode: label 'RUNWORKFLOWONCANCELEMPCONFFORAPPROVAL';

        OnSendEmpPromoApprovalRequestTxt: label 'Approval of an Employee Promotion is requested';
        RunWorkflowOnSendEmpPromoForApprovalCode: label 'RUNWORKFLOWONSENDEMPPROMOFORAPPROVAL';
        OnCancelEmpPromoApprovalRequestTxt: label 'Approval of an Employee Promotion is canceled';
        RunWorkflowOnCancelEmpPromoForApprovalCode: label 'RUNWORKFLOWONCANCELEMPPROMOFORAPPROVAL';

        OnSendEmpTransApprovalRequestTxt: label 'Approval of an Employee Transfer is requested';
        RunWorkflowOnSendEmpTransForApprovalCode: label 'RUNWORKFLOWONSENDEMPTRANSFORAPPROVAL';
        OnCancelEmpTransApprovalRequestTxt: label 'Approval of an Employee Transfer is canceled';
        RunWorkflowOnCancelEmpTransForApprovalCode: label 'RUNWORKFLOWONCANCELEMPTRANSFORAPPROVAL';

        OnSendAssTransApprovalRequestTxt: label 'Approval of an Asset Transfer is requested';
        RunWorkflowOnSendAssTransForApprovalCode: label 'RUNWORKFLOWONSENDASSTRANSFORAPPROVAL';
        OnCancelAssTransApprovalRequestTxt: label 'Approval of an Asset Transfer is canceled';
        RunWorkflowOnCancelAssTransForApprovalCode: label 'RUNWORKFLOWONCANCELASSTRANSFORAPPROVAL';

        OnSendTranspReqApprovalRequestTxt: label 'Approval of a Transport Requsition is requested';
        RunWorkflowOnSendTranspReqForApprovalCode: label 'RUNWORKFLOWONSENDTRANSPREQFORAPPROVAL';
        OnCancelTranspReqApprovalRequestTxt: label 'Approval of a Transport Requisition is canceled';
        RunWorkflowOnCancelTranspReqForApprovalCode: label 'RUNWORKFLOWONCANCELTRANSPREQFORAPPROVAL';

        OnSendOvertimeApprovalRequestTxt: label 'Approval of an Overtime Requisition is requested';
        RunWorkflowOnSendOvertimeForApprovalCode: label 'RUNWORKFLOWONSENDOVERTIMEFORAPPROVAL';
        OnCancelOvertimeApprovalRequestTxt: label 'Approval of an Overtime Requisition is canceled';
        RunWorkflowOnCancelOvertimeForApprovalCode: label 'RUNWORKFLOWONCANCELOVERTIMEFORAPPROVAL';

        OnSendTrainAppApprovalRequestTxt: label 'Approval of a Training Application is requested';
        RunWorkflowOnSendTrainAppForApprovalCode: label 'RUNWORKFLOWONSENDTRAINAPPFORAPPROVAL';
        OnCancelTrainAppApprovalRequestTxt: label 'Approval of a Training Application is canceled';
        RunWorkflowOnCancelTrainAppForApprovalCode: label 'RUNWORKFLOWONCANCELTRAINAPPFORAPPROVAL';

        OnSendLeaveApprovalRequestTxt: label 'Approval of a Leave Application is requested';
        RunWorkflowOnSendLeaveForApprovalCode: label 'RUNWORKFLOWONSENDLEAVEFORAPPROVAL';
        OnCancelLeaveApprovalRequestTxt: label 'Approval of a Leave Application is canceled';
        RunWorkflowOnCancelLeaveForApprovalCode: label 'RUNWORKFLOWONCANCELLEAVEFORAPPROVAL';

        OnSendLeaveReApprovalRequestTxt: label 'Approval of a Leave Reimbursement is requested';
        RunWorkflowOnSendLeaveReForApprovalCode: label 'RUNWORKFLOWONSENDLEAVEREFORAPPROVAL';
        OnCancelLeaveReApprovalRequestTxt: label 'Approval of a Leave Reimbursment is canceled';
        RunWorkflowOnCancelLeaveReForApprovalCode: label 'RUNWORKFLOWONCANCELLEAVEREFORAPPROVAL';

        OnSendDisciplinaryCaseApprovalRequestTxt: label 'Approval of a Disciplinary Case is requested';
        RunWorkflowOnSendDisciplinaryCaseForApprovalCode: label 'RUNWORKFLOWONSENDDISCIPLINARYCASEFORAPPROVAL';
        OnCancelDisciplinaryCaseApprovalRequestTxt: label 'Approval of a Disciplinary Case is canceled';
        RunWorkflowOnCancelDisciplinaryCaseForApprovalCode: label 'RUNWORKFLOWONCANCELDISCIPLINARYCASEFORAPPROVAL';
        OnSendExitApprovalRequestTxt: label 'Approval of an Exit Interview is requested';
        RunWorkflowOnSendExitForApprovalCode: label 'RUNWORKFLOWONSENDEXITFORAPPROVAL';
        OnCancelExitApprovalRequestTxt: label 'Approval of an Exit Interview is canceled';
        RunWorkflowOnCancelExitForApprovalCode: label 'RUNWORKFLOWONCANCELEXITFORAPPROVAL';
        OnSendReceiptApprovalRequestTxt: label 'Approval of a Receipt is requested';
        RunWorkflowOnSendReceiptForApprovalCode: label 'RUNWORKFLOWONSENDRECEIPTFORAPPROVAL';
        OnCancelReceiptApprovalRequestTxt: label 'An Approval of a Receipt is canceled';
        RunWorkflowOnCancelReceiptForApprovalCode: label 'RUNWORKFLOWONCANCELRECEIPTFORAPPROVAL';

        OnSendItemJournalApprovalRequestTxt: label 'Approval of Item Journal is requested';
        RunWorkflowOnSendItemJournalForApprovalCode: label 'RUNWORKFLOWONSENDITEMJOURNALFORAPPROVAL';
        OnCancelItemJournalApprovalRequestTxt: label 'An Approval of Item Journal is canceled';
        RunWorkflowOnCancelItemJournalForApprovalCode: label 'RUNWORKFLOWONCANCELITEMJOURNALFORAPPROVAL';
        OnSendCustomerRegistrationApprovalRequestTxt: label 'An approval request for customer registration is requested';
        RunWorkflowOnSendCustomerRegistrationForApprovalCode: label 'RUNWORKFLOWONSENDCUSTOMERREGISTRATIONFORAPPROVAL';
        OnCancelCustomerRegistrationApprovalRequestTxt: label 'An approval request for customer registration is canceled';
        RunWorkflowOnCancelCustomerRegistrationForApprovalCode: label 'RUNWORKFLOWONCANCELCUSTOMERREGISTRATIONFORAPPROVAL';

        OnSendPaymentDocumentApprovalRequestTxt: label 'An approval request for Payment voucher is requested';
        RunWorkflowOnSendPaymentDocuemntForApprovalCode: label 'RUNWORKFLOWONSENDPAYMENTDOCUMENTFORAPPROVAL';
        OnCancelPaymentDocumentApprovalRequestTxt: label 'An approval request for Payment voucher is canceled';
        RunWorkflowOnCancelPaymentDocumentForApprovalCode: label 'RUNWORKFLOWONCANCELPAYMENTDOCUMENTFORAPPROVAL';
        OnSendItemJournalLineApprovalRequestTxt: label 'Approval of Item Journal line is requested';
        RunWorkflowOnSendItemJournalLineForApprovalCode: label 'RUNWORKFLOWONSENDITEMJOURNALLINEFORAPPROVAL';
        OnCancelItemJournalApprovalLineRequestTxt: label 'An Approval of Item Journal line is canceled';
        RunWorkflowOnCancelItemJournalLineForApprovalCode: label 'RUNWORKFLOWONCANCELITEMJOURNALLINEFORAPPROVAL';

        OnSendBankinslipApprovalRequestTxt: label 'Approval of Bank in slip is requested';
        RunWorkflowOnSendBankInSlipForApprovalCode: label 'RUNWORKFLOWONSENBANKINSLIPFORAPPROVAL';
        OnCancelBankInslipRequestTxt: label 'An Approval of Bank in slip is canceled';
        RunWorkflowOnCancelBankInSlipForApprovalCode: label 'RUNWORKFLOWONCANCEBANKINSLIPFORAPPROVAL';

        //TimesheetApproval
        OnSendTimesheetApprovalRequestTxt: label 'Approval of Time Sheet is requested';
        RunWorkflowOnSendTimesheetForApprovalCode: label 'RUNWORKFLOWONSENTimesheetFORAPPROVAL';
        OnCancelTimesheetRequestTxt: label 'An Approval of Time Sheet is canceled';
        RunWorkflowOnCancelTimesheetForApprovalCode: label 'RUNWORKFLOWONCANCETimeSheetFORAPPROVAL';


    procedure CheckApprovalsWorkflowEnabled(var Variant: Variant): Boolean
    var
        RecRef: RecordRef;
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of

            //TimesheetLines
            Database::TimesheetLines:
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendTimesheetForApprovalCode));


            //Leave Application
            Database::"HR Leave Application":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendLeaveForApprovalCode));

            //Training Application
            Database::"Training Requests":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendTrainAppForApprovalCode));
            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end;
    end;


    procedure CheckApprovalsWorkflowEnabledCode(var Variant: Variant; CheckApprovalsWorkflowTxt: Text): Boolean
    var
        RecRef: RecordRef;
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        begin
            if not WorkflowManagement.CanExecuteWorkflow(Variant, CheckApprovalsWorkflowTxt) then
                Error(NoWorkflowEnabledErr);
            exit(true);
        end;
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendDocForApproval(var Variant: Variant)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelDocApprovalRequest(var Variant: Variant)
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure AddWorkflowEventsToLibrary()
    var
        WorkFlowEventHandling: Codeunit "Workflow Event Handling";
    begin
        //Timesheets
        WorkFlowEventHandling.AddEventToLibrary(
                RunWorkflowOnSendTimesheetForApprovalCode, Database::TimesheetLines, OnSendTimesheetApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelTimesheetForApprovalCode, Database::TimesheetLines, OnCancelTimesheetRequestTxt, 0, false);
        //Leave Application
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendLeaveForApprovalCode, Database::"HR Leave Application", OnSendLeaveApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelLeaveForApprovalCode, Database::"HR Leave Application", OnCancelLeaveApprovalRequestTxt, 0, false);

        //Training Application
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendTrainAppForApprovalCode, Database::"Training Requests", OnSendTrainAppApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelTrainAppForApprovalCode, Database::"Training Requests", OnCancelTrainAppApprovalRequestTxt, 0, false);
    end;

    local procedure RunWorkflowOnSendApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Custom Approvals Codeunit", 'OnSendDocForApproval', '', false, false)]

    procedure RunWorkflowOnSendApprovalRequest(var Variant: Variant)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            //Time Lines
            Database::TimesheetLines:
                WorkflowManagement.HandleEvent(RunWorkflowOnSendTimesheetForApprovalCode, Variant);

            //Leave Application
            Database::"HR Leave Application":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendLeaveForApprovalCode, Variant);
            //Training Application
            Database::"Training Requests":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendTrainAppForApprovalCode, Variant);
            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Custom Approvals Codeunit", 'OnCancelDocApprovalRequest', '', false, false)]

    procedure RunWorkflowOnCancelApprovalRequest(var Variant: Variant)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of

            //HR

            Database::TimesheetLines:
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelTimesheetForApprovalCode, Variant);
            //Leave Application
            Database::"HR Leave Application":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelLeaveForApprovalCode, Variant);
            //Training Application
            Database::"Training Requests":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelTrainAppForApprovalCode, Variant);
            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    procedure ReOpen(RecRef: RecordRef; var Handled: Boolean)
    var
        HRLeaveApplication: Record "HR Leave Application";
        ItemJournalBatch: Record "Item Journal Batch";
        itemjnlline: Record "Item Journal Line";
        TrainingRequests: Record "Training Requests";
        TimeLines: Record TimesheetLines;
    begin
        case RecRef.Number of


            //Timelines

            Database::TimesheetLines:
                begin
                    RecRef.SetTable(TimeLines);
                    TimeLines.Validate(Status, TimeLines.Status::Open);
                    TimeLines.Modify;
                    Handled := true;
                end;
            //Leave Application
            Database::"HR Leave Application":
                begin
                    RecRef.SetTable(HRLeaveApplication);
                    HRLeaveApplication.Validate(Status, HRLeaveApplication.Status::New);
                    HRLeaveApplication.Modify;
                    Handled := true;
                end;

            //Training Application
            Database::"Training Requests":
                begin
                    RecRef.SetTable(TrainingRequests);
                    TrainingRequests.Validate(Status, HRLeaveApplication.Status::New);
                    TrainingRequests.Modify;
                    Handled := true;
                end;

            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    procedure Release(RecRef: RecordRef; var Handled: Boolean)
    var
        HRLeaveApplication: Record "HR Leave Application";
        ItemJournalBatch: Record "Item Journal Batch";
        usersetup: Record "User Setup";
        genjnline: Record "Gen. Journal Line";
        itemjournalline: Record "Item Journal Line";
        TrainingRequests: Record "Training Requests";
        Factory: Codeunit GeneralFunctionsFactory;
        TimeLines: Record TimesheetLines;
    begin
        case RecRef.Number of
            //Training Application
            Database::TimesheetLines:
                begin
                    RecRef.SetTable(TimeLines);
                    TimeLines.Validate(Status, TimeLines.Status::Approved);
                    TimeLines.Modify;
                    Handled := true;
                end;
            //Leave Application
            Database::"HR Leave Application":
                begin
                    RecRef.SetTable(HRLeaveApplication);
                    HRLeaveApplication.Validate(Status, HRLeaveApplication.Status::Approved);
                    Factory.PostNegativeLeaveEntries(HRLeaveApplication);
                    HRLeaveApplication.Validate(Status, HRLeaveApplication.Status::Posted);
                    HRLeaveApplication.Modify;
                    Handled := true;
                end;
            //Training Application
            Database::"Training Requests":
                begin
                    RecRef.SetTable(TrainingRequests);
                    TrainingRequests.Validate(Status, TrainingRequests.Status::Approved);
                    TrainingRequests.Modify;
                    //HRLeaveApplication.CreateLeaveLedgerEntries;
                    Handled := true;
                end;

            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    procedure SetStatusToPending(RecRef: RecordRef; Variant: Variant; var IsHandled: Boolean)
    var

        HRLeaveApplication: Record "HR Leave Application";
        ItemJournalBatch: Record "Item Journal Batch";
        usersetup: Record "User Setup";
        genjnline: Record "Gen. Journal Line";
        itemjournalline: Record "Item Journal Line";
        TrainingRequests: Record "Training Requests";
        TimeLines: record TimesheetLines;
    begin
        case RecRef.Number of
            //Training Application
            Database::TimesheetLines:
                begin
                    RecRef.SetTable(TimeLines);
                    TimeLines.Validate(Status, TimeLines.Status::"Pending Approval");
                    TimeLines.Modify;
                    Variant := TimeLines;
                    IsHandled := true;
                end;
            //Leave Application
            Database::"HR Leave Application":
                begin
                    RecRef.SetTable(HRLeaveApplication);
                    HRLeaveApplication.Validate(Status, HRLeaveApplication.Status::"Pending Approval");

                    HRLeaveApplication.Modify;
                    Variant := HRLeaveApplication;
                    IsHandled := true;
                end;

            //Training Application
            Database::"Training Requests":
                begin
                    RecRef.SetTable(TrainingRequests);
                    TrainingRequests.Validate(Status, TrainingRequests.Status::"Pending Approval");
                    TrainingRequests.Modify;
                    Variant := TrainingRequests;
                    IsHandled := true;
                end;


            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end
    end;


    procedure UpdateRct(ApprovalEntry: Record "Approval Entry")
    begin

        if ApprovalEntry.Status = ApprovalEntry.Status::Open then begin
            ApprovalEntry.Status := ApprovalEntry.Status::Approved;
            ApprovalEntry.Modify(true);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Approval Entry", 'OnBeforeShowRecord', '', false, false)]
    procedure OnBeforeShowRecordApproval(var ApprovalEntry: Record "Approval Entry"; var IsHandled: Boolean)
    var
        RecRef: RecordRef;
        PaymentMemo: Page "Payment Memo Card";
        PurchaseHeader: Record "Purchase Header";
        PageManagement: Codeunit "Page Management";
        MissionProposal: Page "Mission Proposal Card";
        IMSurrender: Page "Imprest Surrender Card";
        IMRequest: Page "Imprest Request Card";


        PurchasRequisition: Page "Task Order Card";
    begin
        // Prevent standard BC logic
        IsHandled := true;
        // Load referenced record
        if not RecRef.Get(ApprovalEntry."Record ID to Approve") then
            exit;

        RecRef.SetRecFilter();

        case RecRef.Number of

            Database::"Purchase Header":
                begin
                    RecRef.SetTable(PurchaseHeader);
                    if PurchaseHeader.PM then begin
                        PaymentMemo.SetRecord(PurchaseHeader);
                        PaymentMemo.Run();
                        exit;
                    end;

                    if PurchaseHeader.MP then begin
                        MissionProposal.SetRecord(PurchaseHeader);
                        MissionProposal.Run();
                        exit;
                    end;
                    if PurchaseHeader.IM then begin
                        IMRequest.SetRecord(PurchaseHeader);
                        IMRequest.Run();
                        exit;
                    end;

                    if PurchaseHeader.SR then begin
                        IMSurrender.SetRecord(PurchaseHeader);
                        IMSurrender.Run();
                        exit;
                    end;

                    if PurchaseHeader.PR then begin
                        PurchasRequisition.SetRecord(PurchaseHeader);
                        PurchasRequisition.Run();
                        exit;
                    end;

                    PageManagement.PageRun(RecRef);
                    exit;
                end;

            else
                PageManagement.PageRun(RecRef);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnBeforeRejectSelectedApprovalRequest', '', false, false)]
    local procedure OnBeforeRejectApprovalRequest(ApprovalEntry: Record "Approval Entry"; var IsHandled: Boolean)
    var
        ApprovalComment: Record "Approval Comment Line";
    begin
        ApprovalComment.Reset();
        ApprovalComment.SetRange("Table ID", ApprovalEntry."Table ID");
        ApprovalComment.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
        if not ApprovalComment.FindFirst() then begin
            Error('You must enter a comment before rejecting this approval.');
            exit;
            IsHandled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', false, false)]

    procedure PopulateEntries(RecRef: RecordRef; WorkflowStepInstance: Record "Workflow Step Instance"; var ApprovalEntryArgument: Record "Approval Entry")
    var
        Hrleave: Record "HR Leave Application";


    begin

        case RecRef.Number of
            DATABASE::"HR Leave Application":
                begin
                    RecRef.SetTable(Hrleave);
                    ApprovalEntryArgument."Document No." := Hrleave."Application Code";
                end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnAfterRejectSelectedApprovalRequest', '', false, false)]

    local procedure OnAfterRejectApprovalRequest(
        ApprovalEntry: Record "Approval Entry")
    var
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        UserSetup: Record "User Setup";
        BodyText: Text;
        RecRef: RecordRef;
        ReceiverEmail: Text;
        HRemployees: Record "HR Employees";
        PurchaseHeader: Record "Purchase Header";
        EmailBody: Text;
        ApproverEmployee: record "HR Employees";
        ApproverName: Text;
        Notifications: Codeunit Notifications;
        EmailSubject: Text;
        HumanResourceLeave: Record "HR Leave Application";
        Timesheets: record TimesheetLines;
        Training: record "Training Requests";
        ApprovalComment: Record "Approval Comment Line";
        comments: Text;
    begin



        if not RecRef.Get(ApprovalEntry."Record ID to Approve") then
            exit;

        ApprovalComment.Reset();
        ApprovalComment.SetRange("Table ID", ApprovalEntry."Table ID");
        ApprovalComment.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
        if ApprovalComment.FindLast() then begin
            comments := ApprovalComment.Comment;
        end;
        RecRef.SetRecFilter();
        case RecRef.Number of
            Database::"Purchase Header":
                begin
                    ApproverEmployee.Reset();
                    ApproverEmployee.SetRange(ApproverEmployee."User ID", ApprovalEntry."Approver ID");
                    if ApproverEmployee.FindSet() then begin
                        ApproverName := ApproverEmployee."First Name" + ' ' + ApproverEmployee."Middle Name" + ' ' + ApproverEmployee."Last Name";
                    end;
                    RecRef.SetTable(PurchaseHeader);
                    HRemployees.reset;
                    if HRemployees.Get(PurchaseHeader."Employee No") then begin
                        ReceiverEmail := HRemployees."E-Mail";
                        EmailBody := 'Your approval request for ' + PurchaseHeader."Posting Description" + ' has been rejected by ' + ApproverName + ' comments:' + comments;
                        EmailSubject := 'REJECTED DOCUMENT ' + Format(PurchaseHeader."No.");
                        Notifications.fnSendemail(HRemployees."First Name" + '' + HRemployees."Last Name", EmailSubject, EmailBody, HRemployees."E-Mail", '', '', false, '', '', '', Enum::"Email Scenario"::Reminder);
                    end;
                end;
            Database::"HR Leave Application":
                begin
                    ApproverEmployee.Reset();
                    ApproverEmployee.SetRange(ApproverEmployee."User ID", ApprovalEntry."Approver ID");
                    if ApproverEmployee.FindSet() then begin
                        ApproverName := ApproverEmployee."First Name" + ' ' + ApproverEmployee."Middle Name" + ' ' + ApproverEmployee."Last Name";
                    end;
                    RecRef.SetTable(HumanResourceLeave);
                    HRemployees.reset;
                    if HRemployees.Get(HumanResourceLeave."Employee No") then begin
                        ReceiverEmail := HRemployees."E-Mail";
                        EmailBody := 'Your approval request for ' + HumanResourceLeave."Leave Type" + ' leave has been rejected by ' + ApproverName + ' comments:' + comments;
                        EmailSubject := 'REJECTED DOCUMENT ' + Format(PurchaseHeader."No.");
                        Notifications.fnSendemail(HRemployees."First Name" + '' + HRemployees."Last Name", EmailSubject, EmailBody, HRemployees."E-Mail", '', '', false, '', '', '', Enum::"Email Scenario"::Reminder);
                    end;
                end;
            Database::TimesheetLines:
                begin
                    ApproverEmployee.Reset();
                    ApproverEmployee.SetRange(ApproverEmployee."User ID", ApprovalEntry."Approver ID");
                    if ApproverEmployee.FindSet() then begin
                        ApproverName := ApproverEmployee."First Name" + ' ' + ApproverEmployee."Middle Name" + ' ' + ApproverEmployee."Last Name";
                    end;
                    RecRef.SetTable(Timesheets);
                    HRemployees.reset;
                    if HRemployees.Get(Timesheets."Employee No") then begin
                        ReceiverEmail := HRemployees."E-Mail";
                        EmailBody := 'Your approval request for ' + Timesheets.Timesheetcode + ' timesheet has been rejected by ' + ApproverName + ' comments:' + comments;
                        EmailSubject := 'REJECTED DOCUMENT ' + Format(PurchaseHeader."No.");
                        Notifications.fnSendemail(HRemployees."First Name" + '' + HRemployees."Last Name", EmailSubject, EmailBody, HRemployees."E-Mail", '', '', false, '', '', '', Enum::"Email Scenario"::Reminder);
                    end;
                end;
            Database::"Training Requests":
                begin
                    ApproverEmployee.Reset();
                    ApproverEmployee.SetRange(ApproverEmployee."User ID", ApprovalEntry."Approver ID");
                    if ApproverEmployee.FindSet() then begin
                        ApproverName := ApproverEmployee."First Name" + ' ' + ApproverEmployee."Middle Name" + ' ' + ApproverEmployee."Last Name";
                    end;
                    RecRef.SetTable(Training);
                    HRemployees.reset;
                    if HRemployees.Get(Training."Employee Code") then begin
                        ReceiverEmail := HRemployees."E-Mail";
                        EmailBody := 'Your approval request for ' + Training."Application Code" + ' Training request has been rejected by ' + ApproverName + ' comments:' + comments;
                        EmailSubject := 'REJECTED DOCUMENT ' + Format(PurchaseHeader."No.");
                        Notifications.fnSendemail(HRemployees."First Name" + '' + HRemployees."Last Name", EmailSubject, EmailBody, HRemployees."E-Mail", '', '', false, '', '', '', Enum::"Email Scenario"::Reminder);
                    end;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', false, false)]
    local procedure OnAfterFinalApproval(
    ApprovalEntry: Record "Approval Entry")
    var
        RecRef: RecordRef;
        OpenApproval: Record "Approval Entry";
        PurchaseHeader: Record "Purchase Header";
        HumanResourceLeave: Record "HR Leave Application";
        Timesheets: Record TimesheetLines;
        Training: Record "Training Requests";

        HREmployees: Record "HR Employees";
        Notifications: Codeunit Notifications;

        EmailBody: Text;
        EmailSubject: Text;
    begin
        OpenApproval.Reset();
        OpenApproval.SetRange("Table ID", ApprovalEntry."Table ID");
        OpenApproval.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
        OpenApproval.SetRange(Status, OpenApproval.Status::Open);
        if OpenApproval.FindFirst() then
            exit;

        if not RecRef.Get(ApprovalEntry."Record ID to Approve") then
            exit;

        case RecRef.Number of

            Database::"Purchase Header":
                begin
                    RecRef.SetTable(PurchaseHeader);

                    if HREmployees.Get(PurchaseHeader."Employee No") then begin
                        EmailSubject := 'APPROVED DOCUMENT ' + PurchaseHeader."No.";
                        EmailBody := 'Your approval request ' + PurchaseHeader."Posting Description" + ' has been fully approved.';
                        Notifications.fnSendemail(HRemployees."First Name" + '' + HRemployees."Last Name", EmailSubject, EmailBody, HREmployees."E-Mail", '', '', false, '', '', '', Enum::"Email Scenario"::Reminder);
                    end;
                end;

            Database::"HR Leave Application":
                begin
                    RecRef.SetTable(HumanResourceLeave);

                    if HREmployees.Get(HumanResourceLeave."Employee No") then begin
                        EmailSubject := 'APPROVED LEAVE APPLICATION';
                        EmailBody := 'Your ' + HumanResourceLeave."Leave Type" + ' leave application has been fully approved.';
                        Notifications.fnSendemail(HRemployees."First Name" + '' + HRemployees."Last Name", EmailSubject, EmailBody, HREmployees."E-Mail", '', '', false, '', '', '', Enum::"Email Scenario"::Reminder);
                    end;
                end;

            Database::TimesheetLines:
                begin
                    RecRef.SetTable(Timesheets);

                    if HREmployees.Get(Timesheets."Employee No") then begin
                        EmailSubject := 'APPROVED TIMESHEET';
                        EmailBody := 'Your timesheet ' + Timesheets.Timesheetcode + ' has been fully approved.';
                        Notifications.fnSendemail(HRemployees."First Name" + '' + HRemployees."Last Name", EmailSubject, EmailBody, HREmployees."E-Mail", '', '', false, '', '', '', Enum::"Email Scenario"::Reminder);
                    end;
                end;

            Database::"Training Requests":
                begin
                    RecRef.SetTable(Training);
                    if HREmployees.Get(Training."Employee Code") then begin
                        EmailSubject := 'APPROVED TRAINING REQUEST';
                        EmailBody := 'Your training request ' + Training."Application Code" + ' has been fully approved.';
                        Notifications.fnSendemail(HRemployees."First Name" + '' + HRemployees."Last Name", EmailSubject, EmailBody, HREmployees."E-Mail", '', '', false, '', '', '', Enum::"Email Scenario"::Reminder);

                    end;
                end;
        end;
    end;

}

