codeunit 50047 PortalEntry
{
    trigger OnRun();
    begin
    end;

    var
        HRLeaveTypesTable: Record "HR Leave Types";
        EmployeeTable: Record "HR Employees";
        LeaveApplicationsTable: Record "HR Leave Application";
        //PurchasesTable: Record "Purchase Order";
        PurchasesHeaderTable: Record "Purchase Header";
        PurchasesLineTable: Record "Purchase Line";
        NoticesTable: Record "Notice Board";
        HrSetUpTable: Record "HR Setup";
        BaseCalendar: Record "Base Calendar Change";
        NumberSeries: Codeunit NoSeriesManagement;
        DimensionsTable: Record "Dimension Value";
        StandardTextTable: Record "Standard Text";
        CountryRegionTable: Record "Country/Region";
        CurrencyTable: Record Currency;
        PurchasesandPayablesSetup: record "Purchases & Payables Setup";
        TimesheetTable: Record TimesheetLines;
        TimeSheetLinesTable: Record "TE Time Sheet1";
        Tickets: record "HelpDesk Tickets";
        lJsonArray: JsonArray;
        lJObject: JsonObject;
        AppraisalHeader: Record "Appraisal Header";


    procedure GetVariousOptions(args: Text): Text
    var
        RequestJson: JsonObject;
        OutputJson: JsonObject;
        JsonToken: JsonToken;

        OptionType: Text;
        EmployeeNumber: Text;
    begin
        Clear(RequestJson);
        if not RequestJson.ReadFrom(args) then
            Error('Invalid JSON input');
        RequestJson.Get('option_type', JsonToken);
        OptionType := JsonToken.AsValue().AsText();
        RequestJson.Get('employee_id', JsonToken);
        EmployeeNumber := JsonToken.AsValue().AsText();

        if (OptionType = 'leavetypes') then
            exit(LeaveApplicationElements(EmployeeNumber));

        if (OptionType = 'travelrequesttypes') then
            exit(TravelRequestElements());

        if (OptionType = 'imprestrequesttypes') then
            exit(ImprestElements());

        if (OptionType = 'imprestsurrendertypes') then
            exit(ImprestSurrenderElements(EmployeeNumber));

        if (OptionType = 'paymentmemotypes') then
            exit(PaymentMemoElements(EmployeeNumber));

        if (OptionType = 'pettycashbatch') then
            exit(PettyCashBanks());

        exit(Format(AddResponseHead(OutputJson, false)));
    end;


    procedure RetrieveInformation(args: Text): Text
    var
        RequestJson: JsonObject;
        JsonToken: JsonToken;

        RequestType: Text;
        IdentifierType: Text;
        RequestEmployeeID: Text;
        optionType: Text;

        outputjson: JsonObject;
    begin
        Clear(RequestJson);
        if not RequestJson.ReadFrom(args) then
            Error('Invalid JSON input');

        RequestJson.Get('request_type', JsonToken);
        RequestType := JsonToken.AsValue().AsText();
        if RequestJson.Get('identifier_type', JsonToken) and not JsonToken.AsValue().IsNull() then
            IdentifierType := JsonToken.AsValue().AsText();
        if RequestJson.Get('employee_id', JsonToken) and not JsonToken.AsValue().IsNull then
            RequestEmployeeID := JsonToken.AsValue().AsText();
        if RequestJson.Get('option_type', JsonToken) and not JsonToken.AsValue().IsNull then
            optionType := JsonToken.AsValue().AsText();

        if (RequestType = 'noticelist') then
            exit(GetEmployeeNotices);
        //In use
        if ((RequestType = 'member_details') and ((IdentifierType = 'EMAIL') or (IdentifierType = 'NUMBER'))) then
            exit(GetMemberDetails(RequestEmployeeID, IdentifierType));
        //In use
        if ((RequestType = 'leave_details') and ((IdentifierType = 'EMAIL') or (IdentifierType = 'NUMBER'))) then
            exit(GetLeaveApplications(RequestEmployeeID, IdentifierType));
        //In use
        if ((RequestType = 'payment_memos_details') and ((IdentifierType = 'EMAIL') or (IdentifierType = 'NUMBER'))) then
            exit(GetPaymentMemos(RequestEmployeeID, IdentifierType));
        if ((RequestType = 'request_forms_details') and ((IdentifierType = 'EMAIL') or (IdentifierType = 'NUMBER'))) then
            exit(GetRequestFormRequests(RequestEmployeeID, IdentifierType));
        //In use
        if ((RequestType = 'purchase_requisitions_details') and ((IdentifierType = 'EMAIL') or (IdentifierType = 'NUMBER'))) then
            exit(GetPurchaseRequisitions(RequestEmployeeID, IdentifierType));
        //In use
        if ((RequestType = 'imprest_requests_details') and ((IdentifierType = 'EMAIL') or (IdentifierType = 'NUMBER'))) then
            exit(GetImprestRequests(RequestEmployeeID, IdentifierType));
        //In use
        if ((RequestType = 'mission_proposals_details') and ((IdentifierType = 'EMAIL') or (IdentifierType = 'NUMBER'))) then
            exit(GetMissionProposals(RequestEmployeeID, IdentifierType));
        //In use
        if ((RequestType = 'imprest_surrenders_details') and ((IdentifierType = 'EMAIL') or (IdentifierType = 'NUMBER'))) then
            exit(GetImprestSurrenders(RequestEmployeeID, IdentifierType));
        //In use
        if ((RequestType = 'timesheet_details') and ((IdentifierType = 'EMAIL') or (IdentifierType = 'NUMBER'))) then
            exit(GetTimeSheets(RequestEmployeeID, IdentifierType));

        if (RequestType = 'pettycash_information') then
            exit(GetPettyCashLines(RequestEmployeeID, IdentifierType, optionType));

        if (RequestType = 'helpdesk_tickets') then
            exit(GetHelpDeskTickets(RequestEmployeeID));

        if (RequestType = 'appraisals') then
            exit(GetAppraisals(RequestEmployeeID));

        exit(Format(AddResponseHead(OutputJson, false)));
    end;

    local procedure GetAppraisals(EmployeeID: code[50]): Text
    var
        Outputjson: JsonObject;
        jsonobject: JsonObject;
        jsonarray: JsonArray;
    begin
        Clear(Outputjson);
        Clear(JsonArray);
        AppraisalHeader.Reset();
        AppraisalHeader.SetRange("Employee No", EmployeeID);
        if AppraisalHeader.FindSet() then begin
            repeat
                Clear(jsonobject);
                jsonobject.Add('appraisal_number', AppraisalHeader."Appraisal Code");
                jsonobject.Add('employee_no', AppraisalHeader."Employee No");
                jsonobject.Add('employee_name', AppraisalHeader."Employee Name");
                jsonobject.Add('job_title', AppraisalHeader."Job Title");
                jsonobject.Add('employee_department', AppraisalHeader."Employee Deparment");
                jsonobject.Add('supervisor_code', AppraisalHeader."Immediate Supervisor");
                jsonobject.Add('supervisor_name', AppraisalHeader."Supervisor Name");
                jsonobject.Add('review_period', AppraisalHeader."Review Period");
                jsonobject.Add('status', Format(AppraisalHeader.Status));
                jsonarray.Add(jsonobject);
            until AppraisalHeader.Next() = 0;

            Outputjson.Add('appraisals', JsonArray);
            exit(Format(AddResponseHead(Outputjson, true)));
        end;
        exit(Format(AddResponseHead(Outputjson, false)));
    end;

    procedure SubmitNewInformation(args: Text): Text
    var
        RequestJson: JsonObject;
        JsonToken: JsonToken;

        SubmissionType: Text;
        ElementInformation: JsonObject;
        EmployeeID: code[50];
    begin

        Clear(RequestJson);
        if not RequestJson.ReadFrom(args) then
            Error('Invalid JSON input');

        RequestJson.Get('submission_type', JsonToken);
        SubmissionType := JsonToken.AsValue().AsText();

        //Leave Application

        //exit(Format(AddResponseHead(RequestJson, true)));
        if (SubmissionType = 'leave_submission') then begin
            RequestJson.Get('leave_application', JsonToken);
            ElementInformation := JsonToken.AsObject();
            exit(NewLeaveApplication(ElementInformation));
        end;

        //Imprest Request
        if (SubmissionType = 'imprest_request_submission') then begin
            RequestJson.Get('imprest_application', JsonToken);
            ElementInformation := JsonToken.AsObject();
            exit(NewImprestRequest(ElementInformation));
        end;
        if (SubmissionType = 'imprest_request_line_submission') then begin
            RequestJson.Get('imprest_request_line', JsonToken);
            ElementInformation := JsonToken.AsObject();
            exit(SaveImprestRequestLine(ElementInformation));
        end;

        if (SubmissionType = 'imprest_surrender_submission') then begin
            RequestJson.Get('imprest_application', JsonToken);
            ElementInformation := JsonToken.AsObject();
            exit(NewImprestSurrender(ElementInformation));
        end;

        if (SubmissionType = 'mission_proposal_submission') then begin
            RequestJson.Get('mission_proposal', JsonToken);
            ElementInformation := JsonToken.AsObject();
            exit(NewMissionProposal(ElementInformation));
        end;

        if (SubmissionType = 'mission_proposal_amendment') then begin
            RequestJson.Get('mission_proposal', JsonToken);
            ElementInformation := JsonToken.AsObject();
            exit(AmendMissionProposal(ElementInformation));
        end;

        if (SubmissionType = 'mission_proposal_lines_amendment') then begin
            RequestJson.Get('mission_proposal', JsonToken);
            ElementInformation := JsonToken.AsObject();
            exit(UpdateMissionProposalLines(ElementInformation));
        end;
        if (SubmissionType = 'timesheet_lines_amendment') then begin
            RequestJson.Get('timesheet', JsonToken);
            ElementInformation := JsonToken.AsObject();
            exit(AmendTimeSheetLines(ElementInformation));
        end;
        //Purchase Request
        if (SubmissionType = 'purchase_request_submission') then begin
            RequestJson.Get('purchase_request_application', JsonToken);
            ElementInformation := JsonToken.AsObject();
            exit(NewPurchaseRequest(ElementInformation));
        end;
        if (SubmissionType = 'purchase_request_line_submission') then begin
            RequestJson.Get('purchase_request_line', JsonToken);
            ElementInformation := JsonToken.AsObject();
            exit(SavePurchaseRequestLine(ElementInformation));
        end;
        //Payment Memo
        if (SubmissionType = 'payment_memo_submission') then begin
            RequestJson.Get('payment_memo_application', JsonToken);
            ElementInformation := JsonToken.AsObject();
            exit(NewPaymentMemo(ElementInformation));
        end;
        //Time Sheet
        if (SubmissionType = 'timesheet_submission') then begin
            RequestJson.Get('timesheet', JsonToken);
            ElementInformation := JsonToken.AsObject();
            exit(NewTimeSheet(ElementInformation));
        end;

        if (SubmissionType = 'helpticket_submission') then begin
            RequestJson.Get('ticket', JsonToken);
            ElementInformation := JsonToken.AsObject();
            exit(NewHelpDeskTicket(ElementInformation));
        end;

        if (SubmissionType = 'pettycash_submission') then begin
            RequestJson.Get('employee_id', JsonToken);
            EmployeeID := JsonToken.AsValue().AsText();
            RequestJson.Get('pettycashline', JsonToken);
            ElementInformation := JsonToken.AsObject();
            exit(PettyCashInsertGLLine(EmployeeID, ElementInformation));
        end;
    end;

    procedure ModifyElements(args: Text): Text
    var
        RequestJson: JsonObject;
        JsonToken: JsonToken;

        ModificationType: Text;
        ElementInformation: JsonObject;
    begin
        Clear(RequestJson);
        if not RequestJson.ReadFrom(args) then
            Error('Invalid JSON input');

        RequestJson.Get('modification_type', JsonToken);
        ModificationType := JsonToken.AsValue().AsText();

        //Leave Modification
        if (ModificationType = 'leave_modification') then begin
            RequestJson.Get('leave_application', JsonToken);
            ElementInformation := JsonToken.AsObject();
            exit(AmendLeaveApplication(ElementInformation));
        end;

        //Imprest Request Modification
        if (ModificationType = 'imprest_request_modification') then begin
            RequestJson.Get('imprest_application', JsonToken);
            ElementInformation := JsonToken.AsObject();
            exit(AmendImprestRequest(ElementInformation));
        end;

        //Imprest Request Modification
        if (ModificationType = 'purchase_request_modification') then begin
            RequestJson.Get('purchase_request_application', JsonToken);
            ElementInformation := JsonToken.AsObject();
            exit(AmendPurchaseRequest(ElementInformation));
        end;

        //Imprest Request Modification
        if (ModificationType = 'payment_memo_modification') then begin
            RequestJson.Get('payment_memo_application', JsonToken);
            ElementInformation := JsonToken.AsObject();
            exit(AmendPaymentMemo(ElementInformation));
        end;

        //Time Sheet Modification
        if (ModificationType = 'timesheet_modification') then begin
            RequestJson.Get('timesheet', JsonToken);
            ElementInformation := JsonToken.AsObject();
            exit(AmendTimeSheet(ElementInformation));
        end;
    end;


    procedure RetrieveElementDetails(args: Text): Text
    var
        RequestJson: JsonObject;
        JsonToken: JsonToken;

        ElementType: Text;
        ElementNumber: Text;
    begin

        Clear(RequestJson);
        if not RequestJson.ReadFrom(args) then
            Error('Invalid JSON input');

        RequestJson.Get('element_type', JsonToken);
        ElementType := JsonToken.AsValue().AsText();
        RequestJson.Get('element_number', JsonToken);
        ElementNumber := JsonToken.AsValue().AsText();

        if (ElementType = 'leave_application') then
            exit(GetLeaveDetails(ElementNumber));

        if (ElementType = 'imprest_request') then
            exit(GetImprestRequestDetails(ElementNumber));

        if (ElementType = 'mission_proposal') then
            exit(GetMissionProposalDetails(ElementNumber));

        if (ElementType = 'purchase_request') then
            exit(GetPurchaseRequestDetails(ElementNumber));

        if (ElementType = 'payment_memo') then
            exit(GetPaymentMemoDetails(ElementNumber));

        if (ElementType = 'timesheet') then
            exit(GetTimeSheetDetails(ElementNumber));
    end;

    procedure SendDocumentApproval(args: Text): Text
    var
        RequestJson: JsonObject;
        JsonToken: JsonToken;
        OutputJson: JsonObject;

        ApprovalType: Text;
        ElementNumber: Text;

        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        varrvariant: Variant;
        CustomApprovalsCodeunit: Codeunit "Custom Approvals Codeunit";
    begin

        Clear(RequestJson);
        if not RequestJson.ReadFrom(args) then
            Error('Invalid JSON input');

        RequestJson.Get('approval_type', JsonToken);
        ApprovalType := JsonToken.AsValue().AsText();
        RequestJson.Get('element_number', JsonToken);
        ElementNumber := JsonToken.AsValue().AsText();

        if (ApprovalType = '1') then begin//Payment Memo
            PurchasesHeaderTable.Reset();
            PurchasesHeaderTable.SetRange("No.", ElementNumber);
            if PurchasesHeaderTable.Find('-') then begin
                //if ApprovalsMgmt.CheckPurchaseApprovalPossible(PurchasesHeaderTable) then
                ApprovalsMgmt.OnSendPurchaseDocForApproval(PurchasesHeaderTable);
                exit(Format(AddResponseHead(OutputJson, true)));
            end;
        end;

        if (ApprovalType = '2') then begin//Purchase Request
            PurchasesHeaderTable.Reset();
            PurchasesHeaderTable.SetRange("No.", ElementNumber);
            if PurchasesHeaderTable.Find('-') then begin
                //if ApprovalsMgmt.CheckPurchaseApprovalPossible(PurchasesHeaderTable) then
                ApprovalsMgmt.OnSendPurchaseDocForApproval(PurchasesHeaderTable);
                exit(Format(AddResponseHead(OutputJson, true)));
            end;
        end;

        if (ApprovalType = '3') then begin//Imprest Request
            PurchasesHeaderTable.Reset();
            PurchasesHeaderTable.SetRange("No.", ElementNumber);
            if PurchasesHeaderTable.Find('-') then begin
                //if ApprovalsMgmt.CheckPurchaseApprovalPossible(PurchasesHeaderTable) then
                ApprovalsMgmt.OnSendPurchaseDocForApproval(PurchasesHeaderTable);
                exit(Format(AddResponseHead(OutputJson, true)));
            end;
        end;

        if (ApprovalType = '4') then begin//Leave Application
            LeaveApplicationsTable.Reset();
            LeaveApplicationsTable.SetRange("Application Code", ElementNumber);
            if LeaveApplicationsTable.Find('-') then begin
                LeaveApplicationsTable.TestField("Leave Type");
                LeaveApplicationsTable.TestField("Days Applied");
                LeaveApplicationsTable.TestField(Reliever);
                LeaveApplicationsTable.TestField("Cell Phone Number");
                LeaveApplicationsTable.TestField("E-mail Address");

                LeaveApplicationsTable.TestField(Status, LeaveApplicationsTable.Status::New);

                varrvariant := LeaveApplicationsTable;

                if CustomApprovalsCodeunit.CheckApprovalsWorkflowEnabled(varrvariant) then
                    CustomApprovalsCodeunit.OnSendDocForApproval(varrvariant);
                exit(Format(AddResponseHead(OutputJson, true)));
            end;
        end;

        if (ApprovalType = '5') then begin//Mission Proposal
            PurchasesHeaderTable.Reset();
            PurchasesHeaderTable.SetRange("No.", ElementNumber);
            if PurchasesHeaderTable.Find('-') then begin
                ApprovalsMgmt.OnSendPurchaseDocForApproval(PurchasesHeaderTable);
                exit(Format(AddResponseHead(OutputJson, true)));
            end;
        end;

        if (ApprovalType = '6') then begin//Time Sheet
            PurchasesHeaderTable.Reset();
            PurchasesHeaderTable.SetRange("No.", ElementNumber);
            if PurchasesHeaderTable.Find('-') then begin
                ApprovalsMgmt.OnSendPurchaseDocForApproval(PurchasesHeaderTable);
                exit(Format(AddResponseHead(OutputJson, true)));
            end;
        end;

    end;

    procedure GetApprovalEntries(ElementNumber: code[20]): Text
    var
        OutputJson: JsonObject;

        Entry: JsonObject;
        Entries: JsonArray;

        ApprovalEntries: Record "Approval Entry";
    begin
        Clear(Entries);
        ApprovalEntries.Reset();
        ApprovalEntries.SetRange("Document No.", ElementNumber);
        ApprovalEntries.SetCurrentKey("Sequence No.");
        if ApprovalEntries.FindSet() then begin
            OutputJson := AddResponseHead(OutputJson, true);
            repeat
                Clear(Entry);
                Entry.add('sequence', ApprovalEntries."Sequence No.");
                Entry.Add('status', Format(ApprovalEntries.Status));
                Entry.add('sender_id', ApprovalEntries."Sender ID");
                Entry.add('approver_id', GetUserName(ApprovalEntries."Approver ID"));
                Entry.add('comments', ApprovalEntries.Comments);
                Entries.add(Entry);
            until ApprovalEntries.next() = 0;
            OutputJson.add('approval_entries', Entries);
            exit(Format(OutputJson));
        end;
        exit(Format(AddResponseHead(OutputJson, false)));
    end;

    local procedure GetUserName(useridcode: code[50]): Text
    var
        UserTable: Record 2000000120;
    begin
        UserTable.Reset();
        UserTable.SetRange("User Name", useridcode);
        if UserTable.find('-') then
            exit(UserTable."Full Name");
    end;


    local procedure GetLeaveTypes(): JsonArray
    var
        leave: JsonObject;
        leaves: JsonArray;
    begin
        HRLeaveTypesTable.Reset();
        if HRLeaveTypesTable.find('-') then begin
            repeat
                Clear(leave);
                leave.Add('leave_code', HRLeaveTypesTable.Code);
                leave.Add('leave_description', HRLeaveTypesTable.Description);
                leave.Add('leave_max_days', HRLeaveTypesTable.Days);
                leave.Add('leave_gender', Format(HRLeaveTypesTable.Gender));
                leaves.Add(leave);
            until HRLeaveTypesTable.Next() = 0;
            exit(leaves);
        end;
    end;

    local procedure GetEmployeeRelievers(employeeid: code[20]): JsonArray
    var
        employeedepartment: text[200];
        employee: JsonObject;
        employees: JsonArray;
    begin
        EmployeeTable.Reset();
        EmployeeTable.SetRange("No.", employeeid);
        if EmployeeTable.FindFirst() then begin
            employeedepartment := EmployeeTable."Shortcut Dimension 4 Code";
        end;

        EmployeeTable.Reset();
        EmployeeTable.SetRange("Shortcut Dimension 4 Code", employeedepartment);
        if EmployeeTable.FindSet() then begin
            repeat
                Clear(employee);
                employee.add('reliever_code', EmployeeTable."No.");
                employee.add('reliever_name', GetEmployeeFullName());
                employees.Add(employee);
            until EmployeeTable.Next() = 0;
        end;
        exit(employees);
    end;

    local procedure GetDimensionValues(filterType: Code[30]; filter: Code[60]): JsonArray;
    VAR
        jarray: JsonArray;
        jobject: JsonObject;
    BEGIN
        Clear(jarray);
        DimensionsTable.RESET;
        DimensionsTable.SetFilter("Global Dimension No.", filterType);
        DimensionsTable.SetRange(Blocked, false);
        //DimensionsTable.SETRANGE(Code, filter);
        DimensionsTable.SETCURRENTKEY(Name);
        DimensionsTable.ASCENDING(TRUE);
        IF DimensionsTable.FINDFIRST THEN
            REPEAT
                Clear(jobject);
                jobject.Add('Code', DimensionsTable.Code);
                jobject.Add('Name', DimensionsTable.Name);
                jarray.Add(jobject);
            UNTIL DimensionsTable.NEXT = 0;
        exit((jarray));
    END;

    local procedure GetTimeSheetDimensionValues(): JsonArray;
    VAR
        jarray: JsonArray;
        jobject: JsonObject;
    BEGIN
        Clear(jarray);
        DimensionsTable.RESET;
        // DimensionsTable.SetRange(Blocked, false);
        DimensionsTable.SETRANGE("Dimension Code", 'FUND');
        DimensionsTable.SETCURRENTKEY(Name);
        DimensionsTable.ASCENDING(TRUE);
        IF DimensionsTable.FINDFIRST THEN
            REPEAT
                Clear(jobject);
                jobject.Add('Code', DimensionsTable.Code);
                jobject.Add('Name', DimensionsTable.Name);
                jarray.Add(jobject);
            UNTIL DimensionsTable.NEXT = 0;
        exit((jarray));
    END;

    local procedure GetGLAccounts(filter: Code[60]): JsonArray;
    VAR
        jarray: JsonArray;
        jobject: JsonObject;
        AccountsTable: Record 15;
    BEGIN
        Clear(jarray);
        AccountsTable.RESET;
        AccountsTable.SETCURRENTKEY("No.");
        AccountsTable.ASCENDING(TRUE);
        IF AccountsTable.FINDFIRST THEN
            REPEAT
                Clear(jobject);
                jobject.Add('Code', AccountsTable."No.");
                jobject.Add('Name', AccountsTable.Name);
                jarray.Add(jobject);
            UNTIL AccountsTable.NEXT = 0;
        exit((jarray));
    END;

    local procedure GetStandardTexts(filterType: Text): JsonArray;
    VAR
        jarray: JsonArray;
        jobject: JsonObject;
        standardoption: Option;
    BEGIN
        if filterType = 'Focus Area' then
            standardoption := StandardTextTable.Type::"Focus Area";
        if filterType = 'Sub Pillar' then
            standardoption := StandardTextTable.Type::"Sub Pillar";
        if filterType = 'Department' then
            standardoption := StandardTextTable.Type::Department;
        if filterType = 'GL Category' then
            standardoption := StandardTextTable.Type::"GL Category";
        // if filterType = 'Focus Area' then
        //     standardoption := StandardTextTable.Type::"Focus Area";
        Clear(jarray);
        StandardTextTable.RESET;
        StandardTextTable.SetRange(Type, standardoption);
        // StandardTextTable.SetRange(Blocked, false);
        StandardTextTable.SETCURRENTKEY(Description);
        StandardTextTable.ASCENDING(TRUE);
        IF StandardTextTable.Find('-') THEN
            REPEAT
                Clear(jobject);
                jobject.Add('Code', StandardTextTable.Code);
                jobject.Add('Name', StandardTextTable.Description);
                jarray.Add(jobject);
            UNTIL StandardTextTable.NEXT = 0;
        exit((jarray));
    END;

    local procedure GetCountryRegions(filterType: Code[30]): JsonArray;
    VAR
        jarray: JsonArray;
        jobject: JsonObject;
    BEGIN
        Clear(jarray);
        CountryRegionTable.RESET;
        CountryRegionTable.SetFilter(Type, filterType);
        // StandardTextTable.SetRange(Blocked, false);
        CountryRegionTable.SETCURRENTKEY(Name);
        CountryRegionTable.ASCENDING(TRUE);
        IF CountryRegionTable.FINDFIRST THEN
            REPEAT
                Clear(jobject);
                jobject.Add('Code', CountryRegionTable.Code);
                jobject.Add('Name', CountryRegionTable.Name);
                jarray.Add(jobject);
            UNTIL CountryRegionTable.NEXT = 0;
        exit((jarray));
    END;

    local procedure GetCurrencies(): JsonArray;
    var
        jarray: JsonArray;
        jobject: JsonObject;
    begin
        Clear(jarray);
        CurrencyTable.Reset();
        if CurrencyTable.Find('-') then begin
            repeat
                Clear(jobject);
                jobject.Add('Code', CurrencyTable.Code);
                jobject.Add('Name', CurrencyTable.Description);
                jarray.Add(jobject);
            until CurrencyTable.Next() = 0;
        end;
        exit(jarray);
    end;

    local procedure GetLeaveDetails(LeaveCode: Code[50]): Text
    var

        LeaveLedgerEntries: Record "HR Leave Ledger Entries";
        OutputJson: JsonObject;
        JsonToken: JsonToken;

        leaveapplication: JsonObject;
    begin
        LeaveApplicationsTable.Reset();
        LeaveApplicationsTable.SetRange("Application Code", LeaveCode);
        if LeaveApplicationsTable.FindSet() then begin
            Clear(OutputJson);
            OutputJson := AddResponseHead(OutputJson, true);
            Clear(leaveapplication);
            leaveapplication.add('employee_id', LeaveApplicationsTable."Employee No");
            leaveapplication.add('application_number', LeaveApplicationsTable."Application Code");
            leaveapplication.add('status', Format(LeaveApplicationsTable.Status));
            leaveapplication.add('leave_type', Format(LeaveApplicationsTable."Leave Type"));
            leaveapplication.add('leave_type_description', GetLeaveDescription(LeaveApplicationsTable."Leave Type"));
            leaveapplication.add('startdate', LeaveApplicationsTable."Start Date");
            leaveapplication.add('enddate', CALCDATE('<-1D>', LeaveApplicationsTable."Return Date"));
            leaveapplication.add('returndate', LeaveApplicationsTable."Return Date");
            leaveapplication.add('days_applied', LeaveApplicationsTable."Days Applied");
            leaveapplication.add('current_leave_balance', GetLeaveTypeBalance(LeaveApplicationsTable."Employee No", LeaveApplicationsTable."Leave Type"));
            leaveapplication.add('application_date', LeaveApplicationsTable."Application Date");
            leaveapplication.add('pending_tasks', LeaveApplicationsTable."Pending Tasks");
            leaveapplication.add('reliever', LeaveApplicationsTable.Reliever);
            leaveapplication.add('reliever_name', LeaveApplicationsTable."Reliever Name");
            leaveapplication.add('contact_information', LeaveApplicationsTable."Cell Phone Number");
            leaveapplication.add('reason', LeaveApplicationsTable.Description);
            OutputJson.Add('leave_application_details', leaveapplication);
            OutputJson.Add('leave_types', GetLeaveTypes());
            OutputJson.add('relievers', GetEmployeeRelievers(LeaveApplicationsTable."Employee No"));

            exit(Format(OutputJson));
        end;
        exit(Format(AddResponseHead(OutputJson, false)));
    end;

    local procedure NewLeaveApplication(RequestJson: JsonObject): Text
    var
        OutputJson: JsonObject;
        JsonToken: JsonToken;

        EmployeeID: code[50];
        DaysRequested: Decimal;
        StartDate: date;
        EndDate: date;
        ReturnDate: date;
        Reason: Text;
        PendingTasks: Text;
        ContactInfo: Text;
        LeaveReason: Text;
        DateText: Text;
        ResponsibilityCenter: Text;
        Reliever: code[50];
        LeaveType: code[50];
        HalfDay: code[50];
        NextLeaveApplicationNo: code[50];
    begin

        RequestJson.Get('employee_id', JsonToken);
        EmployeeID := JsonToken.AsValue().AsText();
        RequestJson.Get('days_applied', JsonToken);
        DaysRequested := JsonToken.AsValue().AsDecimal();

        if RequestJson.Get('startdate', JsonToken) then begin
            DateText := JsonToken.AsValue().AsText();
            if DateText <> '' then
                Evaluate(StartDate, DateText, 9);
        end;
        if RequestJson.Get('enddate', JsonToken) then begin
            DateText := JsonToken.AsValue().AsText();
            if DateText <> '' then
                Evaluate(EndDate, DateText, 9);
        end;
        RequestJson.Get('pending_tasks', JsonToken);
        PendingTasks := JsonToken.AsValue().AsText();
        if RequestJson.Get('reason', JsonToken) then
            LeaveReason := JsonToken.AsValue().AsText();
        RequestJson.Get('reliever', JsonToken);
        Reliever := JsonToken.AsValue().AsText();
        // RequestJson.Get('halfday', JsonToken);
        // HalfDay := JsonToken.AsValue().AsText();
        RequestJson.Get('leave_type', JsonToken);
        LeaveType := JsonToken.AsValue().AsText();
        if RequestJson.Get('contact_information', JsonToken) then
            ContactInfo := JsonToken.AsValue().AsText();

        FnValidateStartDate(StartDate);
        ReturnDate := DetermineLeaveReturnDate(StartDate, DaysRequested, LeaveType);
        EndDate := CalcEndDate(StartDate, DaysRequested, LeaveType);

        HrSetUpTable.Get();
        NextLeaveApplicationNo := NumberSeries.GetNextNo(HrSetUpTable."Leave Application Nos.", 0D, true);

        EmployeeTable.Reset;
        EmployeeTable.SetRange("No.", EmployeeID);
        if EmployeeTable.Find('-')
        then begin
            ResponsibilityCenter := EmployeeTable."Responsibility Center";
            LeaveApplicationsTable."User ID" := EmployeeTable."Employee UserID";
            LeaveApplicationsTable."Application Code" := NextLeaveApplicationNo;
            LeaveApplicationsTable."Employee No" := EmployeeID;
            LeaveApplicationsTable.Insert;
            LeaveApplicationsTable.Names := GetEmployeeFullName();
            LeaveApplicationsTable."E-mail Address" := EmployeeTable."E-Mail";
            LeaveApplicationsTable."Leave Type" := LeaveType;
            LeaveApplicationsTable."Days Applied" := DaysRequested;
            LeaveApplicationsTable.Validate(LeaveApplicationsTable."Days Applied");
            LeaveApplicationsTable."Application Date" := Today;
            LeaveApplicationsTable."No series" := 'LEAVE';
            LeaveApplicationsTable."Start Date" := StartDate;
            LeaveApplicationsTable.Validate("Start Date");
            LeaveApplicationsTable."Return Date" := ReturnDate;
            LeaveApplicationsTable."End Date" := ReturnDate;
            LeaveApplicationsTable."Responsibility Center" := ResponsibilityCenter;
            LeaveApplicationsTable.Reliever := Reliever;
            LeaveApplicationsTable.Validate(LeaveApplicationsTable.Reliever);
            LeaveApplicationsTable.Description := LeaveReason;
            LeaveApplicationsTable.Validate("Employee No");
            LeaveApplicationsTable."Pending Tasks" := PendingTasks;
            LeaveApplicationsTable."Cell Phone Number" := ContactInfo;
            LeaveApplicationsTable."Applicant Comments" := 'Reachable on:' + ContactInfo;
            LeaveApplicationsTable."Is reimbursement" := false;
            LeaveApplicationsTable.Modify;

            OutputJson := AddResponseHead(OutputJson, true);
            exit(Format(OutputJson));
        end;
    end;


    local procedure AmendLeaveApplication(RequestJson: JsonObject): Text
    var
        OutputJson: JsonObject;
        JsonToken: JsonToken;

        EmployeeID: code[50];
        Leavenumber: code[50];
        DaysRequested: Decimal;
        StartDate: date;
        EndDate: date;
        ReturnDate: date;
        Reason: Text;
        PendingTasks: Text;
        ContactInfo: Text;
        LeaveReason: Text;
        DateText: Text;
        ResponsibilityCenter: Text;
        Reliever: code[50];
        LeaveType: code[50];
        HalfDay: code[50];
        NextLeaveApplicationNo: code[50];
    begin
        RequestJson.Get('application_number', JsonToken);
        Leavenumber := JsonToken.AsValue().AsText();
        RequestJson.Get('employee_id', JsonToken);
        EmployeeID := JsonToken.AsValue().AsText();
        RequestJson.Get('days_applied', JsonToken);
        DaysRequested := JsonToken.AsValue().AsDecimal();

        if RequestJson.Get('startdate', JsonToken) then begin
            DateText := JsonToken.AsValue().AsText();
            if DateText <> '' then
                Evaluate(StartDate, DateText, 9);
        end;
        if RequestJson.Get('enddate', JsonToken) then begin
            DateText := JsonToken.AsValue().AsText();
            if DateText <> '' then
                Evaluate(EndDate, DateText, 9);
        end;
        RequestJson.Get('pending_tasks', JsonToken);
        PendingTasks := JsonToken.AsValue().AsText();
        if RequestJson.Get('reason', JsonToken) then
            LeaveReason := JsonToken.AsValue().AsText();
        RequestJson.Get('reliever', JsonToken);
        Reliever := JsonToken.AsValue().AsText();
        // RequestJson.Get('halfday', JsonToken);
        // HalfDay := JsonToken.AsValue().AsText();
        RequestJson.Get('leave_type', JsonToken);
        LeaveType := JsonToken.AsValue().AsText();
        if RequestJson.Get('contact_information', JsonToken) then
            ContactInfo := JsonToken.AsValue().AsText();

        FnValidateStartDate(StartDate);
        ReturnDate := DetermineLeaveReturnDate(StartDate, DaysRequested, LeaveType);
        EndDate := CalcEndDate(StartDate, DaysRequested, LeaveType);

        LeaveApplicationsTable.Reset();
        LeaveApplicationsTable.SetRange("Application Code", Leavenumber);
        if LeaveApplicationsTable.Find('-') then begin
            LeaveApplicationsTable."Leave Type" := LeaveType;
            LeaveApplicationsTable."Days Applied" := DaysRequested;
            LeaveApplicationsTable.Validate(LeaveApplicationsTable."Days Applied");
            LeaveApplicationsTable."Start Date" := StartDate;
            LeaveApplicationsTable.Validate("Start Date");
            LeaveApplicationsTable."Return Date" := ReturnDate;
            LeaveApplicationsTable."End Date" := ReturnDate;
            LeaveApplicationsTable.Reliever := Reliever;
            LeaveApplicationsTable.Validate(LeaveApplicationsTable.Reliever);
            LeaveApplicationsTable.Description := LeaveReason;
            LeaveApplicationsTable."Pending Tasks" := PendingTasks;
            LeaveApplicationsTable."Cell Phone Number" := ContactInfo;
            LeaveApplicationsTable."Applicant Comments" := 'Reachable on:' + ContactInfo;
            LeaveApplicationsTable."Is reimbursement" := false;
            LeaveApplicationsTable.Modify;
            exit(GetLeaveDetails(LeaveApplicationsTable."Application Code"));
        end;
    end;

    local procedure GetEmployeeNotices(): Text
    var
        notice: JsonObject;
        notices: JsonArray;

        OutputJson: JsonObject;
    begin
        Clear(OutputJson);
        Clear(notices);
        NoticesTable.Reset();
        if NoticesTable.find() then begin
            OutputJson := AddResponseHead(OutputJson, true);
            repeat
                Clear(notice);
                notice.Add('notice_text', NoticesTable.Announcement);
                notice.Add('notice_date', NoticesTable."Date of Announcement");
                notice.Add('notice_department', NoticesTable."Department Announcing");
                notices.Add(notice);
            until NoticesTable.Next() = 0;
            OutputJson.Add('notice_list', notices);

            exit(Format(OutputJson));
        end;
        OutputJson := AddResponseHead(OutputJson, false);
        exit(format(OutputJson));
    end;

    local procedure TravelRequestElements(): Text
    var
        OutputJson: JsonObject;
    begin
        OutputJson := AddResponseHead(OutputJson, true);
        OutputJson.Add('donorcodes', GetDimensionValues('3', ''));
        OutputJson.Add('projectcodes', GetDimensionValues('1', ''));
        OutputJson.Add('departmentcodes', GetDimensionValues('4', ''));
        exit(format(OutputJson));
    end;

    local procedure ImprestSurrenderElements(EmployeeNumber: Code[50]): Text
    var
        OutputJson: JsonObject;
        element: JsonObject;
        elements: JsonArray;
    begin
        PurchasesHeaderTable.Reset();
        PurchasesHeaderTable.SetRange(IM, true);
        PurchasesHeaderTable.SetRange(Surrendered, false);
        PurchasesHeaderTable.SetRange("Employee No", EmployeeNumber);
        PurchasesHeaderTable.SetRange(Status, PurchasesHeaderTable.Status::Released);
        if PurchasesHeaderTable.FindSet() then begin
            Clear(OutputJson);
            Clear(elements);
            OutputJson := AddResponseHead(OutputJson, true);
            repeat
                PurchasesHeaderTable.CalcFields(Amount);
                Clear(element);
                element.add('imprest_number', PurchasesHeaderTable."No.");
                element.add('imprest_amount', PurchasesHeaderTable.Amount);
                elements.add(element);
            until PurchasesHeaderTable.Next() = 0;
            OutputJson.Add('imprest_requests', elements);
            outputjson.add('expensecategories', GetStandardTexts('GL Category'));
            exit(Format(OutputJson));
        end;
        exit(Format(AddResponseHead(OutputJson, false)));
    end;

    local procedure ImprestElements(): Text
    var
        OutputJson: JsonObject;
    begin
        OutputJson := AddResponseHead(OutputJson, true);
        outputjson.Add('fund_codes', GetDimensionValues('1', ''));
        outputjson.Add('program_codes', GetDimensionValues('2', ''));
        outputjson.Add('budget_codes', GetDimensionValues('3', ''));
        outputjson.Add('shortcut_4_codes', GetDimensionValues('4', ''));
        outputjson.Add('department_codes', GetDimensionValues('5', ''));
        outputjson.add('currencies', GetCurrencies());
        outputjson.add('strategic_focus_areas', GetStandardTexts('Focus Area'));
        outputjson.add('sub_pillars', GetStandardTexts('Sub Pillar'));
        outputjson.add('countries', GetCountryRegions('Country'));
        outputjson.add('counties', GetCountryRegions('County'));
        outputjson.add('expensecategories', GetStandardTexts('GL Category'));
        outputjson.Add('gl_accounts', GetGLAccounts('5'));
        exit(format(OutputJson));
    end;

    local procedure LeaveApplicationElements(employeeid: code[50]): Text
    var
        leave: JsonObject;
        leaves: JsonArray;

        employeedepartment: Text;

        employee: JsonObject;
        employees: JsonArray;

        OutputJson: JsonObject;
    begin
        Clear(OutputJson);
        Clear(leaves);
        Clear(employees);
        HRLeaveTypesTable.Reset();
        if HRLeaveTypesTable.find('-') then begin
            OutputJson := AddResponseHead(OutputJson, true);
            OutputJson.Add('employee_id', employeeid);
            repeat
                Clear(leave);
                leave.Add('leave_code', HRLeaveTypesTable.Code);
                leave.Add('leave_description', HRLeaveTypesTable.Description);
                leave.Add('leave_max_days', HRLeaveTypesTable.Days);
                leave.Add('leave_gender', Format(HRLeaveTypesTable.Gender));
                leaves.Add(leave);
            until HRLeaveTypesTable.Next() = 0;
            OutputJson.Add('leave_types', leaves);

            EmployeeTable.Reset();
            EmployeeTable.SetRange("No.", employeeid);
            if EmployeeTable.FindFirst() then begin
                employeedepartment := EmployeeTable."Shortcut Dimension 4 Code";
            end;

            EmployeeTable.Reset();
            EmployeeTable.SetRange(Status, EmployeeTable.Status::Active);
            EmployeeTable.SetRange("Shortcut Dimension 4 Code", employeedepartment);
            if EmployeeTable.FindSet() then begin
                repeat
                    Clear(employee);
                    employee.add('reliever_code', EmployeeTable."No.");
                    employee.add('reliever_name', GetEmployeeFullName());
                    employees.Add(employee);
                until EmployeeTable.Next() = 0;
            end;

            OutputJson.add('relievers', employees);
            exit(Format(OutputJson));
        end;
        OutputJson := AddResponseHead(OutputJson, false);
        exit(format(OutputJson));
    end;

    local procedure GetMemberDetails(employeeid: Text; Identifier: Text): Text
    var
        OutputJson: JsonObject;
        DataJson: JsonObject;
    begin
        if (employeeid <> '') then begin
            EmployeeTable.Reset();
            EmployeeTable.SetRange(Status, EmployeeTable.Status::Active);
            if (Identifier = 'EMAIL') then
                EmployeeTable.SetRange("E-Mail", employeeid);
            if (Identifier = 'NUMBER') then
                EmployeeTable.SetRange("No.", employeeid);
            if EmployeeTable.FindFirst() then begin
                Clear(OutputJson);
                EmployeeTable.CalcFields("Total (Leave Days)", "Total Leave Taken", "Annual Leave Account", "Maternity Leave Acc.", "Study Leave Acc", "Paternity Leave Acc.", "Compassionate Leave Acc.", "CTO  Leave Acc.", "Sick Leave Acc.");
                OutputJson := AddResponseHead(OutputJson, true);
                DataJson.add('employee_full_name', GetEmployeeFullName());
                DataJson.add('employee_id', EmployeeTable."No.");
                DataJson.add('company_email', EmployeeTable."E-Mail");
                DataJson.add('personal_email', EmployeeTable."E-Mail");
                DataJson.add('date_of_birth', EmployeeTable."Date Of Birth");
                DataJson.add('date_of_joining', EmployeeTable."Date Of Join");
                DataJson.add('id_number', EmployeeTable."ID Number");
                DataJson.Add('phone_number', EmployeeTable."Home Phone Number");
                DataJson.Add('job_title', EmployeeTable.Position);
                DataJson.Add('gender', Format(EmployeeTable.Gender));
                DataJson.Add('kra_pin', EmployeeTable."PIN No.");
                DataJson.Add('nssf_pin', EmployeeTable."NSSF No.");
                DataJson.Add('nhif_pin', EmployeeTable."NHIF No.");

                //Supervisor
                DataJson.Add('supervisor_id', EmployeeTable."Supervisor ID");
                //DataJson.Add('supervisor_name', EmployeeTable."Supervisor  Name");

                //Leave
                DataJson.Add('total_leave_days_allocated', EmployeeTable."Total (Leave Days)");
                DataJson.Add('total_leave_taken', EmployeeTable."Total Leave Taken");
                DataJson.Add('annual_leave_balance', EmployeeTable."Annual Leave Account");
                DataJson.Add('maternity_leave_balance', EmployeeTable."Maternity Leave Acc.");
                DataJson.Add('exam_leave_balance', EmployeeTable."Study Leave Acc");
                DataJson.Add('paternity_leave_balance', EmployeeTable."Paternity Leave Acc.");
                DataJson.Add('compassionate_leave_balance', EmployeeTable."Compassionate Leave Acc.");
                DataJson.Add('cto_leave_balance', EmployeeTable."CTO  Leave Acc.");
                //DataJson.Add('rnr_leave_balance', EmployeeTable.rnr);
                DataJson.Add('sick_leave_balance', EmployeeTable."Sick Leave Acc.");
                OutputJson.Add('employee_biodata', DataJson);
                exit(Format(OutputJson));
            end;
        end;
        exit(Format(AddResponseHead(OutputJson, false)));
    end;

    local procedure GetLeaveApplications(employeeid: Text; Identifier: Text): Text
    var
        OutputJson: JsonObject;
        DataJson: JsonObject;

        leaveapplication: JsonObject;
        leaveapplications: JsonArray;
    begin
        if (employeeid <> '') then begin
            EmployeeTable.Reset();
            if (Identifier = 'EMAIL') then
                EmployeeTable.SetRange("Company E-Mail", employeeid);
            if (Identifier = 'NUMBER') then
                EmployeeTable.SetRange("No.", employeeid);
            if EmployeeTable.FindFirst() then begin
                LeaveApplicationsTable.Reset();
                LeaveApplicationsTable.SetRange("Employee No", EmployeeTable."No.");
                if LeaveApplicationsTable.FindSet() then begin
                    Clear(OutputJson);
                    Clear(leaveapplications);
                    OutputJson := AddResponseHead(OutputJson, true);
                    repeat
                        Clear(leaveapplication);
                        leaveapplication.add('application_number', LeaveApplicationsTable."Application Code");
                        leaveapplication.add('status', Format(LeaveApplicationsTable.Status));
                        leaveapplication.add('leave_type', Format(LeaveApplicationsTable."Leave Type"));
                        leaveapplication.add('days_applied', LeaveApplicationsTable."Days Applied");
                        leaveapplication.add('startdate', LeaveApplicationsTable."Start Date");
                        leaveapplication.add('enddate', LeaveApplicationsTable."End Date");
                        leaveapplication.add('application_date', LeaveApplicationsTable."Application Date");
                        leaveapplication.add('leave_type_description', GetLeaveDescription(LeaveApplicationsTable."Leave Type"));
                        leaveapplications.add(leaveapplication);
                    until LeaveApplicationsTable.Next() = 0;
                    OutputJson.Add('leave_applications', leaveapplications);
                    exit(Format(OutputJson));
                end;
            end;
        end;
        exit(Format(AddResponseHead(OutputJson, false)));
    end;


    local procedure GetRequestFormRequests(employeeid: Text; Identifier: Text): Text
    var
        OutputJson: JsonObject;
        DataJson: JsonObject;

        requestform: JsonObject;
        requestforms: JsonArray;
    begin
        if (employeeid <> '') then begin
            EmployeeTable.Reset();
            if (Identifier = 'EMAIL') then
                EmployeeTable.SetRange("Company E-Mail", employeeid);
            if (Identifier = 'NUMBER') then
                EmployeeTable.SetRange("No.", employeeid);
            if EmployeeTable.FindFirst() then begin
                PurchasesHeaderTable.Reset();
                PurchasesHeaderTable.SetAscending("No.", false);
                PurchasesHeaderTable.SetRange("Employee No", EmployeeTable."No.");
                //PurchasesHeaderTable.SetRange("AU Form Type", PurchasesHeaderTable."AU Form Type"::"Request Form");
                if PurchasesHeaderTable.FindSet() then begin
                    Clear(OutputJson);
                    Clear(requestforms);
                    OutputJson := AddResponseHead(OutputJson, true);
                    repeat
                        Clear(requestform);
                        requestform.add('request_number', PurchasesHeaderTable."No.");
                        requestform.add('status', Format(PurchasesHeaderTable.Status));
                        // requestform.add('request_memo', PurchasesHeaderTable."Payee Naration");
                        // requestform.add('start_date', PurchasesHeaderTable.fromDate);
                        requestform.add('end_date', PurchasesHeaderTable."Due Date");
                        requestform.add('request_amount', PurchasesHeaderTable.Amount);
                        requestforms.add(requestform);
                    until PurchasesHeaderTable.Next() = 0;
                    OutputJson.Add('requestform_requests', requestforms);
                    exit(Format(OutputJson));
                end;
            end;
        end;
        exit(Format(AddResponseHead(OutputJson, false)));
    end;


    local procedure GetPurchaseRequisitions(employeeid: Text; Identifier: Text): Text
    var
        OutputJson: JsonObject;
        DataJson: JsonObject;

        purchaserequisition: JsonObject;
        purchaserequisitions: JsonArray;
    begin
        if (employeeid <> '') then begin
            EmployeeTable.Reset();
            if (Identifier = 'EMAIL') then
                EmployeeTable.SetRange("Company E-Mail", employeeid);
            if (Identifier = 'NUMBER') then
                EmployeeTable.SetRange("No.", employeeid);
            if EmployeeTable.FindFirst() then begin
                PurchasesHeaderTable.Reset();
                PurchasesHeaderTable.SetCurrentKey("Requested Receipt Date");
                PurchasesHeaderTable.SetAscending("Requested Receipt Date", false);
                PurchasesHeaderTable.SetRange("Employee No", EmployeeTable."No.");
                PurchasesHeaderTable.SetRange(pr, true);
                if PurchasesHeaderTable.FindSet() then begin
                    Clear(OutputJson);
                    Clear(purchaserequisitions);
                    OutputJson := AddResponseHead(OutputJson, true);
                    repeat
                        PurchasesHeaderTable.CalcFields(Amount);
                        Clear(purchaserequisition);
                        purchaserequisition.add('number', PurchasesHeaderTable."No.");
                        purchaserequisition.add('status', Format(PurchasesHeaderTable.Status));
                        purchaserequisition.add('employee_name', PurchasesHeaderTable."Employee Name");
                        purchaserequisition.add('request_date', PurchasesHeaderTable."Requested Receipt Date");
                        purchaserequisition.add('date_required', PurchasesHeaderTable."Expected Receipt Date");
                        purchaserequisition.add('total_amount_including_vat', PurchasesHeaderTable.Amount);
                        purchaserequisitions.add(purchaserequisition);
                    until PurchasesHeaderTable.Next() = 0;
                    OutputJson.Add('purchase_requisitions', purchaserequisitions);
                    exit(Format(OutputJson));
                end;
            end;
        end;
        exit(Format(AddResponseHead(OutputJson, false)));
    end;

    local procedure GetPurchaseRequestDetails(requestnumber: code[50]): Text
    var
        outputjson: JsonObject;
        element: JsonObject;
        line: JsonObject;
        lines: JsonArray;
    begin
        PurchasesHeaderTable.Reset();
        PurchasesHeaderTable.SetRange("No.", requestnumber);
        if PurchasesHeaderTable.Find('-') then begin
            outputjson := AddResponseHead(outputjson, true);

            element.add('number', PurchasesHeaderTable."No.");
            element.add('request_date', PurchasesHeaderTable."Requested Receipt Date");
            element.add('date_required', PurchasesHeaderTable."Expected Receipt Date");
            element.add('fund_code', PurchasesHeaderTable."Shortcut Dimension 1 Code");
            element.add('program_code', PurchasesHeaderTable."Shortcut Dimension 2 Code");
            element.add('budget_lines_code', PurchasesHeaderTable."Shortcut Dimension 3 Code");
            element.add('budget_category_code', PurchasesHeaderTable."Shortcut Dimension 4 Code");
            element.add('department_code', PurchasesHeaderTable."Shortcut Dimension 5 Code");
            element.add('status', Format(PurchasesHeaderTable.Status));
            element.add('mission_proposal_number', PurchasesHeaderTable."Mission Proposal No");
            element.add('employee_number', PurchasesHeaderTable."Employee No");
            element.add('employee_name', PurchasesHeaderTable."Employee Name");
            element.add('currency_code', PurchasesHeaderTable."Currency Code");
            element.add('transaction_type', PurchasesHeaderTable."Transaction Type");
            element.add('transaction_specification', PurchasesHeaderTable."Transaction Specification");
            element.add('transport_method', PurchasesHeaderTable."Transport Method");
            element.add('entry_point', PurchasesHeaderTable."Entry Point");
            element.add('area', PurchasesHeaderTable."Area");

            Clear(lines);
            PurchasesLineTable.Reset();
            PurchasesLineTable.SetRange("Document No.", PurchasesHeaderTable."No.");
            if PurchasesLineTable.FindSet() then begin
                repeat
                    Clear(line);
                    line.Add('line_no', PurchasesLineTable."Line No.");
                    line.Add('expense_category', PurchasesLineTable."Expense Category");
                    line.Add('item_specification', PurchasesLineTable."Description 2");
                    line.Add('line_amount', PurchasesLineTable.Amount);
                    line.Add('quantity', PurchasesLineTable.Quantity);
                    line.Add('direct_unit_cost', PurchasesLineTable."Direct Unit Cost");
                    lines.Add(line);
                until PurchasesLineTable.Next() = 0;
                element.Add('purchase_request_lines', lines);
            end;

            outputjson.Add('purchase_request_details', element);

            outputjson.Add('fund_codes', GetDimensionValues('1', ''));
            outputjson.Add('program_codes', GetDimensionValues('2', ''));
            outputjson.Add('budget_codes', GetDimensionValues('3', ''));
            outputjson.Add('shortcut_4_codes', GetDimensionValues('4', ''));
            outputjson.Add('department_codes', GetDimensionValues('5', ''));
            outputjson.add('currencies', GetCurrencies());
            outputjson.add('strategic_focus_areas', GetStandardTexts('Focus Area'));
            outputjson.add('sub_pillars', GetStandardTexts('Sub Pillar'));
            outputjson.add('countries', GetCountryRegions('Country'));
            outputjson.add('counties', GetCountryRegions('County'));
            outputjson.add('expensecategories', GetStandardTexts('GL Category'));

            exit(format(outputjson));
        end;
        exit(Format(AddResponseHead(outputjson, false)));
    end;

    local procedure NewPurchaseRequest(RequestJson: JsonObject): Text;
    var
        OutputJson: JsonObject;
        JsonToken: JsonToken;

        StaffID: Code[50];
        DateText: Text;
        FundCode: Code[100];
        ProgramCode: Code[100];
        DepartmentCode: Code[100];
        BudgetLinesCode: Code[100];
        BudgetCategoryCode: Code[100];
        Currency: Code[100];
        RequiredDate: Date;
    begin

        RequestJson.Get('employee_number', JsonToken);
        StaffID := JsonToken.AsValue().AsText();
        if RequestJson.Get('date_required', JsonToken) then begin
            DateText := JsonToken.AsValue().AsText();
            if DateText <> '' then
                Evaluate(RequiredDate, DateText, 9);
        end;
        RequestJson.Get('fund_code', JsonToken);
        FundCode := JsonToken.AsValue().AsText();
        RequestJson.Get('program_code', JsonToken);
        ProgramCode := JsonToken.AsValue().AsText();
        RequestJson.Get('department_code', JsonToken);
        DepartmentCode := JsonToken.AsValue().AsText();
        RequestJson.Get('budget_lines_code', JsonToken);
        BudgetLinesCode := JsonToken.AsValue().AsText();
        RequestJson.Get('budget_category_code', JsonToken);
        BudgetCategoryCode := JsonToken.AsValue().AsText();
        RequestJson.Get('currency_code', JsonToken);
        Currency := JsonToken.AsValue().AsText();

        EmployeeTable.Reset();
        EmployeeTable.SetRange("No.", StaffID);
        if EmployeeTable.Find('-') then begin
            PurchasesandPayablesSetup.Get();
            PurchasesHeaderTable.Init();
            PurchasesHeaderTable."No." := NumberSeries.GetNextNo(PurchasesandPayablesSetup."Requisition Nos.", Today, true);
            PurchasesHeaderTable."Employee No" := StaffID;
            PurchasesHeaderTable.Validate("Employee No");
            // PurchasesHeaderTable."Document Type" := PurchasesHeaderTable."Document Type"::Quote;
            PurchasesHeaderTable."Doc Type" := PurchasesHeaderTable."Doc Type"::PurchReq;
            PurchasesHeaderTable.PR := true;
            PurchasesHeaderTable.Requisition := true;
            PurchasesHeaderTable.DocApprovalType := PurchasesHeaderTable.DocApprovalType::Requisition;
            PurchasesHeaderTable."Requested Receipt Date" := Today;
            PurchasesHeaderTable."Shortcut Dimension 1 Code" := FundCode;
            PurchasesHeaderTable."Shortcut Dimension 2 Code" := ProgramCode;
            PurchasesHeaderTable."Shortcut Dimension 3 Code" := BudgetLinesCode;
            PurchasesHeaderTable."Shortcut Dimension 4 Code" := BudgetCategoryCode;
            PurchasesHeaderTable."Shortcut Dimension 5 Code" := DepartmentCode;
            PurchasesHeaderTable."Expected Receipt Date" := RequiredDate;
            PurchasesHeaderTable.Status := PurchasesHeaderTable.Status::Open;
            PurchasesHeaderTable."Account No" := EmployeeTable.Travelaccountno;
            PurchasesHeaderTable."Account Name" := EmployeeTable.FullName();
            PurchasesHeaderTable."Responsibility Center" := EmployeeTable."User ID";
            PurchasesHeaderTable."Assigned User ID" := EmployeeTable."User ID";
            PurchasesHeaderTable."User ID" := EmployeeTable."User ID";
            PurchasesHeaderTable."Requested Receipt Date" := Today;
            PurchasesHeaderTable."Buy-from Vendor No." := 'FM-V00123';
            PurchasesHeaderTable."Vendor Posting Group" := 'TRADERS';
            PurchasesHeaderTable."Currency Code" := Currency;
            PurchasesHeaderTable."Currency Factor" := 1;
            PurchasesHeaderTable.Validate("Currency Code");

            if (PurchasesHeaderTable.Insert(true) = true) then
                exit(Format(AddResponseHead(OutputJson, true)));
        end;
        exit(format(AddResponseHead(outputjson, false)));

    end;

    local procedure AmendPurchaseRequest(RequestJson: JsonObject): Text;
    var
        OutputJson: JsonObject;
        JsonToken: JsonToken;

        RequestNumber: code[50];
        DateText: Text;
        FundCode: Code[100];
        ProgramCode: Code[100];
        DepartmentCode: Code[100];
        BudgetLinesCode: Code[100];
        BudgetCategoryCode: Code[100];
        RequiredDate: Date;
    begin

        if RequestJson.Get('date_required', JsonToken) then begin
            DateText := JsonToken.AsValue().AsText();
            if DateText <> '' then
                Evaluate(RequiredDate, DateText, 9);
        end;
        RequestJson.Get('number', JsonToken);
        RequestNumber := JsonToken.AsValue().AsText();
        RequestJson.Get('fund_code', JsonToken);
        FundCode := JsonToken.AsValue().AsText();
        RequestJson.Get('program_code', JsonToken);
        ProgramCode := JsonToken.AsValue().AsText();
        RequestJson.Get('department_code', JsonToken);
        DepartmentCode := JsonToken.AsValue().AsText();
        RequestJson.Get('budget_lines_code', JsonToken);
        BudgetLinesCode := JsonToken.AsValue().AsText();
        RequestJson.Get('budget_category_code', JsonToken);
        BudgetCategoryCode := JsonToken.AsValue().AsText();

        PurchasesHeaderTable.Reset();
        PurchasesHeaderTable.SetRange("No.", RequestNumber);
        if PurchasesHeaderTable.Find('-') then begin
            PurchasesHeaderTable."Shortcut Dimension 1 Code" := FundCode;
            PurchasesHeaderTable."Shortcut Dimension 2 Code" := ProgramCode;
            PurchasesHeaderTable."Shortcut Dimension 3 Code" := BudgetLinesCode;
            PurchasesHeaderTable."Shortcut Dimension 4 Code" := BudgetCategoryCode;
            PurchasesHeaderTable."Shortcut Dimension 5 Code" := DepartmentCode;
            PurchasesHeaderTable."Expected Receipt Date" := RequiredDate;
            PurchasesHeaderTable."Buy-from Vendor No." := 'FM-V00123';
            PurchasesHeaderTable."Vendor Posting Group" := 'TRADERS';

            if (PurchasesHeaderTable.Modify(true) = true) then
                exit(Format(AddResponseHead(OutputJson, true)));
        end;
        exit(format(AddResponseHead(outputjson, false)));

    end;

    local procedure GetPaymentMemos(employeeid: Text; Identifier: Text): Text
    var
        OutputJson: JsonObject;
        DataJson: JsonObject;

        purchaserequisition: JsonObject;
        purchaserequisitions: JsonArray;
    begin
        if (employeeid <> '') then begin
            EmployeeTable.Reset();
            if (Identifier = 'EMAIL') then
                EmployeeTable.SetRange("Company E-Mail", employeeid);
            if (Identifier = 'NUMBER') then
                EmployeeTable.SetRange("No.", employeeid);
            if EmployeeTable.FindFirst() then begin
                PurchasesHeaderTable.Reset();
                PurchasesHeaderTable.SetAscending("No.", false);
                PurchasesHeaderTable.SetRange("Employee No", EmployeeTable."No.");
                PurchasesHeaderTable.SetRange(PM, true);
                if PurchasesHeaderTable.FindSet() then begin
                    Clear(OutputJson);
                    Clear(purchaserequisitions);
                    OutputJson := AddResponseHead(OutputJson, true);
                    repeat
                        PurchasesHeaderTable.CalcFields(Amount);
                        Clear(purchaserequisition);
                        purchaserequisition.add('number', PurchasesHeaderTable."No.");
                        purchaserequisition.add('status', Format(PurchasesHeaderTable.Status));
                        purchaserequisition.add('employee_name', PurchasesHeaderTable."Employee Name");
                        purchaserequisition.add('subject_or_ref', PurchasesHeaderTable."Your Reference");
                        purchaserequisition.add('date', PurchasesHeaderTable."Document Date");
                        purchaserequisition.add('amount', PurchasesHeaderTable.Amount);
                        purchaserequisitions.add(purchaserequisition);
                    until PurchasesHeaderTable.Next() = 0;
                    OutputJson.Add('payment_memos', purchaserequisitions);
                    exit(Format(OutputJson));
                end;
            end;
        end;
        exit(Format(AddResponseHead(OutputJson, false)));
    end;

    local procedure GetPaymentMemoDetails(requestnumber: code[50]): Text
    var
        outputjson: JsonObject;
        element: JsonObject;
        line: JsonObject;
        lines: JsonArray;

        EmployeeNumber: Code[20];
    begin
        PurchasesHeaderTable.Reset();
        PurchasesHeaderTable.SetRange("No.", requestnumber);
        if PurchasesHeaderTable.Find('-') then begin
            EmployeeNumber := PurchasesHeaderTable."Employee No";
            outputjson := AddResponseHead(outputjson, true);

            element.add('number', PurchasesHeaderTable."No.");
            element.add('employee_number', PurchasesHeaderTable."Employee No");
            element.add('employee_name', PurchasesHeaderTable."Employee Name");
            element.add('subject_or_ref', PurchasesHeaderTable."Your Reference");
            element.add('date', PurchasesHeaderTable."Document Date");
            element.add('purchase_requisition_number', PurchasesHeaderTable."Requisition No");
            element.add('mission_proposal_number', PurchasesHeaderTable."Mission Proposal No");
            element.add('narration', PurchasesHeaderTable.Background);
            element.add('amount', PurchasesHeaderTable.Amount);
            element.add('fund_code', PurchasesHeaderTable."Shortcut Dimension 1 Code");
            element.add('program_code', PurchasesHeaderTable."Shortcut Dimension 2 Code");
            element.add('budget_lines_code', PurchasesHeaderTable."Shortcut Dimension 3 Code");
            element.add('budget_category_code', PurchasesHeaderTable."Shortcut Dimension 4 Code");
            element.add('department_code', PurchasesHeaderTable."Shortcut Dimension 5 Code");
            element.add('status', Format(PurchasesHeaderTable.Status));

            outputjson.Add('payment_memo_details', element);



            outputjson.Add('fund_codes', GetDimensionValues('1', ''));
            outputjson.Add('program_codes', GetDimensionValues('2', ''));
            outputjson.Add('budget_codes', GetDimensionValues('3', ''));
            outputjson.Add('shortcut_4_codes', GetDimensionValues('4', ''));
            outputjson.Add('department_codes', GetDimensionValues('5', ''));
            outputjson.add('currencies', GetCurrencies());
            outputjson.add('strategic_focus_areas', GetStandardTexts('Focus Area'));
            outputjson.add('sub_pillars', GetStandardTexts('Sub Pillar'));
            outputjson.add('countries', GetCountryRegions('Country'));
            outputjson.add('counties', GetCountryRegions('County'));
            outputjson.add('expensecategories', GetStandardTexts('GL Category'));

            exit(format(outputjson));
        end;
        exit(Format(AddResponseHead(outputjson, false)));
    end;

    local procedure GetTimeSheetDetails(requestnumber: code[50]): Text
    var
        outputjson: JsonObject;
        element: JsonObject;
        line: JsonObject;
        lines: JsonArray;

        EmployeeNumber: Code[20];
    begin
        TimesheetTable.Reset();
        TimesheetTable.SetRange(Timesheetcode, requestnumber);
        if TimesheetTable.Find('-') then begin
            outputjson := AddResponseHead(outputjson, true);
            Clear(element);
            element.add('document_no', TimesheetTable.Timesheetcode);
            element.add('employee_no', TimesheetTable."Employee No");
            element.add('status', Format(TimesheetTable.Status));
            element.add('employee_name', Format(TimesheetTable."Employee Name"));
            element.add('from_date', TimesheetTable.From);
            element.add('to_date', TimesheetTable."To Date");
            element.add('hours', TimesheetTable.hours);

            Clear(lines);
            TimeSheetLinesTable.Reset();
            TimeSheetLinesTable.SetRange("Document No.", TimesheetTable.Timesheetcode);
            if TimeSheetLinesTable.FindSet() then begin
                repeat
                    Clear(line);
                    line.Add('line_no', TimeSheetLinesTable.Entry);
                    line.Add('document_no', TimeSheetLinesTable."Document No.");
                    line.Add('date', TimeSheetLinesTable.Date);
                    line.Add('project_code', TimeSheetLinesTable."Global Dimension 1 Code");
                    line.Add('hours_worked', TimeSheetLinesTable.Hours);
                    line.Add('narration', TimeSheetLinesTable.Narration);
                    lines.Add(line);
                until TimeSheetLinesTable.Next() = 0;
            end;

            element.Add('lines', lines);

            outputjson.Add('timesheet_details', element);
            outputjson.Add('project_codes', GetTimeSheetDimensionValues());

            exit(format(outputjson));
        end;
        exit(Format(AddResponseHead(outputjson, false)));
    end;

    local procedure PaymentMemoElements(employeenumber: code[20]): Text
    var
        OutputJson: JsonObject;
        line: JsonObject;
        lines: JsonArray;
    begin
        OutputJson := AddResponseHead(OutputJson, true);
        outputjson.Add('fund_codes', GetDimensionValues('1', ''));
        outputjson.Add('program_codes', GetDimensionValues('2', ''));
        outputjson.Add('budget_codes', GetDimensionValues('3', ''));
        outputjson.Add('shortcut_4_codes', GetDimensionValues('4', ''));
        outputjson.Add('department_codes', GetDimensionValues('5', ''));
        outputjson.add('currencies', GetCurrencies());
        outputjson.add('strategic_focus_areas', GetStandardTexts('Focus Area'));
        outputjson.add('sub_pillars', GetStandardTexts('Sub Pillar'));
        outputjson.add('countries', GetCountryRegions('Country'));
        outputjson.add('counties', GetCountryRegions('County'));
        outputjson.add('expensecategories', GetStandardTexts('GL Category'));
        outputjson.Add('gl_accounts', GetGLAccounts('5'));

        PurchasesHeaderTable.Reset();
        PurchasesHeaderTable.SetRange("Employee No", EmployeeNumber);
        PurchasesHeaderTable.SetRange(PR, true);
        if PurchasesHeaderTable.Findset() then begin
            Clear(lines);
            repeat
                Clear(line);
                line.Add('Code', PurchasesHeaderTable."No.");
                line.Add('Name', Format(PurchasesHeaderTable.Amount));
                lines.Add(line);
            until PurchasesHeaderTable.Next() = 0;
        end;
        OutputJson.Add('purchase_requests_list', lines);

        PurchasesHeaderTable.Reset();
        PurchasesHeaderTable.SetRange("Employee No", EmployeeNumber);
        PurchasesHeaderTable.SetRange(MP, true);
        if PurchasesHeaderTable.Findset() then begin
            Clear(lines);
            repeat
                Clear(line);
                line.Add('Code', PurchasesHeaderTable."No.");
                line.Add('Name', Format(PurchasesHeaderTable.Amount));
                lines.Add(line);
            until PurchasesHeaderTable.Next() = 0;
        end;
        OutputJson.Add('mission_proposals_list', lines);

        exit(format(OutputJson));
    end;

    local procedure NewPaymentMemo(RequestJson: JsonObject): Text;
    var
        OutputJson: JsonObject;
        JsonToken: JsonToken;

        NewNo: code[50];

        StaffID: Code[50];
        SubjectRef: Text;
        DateText: Text;
        Narration: Text;
        PRNumber: Code[50];
        MissionNumber: Code[50];
        FundCode: Code[100];
        ProgramCode: Code[100];
        DepartmentCode: Code[100];
        BudgetLinesCode: Code[100];
        BudgetCategoryCode: Code[100];
        Date: Date;
        optiontype: option;
    begin

        RequestJson.Get('employee_number', JsonToken);
        StaffID := JsonToken.AsValue().AsText();
        if RequestJson.Get('purchase_requisition_number', JsonToken) and not JsonToken.AsValue().IsNull() then
            PRNumber := JsonToken.AsValue().AsText();
        if RequestJson.Get('mission_proposal_number', JsonToken) and not JsonToken.AsValue().IsNull() then
            MissionNumber := JsonToken.AsValue().AsText();
        RequestJson.Get('narration', JsonToken);
        Narration := JsonToken.AsValue().AsText();
        RequestJson.Get('subject_or_ref', JsonToken);
        SubjectRef := JsonToken.AsValue().AsText();
        if RequestJson.Get('date', JsonToken) then begin
            DateText := JsonToken.AsValue().AsText();
            if DateText <> '' then
                Evaluate(Date, DateText, 9);
        end;
        RequestJson.Get('fund_code', JsonToken);
        FundCode := JsonToken.AsValue().AsText();
        RequestJson.Get('program_code', JsonToken);
        ProgramCode := JsonToken.AsValue().AsText();
        RequestJson.Get('department_code', JsonToken);
        DepartmentCode := JsonToken.AsValue().AsText();
        RequestJson.Get('budget_lines_code', JsonToken);
        BudgetLinesCode := JsonToken.AsValue().AsText();
        RequestJson.Get('budget_category_code', JsonToken);
        BudgetCategoryCode := JsonToken.AsValue().AsText();

        EmployeeTable.Reset();
        EmployeeTable.SetRange("No.", StaffID);
        if EmployeeTable.Find('-') then begin
            PurchasesandPayablesSetup.Get();
            PurchasesHeaderTable.Init();
            NewNo := NumberSeries.GetNextNo(PurchasesandPayablesSetup."Payment Memo Nos.", Today, true);
            PurchasesHeaderTable."No." := NewNo;
            PurchasesHeaderTable."Document Type" := PurchasesHeaderTable."Document Type"::Quote;
            PurchasesHeaderTable."Doc Type" := optiontype;
            PurchasesHeaderTable.PM := true;
            PurchasesHeaderTable."Requested Receipt Date" := Today;
            PurchasesHeaderTable.Status := PurchasesHeaderTable.Status::Open;
            PurchasesHeaderTable."Responsibility Center" := EmployeeTable."User ID";
            PurchasesHeaderTable."Assigned User ID" := EmployeeTable."User ID";
            PurchasesHeaderTable."User ID" := EmployeeTable."User ID";
            PurchasesHeaderTable."Employee No" := StaffID;
            PurchasesHeaderTable.Validate("Employee No");
            PurchasesHeaderTable."Your Reference" := SubjectRef;
            PurchasesHeaderTable."Document Date" := Date;
            PurchasesHeaderTable."Requisition No" := PRNumber;
            PurchasesHeaderTable."Mission Proposal No" := MissionNumber;
            PurchasesHeaderTable.Background := Narration;
            PurchasesHeaderTable."Shortcut Dimension 1 Code" := FundCode;
            PurchasesHeaderTable."Shortcut Dimension 2 Code" := ProgramCode;
            PurchasesHeaderTable."Shortcut Dimension 3 Code" := BudgetLinesCode;
            PurchasesHeaderTable."Shortcut Dimension 4 Code" := BudgetCategoryCode;
            PurchasesHeaderTable."Shortcut Dimension 5 Code" := DepartmentCode;
            PurchasesHeaderTable."Recalculate Invoice Disc." := true;
            // PurchasesHeaderTable."Account No" := EmployeeTable.Travelaccountno;
            PurchasesHeaderTable."Buy-from Vendor No." := 'FM-V00123';
            PurchasesHeaderTable."Vendor Posting Group" := 'TRADERS';

            if (PurchasesHeaderTable.Insert(true) = true) then begin

                PurchasesHeaderTable.Validate("Requisition No");
                // PurchasesLineTable.Init();
                // PurchasesLineTable."Document No." := NewNo;
                // PurchasesLineTable.Insert(true);
                exit(Format(AddResponseHead(OutputJson, true)));
            end;
        end;
        exit(format(AddResponseHead(outputjson, false)));

    end;

    local procedure NewTimeSheet(RequestJson: JsonObject): Text;
    var
        OutputJson: JsonObject;
        JsonToken: JsonToken;

        NewNo: code[50];

        StaffID: Code[50];
        DateText: Text;
        FromDate: Date;
        ToDate: Date;

        GenSetup: Record "Resources Setup";
    begin
        RequestJson.Get('employee_no', JsonToken);
        StaffID := JsonToken.AsValue().AsText();
        if RequestJson.Get('from_date', JsonToken) then begin
            DateText := JsonToken.AsValue().AsText();
            if DateText <> '' then
                Evaluate(FromDate, DateText, 9);
        end;
        if RequestJson.Get('to_date', JsonToken) then begin
            DateText := JsonToken.AsValue().AsText();
            if DateText <> '' then
                Evaluate(ToDate, DateText, 9);
        end;

        EmployeeTable.Reset();
        EmployeeTable.SetRange("No.", StaffID);
        if EmployeeTable.Find('-') then begin
            TimesheetTable.Init();
            TimesheetTable."Employee No" := EmployeeTable."No.";
            TimesheetTable."Employee Name" := EmployeeTable.FullName();
            TimesheetTable.From := FromDate;
            TimesheetTable."To Date" := ToDate;
            if TimesheetTable.Insert(true) then
                exit(Format(AddResponseHead(OutputJson, true)));
        end;
        exit(Format(AddResponseHead(OutputJson, false)));
    end;

    local procedure AmendTimeSheet(RequestJson: JsonObject): Text;
    var
        OutputJson: JsonObject;
        JsonToken: JsonToken;

        NewNo: code[50];

        RequestNumber: Code[50];
        DateText: Text;
        FromDate: Date;
        ToDate: Date;
    begin
        RequestJson.Get('document_no', JsonToken);
        RequestNumber := JsonToken.AsValue().AsText();
        if RequestJson.Get('from_date', JsonToken) then begin
            DateText := JsonToken.AsValue().AsText();
            if DateText <> '' then
                Evaluate(FromDate, DateText, 9);
        end;
        if RequestJson.Get('to_date', JsonToken) then begin
            DateText := JsonToken.AsValue().AsText();
            if DateText <> '' then
                Evaluate(ToDate, DateText, 9);
        end;

        TimesheetTable.Reset();
        TimesheetTable.SetRange(Timesheetcode, RequestNumber);
        if TimesheetTable.find('-') then begin
            TimesheetTable.From := FromDate;
            TimesheetTable."To Date" := ToDate;
            if TimesheetTable.Modify(true) then
                exit(Format(AddResponseHead(OutputJson, true)));
        end;
        exit(Format(AddResponseHead(OutputJson, false)));
    end;

    local procedure AmendTimeSheetLines(RequestJson: JsonObject): Text;
    var
        OutputJson: JsonObject;
        JsonToken: JsonToken;

        NewNo: code[50];

        RequestNumber: Code[50];
        DateText: Text;
        LineDate: Date;

        Lines: JsonArray;
        Line: JsonObject;

        LineNo: Integer;
        Hours: Integer;

        Narration: Text;
        FundCode: code[20];
    begin
        RequestJson.Get('document_no', JsonToken);
        RequestNumber := JsonToken.AsValue().AsText();

        RequestJson.Get('lines', JsonToken);
        Lines := JsonToken.AsArray();
        if Lines.Count() > 0 then begin
            foreach JsonToken in Lines do begin
                if JsonToken.IsObject() then begin
                    Line := JsonToken.AsObject();
                    if Line.Get('line_no', JsonToken) and not JsonToken.AsValue().IsNull() then
                        LineNo := JsonToken.AsValue().AsInteger();

                    if Line.Get('date', JsonToken) and not JsonToken.AsValue().IsNull() then begin
                        DateText := JsonToken.AsValue().AsText();
                        if DateText <> '' then
                            Evaluate(LineDate, DateText, 9);
                    end;

                    if Line.Get('narration', JsonToken) and not JsonToken.AsValue().IsNull() then
                        Narration := JsonToken.AsValue().AsText();
                    if Line.Get('project_code', JsonToken) and not JsonToken.AsValue().IsNull() then
                        FundCode := JsonToken.AsValue().AsText();
                    if Line.Get('hours_worked', JsonToken) and not JsonToken.AsValue().IsNull() then
                        Hours := JsonToken.AsValue().AsInteger();
                    if TimesheetTable.Get(RequestNumber) then begin
                        TimeSheetLinesTable.Reset();
                        TimeSheetLinesTable.SetRange("Document No.", TimesheetTable.Timesheetcode);
                        TimeSheetLinesTable.SetRange(Entry, LineNo);
                        if TimeSheetLinesTable.Find('-') then begin
                            TimeSheetLinesTable."Global Dimension 1 Code" := FundCode;
                            TimeSheetLinesTable.Date := LineDate;
                            TimeSheetLinesTable."Employee No" := TimesheetTable."Employee No";
                            TimeSheetLinesTable."Employee Name" := TimesheetTable."Employee Name";
                            TimeSheetLinesTable.Narration := Narration;
                            TimeSheetLinesTable.Hours := Hours;
                            TimeSheetLinesTable.Modify(true);
                            TimesheetTable.GetTotalHours();
                            TimesheetTable.Modify();
                        end else begin
                            LineNo := TimeSheetLinesTable.GetNextEntryNo();
                            TimeSheetLinesTable.Init();
                            TimeSheetLinesTable.Entry := LineNo;
                            TimeSheetLinesTable."Document No." := TimesheetTable.Timesheetcode;
                            TimeSheetLinesTable."Global Dimension 1 Code" := FundCode;
                            TimeSheetLinesTable.Date := LineDate;
                            TimeSheetLinesTable."Employee No" := TimesheetTable."Employee No";
                            TimeSheetLinesTable."Employee Name" := TimesheetTable."Employee Name";
                            TimeSheetLinesTable.Narration := Narration;
                            TimeSheetLinesTable.Hours := Hours;
                            TimeSheetLinesTable.Insert(true);
                            TimesheetTable.GetTotalHours();
                            TimesheetTable.Modify();
                        end;
                    end;

                    exit(Format(AddResponseHead(OutputJson, true)));
                end;
            end;
        end;
    end;

    // local procedure GetTotalHours(Number: code[20])
    // var
    //     Hours: Integer;
    // begin
    //     TimesheetTable.Get(Number);
    //     TimeSheetLinesTable.Reset();
    //     TimeSheetLinesTable.SetRange("Document No.", Number);
    //     if TimeSheetLinesTable.FindSet() then begin
    //         repeat
    //             if TimeSheetLinesTable.Hours > 0 then
    //                 Hours += TimeSheetLinesTable.Hours;
    //         until TimeSheetLinesTable.Next() = 0;
    //     end;
    //     TimesheetTable.hours := hours;
    //     TimesheetTable.Modify();
    // end;

    local procedure AmendPaymentMemo(RequestJson: JsonObject): Text;
    var
        OutputJson: JsonObject;
        JsonToken: JsonToken;

        RequestNumber: code[50];

        SubjectRef: Text;
        DateText: Text;
        Narration: Text;
        FundCode: Code[100];
        ProgramCode: Code[100];
        DepartmentCode: Code[100];
        BudgetLinesCode: Code[100];
        BudgetCategoryCode: Code[100];
        PRNumber: Code[100];
        MissionNumber: Code[100];
        Date: Date;

        optiontype: option;
    begin

        RequestJson.Get('number', JsonToken);
        RequestNumber := JsonToken.AsValue().AsText();
        RequestJson.Get('narration', JsonToken);
        Narration := JsonToken.AsValue().AsText();
        RequestJson.Get('subject_or_ref', JsonToken);
        SubjectRef := JsonToken.AsValue().AsText();
        if RequestJson.Get('purchase_requisition_number', JsonToken) and not JsonToken.AsValue().IsNull then
            PRNumber := JsonToken.AsValue().AsText();
        if RequestJson.Get('mission_proposal_number', JsonToken) and not JsonToken.AsValue().IsNull then
            MissionNumber := JsonToken.AsValue().AsText();
        if RequestJson.Get('date', JsonToken) then begin
            DateText := JsonToken.AsValue().AsText();
            if DateText <> '' then
                Evaluate(Date, DateText, 9);
        end;
        RequestJson.Get('fund_code', JsonToken);
        FundCode := JsonToken.AsValue().AsText();
        RequestJson.Get('program_code', JsonToken);
        ProgramCode := JsonToken.AsValue().AsText();
        RequestJson.Get('department_code', JsonToken);
        DepartmentCode := JsonToken.AsValue().AsText();
        RequestJson.Get('budget_lines_code', JsonToken);
        BudgetLinesCode := JsonToken.AsValue().AsText();
        RequestJson.Get('budget_category_code', JsonToken);
        BudgetCategoryCode := JsonToken.AsValue().AsText();

        PurchasesHeaderTable.Reset();
        PurchasesHeaderTable.SetRange("No.", RequestNumber);
        if PurchasesHeaderTable.Find('-') then begin
            PurchasesHeaderTable."Doc Type" := optiontype;
            PurchasesHeaderTable."Recalculate Invoice Disc." := true;
            PurchasesHeaderTable."Your Reference" := SubjectRef;
            PurchasesHeaderTable."Document Date" := Date;
            PurchasesHeaderTable.Background := Narration;
            PurchasesHeaderTable."Requisition No" := PRNumber;
            PurchasesHeaderTable.Validate("Requisition No");
            PurchasesHeaderTable."Mission Proposal No" := MissionNumber;
            PurchasesHeaderTable."Shortcut Dimension 1 Code" := FundCode;
            PurchasesHeaderTable."Shortcut Dimension 2 Code" := ProgramCode;
            PurchasesHeaderTable."Shortcut Dimension 3 Code" := BudgetLinesCode;
            PurchasesHeaderTable."Shortcut Dimension 4 Code" := BudgetCategoryCode;
            PurchasesHeaderTable."Shortcut Dimension 5 Code" := DepartmentCode;

            if PurchasesHeaderTable.Modify(true) then begin
                exit(Format(AddResponseHead(OutputJson, true)));
            end;
        end;
        exit(format(AddResponseHead(outputjson, false)));

    end;

    local procedure GetImprestRequests(employeeid: Text; Identifier: Text): Text
    var
        OutputJson: JsonObject;
        DataJson: JsonObject;

        element: JsonObject;
        elements: JsonArray;
    begin
        if (employeeid <> '') then begin
            EmployeeTable.Reset();
            if (Identifier = 'EMAIL') then
                EmployeeTable.SetRange("Company E-Mail", employeeid);
            if (Identifier = 'NUMBER') then
                EmployeeTable.SetRange("No.", employeeid);
            if EmployeeTable.FindFirst() then begin
                PurchasesHeaderTable.Reset();
                PurchasesHeaderTable.SetAscending("No.", false);
                PurchasesHeaderTable.SetRange("Employee No", EmployeeTable."No.");
                PurchasesHeaderTable.SetRange("Document Type", PurchasesHeaderTable."Document Type"::Quote);
                PurchasesHeaderTable.SetRange(IM, true);
                if PurchasesHeaderTable.FindSet() then begin
                    Clear(OutputJson);
                    Clear(elements);
                    OutputJson := AddResponseHead(OutputJson, true);
                    repeat
                        PurchasesHeaderTable.CalcFields(Amount);
                        Clear(element);
                        element.add('imprest_number', PurchasesHeaderTable."No.");
                        element.add('status', Format(PurchasesHeaderTable.Status));
                        element.add('employee_name', Format(PurchasesHeaderTable."Employee Name"));
                        element.add('purpose', PurchasesHeaderTable."Posting Description");
                        element.add('imprest_amount', PurchasesHeaderTable.Amount);
                        elements.add(element);
                    until PurchasesHeaderTable.Next() = 0;
                    OutputJson.Add('imprest_requests', elements);
                    exit(Format(OutputJson));
                end;
            end;
        end;
        exit(Format(AddResponseHead(OutputJson, false)));
    end;

    local procedure GetImprestRequestDetails(requestnumber: code[50]): Text
    var
        outputjson: JsonObject;
        element: JsonObject;
        line: JsonObject;
        lines: JsonArray;

        ImprestAmount: Decimal;
    begin
        PurchasesHeaderTable.Reset();
        PurchasesHeaderTable.SetRange("No.", requestnumber);
        if PurchasesHeaderTable.Find('-') then begin
            outputjson := AddResponseHead(outputjson, true);

            element.add('request_number', requestnumber);
            element.add('imprest_number', PurchasesHeaderTable."Imprest No");
            element.add('mission_proposal_no', PurchasesHeaderTable."Mission Proposal No");
            element.add('posting_date', PurchasesHeaderTable."Posting Date");
            element.add('purpose', PurchasesHeaderTable."Posting Description");
            element.add('fund_code', PurchasesHeaderTable."Shortcut Dimension 1 Code");
            element.add('program_code', PurchasesHeaderTable."Shortcut Dimension 2 Code");
            element.add('budget_code', PurchasesHeaderTable."Shortcut Dimension 3 Code");
            element.add('shortcut_4', PurchasesHeaderTable."Shortcut Dimension 4 Code");
            element.add('department_code', PurchasesHeaderTable."Shortcut Dimension 5 Code");
            element.add('status', Format(PurchasesHeaderTable.Status));
            element.add('employee_id', Format(PurchasesHeaderTable."Employee No"));
            element.add('employee_name', Format(PurchasesHeaderTable."Employee Name"));
            // element.add('mission_proposal_no', Format(PurchasesHeaderTable."Mission Proposal No"));
            ImprestAmount := 0;
            Clear(lines);

            PurchasesLineTable.Reset();
            PurchasesLineTable.SetRange("Document No.", PurchasesHeaderTable."No.");
            if PurchasesLineTable.FindSet() then begin
                repeat
                    Clear(line);
                    line.Add('transaction_type', Format(PurchasesLineTable."Expense Category"));
                    line.Add('line_no', PurchasesLineTable."Line No.");
                    line.Add('account_no', PurchasesLineTable."No.");
                    line.Add('expense_category', PurchasesLineTable."Expense Category");
                    line.Add('description', PurchasesLineTable.Description);
                    line.Add('item_specification', PurchasesLineTable."Description 2");
                    line.Add('quantity', PurchasesLineTable.Quantity);
                    line.Add('currency_code', PurchasesLineTable."Currency Code");
                    line.Add('unit_cost', PurchasesLineTable."Direct Unit Cost");
                    line.Add('amount', PurchasesLineTable."Line Amount");
                    line.Add('amount_spent', PurchasesLineTable."Amount Spent");
                    lines.Add(line);
                    ImprestAmount += PurchasesLineTable."Line Amount";
                    PurchasesLineTable.Amount := PurchasesLineTable."Line Amount";
                    PurchasesLineTable.Modify();
                until PurchasesLineTable.Next() = 0;
                element.Add('impres_request_lines', lines);
            end;
            element.add('imprest_amount', ImprestAmount);
            outputjson.Add('imprest_request', element);

            outputjson.Add('fund_codes', GetDimensionValues('1', ''));
            outputjson.Add('program_codes', GetDimensionValues('2', ''));
            outputjson.Add('budget_codes', GetDimensionValues('3', ''));
            outputjson.Add('shortcut_4_codes', GetDimensionValues('4', ''));
            outputjson.Add('department_codes', GetDimensionValues('5', ''));
            outputjson.Add('gl_accounts', GetGLAccounts('5'));
            outputjson.add('currencies', GetCurrencies());
            outputjson.add('expensecategories', GetStandardTexts('GL Category'));
            exit(format(outputjson));
        end;
        exit(Format(AddResponseHead(outputjson, false)));
    end;

    local procedure NewImprestRequest(RequestJson: JsonObject): Text;
    var
        OutputJson: JsonObject;
        JsonToken: JsonToken;

        StaffID: Code[50];
        Purpose: Text;
        FundCode: Code[100];
        ProgramCode: Code[100];
        DepartmentCode: Code[100];
        BudgetCode: Code[100];
        BudgetCategoryCode: Code[100];
        Currency: Code[100];

        ChangeExchangeRate: page "Change Exchange Rate";
        optiontype: option;
        DimMgt: Codeunit DimensionManagement;
        NextNo: code[20];
    begin

        RequestJson.Get('employee_id', JsonToken);
        StaffID := JsonToken.AsValue().AsText();
        RequestJson.Get('purpose', JsonToken);
        Purpose := JsonToken.AsValue().AsText();
        RequestJson.Get('fund_code', JsonToken);
        FundCode := JsonToken.AsValue().AsText();
        RequestJson.Get('program_code', JsonToken);
        ProgramCode := JsonToken.AsValue().AsText();
        RequestJson.Get('department_code', JsonToken);
        DepartmentCode := JsonToken.AsValue().AsText();
        RequestJson.Get('budget_code', JsonToken);
        BudgetCode := JsonToken.AsValue().AsText();
        RequestJson.Get('shortcut_4', JsonToken);
        BudgetCategoryCode := JsonToken.AsValue().AsText();
        // RequestJson.Get('currency_code', JsonToken);
        // Currency := JsonToken.AsValue().AsText();

        EmployeeTable.Reset();
        EmployeeTable.SetRange("No.", StaffID);
        if EmployeeTable.Find('-') then begin
            PurchasesandPayablesSetup.Get();
            PurchasesHeaderTable.Init();
            NextNo := NumberSeries.GetNextNo(PurchasesandPayablesSetup."Imprest Nos.", Today, true);
            PurchasesHeaderTable."No." := NextNo;
            PurchasesHeaderTable.Completed := false;
            PurchasesHeaderTable.Archived := false;
            PurchasesHeaderTable."Currency Code" := '';
            PurchasesHeaderTable.Status := PurchasesHeaderTable.Status::Open;
            PurchasesHeaderTable."Document Type" := PurchasesHeaderTable."Document Type"::Quote;
            PurchasesHeaderTable."Doc Type" := optiontype;
            PurchasesHeaderTable.IM := true;
            PurchasesHeaderTable."Posting Date" := Today;
            PurchasesHeaderTable."Requested Receipt Date" := Today;
            PurchasesHeaderTable."Buy-from Vendor No." := 'FM-V00123';
            PurchasesHeaderTable."Vendor Posting Group" := 'TRADERS';
            PurchasesHeaderTable.Validate("Dimension Set ID");
            PurchasesHeaderTable."Employee No" := StaffID;
            PurchasesHeaderTable.Validate("Employee No");
            PurchasesHeaderTable."Posting Description" := Purpose;
            PurchasesHeaderTable."Shortcut Dimension 1 Code" := FundCode;
            PurchasesHeaderTable."Shortcut Dimension 2 Code" := ProgramCode;
            PurchasesHeaderTable."Shortcut Dimension 3 Code" := BudgetCode;
            PurchasesHeaderTable."Shortcut Dimension 4 Code" := BudgetCategoryCode;
            PurchasesHeaderTable."Shortcut Dimension 5 Code" := DepartmentCode;
            PurchasesHeaderTable."Account No" := EmployeeTable.Travelaccountno;
            PurchasesHeaderTable."Responsibility Center" := EmployeeTable."User ID";
            PurchasesHeaderTable."Assigned User ID" := EmployeeTable."User ID";
            PurchasesHeaderTable."User ID" := EmployeeTable."User ID";

            if (PurchasesHeaderTable.Insert() = true) then
                exit(Format(AddResponseHead(OutputJson, true)));

        end;
        exit(format(AddResponseHead(outputjson, false)));

    end;

    local procedure AmendImprestRequest(RequestJson: JsonObject): Text;
    var
        OutputJson: JsonObject;
        JsonToken: JsonToken;

        RequestNumber: Code[50];
        Purpose: Text;
        FundCode: Code[100];
        ProgramCode: Code[100];
        DepartmentCode: Code[100];
        BudgetCode: Code[100];
        BudgetCategoryCode: Code[100];
    begin

        RequestJson.Get('request_number', JsonToken);
        RequestNumber := JsonToken.AsValue().AsText();
        RequestJson.Get('purpose', JsonToken);
        Purpose := JsonToken.AsValue().AsText();
        RequestJson.Get('fund_code', JsonToken);
        FundCode := JsonToken.AsValue().AsText();
        RequestJson.Get('program_code', JsonToken);
        ProgramCode := JsonToken.AsValue().AsText();
        RequestJson.Get('department_code', JsonToken);
        DepartmentCode := JsonToken.AsValue().AsText();
        RequestJson.Get('budget_code', JsonToken);
        BudgetCode := JsonToken.AsValue().AsText();
        RequestJson.Get('shortcut_4', JsonToken);
        BudgetCategoryCode := JsonToken.AsValue().AsText();

        PurchasesHeaderTable.Reset();
        PurchasesHeaderTable.SetRange("No.", RequestNumber);
        if PurchasesHeaderTable.Find('-') then begin
            PurchasesHeaderTable."Posting Description" := Purpose;
            PurchasesHeaderTable."Shortcut Dimension 1 Code" := FundCode;
            PurchasesHeaderTable."Shortcut Dimension 2 Code" := ProgramCode;
            PurchasesHeaderTable."Shortcut Dimension 3 Code" := BudgetCode;
            PurchasesHeaderTable."Shortcut Dimension 4 Code" := BudgetCategoryCode;
            PurchasesHeaderTable."Shortcut Dimension 5 Code" := DepartmentCode;

            if PurchasesHeaderTable.modify() then
                exit(Format(AddResponseHead(OutputJson, true)));
        end;
        exit(format(AddResponseHead(outputjson, false)));

    end;


    local procedure SaveImprestRequestLine(RequestJson: JsonObject): Text;
    var
        OutputJson: JsonObject;
        JsonToken: JsonToken;

        ImprestNumber: Code[50];
        LineNo: Integer;
        ExpenseCategory: Code[100];
        // GLAccount: Code[100];
        // Description: Text;
        ItemSpecification: Text;
        Quantity: Integer;
        UnitCost: Decimal;

        ImprestAmount: Decimal;
        ImprestAmountSpent: Decimal;
    begin

        RequestJson.Get('imprest_number', JsonToken);
        ImprestNumber := JsonToken.AsValue().AsText();
        RequestJson.Get('line_no', JsonToken);
        LineNo := JsonToken.AsValue().AsInteger();
        RequestJson.Get('expense_category', JsonToken);
        ExpenseCategory := JsonToken.AsValue().AsText();
        // RequestJson.Get('account_no', JsonToken);
        // GLAccount := JsonToken.AsValue().AsText();
        // RequestJson.Get('description', JsonToken);
        // Description := JsonToken.AsValue().AsText();
        RequestJson.Get('item_specification', JsonToken);
        ItemSpecification := JsonToken.AsValue().AsText();
        RequestJson.Get('quantity', JsonToken);
        Quantity := JsonToken.AsValue().AsInteger();
        RequestJson.Get('unit_cost', JsonToken);
        UnitCost := JsonToken.AsValue().AsDecimal();
        if RequestJson.Get('amount_spent', JsonToken) then
            ImprestAmountSpent := JsonToken.AsValue().AsDecimal();

        PurchasesHeaderTable.Reset();
        PurchasesHeaderTable.SetRange("No.", ImprestNumber);
        if PurchasesHeaderTable.Find('-') then begin
            PurchasesLineTable.Reset();
            PurchasesLineTable.SetRange("Line No.", LineNo);
            PurchasesLineTable.SetRange("Document No.", PurchasesHeaderTable."No.");
            if PurchasesLineTable.Find('-') then begin
                PurchasesLineTable."Expense Category" := ExpenseCategory;
                PurchasesLineTable.Validate("Expense Category");

                if PurchasesLineTable.Modify(true) then begin
                    PurchasesLineTable.Reset();
                    PurchasesLineTable.SetRange("Line No.", LineNo);
                    PurchasesLineTable.SetRange("Document No.", PurchasesHeaderTable."No.");
                    if PurchasesLineTable.Find('-') then begin
                        PurchasesLineTable."Document No." := PurchasesHeaderTable."No.";
                        PurchasesLineTable."Document Type" := PurchasesLineTable."Document Type"::Quote;
                        PurchasesLineTable."Description 2" := ItemSpecification;
                        PurchasesLineTable.Quantity := Quantity;
                        PurchasesLineTable."Direct Unit Cost" := UnitCost;
                        PurchasesLineTable."Line Amount" := Quantity * UnitCost;
                        PurchasesLineTable.Amount := Quantity * UnitCost;
                        PurchasesLineTable."Amount Spent" := ImprestAmountSpent;
                        PurchasesLineTable."Cash Refund" := (Quantity * UnitCost) - ImprestAmountSpent;
                        if PurchasesLineTable.Modify(true) then begin
                            // PurchasesLineTable.Reset();
                            // PurchasesLineTable.SetRange("Document No.", PurchasesHeaderTable."No.");
                            // if PurchasesLineTable.FindSet() then begin
                            //     PurchasesLineTable.CalcSums("Line Amount");
                            //     PurchasesHeaderTable.Amount := PurchasesLineTable."Line Amount";
                            //     PurchasesHeaderTable.Modify();
                            // end;
                            // RedistributeTotalsOnAfterValidate(PurchasesLineTable."Document Type", PurchasesLineTable."Document No.", PurchasesLineTable);
                            exit(format(AddResponseHead(outputjson, true)));
                        end;
                    end
                end;
            end else begin
                PurchasesLineTable.Reset();
                PurchasesLineTable.SetRange("Document No.", PurchasesHeaderTable."No.");
                if PurchasesLineTable.FindLast() then
                    LineNo := PurchasesLineTable."Line No." + 1000
                else
                    LineNo := 1000;
                PurchasesLineTable.Init();
                PurchasesLineTable."Line No." := LineNo;
                PurchasesLineTable."Document No." := PurchasesHeaderTable."No.";
                PurchasesLineTable."Document Type" := PurchasesLineTable."Document Type"::Quote;
                PurchasesLineTable.Type := PurchasesLineTable.Type::"G/L Account";
                PurchasesLineTable."Currency Code" := PurchasesHeaderTable."Currency Code";
                PurchasesLineTable."Direct Unit Cost" := UnitCost;
                PurchasesLineTable."Shortcut Dimension 1 Code" := PurchasesHeaderTable."Shortcut Dimension 1 Code";
                PurchasesLineTable."Shortcut Dimension 2 Code" := PurchasesHeaderTable."Shortcut Dimension 2 Code";
                PurchasesLineTable."Expense Category" := ExpenseCategory;
                PurchasesLineTable.Validate("Expense Category");
                if PurchasesLineTable.Insert(true) then begin
                    PurchasesLineTable.Reset();
                    PurchasesLineTable.SetRange("Line No.", LineNo);
                    PurchasesLineTable.SetRange("Document No.", PurchasesHeaderTable."No.");
                    if PurchasesLineTable.Find('-') then begin
                        // PurchasesLineTable."Expense Category" := ExpenseCategory;
                        PurchasesLineTable."Document No." := PurchasesHeaderTable."No.";
                        PurchasesLineTable."Description 2" := ItemSpecification;
                        PurchasesLineTable.Quantity := Quantity;
                        PurchasesLineTable."Direct Unit Cost" := UnitCost;
                        PurchasesLineTable."Line Amount" := Quantity * UnitCost;
                        PurchasesLineTable."Amount Spent" := ImprestAmountSpent;
                        PurchasesLineTable."Cash Refund" := (Quantity * UnitCost) - ImprestAmountSpent;
                        // PurchasesLineTable.Validate("No.");

                        if PurchasesLineTable.Modify(true) then begin

                            // RedistributeTotalsOnAfterValidate(PurchasesLineTable."Document Type", PurchasesLineTable."Document No.", PurchasesLineTable);
                            exit(format(AddResponseHead(outputjson, true)));
                        end;
                    end;
                end;

            end;
        end;
        exit(format(AddResponseHead(outputjson, false)));

    end;

    local procedure SavePurchaseRequestLine(RequestJson: JsonObject): Text;
    var
        OutputJson: JsonObject;
        JsonToken: JsonToken;

        PRNumber: Code[50];
        LineNo: Integer;
        ExpenseCategory: Code[100];
        ItemSpecification: Text;
        Quantity: Integer;
        Unit_costt: Decimal;
    begin

        RequestJson.Get('number', JsonToken);
        PRNumber := JsonToken.AsValue().AsText();
        RequestJson.Get('line_no', JsonToken);
        LineNo := JsonToken.AsValue().AsInteger();
        RequestJson.Get('expense_category', JsonToken);
        ExpenseCategory := JsonToken.AsValue().AsText();
        RequestJson.Get('item_specification', JsonToken);
        ItemSpecification := JsonToken.AsValue().AsText();
        RequestJson.Get('quantity', JsonToken);
        Quantity := JsonToken.AsValue().AsInteger();
        RequestJson.Get('direct_unit_cost', JsonToken);
        Unit_costt := JsonToken.AsValue().AsDecimal();

        PurchasesHeaderTable.Reset();
        PurchasesHeaderTable.SetRange("No.", PRNumber);
        if PurchasesHeaderTable.Find('-') then begin
            PurchasesHeaderTable."Currency Factor" := 1;
            PurchasesHeaderTable.Modify();
            PurchasesLineTable.Reset();
            PurchasesLineTable.SetRange("Line No.", LineNo);
            PurchasesLineTable.SetRange("Document No.", PurchasesHeaderTable."No.");
            if PurchasesLineTable.Find('-') then begin
                PurchasesLineTable."Expense Category" := ExpenseCategory;
                PurchasesLineTable.Validate("Expense Category");
                if PurchasesLineTable.Modify(true) then begin
                    PurchasesLineTable.Reset();
                    PurchasesLineTable.SetRange("Line No.", LineNo);
                    PurchasesLineTable.SetRange("Document No.", PurchasesHeaderTable."No.");
                    if PurchasesLineTable.Find('-') then begin
                        PurchasesLineTable."Description 2" := ItemSpecification;
                        PurchasesLineTable."Direct Unit Cost" := Unit_costt;
                        PurchasesLineTable.Quantity := Quantity;
                        PurchasesLineTable.Amount := Quantity * Unit_costt;
                        PurchasesLineTable."Currency Code" := PurchasesHeaderTable."Currency Code";
                        if PurchasesLineTable.Modify(true) then begin
                            exit(format(AddResponseHead(outputjson, true)));
                        end;
                    end
                end;
            end else begin
                PurchasesLineTable.Reset();
                PurchasesLineTable.SetRange("Document No.", PurchasesHeaderTable."No.");
                if PurchasesLineTable.FindLast() then
                    LineNo := PurchasesLineTable."Line No." + 1000
                else
                    LineNo := 1000;
                PurchasesLineTable.Init();
                PurchasesLineTable."Line No." := LineNo;
                PurchasesLineTable."Document No." := PurchasesHeaderTable."No.";
                PurchasesLineTable."Document Type" := PurchasesLineTable."Document Type"::Quote;
                PurchasesLineTable.Type := PurchasesLineTable.Type::Item;
                PurchasesLineTable."Expense Category" := ExpenseCategory;
                PurchasesLineTable.Validate("Expense Category");
                if PurchasesLineTable.Insert(true) then begin
                    PurchasesLineTable.Reset();
                    PurchasesLineTable.SetRange("Line No.", LineNo);
                    PurchasesLineTable.SetRange("Document No.", PurchasesHeaderTable."No.");
                    if PurchasesLineTable.Find('-') then begin
                        PurchasesLineTable."Description 2" := ItemSpecification;
                        PurchasesLineTable."Direct Unit Cost" := Unit_costt;
                        PurchasesLineTable.Quantity := Quantity;
                        PurchasesLineTable.Amount := Quantity * Unit_costt;
                        PurchasesLineTable."Currency Code" := PurchasesHeaderTable."Currency Code";
                        if PurchasesLineTable.Modify(true) then begin
                            exit(format(AddResponseHead(outputjson, true)));
                        end;
                    end;
                end;

            end;
        end;
        exit(format(AddResponseHead(outputjson, false)));

    end;


    local procedure NewImprestSurrender(RequestJson: JsonObject): Text;
    var
        OutputJson: JsonObject;
        JsonToken: JsonToken;

        ImprestNumber: Code[50];
        PurchasesTable2: Record "Purchase Header";
        PurchaseLines2: Record "Purchase Line";
        LineNo: Integer;
        optiontype: option;
    begin

        RequestJson.Get('imprest_number', JsonToken);
        ImprestNumber := JsonToken.AsValue().AsText();

        PurchasesTable2.Reset();
        PurchasesTable2.SetRange("No.", ImprestNumber);
        if PurchasesTable2.Find('-') then begin
            EmployeeTable.Reset();
            EmployeeTable.SetRange("No.", PurchasesTable2."Employee No");
            if EmployeeTable.Find('-') then begin
                PurchasesandPayablesSetup.Get();
                PurchasesHeaderTable.Init();
                PurchasesHeaderTable."Imprest No" := PurchasesTable2."No.";
                // PurchasesHeaderTable."No." := NumberSeries.GetNextNo(PurchasesandPayablesSetup."Surrender Nos.", Today, true);
                PurchasesHeaderTable."Employee No" := PurchasesTable2."Employee No";
                PurchasesHeaderTable."Doc Type" := optiontype;
                PurchasesHeaderTable.Validate("Employee No");
                PurchasesHeaderTable."Document Type" := PurchasesHeaderTable."Document Type"::Quote;
                PurchasesHeaderTable.SR := true;
                PurchasesHeaderTable."Requested Receipt Date" := Today;
                PurchasesHeaderTable."Posting Description" := '';
                PurchasesHeaderTable."Shortcut Dimension 1 Code" := PurchasesTable2."Shortcut Dimension 1 Code";
                PurchasesHeaderTable."Shortcut Dimension 2 Code" := PurchasesTable2."Shortcut Dimension 2 Code";
                PurchasesHeaderTable."Shortcut Dimension 3 Code" := PurchasesTable2."Shortcut Dimension 3 Code";
                PurchasesHeaderTable."Shortcut Dimension 4 Code" := PurchasesTable2."Shortcut Dimension 4 Code";
                PurchasesHeaderTable."Shortcut Dimension 5 Code" := PurchasesTable2."Shortcut Dimension 5 Code";
                PurchasesHeaderTable.Status := PurchasesHeaderTable.Status::Open;
                PurchasesHeaderTable."Buy-from Vendor No." := 'FM-V00123';
                PurchasesHeaderTable."Vendor Posting Group" := 'TRADERS';
                PurchasesHeaderTable."Currency Code" := PurchasesTable2."Currency Code";
                PurchasesHeaderTable."Mission Proposal No" := PurchasesTable2."Mission Proposal No";
                PurchasesHeaderTable."Responsibility Center" := EmployeeTable."User ID";
                PurchasesHeaderTable."Assigned User ID" := EmployeeTable."User ID";
                PurchasesHeaderTable."User ID" := EmployeeTable."User ID";
                PurchasesHeaderTable."Account No" := EmployeeTable.Travelaccountno;
                PurchasesHeaderTable."Account Name" := EmployeeTable.FullName();
                PurchasesHeaderTable.Validate("Currency Code");

                if PurchasesHeaderTable.Insert(true) then begin
                    outputjson := AddResponseHead(OutputJson, true);
                    PurchaseLines2.Reset;
                    PurchaseLines2.SetRange("Document No.", ImprestNumber);
                    if PurchaseLines2.Find('-') then begin
                        repeat
                            Clear(OutputJson);
                            PurchasesLineTable.Init;

                            LineNo := LineNo + 1000;
                            PurchasesLineTable.Type := PurchasesLineTable.Type::"G/L Account";
                            PurchasesLineTable."Document Type" := PurchasesHeaderTable."Document Type";
                            PurchasesLineTable.Validate("Document Type");
                            PurchasesLineTable."Document No." := PurchasesHeaderTable."No.";
                            PurchasesLineTable.Validate("Document No.");
                            PurchasesLineTable."Line No." := LineNo;
                            PurchasesLineTable.Type := PurchaseLines2.Type;
                            PurchasesLineTable."No." := PurchaseLines2."No.";
                            PurchasesLineTable.Validate("No.");
                            PurchasesLineTable.Description := PurchaseLines2.Description;
                            PurchasesLineTable."Description 2" := PurchaseLines2."Description 2";
                            PurchasesLineTable.Quantity := PurchaseLines2.Quantity;
                            PurchasesLineTable.Validate(Quantity);
                            PurchasesLineTable."Unit of Measure Code" := PurchaseLines2."Unit of Measure Code";
                            PurchasesLineTable.Validate("Unit of Measure Code");
                            PurchasesLineTable."Direct Unit Cost" := PurchaseLines2."Direct Unit Cost";
                            PurchasesLineTable.Validate("Direct Unit Cost");
                            PurchasesLineTable."Location Code" := PurchaseLines2."Location Code";
                            PurchasesLineTable."Location Code" := PurchasesHeaderTable."Location Code";
                            PurchasesLineTable."Expense Category" := PurchaseLines2."Expense Category";
                            PurchasesLineTable."Shortcut Dimension 1 Code" := PurchasesHeaderTable."Shortcut Dimension 1 Code";
                            PurchasesLineTable."Shortcut Dimension 2 Code" := PurchasesHeaderTable."Shortcut Dimension 2 Code";
                            if PurchasesLineTable.Insert() then
                                outputjson := AddResponseHead(OutputJson, true);
                        until PurchaseLines2.Next = 0;
                    end;
                    exit(format(OutputJson));
                end;

            end;
            // exit(Format(AddResponseHead(OutputJson, true)));
        end;

        exit(format(AddResponseHead(outputjson, false)));
    end;

    // local procedure RedistributeTotalsOnAfterValidate(DocumentType: enum "Purchase Document Type"; DocumentNo: Code[20]; Rec: record "Purchase Line")
    // var
    //     DocumentTotals: Codeunit "Document Totals";
    //     VATAmount: decimal;
    //     TotalPurchaseLine: Record "Purchase Line";
    // begin

    //     PurchasesHeaderTable.Get(DocumentType, DocumentNo);
    //     if DocumentTotals.PurchaseCheckNumberOfLinesLimit(PurchasesHeaderTable) then
    //         DocumentTotals.PurchaseRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalPurchaseLine);
    // end;

    procedure FnUpdateSetup(): Text
    begin
        PurchasesandPayablesSetup.Get();
        PurchasesandPayablesSetup."Imprest Nos." := 'IMP';
        // PurchasesandPayablesSetup.Modify();
        exit(PurchasesandPayablesSetup."Imprest Nos.");

    end;

    local procedure GetImprestSurrenders(employeeid: Text; Identifier: Text): Text
    var
        OutputJson: JsonObject;
        DataJson: JsonObject;

        element: JsonObject;
        elements: JsonArray;
    begin
        if (employeeid <> '') then begin
            EmployeeTable.Reset();
            if (Identifier = 'EMAIL') then
                EmployeeTable.SetRange("Company E-Mail", employeeid);
            if (Identifier = 'NUMBER') then
                EmployeeTable.SetRange("No.", employeeid);
            if EmployeeTable.FindFirst() then begin
                PurchasesHeaderTable.Reset();
                PurchasesHeaderTable.SetAscending("No.", false);
                PurchasesHeaderTable.SetRange("Employee No", EmployeeTable."No.");
                PurchasesHeaderTable.SetRange("Document Type", PurchasesHeaderTable."Document Type"::Quote);
                PurchasesHeaderTable.SetRange(SR, true);
                if PurchasesHeaderTable.FindSet() then begin
                    Clear(OutputJson);
                    Clear(elements);
                    OutputJson := AddResponseHead(OutputJson, true);
                    repeat
                        PurchasesHeaderTable.CalcFields(Amount);
                        Clear(element);
                        element.add('surrender_number', PurchasesHeaderTable."No.");
                        element.add('imprest_number', PurchasesHeaderTable."Imprest No");
                        element.add('status', Format(PurchasesHeaderTable.Status));
                        element.add('employee_name', Format(PurchasesHeaderTable."Employee Name"));
                        element.add('purpose', PurchasesHeaderTable."Posting Description");
                        element.add('surrender_amount', PurchasesHeaderTable.Amount);
                        element.add('imprest_amount', PurchasesHeaderTable."Imprest Amount");
                        elements.add(element);
                    until PurchasesHeaderTable.Next() = 0;
                    OutputJson.Add('imprest_surrenders', elements);
                    exit(Format(OutputJson));
                end;
            end;
        end;
        exit(Format(AddResponseHead(OutputJson, false)));
    end;

    local procedure GetTimeSheets(employeeid: Text; Identifier: Text): Text
    var
        OutputJson: JsonObject;
        DataJson: JsonObject;

        element: JsonObject;
        elements: JsonArray;
    begin
        if (employeeid <> '') then begin
            EmployeeTable.Reset();
            if (Identifier = 'EMAIL') then
                EmployeeTable.SetRange("Company E-Mail", employeeid);
            if (Identifier = 'NUMBER') then
                EmployeeTable.SetRange("No.", employeeid);
            if EmployeeTable.FindFirst() then begin
                TimesheetTable.Reset();
                TimesheetTable.SetAscending(Timesheetcode, false);
                TimesheetTable.SetRange("Employee No", EmployeeTable."No.");
                if TimesheetTable.FindSet() then begin
                    Clear(OutputJson);
                    Clear(elements);
                    OutputJson := AddResponseHead(OutputJson, true);
                    repeat
                        Clear(element);
                        element.add('document_no', TimesheetTable.Timesheetcode);
                        element.add('employee_no', TimesheetTable."Employee No");
                        element.add('status', Format(TimesheetTable.Status));
                        element.add('employee_name', Format(TimesheetTable."Employee Name"));
                        element.add('from_date', TimesheetTable.From);
                        element.add('to_date', TimesheetTable."To Date");
                        element.add('hours', TimesheetTable.hours);
                        elements.add(element);
                    until TimesheetTable.Next() = 0;
                    OutputJson.Add('timesheets', elements);
                    outputjson.Add('project_codes', GetTimeSheetDimensionValues());
                    exit(Format(OutputJson));
                end;
            end;
        end;

        outputjson.Add('project_codes', GetTimeSheetDimensionValues());
        exit(Format(AddResponseHead(OutputJson, false)));
    end;

    local procedure GetHelpDeskTickets(EmployeeID: code[20]): Text
    var
        Outputjson: JsonObject;
        jsonobject: JsonObject;
        jsonarray: JsonArray;
    begin
        Clear(Outputjson);
        Clear(JsonArray);
        Tickets.Reset();
        Tickets.SetRange("Employee ID", EmployeeID);
        if Tickets.FindSet() then begin
            repeat
                Clear(jsonobject);
                jsonobject.Add('ticket_number', Tickets."Document No");
                jsonobject.Add('employee_id', Tickets."Employee ID");
                jsonobject.Add('employee_name', Tickets."Employee Name");
                jsonobject.Add('subject', Tickets.Title);
                jsonobject.Add('description', Tickets.Description);
                jsonobject.Add('date_created', Tickets."Placed On");
                jsonobject.Add('documentlink', Tickets."Document Link");
                jsonobject.Add('status', Format(Tickets.Status));
                jsonarray.Add(jsonobject);
            until Tickets.Next() = 0;

            Outputjson.Add('helpdesk_tickets', JsonArray);
            exit(Format(AddResponseHead(Outputjson, true)));
        end;
        exit(Format(AddResponseHead(Outputjson, false)));
    end;

    local procedure NewHelpDeskTicket(RequestJson: JsonObject): Text
    var
        jsontoken: JsonToken;
        NextNo: code[20];
        NoSeriesMgt: codeunit "No. Series";

        EmployeeID: code[20];
        outputjson: JsonObject;
    begin
        Clear(outputjson);
        HrSetUpTable.Get();
        HrSetUpTable.TestField("Ticket Nos.");
        NextNo := NoSeriesMgt.GetNextNo(HrSetUpTable."Ticket Nos.", 0D, true);

        if RequestJson.Get('employee_id', jsontoken) and not jsontoken.AsValue().IsNull then
            EmployeeID := jsontoken.AsValue().AsText();
        if EmployeeTable.Get(EmployeeID) then begin
            Tickets.Init();
            Tickets."Document No" := NextNo;
            Tickets."Employee ID" := EmployeeTable."No.";
            Tickets."Employee Name" := EmployeeTable.FullName();
            if RequestJson.Get('subject', jsontoken) and not jsontoken.AsValue().IsNull then
                Tickets.Title := jsontoken.AsValue().AsText();
            if RequestJson.Get('description', jsontoken) and not jsontoken.AsValue().IsNull then
                Tickets.Description := jsontoken.AsValue().AsText();
            Tickets."Placed On" := Today;

            outputjson.Add('ReturnNumber', NextNo);
            outputjson.Add('employee_full_name', EmployeeTable.FullName());

            if Tickets.Insert() then
                exit(Format(AddResponseHead(outputjson, true)));

            exit(Format(AddResponseHead(outputjson, false)));

        end;
    end;

    local procedure GetMissionProposals(employeeid: Text; Identifier: Text): Text
    var
        OutputJson: JsonObject;
        DataJson: JsonObject;

        element: JsonObject;
        elements: JsonArray;
    begin
        if (employeeid <> '') then begin
            EmployeeTable.Reset();
            if (Identifier = 'EMAIL') then
                EmployeeTable.SetRange("Company E-Mail", employeeid);
            if (Identifier = 'NUMBER') then
                EmployeeTable.SetRange("No.", employeeid);
            if EmployeeTable.FindFirst() then begin
                PurchasesHeaderTable.Reset();
                PurchasesHeaderTable.SetAscending("No.", false);
                PurchasesHeaderTable.SetRange("Employee No", EmployeeTable."No.");
                PurchasesHeaderTable.SetRange("Document Type", PurchasesHeaderTable."Document Type"::Quote);
                PurchasesHeaderTable.SetRange(MP, true);
                if PurchasesHeaderTable.FindSet() then begin
                    Clear(OutputJson);
                    Clear(elements);
                    OutputJson := AddResponseHead(OutputJson, true);
                    repeat
                        PurchasesHeaderTable.CalcFields(Amount);
                        Clear(element);
                        element.add('proposal_number', PurchasesHeaderTable."No.");
                        element.add('status', Format(PurchasesHeaderTable.Status));
                        element.add('employee_name', Format(PurchasesHeaderTable."Employee Name"));
                        element.add('strategic_focus_area', PurchasesHeaderTable."Strategic Focus Area");
                        element.add('project_title', PurchasesHeaderTable."Project Title");
                        element.add('mission_team', PurchasesHeaderTable."Mission Team");
                        element.add('dates_of_activity', PurchasesHeaderTable."Date(s) of Activity");
                        elements.add(element);
                    until PurchasesHeaderTable.Next() = 0;
                    OutputJson.Add('mission_proposals', elements);
                    outputjson.add('expensecategories', GetStandardTexts('GL Category'));
                    exit(Format(OutputJson));
                end;
            end;
        end;
        OutputJson := AddResponseHead(OutputJson, false);
        outputjson.add('expensecategories', GetStandardTexts('GL Category'));
        exit(Format(OutputJson));
    end;

    local procedure NewMissionProposal(RequestJson: JsonObject): Text;
    var
        OutputJson: JsonObject;
        JsonToken: JsonToken;

        StaffID: Code[50];
        StrategicFocusArea: code[100];
        SubPillar: code[100];
        ProjectTitle: Text;
        Country: Code[100];
        County: Code[100];
        DatesofActivity: Text;
        MissionTeam: Text;
        InvitedTeam: Text;
        FundCode: Code[100];
        ProgramCode: Code[100];
        Shortcut3: Code[100];
        Shortcut4: Code[100];
        Shortcut5: Code[100];
        Currency: Code[100];
    begin

        RequestJson.Get('employee_id', JsonToken);
        StaffID := JsonToken.AsValue().AsText();
        if RequestJson.Get('strategic_focus_area', JsonToken) and not JsonToken.AsValue().IsNull then
            StrategicFocusArea := JsonToken.AsValue().AsText();
        if RequestJson.Get('sub_pillar_code', JsonToken) and not JsonToken.AsValue().IsNull then
            SubPillar := JsonToken.AsValue().AsText();
        if RequestJson.Get('project_title', JsonToken) and not JsonToken.AsValue().IsNull then
            ProjectTitle := JsonToken.AsValue().AsText();
        if RequestJson.Get('country', JsonToken) and not JsonToken.AsValue().IsNull then
            Country := JsonToken.AsValue().AsText();
        if RequestJson.Get('county', JsonToken) and not JsonToken.AsValue().IsNull then
            County := JsonToken.AsValue().AsText();
        if RequestJson.Get('dates_of_activity', JsonToken) and not JsonToken.AsValue().IsNull then
            DatesofActivity := JsonToken.AsValue().AsText();
        if RequestJson.Get('mission_team', JsonToken) and not JsonToken.AsValue().IsNull then
            MissionTeam := JsonToken.AsValue().AsText();
        if RequestJson.Get('invited_members', JsonToken) and not JsonToken.AsValue().IsNull then
            InvitedTeam := JsonToken.AsValue().AsText();
        if RequestJson.Get('fund_code', JsonToken) and not JsonToken.AsValue().IsNull then
            FundCode := JsonToken.AsValue().AsText();
        if RequestJson.Get('program_code', JsonToken) and not JsonToken.AsValue().IsNull then
            ProgramCode := JsonToken.AsValue().AsText();
        if RequestJson.Get('shortcut_3', JsonToken) and not JsonToken.AsValue().IsNull then
            Shortcut3 := JsonToken.AsValue().AsText();
        if RequestJson.Get('shortcut_4', JsonToken) and not JsonToken.AsValue().IsNull then
            Shortcut4 := JsonToken.AsValue().AsText();
        if RequestJson.Get('shortcut_5', JsonToken) and not JsonToken.AsValue().IsNull then
            Shortcut5 := JsonToken.AsValue().AsText();
        if RequestJson.Get('currency_code', JsonToken) and not JsonToken.AsValue().IsNull then
            Currency := JsonToken.AsValue().AsText();

        PurchasesandPayablesSetup.Get();
        PurchasesHeaderTable.Init();
        PurchasesHeaderTable."No." := NumberSeries.GetNextNo(PurchasesandPayablesSetup."Mission Proposal Nos.", Today, true);
        PurchasesHeaderTable."Employee No" := StaffID;
        PurchasesHeaderTable.Validate("Employee No");
        PurchasesHeaderTable."Document Type" := PurchasesHeaderTable."Document Type"::Quote;
        PurchasesHeaderTable.MP := true;
        PurchasesHeaderTable."Posting Date" := Today;
        PurchasesHeaderTable."Strategic Focus Area" := StrategicFocusArea;
        PurchasesHeaderTable."Sub Pillar" := SubPillar;
        PurchasesHeaderTable."Project Title" := ProjectTitle;
        PurchasesHeaderTable.Country := Country;
        PurchasesHeaderTable.County := County;
        PurchasesHeaderTable."Date(s) of Activity" := DatesofActivity;
        PurchasesHeaderTable."Mission Team" := MissionTeam;
        PurchasesHeaderTable."Invited Members/Partners" := InvitedTeam;
        PurchasesHeaderTable."Shortcut Dimension 1 Code" := FundCode;
        PurchasesHeaderTable."Shortcut Dimension 2 Code" := ProgramCode;
        PurchasesHeaderTable."Shortcut Dimension 3 Code" := Shortcut3;
        PurchasesHeaderTable."Shortcut Dimension 3 Code" := Shortcut4;
        PurchasesHeaderTable."Shortcut Dimension 5 Code" := Shortcut5;
        PurchasesHeaderTable.Status := PurchasesHeaderTable.Status::Open;
        PurchasesHeaderTable."Currency Code" := Currency;
        PurchasesHeaderTable."Currency Factor" := 1;

        if (PurchasesHeaderTable.Insert(true) = true) then
            exit(Format(AddResponseHead(OutputJson, true)));

        exit(format(AddResponseHead(outputjson, false)));

    end;

    local procedure AmendMissionProposal(RequestJson: JsonObject): Text;
    var
        OutputJson: JsonObject;
        JsonToken: JsonToken;

        RequestNumber: Code[50];
        StrategicFocusArea: code[100];
        SubPillar: code[100];
        ProjectTitle: Text;
        Country: Code[100];
        County: Code[100];
        DatesofActivity: Text;
        MissionTeam: Text;
        InvitedTeam: Text;
        FundCode: Code[100];
        ProgramCode: Code[100];
        Shortcut3: Code[100];
        Shortcut4: Code[100];
        Shortcut5: Code[100];
        Background: Text;
        Contribution: Text;
        Outcome: Text;
        BudgetBalance: Decimal;
        Amount: Decimal;
        BalanceBroughForward: Decimal;

    begin

        RequestJson.Get('proposal_number', JsonToken);
        RequestNumber := JsonToken.AsValue().AsText();
        if RequestJson.Get('strategic_focus_area', JsonToken) then
            StrategicFocusArea := JsonToken.AsValue().AsText();
        if RequestJson.Get('sub_pillar_code', JsonToken) then
            SubPillar := JsonToken.AsValue().AsText();
        RequestJson.Get('project_title', JsonToken);
        ProjectTitle := JsonToken.AsValue().AsText();
        if RequestJson.Get('country', JsonToken) then
            Country := JsonToken.AsValue().AsText();
        if RequestJson.Get('county', JsonToken) then
            County := JsonToken.AsValue().AsText();
        RequestJson.Get('dates_of_activity', JsonToken);
        DatesofActivity := JsonToken.AsValue().AsText();
        RequestJson.Get('mission_team', JsonToken);
        MissionTeam := JsonToken.AsValue().AsText();
        RequestJson.Get('invited_members', JsonToken);
        InvitedTeam := JsonToken.AsValue().AsText();
        RequestJson.Get('fund_code', JsonToken);
        FundCode := JsonToken.AsValue().AsText();
        RequestJson.Get('program_code', JsonToken);
        ProgramCode := JsonToken.AsValue().AsText();
        RequestJson.Get('shortcut_3', JsonToken);
        Shortcut3 := JsonToken.AsValue().AsText();
        RequestJson.Get('shortcut_4', JsonToken);
        Shortcut4 := JsonToken.AsValue().AsText();
        RequestJson.Get('shortcut_5', JsonToken);
        Shortcut5 := JsonToken.AsValue().AsText();
        RequestJson.Get('background', JsonToken);
        Background := JsonToken.AsValue().AsText();
        RequestJson.Get('contribution_to_focus', JsonToken);
        Contribution := JsonToken.AsValue().AsText();
        RequestJson.Get('main_outcome', JsonToken);
        Outcome := JsonToken.AsValue().AsText();
        RequestJson.Get('budget_balance', JsonToken);
        BudgetBalance := JsonToken.AsValue().AsDecimal();
        RequestJson.Get('amount', JsonToken);
        Amount := JsonToken.AsValue().AsDecimal();
        // RequestJson.Get('balance_carried_forward', JsonToken);
        // BalanceBroughForward := JsonToken.AsValue().AsDecimal();

        PurchasesHeaderTable.Reset();
        PurchasesHeaderTable.SetRange("No.", RequestNumber);
        PurchasesHeaderTable.SetRange(MP, true);
        if PurchasesHeaderTable.find('-') then begin
            PurchasesHeaderTable."Strategic Focus Area" := StrategicFocusArea;
            PurchasesHeaderTable."Sub Pillar" := SubPillar;
            PurchasesHeaderTable."Project Title" := ProjectTitle;
            PurchasesHeaderTable.Country := Country;
            PurchasesHeaderTable.County := County;
            PurchasesHeaderTable."Date(s) of Activity" := DatesofActivity;
            PurchasesHeaderTable."Mission Team" := MissionTeam;
            PurchasesHeaderTable."Invited Members/Partners" := InvitedTeam;
            PurchasesHeaderTable."Shortcut Dimension 1 Code" := FundCode;
            PurchasesHeaderTable."Shortcut Dimension 2 Code" := ProgramCode;
            PurchasesHeaderTable."Shortcut Dimension 3 Code" := Shortcut3;
            PurchasesHeaderTable."Shortcut Dimension 3 Code" := Shortcut4;
            PurchasesHeaderTable."Shortcut Dimension 5 Code" := Shortcut5;
            PurchasesHeaderTable.Background := Background;
            PurchasesHeaderTable."Contribution to focus" := Contribution;
            PurchasesHeaderTable."Main Outcome" := Outcome;
            PurchasesHeaderTable."Mission Total" := Amount;
            PurchasesHeaderTable."Budget Balance" := BudgetBalance;
            PurchasesHeaderTable."Currency Factor" := 1;

            if (PurchasesHeaderTable.Modify(true) = true) then
                exit(Format(AddResponseHead(OutputJson, true)));
        end;
        exit(format(AddResponseHead(outputjson, false)));
    end;

    local procedure GetMissionProposalDetails(requestnumber: code[50]): Text
    var
        outputjson: JsonObject;
        element: JsonObject;
        line: JsonObject;
        lines: JsonArray;
    begin
        PurchasesHeaderTable.Reset();
        PurchasesHeaderTable.SetRange("No.", requestnumber);
        if PurchasesHeaderTable.Find('-') then begin
            outputjson := AddResponseHead(outputjson, true);

            element.add('proposal_number', PurchasesHeaderTable."No.");
            element.add('employee_id', PurchasesHeaderTable."Employee No");
            element.add('employee_name', PurchasesHeaderTable."Employee Name");
            element.add('strategic_focus_area', PurchasesHeaderTable."Strategic Focus Area");
            element.add('sub_pillar_code', PurchasesHeaderTable."Sub Pillar");
            element.add('project_title', PurchasesHeaderTable."Project Title");
            element.add('country', PurchasesHeaderTable.Country);
            element.add('county', PurchasesHeaderTable.County);
            element.add('dates_of_activity', PurchasesHeaderTable."Date(s) of Activity");
            element.add('mission_team', PurchasesHeaderTable."Mission Team");
            element.add('invited_members', PurchasesHeaderTable."Invited Members/Partners");
            element.add('fund_code', PurchasesHeaderTable."Shortcut Dimension 1 Code");
            element.add('program_code', PurchasesHeaderTable."Shortcut Dimension 2 Code");
            element.add('budget_code', PurchasesHeaderTable."Shortcut Dimension 3 Code");
            element.add('shortcut_4', PurchasesHeaderTable."Shortcut Dimension 4 Code");
            element.add('department_code', PurchasesHeaderTable."Shortcut Dimension 5 Code");
            element.add('currency_code', PurchasesHeaderTable."Currency Code");
            element.add('status', Format(PurchasesHeaderTable.Status));
            element.add('background', Format(PurchasesHeaderTable.Background));
            element.add('contribution_to_focus', Format(PurchasesHeaderTable."Contribution to focus"));
            element.add('main_outcome', Format(PurchasesHeaderTable."Main Outcome"));
            element.add('budget_balance', Format(PurchasesHeaderTable."Budget Balance"));
            element.add('amount', Format(PurchasesHeaderTable."Mission Total"));
            element.add('balance_carried_forward', Format(PurchasesHeaderTable."Budget Balance" - PurchasesHeaderTable."Mission Total"));
            element.add('imprest_amount', Format(PurchasesHeaderTable."Imprest Amount"));
            element.add('imprest_holder', Format(PurchasesHeaderTable."Imprest Holder"));
            element.add('days_outstanding', Format(PurchasesHeaderTable."No of Days Outstanding"));
            element.add('finance_action', Format(PurchasesHeaderTable."Finance Action"));

            Clear(lines);
            PurchasesLineTable.Reset();
            PurchasesLineTable.SetRange("Document No.", PurchasesHeaderTable."No.");
            PurchasesLineTable.SetRange("Line Type", PurchasesLineTable."Line Type"::Objectives);
            if PurchasesLineTable.FindSet() then begin
                repeat
                    Clear(line);
                    line.Add('line_no', PurchasesLineTable."Line No.");
                    line.Add('line_type', Format(PurchasesLineTable."Line Type"));
                    line.Add('description', PurchasesLineTable."Description 6");
                    lines.Add(line);
                until PurchasesLineTable.Next() = 0;
                element.Add('mission_proposal_objectives', lines);
            end;

            Clear(lines);
            PurchasesLineTable.Reset();
            PurchasesLineTable.SetRange("Document No.", PurchasesHeaderTable."No.");
            PurchasesLineTable.SetRange("Line Type", PurchasesLineTable."Line Type"::"Team Roles");
            if PurchasesLineTable.FindSet() then begin
                repeat
                    Clear(line);
                    line.Add('line_no', PurchasesLineTable."Line No.");
                    line.Add('line_type', Format(PurchasesLineTable."Line Type"));
                    line.Add('employee_name', PurchasesLineTable."Description 2");
                    line.Add('responsibilities', PurchasesLineTable."Description 3");
                    lines.Add(line);
                until PurchasesLineTable.Next() = 0;
                element.Add('mission_proposal_team_roles', lines);
            end;


            Clear(lines);
            PurchasesLineTable.Reset();
            PurchasesLineTable.SetRange("Document No.", PurchasesHeaderTable."No.");
            PurchasesLineTable.SetRange("Line Type", PurchasesLineTable."Line Type"::Activity);
            if PurchasesLineTable.FindSet() then begin
                repeat
                    Clear(line);
                    line.Add('line_no', PurchasesLineTable."Line No.");
                    line.Add('line_type', Format(PurchasesLineTable."Line Type"));
                    line.Add('date', PurchasesLineTable."Expected Receipt Date");
                    line.Add('activity', PurchasesLineTable."Description 3");
                    line.Add('duration', PurchasesLineTable."Unit of Measure");
                    line.Add('output', PurchasesLineTable."Description 2");
                    lines.Add(line);
                until PurchasesLineTable.Next() = 0;
                element.Add('mission_proposal_activities', lines);
            end;

            Clear(lines);
            PurchasesLineTable.Reset();
            PurchasesLineTable.SetRange("Document No.", PurchasesHeaderTable."No.");
            PurchasesLineTable.SetRange("Line Type", PurchasesLineTable."Line Type"::"Budget Info");
            if PurchasesLineTable.FindSet() then begin
                repeat
                    Clear(line);
                    line.Add('line_no', PurchasesLineTable."Line No.");
                    line.Add('line_type', Format(PurchasesLineTable."Line Type"));
                    line.Add('budget_item', PurchasesLineTable."Description 3");
                    line.Add('identified_vendor', PurchasesLineTable."Description 2");
                    line.Add('no_of_days', PurchasesLineTable."No of days");
                    line.Add('no_of_pax', PurchasesLineTable."No of pax");
                    line.Add('ksh', PurchasesLineTable.Ksh);
                    line.Add('other_currency', PurchasesLineTable."other currency");
                    line.Add('total_ksh', PurchasesLineTable."Total Ksh");
                    line.Add('total_other_currency', PurchasesLineTable."Total Other Currency");
                    line.Add('mission_expense_category', PurchasesLineTable."Mission Expense Category");
                    line.Add('budget_justification', PurchasesLineTable."Description 6");
                    lines.Add(line);
                until PurchasesLineTable.Next() = 0;
                element.Add('mission_proposal_budgetinfo', lines);
            end;

            Clear(lines);
            PurchasesLineTable.Reset();
            PurchasesLineTable.SetRange("Document No.", PurchasesHeaderTable."No.");
            PurchasesLineTable.SetRange("Line Type", PurchasesLineTable."Line Type"::"Budget Notes");
            if PurchasesLineTable.FindSet() then begin
                repeat
                    Clear(line);
                    line.Add('line_no', PurchasesLineTable."Line No.");
                    line.Add('line_type', Format(PurchasesLineTable."Line Type"));
                    line.Add('details', PurchasesLineTable."Description 3");
                    line.Add('vendor_1', PurchasesLineTable."Description 2");
                    line.Add('vendor_2', PurchasesLineTable."Description 4");
                    line.Add('vendor_3', PurchasesLineTable."Description 5");
                    line.Add('comments', PurchasesLineTable."Description 6");
                    lines.Add(line);
                until PurchasesLineTable.Next() = 0;
                element.Add('mission_proposal_budgetnotes', lines);
            end;

            outputjson.Add('mission_proposal', element);

            outputjson.Add('fund_codes', GetDimensionValues('1', ''));
            outputjson.Add('program_codes', GetDimensionValues('2', ''));
            outputjson.Add('budget_codes', GetDimensionValues('3', ''));
            outputjson.Add('shortcut_4_codes', GetDimensionValues('4', ''));
            outputjson.Add('department_codes', GetDimensionValues('5', ''));
            outputjson.add('currencies', GetCurrencies());
            outputjson.add('strategic_focus_areas', GetStandardTexts('Focus Area'));
            outputjson.add('sub_pillars', GetStandardTexts('Sub Pillar'));
            outputjson.add('countries', GetCountryRegions('Country'));
            outputjson.add('counties', GetCountryRegions('County'));
            outputjson.add('expensecategories', GetStandardTexts('GL Category'));

            exit(format(outputjson));
        end;
        exit(Format(AddResponseHead(outputjson, false)));
    end;


    local procedure UpdateMissionProposalLines(RequestJson: JsonObject): Text
    var
        Linetype: Text;
        LineNo: Integer;
        ProposalNumber: code[20];
        EmployeeName: Text;
        Responsibilities: Text;
        Description: Text;
        DateText: Text;
        DateExpected: Date;
        Activity: Text;
        Duration: Text;
        Output: text;
        BudgetItem: Text;
        IdentifiedVendor: TExt;
        NoOfDays: decimal;
        NoOfPax: decimal;
        Ksh: decimal;
        OtherCurrency: decimal;
        TotalKsh: decimal;
        TotalOtherKsh: decimal;
        Details: Text;
        ExpenseCategory: Code[50];
        Vendor1: Text;
        Vendor2: Text;
        Vendor3: Text;
        Comments: Text;
        BudgetJustification: Text;
        JsonToken: JsonToken;

        MissionLines: JsonArray;
        MissionLine: JsonObject;

        outputjson: JsonObject;
    begin
        RequestJson.Get('proposal_line_type', JsonToken);
        Linetype := JsonToken.AsValue().AsText();
        RequestJson.Get('proposal_number', JsonToken);
        ProposalNumber := JsonToken.AsValue().AsText();

        case Lowercase(Linetype) of
            'mission_objective':
                begin
                    RequestJson.Get('mission_proposal_objectives', JsonToken);
                    MissionLines := JsonToken.AsArray();
                    if MissionLines.Count() > 0 then begin
                        foreach JsonToken in MissionLines do begin
                            if JsonToken.IsObject() then begin
                                MissionLine := JsonToken.AsObject();
                                if MissionLine.Get('line_no', JsonToken) and not JsonToken.AsValue().IsNull() then
                                    LineNo := JsonToken.AsValue().AsInteger()
                                else
                                    LineNo := 0;

                                if MissionLine.Get('description', JsonToken) and not JsonToken.AsValue().IsNull() then
                                    Description := JsonToken.AsValue().AsText();

                                PurchasesLineTable.Reset();
                                PurchasesLineTable.SetRange("Document No.", ProposalNumber);
                                PurchasesLineTable.SetRange("Line No.", LineNo);
                                PurchasesLineTable.SetRange("Line Type", PurchasesLineTable."Line Type"::Objectives);
                                if PurchasesLineTable.Find('-') then begin
                                    PurchasesLineTable."Description 6" := Description;
                                    PurchasesLineTable.Modify();
                                end else begin
                                    PurchasesLineTable.Reset();
                                    PurchasesLineTable.SetRange("Document No.", ProposalNumber);
                                    if PurchasesLineTable.FindLast() then begin
                                        LineNo := PurchasesLineTable."Line No." + 100;
                                        PurchasesLineTable.Init();
                                        PurchasesLineTable."Line No." := LineNo;
                                        PurchasesLineTable.Type := PurchasesLineTable.Type::Item;
                                        PurchasesLineTable."Line Type" := PurchasesLineTable."line type"::Objectives;
                                        PurchasesLineTable."Document No." := ProposalNumber;
                                        PurchasesLineTable."Description 6" := Description;
                                        PurchasesLineTable.Insert();
                                    end else begin
                                        LineNo := 100;
                                        PurchasesLineTable.Init();
                                        PurchasesLineTable."Line No." := LineNo;
                                        PurchasesLineTable.Type := PurchasesLineTable.Type::Item;
                                        PurchasesLineTable."Line Type" := PurchasesLineTable."line type"::Objectives;
                                        PurchasesLineTable."Document No." := ProposalNumber;
                                        PurchasesLineTable."Description 6" := Description;
                                        PurchasesLineTable.Insert();
                                    end;
                                end;
                            end;
                        end;
                    end;
                    exit(Format(AddResponseHead(outputjson, true)));
                end;

            'team_roles':
                begin
                    RequestJson.Get('mission_proposal_team_roles', JsonToken);
                    MissionLines := JsonToken.AsArray();
                    if MissionLines.Count() > 0 then begin
                        foreach JsonToken in MissionLines do begin
                            if JsonToken.IsObject() then begin
                                MissionLine := JsonToken.AsObject();
                                if MissionLine.Get('line_no', JsonToken) and not JsonToken.AsValue().IsNull() then
                                    LineNo := JsonToken.AsValue().AsInteger()
                                else
                                    LineNo := 0;

                                if MissionLine.Get('employee_name', JsonToken) and not JsonToken.AsValue().IsNull() then
                                    EmployeeName := JsonToken.AsValue().AsText();
                                if MissionLine.Get('responsibilities', JsonToken) and not JsonToken.AsValue().IsNull() then
                                    Responsibilities := JsonToken.AsValue().AsText();

                                PurchasesLineTable.Reset();
                                PurchasesLineTable.SetRange("Document No.", ProposalNumber);
                                PurchasesLineTable.SetRange("Line No.", LineNo);
                                PurchasesLineTable.SetRange("Line Type", PurchasesLineTable."Line Type"::"Team Roles");
                                if PurchasesLineTable.Find('-') then begin
                                    PurchasesLineTable."Description 2" := EmployeeName;
                                    PurchasesLineTable."Description 3" := Responsibilities;
                                    PurchasesLineTable.Modify();
                                end else begin
                                    PurchasesLineTable.Reset();
                                    PurchasesLineTable.SetRange("Document No.", ProposalNumber);
                                    if PurchasesLineTable.FindLast() then begin
                                        LineNo := PurchasesLineTable."Line No." + 100;
                                        PurchasesLineTable.Init();
                                        PurchasesLineTable."Line No." := LineNo;
                                        PurchasesLineTable.Type := PurchasesLineTable.Type::Item;
                                        PurchasesLineTable."Line Type" := PurchasesLineTable."line type"::"Team Roles";
                                        PurchasesLineTable."Document No." := ProposalNumber;
                                        PurchasesLineTable."Description 2" := EmployeeName;
                                        PurchasesLineTable."Description 3" := Responsibilities;
                                        PurchasesLineTable.Insert();
                                    end else begin
                                        LineNo := 100;
                                        PurchasesLineTable.Init();
                                        PurchasesLineTable."Line No." := LineNo;
                                        PurchasesLineTable.Type := PurchasesLineTable.Type::Item;
                                        PurchasesLineTable."Line Type" := PurchasesLineTable."line type"::"Team Roles";
                                        PurchasesLineTable."Document No." := ProposalNumber;
                                        PurchasesLineTable."Description 2" := EmployeeName;
                                        PurchasesLineTable."Description 3" := Responsibilities;
                                        PurchasesLineTable.Insert();
                                    end;
                                end;
                            end;
                        end;
                    end;
                    exit(Format(AddResponseHead(outputjson, true)));
                end;

            'activity':
                begin
                    RequestJson.Get('mission_proposal_activities', JsonToken);
                    MissionLines := JsonToken.AsArray();
                    if MissionLines.Count() > 0 then begin
                        foreach JsonToken in MissionLines do begin
                            if JsonToken.IsObject() then begin
                                MissionLine := JsonToken.AsObject();
                                if MissionLine.Get('line_no', JsonToken) and not JsonToken.AsValue().IsNull() then
                                    LineNo := JsonToken.AsValue().AsInteger()
                                else
                                    LineNo := 0;

                                if MissionLine.Get('date', JsonToken) and not JsonToken.AsValue().IsNull() then begin
                                    DateText := JsonToken.AsValue().AsText();
                                    if DateText <> '' then
                                        Evaluate(DateExpected, DateText, 9);
                                end;

                                if MissionLine.Get('activity', JsonToken) and not JsonToken.AsValue().IsNull() then
                                    Activity := JsonToken.AsValue().AsText();
                                if MissionLine.Get('duration', JsonToken) and not JsonToken.AsValue().IsNull() then
                                    Duration := JsonToken.AsValue().AsText();
                                if MissionLine.Get('output', JsonToken) and not JsonToken.AsValue().IsNull() then
                                    Output := JsonToken.AsValue().AsText();

                                PurchasesLineTable.Reset();
                                PurchasesLineTable.SetRange("Document No.", ProposalNumber);
                                PurchasesLineTable.SetRange("Line No.", LineNo);
                                PurchasesLineTable.SetRange("Line Type", PurchasesLineTable."Line Type"::Activity);
                                if PurchasesLineTable.Find('-') then begin
                                    PurchasesLineTable."Expected Receipt Date" := DateExpected;
                                    PurchasesLineTable."Description 3" := Activity;
                                    PurchasesLineTable."Unit of Measure" := Duration;
                                    PurchasesLineTable."Description 2" := Output;
                                    PurchasesLineTable.Modify();
                                end else begin
                                    PurchasesLineTable.Reset();
                                    PurchasesLineTable.SetRange("Document No.", ProposalNumber);
                                    if PurchasesLineTable.FindLast() then begin
                                        LineNo := PurchasesLineTable."Line No." + 100;
                                        PurchasesLineTable.Init();
                                        PurchasesLineTable."Line No." := LineNo;
                                        PurchasesLineTable.Type := PurchasesLineTable.Type::Item;
                                        PurchasesLineTable."Line Type" := PurchasesLineTable."line type"::Activity;
                                        PurchasesLineTable."Document No." := ProposalNumber;
                                        PurchasesLineTable."Expected Receipt Date" := DateExpected;
                                        PurchasesLineTable."Description 3" := Activity;
                                        PurchasesLineTable."Unit of Measure" := Duration;
                                        PurchasesLineTable."Description 2" := Output;
                                        PurchasesLineTable.Insert();
                                    end else begin
                                        LineNo := 100;
                                        PurchasesLineTable.Init();
                                        PurchasesLineTable."Line No." := LineNo;
                                        PurchasesLineTable.Type := PurchasesLineTable.Type::Item;
                                        PurchasesLineTable."Line Type" := PurchasesLineTable."line type"::Activity;
                                        PurchasesLineTable."Document No." := ProposalNumber;
                                        PurchasesLineTable."Expected Receipt Date" := DateExpected;
                                        PurchasesLineTable."Description 3" := Activity;
                                        PurchasesLineTable."Unit of Measure" := Duration;
                                        PurchasesLineTable."Description 2" := Output;
                                        PurchasesLineTable.Insert();
                                    end;
                                end;
                            end;
                        end;
                    end;
                    exit(Format(AddResponseHead(outputjson, true)));
                end;

            'budget_info':
                begin
                    RequestJson.Get('mission_proposal_budgetinfo', JsonToken);
                    MissionLines := JsonToken.AsArray();
                    if MissionLines.Count() > 0 then begin
                        foreach JsonToken in MissionLines do begin
                            if JsonToken.IsObject() then begin
                                MissionLine := JsonToken.AsObject();
                                if MissionLine.Get('line_no', JsonToken) and not JsonToken.AsValue().IsNull() then
                                    LineNo := JsonToken.AsValue().AsInteger()
                                else
                                    LineNo := 0;

                                if MissionLine.Get('budget_item', JsonToken) and not JsonToken.AsValue().IsNull() then
                                    BudgetItem := JsonToken.AsValue().AsText();
                                if MissionLine.Get('identified_vendor', JsonToken) and not JsonToken.AsValue().IsNull() then
                                    IdentifiedVendor := JsonToken.AsValue().AsText();
                                if MissionLine.Get('mission_expense_category', JsonToken) and not JsonToken.AsValue().IsNull() then
                                    ExpenseCategory := JsonToken.AsValue().AsText();
                                if MissionLine.Get('budget_justification', JsonToken) and not JsonToken.AsValue().IsNull() then
                                    BudgetJustification := JsonToken.AsValue().AsText();
                                if MissionLine.Get('no_of_days', JsonToken) and not JsonToken.AsValue().IsNull() then
                                    NoOfDays := JsonToken.AsValue().AsDecimal();
                                if MissionLine.Get('no_of_pax', JsonToken) and not JsonToken.AsValue().IsNull() then
                                    NoOfPax := JsonToken.AsValue().AsDecimal();
                                if MissionLine.Get('ksh', JsonToken) and not JsonToken.AsValue().IsNull() then
                                    Ksh := JsonToken.AsValue().AsDecimal();
                                if MissionLine.Get('total_ksh', JsonToken) and not JsonToken.AsValue().IsNull() then
                                    TotalKsh := JsonToken.AsValue().AsDecimal();

                                PurchasesLineTable.Reset();
                                PurchasesLineTable.SetRange("Document No.", ProposalNumber);
                                PurchasesLineTable.SetRange("Line No.", LineNo);
                                PurchasesLineTable.SetRange("Line Type", PurchasesLineTable."Line Type"::"Budget Info");
                                if PurchasesLineTable.Find('-') then begin
                                    PurchasesLineTable."Description 3" := BudgetItem;
                                    PurchasesLineTable."Description 2" := IdentifiedVendor;
                                    PurchasesLineTable."No of days" := NoOfDays;
                                    PurchasesLineTable."No of pax" := NoOfPax;
                                    PurchasesLineTable.Ksh := Ksh;
                                    PurchasesLineTable."Total Ksh" := TotalKsh;
                                    PurchasesLineTable."Description 6" := BudgetJustification;
                                    PurchasesLineTable."Mission Expense Category" := ExpenseCategory;
                                    if PurchasesHeaderTable.get(PurchasesHeaderTable."Document Type"::Quote, ProposalNumber) then
                                        PurchasesLineTable."Currency Code" := PurchasesHeaderTable."Currency Code";
                                    PurchasesLineTable.Modify();
                                end else begin
                                    PurchasesLineTable.Reset();
                                    PurchasesLineTable.SetRange("Document No.", ProposalNumber);
                                    if PurchasesLineTable.FindLast() then begin
                                        LineNo := PurchasesLineTable."Line No." + 100;
                                        PurchasesLineTable.Init();
                                        PurchasesLineTable."Line No." := LineNo;
                                        PurchasesLineTable.Type := PurchasesLineTable.Type::Item;
                                        PurchasesLineTable."Line Type" := PurchasesLineTable."line type"::"Budget Info";
                                        PurchasesLineTable."Document No." := ProposalNumber;
                                        PurchasesLineTable."Description 3" := BudgetItem;
                                        PurchasesLineTable."Description 2" := IdentifiedVendor;
                                        PurchasesLineTable."No of days" := NoOfDays;
                                        PurchasesLineTable."No of pax" := NoOfPax;
                                        PurchasesLineTable.Ksh := Ksh;
                                        PurchasesLineTable."Total Ksh" := TotalKsh;
                                        PurchasesLineTable."Description 6" := BudgetJustification;
                                        PurchasesLineTable."Mission Expense Category" := ExpenseCategory;
                                        if PurchasesHeaderTable.get(PurchasesHeaderTable."Document Type"::Quote, ProposalNumber) then
                                            PurchasesLineTable."Currency Code" := PurchasesHeaderTable."Currency Code";
                                        PurchasesLineTable.Insert();
                                    end else begin
                                        LineNo := 100;
                                        PurchasesLineTable.Init();
                                        PurchasesLineTable."Line No." := LineNo;
                                        PurchasesLineTable.Type := PurchasesLineTable.Type::Item;
                                        PurchasesLineTable."Line Type" := PurchasesLineTable."line type"::"Budget Info";
                                        PurchasesLineTable."Document No." := ProposalNumber;
                                        PurchasesLineTable."Description 3" := BudgetItem;
                                        PurchasesLineTable."Description 2" := IdentifiedVendor;
                                        PurchasesLineTable."No of days" := NoOfDays;
                                        PurchasesLineTable."No of pax" := NoOfPax;
                                        PurchasesLineTable.Ksh := Ksh;
                                        PurchasesLineTable."Total Ksh" := TotalKsh;
                                        PurchasesLineTable."Description 6" := BudgetJustification;
                                        PurchasesLineTable."Mission Expense Category" := ExpenseCategory;
                                        if PurchasesHeaderTable.get(PurchasesHeaderTable."Document Type"::Quote, ProposalNumber) then
                                            PurchasesLineTable."Currency Code" := PurchasesHeaderTable."Currency Code";
                                        PurchasesLineTable.Insert();
                                    end;
                                end;
                            end;
                        end;
                    end;
                    exit(Format(AddResponseHead(outputjson, true)));
                end;
        end;

    end;

    procedure DeleteLines(arguments: Text): Text
    var
        RequestJson: JsonObject;
        OutputJson: JsonObject;
        JsonToken: JsonToken;

        OptionType: code[10];
    begin
        Clear(RequestJson);
        Clear(OutputJson);
        if not RequestJson.ReadFrom(arguments) then
            Error('Invalid JSON input');
        RequestJson.Get('line_type', JsonToken);
        OptionType := JsonToken.AsValue().AsText();

        if OptionType = '1' then begin//Mission Proposal Line
            PurchasesLineTable.Reset();
            if RequestJson.Get('line_no', JsonToken) and not JsonToken.AsValue().IsNull then begin
                PurchasesLineTable.SetRange("Line No.", JsonToken.AsValue().AsInteger());
                if RequestJson.Get('element_number', JsonToken) and not JsonToken.AsValue().IsNull then
                    PurchasesLineTable.SetRange("Document No.", JsonToken.AsValue().AsText());
                if PurchasesLineTable.Find('-') then begin
                    if PurchasesLineTable.Delete() then
                        exit(Format(AddResponseHead(OutputJson, true)));
                end;
            end;
        end;
    end;

    procedure UploadDocument(OriginalFileName: Text; FileExtension: text; SavedPath: text; ElementNumber: Code[50]): Text
    var
        DocumentsTable: Record "Portal Documents";
        outputjson: JsonObject;
    begin
        DocumentsTable.Init();
        DocumentsTable."Original File Name" := OriginalFileName;
        DocumentsTable."File Extension" := FileExtension;
        DocumentsTable."Original File Path" := SavedPath;
        DocumentsTable."Document Number" := ElementNumber;
        DocumentsTable."Local Url" := FileExtension.Replace('C:\inetpub\wwwroot\StaffPortal\Portal\PortalDocuments', 'https://self-service.tikenya.org\PortalDocuments');
        if DocumentsTable.Insert(true) then begin
            UpdateDocumentsWithPosition();
            exit(Format(AddResponseHead(outputjson, true)));
        end;
    end;

    procedure UpdateDocumentsWithPosition(): Text
    var
        DocumentsTable: Record "Portal Documents";
        OldPath: Text;
        NewPath: Text;
        LeftPart: Text;
        RightPart: Text;
        StartPos: Integer;
        LengthOfOldPath: Integer;
    begin
        // OldPath := 'C:/inetpub/wwwroot/StaffPortalDocuments/';
        OldPath := 'C:\inetpub\wwwroot\StaffPortal\Portal\PortalDocuments';
        NewPath := 'https://self-service.tikenya.org\PortalDocuments';
        LengthOfOldPath := StrLen(OldPath);

        DocumentsTable.Reset();
        if DocumentsTable.Find('-') then begin
            repeat
                StartPos := StrPos(DocumentsTable."Original File Path", OldPath);

                if StartPos > 0 then begin

                    LeftPart := CopyStr(DocumentsTable."Original File Path", 1, StartPos - 1);

                    RightPart := CopyStr(DocumentsTable."Original File Path", StartPos + LengthOfOldPath);

                    DocumentsTable."Local Url" := LeftPart + NewPath + RightPart;
                    // DocumentsTable.Description := DocumentsTable."Original File Name";

                    DocumentsTable.Modify();
                end;
            until DocumentsTable.Next() = 0;

            exit('success. Right' + LeftPart + NewPath + RightPart);
        end;
        exit('failure' + RightPart + LeftPart);
    end;

    procedure RetrieveDocumentsForelement(ElementNumber: code[100]): Text
    var
        document: JsonObject;
        documents: JsonArray;
        DocumentsTable: Record "Portal Documents";
        outputjson: JsonObject;
    begin
        DocumentsTable.Reset();
        DocumentsTable.SetRange("Document Number", ElementNumber);
        if DocumentsTable.FindSet() then begin
            Clear(outputjson);
            Clear(documents);
            outputjson := AddResponseHead(outputjson, true);
            repeat
                Clear(document);
                document.Add('entry_no', DocumentsTable."Line No");
                document.Add('title', DocumentsTable."Original File Name");
                document.Add('path', DocumentsTable."Original File Path");
                document.Add('type', DocumentsTable."File Extension");
                documents.Add(document);
            until DocumentsTable.Next() = 0;
            outputjson.Add('uploaded_documents', documents);
            exit(Format(outputjson));
        end;
        exit(Format(AddResponseHead(outputjson, false)));
    end;

    local procedure PettyCashBanks(): Text
    var
        ObjBank: Record "Bank Account";
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        Outputjson: JsonObject;
        BatchTable: Record "Gen. Journal Batch";
    begin
        Clear(Outputjson);
        Clear(JsonArray);
        ObjBank.Reset;
        if ObjBank.FindFirst() then
            repeat
                Clear(JsonObject);
                JsonObject.Add('Code', ObjBank."No.");
                JsonObject.Add('Name', ObjBank.Name);
                JsonArray.Add(JsonObject);
            until ObjBank.Next() = 0;

        Outputjson.Add('pettycash_banks', JsonArray);

        Clear(JsonArray);
        BatchTable.RESET;
        BatchTable.SETRANGE("Journal Template Name", 'PAYMENTS');
        IF BatchTable.FINDFIRST THEN
            REPEAT
                Clear(JsonObject);
                JsonObject.Add('Code', BatchTable.Name);
                JsonObject.Add('Name', BatchTable.Description);
                JsonArray.Add(JsonObject);
            UNTIL BatchTable.NEXT = 0;

        Outputjson.Add('pettycash_batches', JsonArray);
        outputjson.Add('gl_accounts', GetGLAccounts('5'));
        outputjson.Add('fund_codes', GetDimensionValues('1', ''));
        outputjson.add('currencies', GetCurrencies());

        exit(format(AddResponseHead(Outputjson, true)));
    end;

    local procedure GetPettyCashLines(empno: Code[20]; payingBank: Code[60]; template: code[60]): Text
    var
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        OutputJson: JsonObject;
        UserSetup: Record "User Setup";
        templatename: Code[100];
        GenJournalLine: Record "Gen. Journal Line";
    begin

        EmployeeTable.Reset;
        if EmployeeTable.Get(empno) then begin
            UserSetup.Reset;
            if UserSetup.Get(EmployeeTable."User ID") then
                templatename := UserSetup."Payments Batch"
            else
                templatename := EmployeeTable."Payments Batch";
        end;

        Clear(JsonArray);
        GenJournalLine.Reset;
        GenJournalLine.SetFilter("Journal Template Name", 'PAYMENTS');
        GenJournalLine.SetFilter("Journal Batch Name", template);
        GenJournalLine.SetRange("Bal. Account No.", payingBank);
        if GenJournalLine.Find('-') then
            repeat
                Clear(JsonObject);
                JsonObject.Add('Description', GenJournalLine.Description);
                JsonObject.Add('GLAccount', GenJournalLine."Account No.");
                JsonObject.Add('FundCode', GenJournalLine."Shortcut Dimension 1 Code");
                JsonObject.Add('PostingDate', GenJournalLine."Posting Date");
                JsonObject.Add('DocumentNo', GenJournalLine."Document No.");
                JsonObject.Add('PayingBank', payingBank);
                JsonObject.Add('Amount', GenJournalLine.Amount);
                JsonObject.Add('LineNo', GenJournalLine."Line No.");
                JsonObject.Add('Currency', GenJournalLine."Currency Code");

                JsonArray.Add(JsonObject);
            until GenJournalLine.Next = 0;

        OutputJson.Add('pettycash_lines', JsonArray);
        exit(Format(AddResponseHead(OutputJson, true)));

    end;

    local procedure PettyCashInsertGLLine(EmployeeId: code[20]; RequestJson: JsonObject): Text
    var
        usertemplate: Code[50];
        lineno: Integer;
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalLine2: Record "Gen. Journal Line";
        UserSetup: Record "User Setup";

        jsontoken: JsonToken;
        DocumentNo: code[100];
        outputjson: jsonobject;
    begin
        EmployeeTable.Reset;
        EmployeeTable.SetRange("No.", EmployeeID);
        if EmployeeTable.Find('-') then begin


            if UserSetup.Get(EmployeeTable."User ID") then begin
                usertemplate := UserSetup."Payments Batch";
            end else begin
                usertemplate := EmployeeTable."Payments Batch";
            end;
            //GenJournalLine2.
            lineno := GenJournalLine2.Count() + 2000;
            GenJournalLine.Init;
            GenJournalLine."Line No." := lineno;
            if RequestJson.Get('BatchCode', jsontoken) and not jsontoken.AsValue().IsNull then
                usertemplate := jsontoken.AsValue().AsText();
            GenJournalLine."Journal Batch Name" := usertemplate;
            GenJournalLine."Journal Template Name" := 'PAYMENTS';
            if RequestJson.Get('Description', jsontoken) and not jsontoken.AsValue().IsNull then
                GenJournalLine.Description := jsontoken.AsValue().AsText();
            if RequestJson.Get('Amount', jsontoken) and not jsontoken.AsValue().IsNull then
                GenJournalLine.Amount := jsontoken.AsValue().AsDecimal();
            if RequestJson.Get('GLAccount', jsontoken) and not jsontoken.AsValue().IsNull then
                GenJournalLine."Account No." := jsontoken.AsValue().AsText();
            if RequestJson.Get('Currency', jsontoken) and not jsontoken.AsValue().IsNull then
                GenJournalLine."Currency Code" := jsontoken.AsValue().AsText();
            // GenJournalLine.Validate("Currency Code");
            if RequestJson.Get('FundCode', jsontoken) and not jsontoken.AsValue().IsNull then
                GenJournalLine."Shortcut Dimension 1 Code" := jsontoken.AsValue().AsText();
            if RequestJson.Get('DocumentNo', jsontoken) and not jsontoken.AsValue().IsNull then
                DocumentNo := jsontoken.AsValue().AsText();
            GenJournalLine."Document No." := DocumentNo;
            GenJournalLine.Validate("Document No.");
            GenJournalLine.Validate("Journal Template Name");
            if RequestJson.Get('PostingDate', jsontoken) and not jsontoken.AsValue().IsNull then
                GenJournalLine."Posting Date" := System.DT2Date(jsontoken.AsValue().AsDateTime());
            // GenJournalLine.Validate("Posting Date");
            GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::"Bank Account";
            if RequestJson.Get('PayingBank', jsontoken) and not jsontoken.AsValue().IsNull then
                GenJournalLine."Bal. Account No." := jsontoken.AsValue().AsText();
            //GenJournalLine.VALIDATE("Bal. Account No.");
            //GenJournalLine.VALIDATE("Bal. Account Type");
            // GenJournalLine.Validate(Amount);
            if GenJournalLine.Amount <> 0 then begin
                GenJournalLine2.Reset;
                GenJournalLine2.SetRange("Document No.", DocumentNo);
                if not GenJournalLine2.Find('-') then
                    if GenJournalLine.Insert() then
                        exit(Format(AddResponseHead(outputjson, true)));
            end;
        end;

        exit(Format(AddResponseHead(outputjson, false)));
    end;

    procedure RetrieveDocumentPath(LineID: Integer): Text
    var
        document: JsonObject;
        DocumentsTable: Record "Portal Documents";
    begin
        DocumentsTable.Reset();
        DocumentsTable.SetRange("Line No", LineID);
        if DocumentsTable.Find('-') then begin
            repeat
                Clear(document);
                document.Add('entry_no', DocumentsTable."Line No");
                document.Add('title', DocumentsTable."Original File Name");
                document.Add('path', DocumentsTable."Original File Path");
                document.Add('type', DocumentsTable."File Extension");
            until DocumentsTable.Next() = 0;
            exit(Format(document));
        end;
    end;

    procedure GetLeaveTypeBalance(empNo: Code[50]; leavetype: Code[50]) balance: Decimal
    begin
        EmployeeTable.Reset;
        EmployeeTable.SetRange("No.", empNo);
        if EmployeeTable.Find('-') then begin
            EmployeeTable.CalcFields("Maternity Leave Acc.", "Paternity Leave Acc.", "Annual Leave Account", "Compassionate Leave Acc.", "Sick Leave Acc.", "Study Leave Acc", "CTO  Leave Acc.");
            if leavetype = 'COMPASSIONATE' then
                balance := (EmployeeTable."Compassionate Leave Acc.");
            if leavetype = 'EXAM' then
                balance := (EmployeeTable."Study Leave Acc");
            if leavetype = 'MATERNITY' then
                balance := (EmployeeTable."Maternity Leave Acc.");
            if leavetype = 'PATERNITY' then
                balance := (EmployeeTable."Paternity Leave Acc.");
            if leavetype = 'ANNUAL' then
                balance := (EmployeeTable."Annual Leave Account");
            if leavetype = 'SICK' then
                balance := (EmployeeTable."Sick Leave Acc.");
            if leavetype = 'SPECIAL LEAVE' then
                balance := (EmployeeTable."CTO  Leave Acc.");
            if leavetype = 'STUDY' then
                balance := (EmployeeTable."Study Leave Acc");
        end;
    end;

    //Documents Section
    procedure StaffPayslipDocument(EmployeeNo: Code[20]; PayPeriod: Date; var Base64Txt: Text)
    var
        Filename: Text[100];
        TempBlob: Codeunit "Temp Blob";
        StatementOutstream: OutStream;
        StatementInstream: InStream;
        PayslipReport: Report 80011;
        Base64Convert: Codeunit "Base64 Convert";
        PayrollEmployee: Record "Payroll Employee_AU";
        PayrollDate: Record "Payroll Calender_AU";
    begin
        EmployeeTable.Reset;
        EmployeeTable.SetRange("No.", EmployeeNo);
        if EmployeeTable.Find('-') then begin
            // PayrollDate.Reset();
            // PayrollDate.SetFilter("Date Opened", '%1', PayPeriod);
            // PayrollDate.Find();
            PayrollEmployee.Reset();
            PayrollEmployee.SetFilter("No.", '%1', EmployeeTable."No.");
            PayrollEmployee.SetFilter("Period Filter", '%1', PayPeriod);
            if PayrollEmployee.Find('-') then begin
                PayslipReport.SetTableView(PayrollEmployee);
                // PayslipReport.SetTableView(PayrollDate);
                TempBlob.CreateOutStream(StatementOutstream);
                if PayslipReport.SaveAs('', ReportFormat::Pdf, StatementOutstream) then begin
                    TempBlob.CreateInStream(StatementInstream);
                    Base64Txt := Base64Convert.ToBase64(StatementInstream, true);
                end;
            end

        end;
    end;

    procedure StaffP9Document(EmployeeNo: Code[20]; SelectedYear: Integer; var Base64Txt: Text)
    var
        Filename: Text[100];
        TempBlob: Codeunit "Temp Blob";
        StatementOutstream: OutStream;
        StatementInstream: InStream;
        P9Report: Report 80034;
        Base64Convert: Codeunit "Base64 Convert";
        PayrollEmployee: Record "Payroll Employee P9_AU";
    // Path: DotNet Path;
    begin
        // Filename := Path.GetTempPath() + Path.GetRandomFileName();
        EmployeeTable.Reset;
        EmployeeTable.SetRange("No.", EmployeeNo);
        if EmployeeTable.Find('-') then begin
            PayrollEmployee.Reset();
            PayrollEmployee.SetFilter("Period Year", '%1', SelectedYear);
            if PayrollEmployee.Find('-') then begin
                P9Report.SetTableView(PayrollEmployee);
                P9Report.SetTableView(EmployeeTable);
                TempBlob.CreateOutStream(StatementOutstream);
                if P9Report.SaveAs('', ReportFormat::Pdf, StatementOutstream) then begin
                    TempBlob.CreateInStream(StatementInstream);
                    Base64Txt := Base64Convert.ToBase64(StatementInstream, true);
                end;
            end

        end;
    end;

    procedure StaffImprestStatement(EmployeeNo: Code[20]; var Base64Txt: Text)
    var
        Filename: Text[100];
        TempBlob: Codeunit "Temp Blob";
        StatementOutstream: OutStream;
        StatementInstream: InStream;
        ImprestReport: Report 80038;
        Base64Convert: Codeunit "Base64 Convert";
        CustomerTable: record Customer;
    // Path: DotNet Path;
    begin
        // Filename := Path.GetTempPath() + Path.GetRandomFileName();
        EmployeeTable.Reset;
        EmployeeTable.SetRange("No.", EmployeeNo);
        if EmployeeTable.Find('-') then begin
            CustomerTable.Reset();
            CustomerTable.SetRange("No.", EmployeeTable.Travelaccountno);
            if CustomerTable.Find('-') then begin
                ImprestReport.SetTableView(CustomerTable);
                TempBlob.CreateOutStream(StatementOutstream);
                if ImprestReport.SaveAs('', ReportFormat::Pdf, StatementOutstream) then begin
                    TempBlob.CreateInStream(StatementInstream);
                    Base64Txt := Base64Convert.ToBase64(StatementInstream, true);
                end;
            end

        end;
    end;

    procedure StaffLeaveStatement(EmployeeNo: Code[20]; var Base64Txt: Text)
    var
        Filename: Text[100];
        TempBlob: Codeunit "Temp Blob";
        StatementOutstream: OutStream;
        StatementInstream: InStream;
        LeaveStatementReport: Report 80029;
        Base64Convert: Codeunit "Base64 Convert";
        PayrollEmployee: Record "Payroll Employee_AU";
    begin
        EmployeeTable.Reset;
        EmployeeTable.SetRange("No.", EmployeeNo);
        if EmployeeTable.Find('-') then begin
            LeaveStatementReport.SetTableView(EmployeeTable);
            TempBlob.CreateOutStream(StatementOutstream);
            if LeaveStatementReport.SaveAs('', ReportFormat::Pdf, StatementOutstream) then begin
                TempBlob.CreateInStream(StatementInstream);
                Base64Txt := Base64Convert.ToBase64(StatementInstream, true);
            end;
        end

    end;



    //Helper Functions
    local procedure AddResponseHead(OutputJson: JsonObject; status: Boolean): JsonObject
    begin
        if status = true then begin
            OutputJson.add('response_status', 'true');
            OutputJson.add('response_code', 200);
            exit(OutputJson);
        end else begin
            OutputJson.add('response_status', 'false');
            OutputJson.add('response_code', 404);
            exit(OutputJson);
        end;
        ;
    end;

    local procedure GetLeaveDescription(leavecode: code[50]): Text

    begin
        HRLeaveTypesTable.Reset;
        HRLeaveTypesTable.SetRange(Code, leavecode);
        if HRLeaveTypesTable.Find('-') then begin
            exit(HRLeaveTypesTable.Description);
        end;
    end;

    local procedure GetEmployeeFullName(): Text
    begin
        if EmployeeTable."Middle Name" = '' then
            exit(EmployeeTable."First Name" + ' ' + EmployeeTable."Last Name");
        exit(EmployeeTable."First Name" + ' ' + EmployeeTable."Middle Name" + ' ' + EmployeeTable."Last Name");
    end;

    procedure FnValidateStartDate("Start Date": Date)
    var
    begin
        BaseCalendar.Reset;
        BaseCalendar.SetFilter(BaseCalendar."Base Calendar Code", HrSetUpTable."Base Calendar");
        BaseCalendar.SetRange(BaseCalendar.Date, "Start Date");
        if BaseCalendar.Find('-') then begin
            repeat
                if BaseCalendar.Nonworking = true then begin
                    if BaseCalendar.Description <> '' then
                        Error('You can not start your Leave on a Holiday - ''' + BaseCalendar.Description + '''')
                    else
                        Error('You can not start your Leave on a Holiday');
                end;
            until BaseCalendar.Next = 0;
        end;

        // For Annual Holidays
        BaseCalendar.Reset;
        BaseCalendar.SetFilter(BaseCalendar."Base Calendar Code", HrSetUpTable."Base Calendar");
        BaseCalendar.SetRange(BaseCalendar."Recurring System", BaseCalendar."recurring system"::"Annual Recurring");
        if BaseCalendar.Find('-') then begin
            repeat
                if ((Date2dmy("Start Date", 1) = BaseCalendar.Day)) then begin
                    if BaseCalendar.Nonworking = true then begin
                        if BaseCalendar.Description <> '' then
                            Error('You can not start your Leave on a Holiday - ''' + BaseCalendar.Description + '''')
                        else
                            Error('You can not start your Leave on a Holiday');
                    end;
                end;
            until BaseCalendar.Next = 0;
        end;
    end;

    procedure DetermineLeaveReturnDate(fBeginDate: Date; fDays: Decimal; "Leave Type": Code[100]) fReturnDate: Date
    var
        varDaysApplied: Decimal;
    begin
        HRLeaveTypesTable.Reset;
        HRLeaveTypesTable.SetRange(Code, "Leave Type");
        if HRLeaveTypesTable.Find('-') then begin
            varDaysApplied := fDays;
            fReturnDate := fBeginDate;
            repeat
                if DetermineIfIncludesNonWorking("Leave Type") = false then begin
                    fReturnDate := CalcDate('1D', fReturnDate);
                    if DetermineIfIsNonWorking(fReturnDate, HRLeaveTypesTable) then
                        varDaysApplied := varDaysApplied + 1
                    else
                        varDaysApplied := varDaysApplied;
                    varDaysApplied := varDaysApplied - 1
                end
                else begin
                    fReturnDate := CalcDate('1D', fReturnDate);
                    varDaysApplied := varDaysApplied - 1;
                end;
            until varDaysApplied = 0;
        end;
        exit(fReturnDate);
    end;

    local procedure DetermineIfIncludesNonWorking(fLeaveCode: Code[100]): Boolean
    begin
        if HRLeaveTypesTable.Get(fLeaveCode) then begin
            if HRLeaveTypesTable."Inclusive of Non Working Days" = true then
                exit(true);
        end;
    end;

    local procedure DetermineIfIsNonWorking(bcDate: Date; var ltype: Record "HR Leave Types") ItsNonWorking: Boolean
    var
        dates: Record Date;
    begin
        Clear(ItsNonWorking);
        HrSetUpTable.Find('-');
        //One off Hollidays like Good Friday
        BaseCalendar.Reset;
        BaseCalendar.SetFilter(BaseCalendar."Base Calendar Code", HrSetUpTable."Base Calendar");
        BaseCalendar.SetRange(BaseCalendar.Date, bcDate);
        if BaseCalendar.Find('-') then begin
            if BaseCalendar.Nonworking = true then
                ItsNonWorking := true;
        end;

        // For Annual Holidays
        BaseCalendar.Reset;
        BaseCalendar.SetFilter(BaseCalendar."Base Calendar Code", HrSetUpTable."Base Calendar");
        BaseCalendar.SetRange(BaseCalendar."Recurring System", BaseCalendar."recurring system"::"Annual Recurring");
        if BaseCalendar.Find('-') then begin
            repeat
                if ((Date2dmy(bcDate, 1) = BaseCalendar.Day)) then begin
                    if BaseCalendar.Nonworking = true then
                        ItsNonWorking := true;
                end;
            until BaseCalendar.Next = 0;
        end;

        if ItsNonWorking = false then begin
            // Check if its a weekend
            dates.Reset;
            dates.SetRange(dates."Period Type", dates."period type"::Date);
            dates.SetRange(dates."Period Start", bcDate);
            if dates.Find('-') then begin
                //if date is a sunday
                if dates."Period Name" = 'Sunday' then begin
                    //check if Leave includes sunday
                    if ltype."Inclusive of Sunday" = false then ItsNonWorking := true;
                end else
                    if dates."Period Name" = 'Saturday' then begin
                        //check if Leave includes sato
                        if ltype."Inclusive of Saturday" = false then ItsNonWorking := true;
                    end;
            end;
        end;

    end;

    procedure CurrentTime(): Text
    begin
        exit(format(time + (3 * 60 * 60 * 1000)));
    end;

    procedure CalcEndDate(SDate: Date; LDays: Decimal; varLType: Code[100]) LEndDate: Date
    var
        EndLeave: Boolean;
        DayCount: Decimal;
        ltype: Record "HR Leave Types";
    begin
        if ltype.Get(varLType) then begin
            SDate := SDate;
            DayCount := LDays;
            EndLeave := false;
            while EndLeave = false do begin
                if not DetermineIfIsNonWorking(SDate, ltype) then begin
                    DayCount := DayCount - 1;
                    SDate := SDate + 1;
                end
                else
                    SDate := SDate + 1;
                if DayCount = 0 then
                    EndLeave := true;
            end;
            LEndDate := SDate - 1;

            while DetermineIfIsNonWorking(LEndDate, ltype) = true do begin
                LEndDate := LEndDate + 1;
            end;
        end;

    end;
}