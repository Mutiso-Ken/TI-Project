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


    procedure CheckApprovalsWorkflowEnabled(var Variant: Variant): Boolean
    var
        RecRef: RecordRef;
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of

            //HR



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
        //HR


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


    procedure ReOpen(var Variant: Variant)
    var
        RecRef: RecordRef;
        HRLeaveApplication: Record "HR Leave Application";
        ItemJournalBatch: Record "Item Journal Batch";
        itemjnlline: Record "Item Journal Line";
        TrainingRequests: Record "Training Requests";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of



            //Leave Application
            Database::"HR Leave Application":
                begin
                    RecRef.SetTable(HRLeaveApplication);
                    HRLeaveApplication.Validate(Status, HRLeaveApplication.Status::New);
                    HRLeaveApplication.Modify;
                    Variant := HRLeaveApplication;
                end;

            //Training Application
            Database::"Training Requests":
                begin
                    RecRef.SetTable(TrainingRequests);
                    TrainingRequests.Validate(Status, HRLeaveApplication.Status::New);
                    TrainingRequests.Modify;
                    Variant := TrainingRequests;
                end;

            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end
    end;


    procedure Release(var Variant: Variant)
    var
        RecRef: RecordRef;
        HRLeaveApplication: Record "HR Leave Application";
        ItemJournalBatch: Record "Item Journal Batch";
        usersetup: Record "User Setup";
        genjnline: Record "Gen. Journal Line";
        itemjournalline: Record "Item Journal Line";
        TrainingRequests: Record "Training Requests";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of


            //Leave Application
            Database::"HR Leave Application":
                begin
                    RecRef.SetTable(HRLeaveApplication);
                    HRLeaveApplication.Validate(Status, HRLeaveApplication.Status::Approved);
                    HRLeaveApplication.Modify;
                    HRLeaveApplication.CreateLeaveLedgerEntries;
                    Variant := HRLeaveApplication;
                end;

            //Training Application
            Database::"Training Requests":
                begin
                    RecRef.SetTable(TrainingRequests);
                    TrainingRequests.Validate(Status, TrainingRequests.Status::Approved);
                    TrainingRequests.Modify;
                    //HRLeaveApplication.CreateLeaveLedgerEntries;
                    Variant := TrainingRequests;
                end;

            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end
    end;


    procedure SetStatusToPending(var Variant: Variant)
    var
        RecRef: RecordRef;
        HRLeaveApplication: Record "HR Leave Application";
        ItemJournalBatch: Record "Item Journal Batch";
        usersetup: Record "User Setup";
        genjnline: Record "Gen. Journal Line";
        itemjournalline: Record "Item Journal Line";
        TrainingRequests: Record "Training Requests";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of


            //Leave Application
            Database::"HR Leave Application":
                begin
                    RecRef.SetTable(HRLeaveApplication);
                    HRLeaveApplication.Validate(Status, HRLeaveApplication.Status::"Pending Approval");
                    HRLeaveApplication.Modify;
                    Variant := HRLeaveApplication;
                end;

            //Training Application
            Database::"Training Requests":
                begin
                    RecRef.SetTable(TrainingRequests);
                    TrainingRequests.Validate(Status, TrainingRequests.Status::"Pending Approval");
                    TrainingRequests.Modify;
                    Variant := TrainingRequests;
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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnBeforeCheckPurchLines', '', false, false)]
    local procedure SkipCheckPurchLines(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

}

