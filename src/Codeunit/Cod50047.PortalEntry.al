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
        lJsonArray: JsonArray;
        lJObject: JsonObject;


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

        exit(Format(AddResponseHead(OutputJson, false)));
    end;


    procedure RetrieveInformation(args: Text): Text
    var
        RequestJson: JsonObject;
        JsonToken: JsonToken;

        RequestType: Text;
        IdentifierType: Text;
        RequestEmployeeID: Text;

        outputjson: JsonObject;
    begin
        Clear(RequestJson);
        if not RequestJson.ReadFrom(args) then
            Error('Invalid JSON input');

        RequestJson.Get('request_type', JsonToken);
        RequestType := JsonToken.AsValue().AsText();
        RequestJson.Get('identifier_type', JsonToken);
        IdentifierType := JsonToken.AsValue().AsText();
        RequestJson.Get('employee_id', JsonToken);
        RequestEmployeeID := JsonToken.AsValue().AsText();

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

        exit(Format(AddResponseHead(OutputJson, false)));
    end;

    procedure SubmitNewInformation(args: Text): Text
    var
        RequestJson: JsonObject;
        JsonToken: JsonToken;

        SubmissionType: Text;
        ElementInformation: JsonObject;
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
            RequestJson.Get('mission_proposal_line', JsonToken);
            ElementInformation := JsonToken.AsObject();
            exit(UpdateMissionProposalLines(ElementInformation));
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
        PurchasesHeaderTable.SetRange("Employee No", EmployeeNumber);
        // PurchasesHeaderTable.SetRange(Status, PurchasesHeaderTable.Status::Released);
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
                PurchasesHeaderTable.SetAscending("No.", false);
                PurchasesHeaderTable.SetRange("Employee No", EmployeeTable."No.");
                // PurchasesHeaderTable.SetRange(pr, true);
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
                        purchaserequisition.add('request_date', PurchasesHeaderTable."Order Date");
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

            exit(format(outputjson));
        end;
        exit(Format(AddResponseHead(outputjson, false)));
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
                // PurchasesHeaderTable.SetRange(PM, true);
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
        CurrencyCode: Code[100];
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
        RequestJson.Get('currency_code', JsonToken);
        CurrencyCode := JsonToken.AsValue().AsText();

        EmployeeTable.Reset();
        EmployeeTable.SetRange("No.", StaffID);
        if EmployeeTable.Find('-') then begin
            PurchasesandPayablesSetup.Get();
            PurchasesHeaderTable.Init();
            PurchasesHeaderTable."No." := NumberSeries.GetNextNo(PurchasesandPayablesSetup."Imprest Nos.", Today, true);
            PurchasesHeaderTable."Employee No" := StaffID;
            PurchasesHeaderTable.Validate("Employee No");
            PurchasesHeaderTable."Document Type" := PurchasesHeaderTable."Document Type"::Quote;
            PurchasesHeaderTable.IM := true;
            PurchasesHeaderTable."Posting Date" := Today;
            PurchasesHeaderTable."Posting Description" := Purpose;
            PurchasesHeaderTable."Shortcut Dimension 1 Code" := FundCode;
            PurchasesHeaderTable."Shortcut Dimension 2 Code" := ProgramCode;
            PurchasesHeaderTable."Shortcut Dimension 3 Code" := BudgetCode;
            PurchasesHeaderTable."Shortcut Dimension 5 Code" := DepartmentCode;
            PurchasesHeaderTable.Status := PurchasesHeaderTable.Status::Open;
            PurchasesHeaderTable."Account No" := EmployeeTable.Travelaccountno;
            PurchasesHeaderTable."Responsibility Center" := EmployeeTable."User ID";
            PurchasesHeaderTable."Assigned User ID" := EmployeeTable."User ID";
            PurchasesHeaderTable."User ID" := EmployeeTable."User ID";
            PurchasesHeaderTable."Requested Receipt Date" := Today;
            PurchasesHeaderTable."Buy-from Vendor No." := 'FM-V00052';
            PurchasesHeaderTable."Vendor Posting Group" := 'TRADERS';

            // PurchasesHeaderTable.Validate("Shortcut Dimension 1 Code");
            // PurchasesHeaderTable.Validate("Shortcut Dimension 2 Code");
            // PurchasesHeaderTable.Validate("Shortcut Dimension 3 Code");
            // PurchasesHeaderTable.Validate("Shortcut Dimension 4 Code");
            PurchasesHeaderTable."Currency Code" := CurrencyCode;
            PurchasesHeaderTable.Validate("Currency Code");

            if (PurchasesHeaderTable.Insert(true) = true) then
                exit(Format(AddResponseHead(OutputJson, true)));
        end;
        exit(format(AddResponseHead(outputjson, false)));

    end;

    local procedure AmendImprestRequest(RequestJson: JsonObject): Text;
    var
        OutputJson: JsonObject;
        JsonToken: JsonToken;

        RequestNumber: Code[50];
        StaffID: Code[50];
        Purpose: Text;
        FundCode: Code[100];
        ProgramCode: Code[100];
        DepartmentCode: Code[100];
        BudgetCode: Code[100];
        CurrencyCode: Code[100];
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
        RequestJson.Get('currency_code', JsonToken);
        CurrencyCode := JsonToken.AsValue().AsText();

        PurchasesHeaderTable.Reset();
        PurchasesHeaderTable.SetRange("No.", RequestNumber);
        if PurchasesHeaderTable.Find('-') then begin
            PurchasesHeaderTable."Posting Description" := Purpose;
            PurchasesHeaderTable."Shortcut Dimension 1 Code" := FundCode;
            PurchasesHeaderTable."Shortcut Dimension 2 Code" := ProgramCode;
            PurchasesHeaderTable."Shortcut Dimension 3 Code" := BudgetCode;
            PurchasesHeaderTable."Shortcut Dimension 5 Code" := DepartmentCode;
            PurchasesHeaderTable."Currency Code" := CurrencyCode;
            PurchasesHeaderTable.Validate("Currency Code");

            if PurchasesHeaderTable.modify(true) then
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
        GLAccount: Code[100];
        // Description: Text;
        ItemSpecification: Text;
        Quantity: Integer;
        UnitCost: Decimal;

        linespage: page "Imprest Subform";
    begin

        RequestJson.Get('imprest_number', JsonToken);
        ImprestNumber := JsonToken.AsValue().AsText();
        RequestJson.Get('line_no', JsonToken);
        LineNo := JsonToken.AsValue().AsInteger();
        RequestJson.Get('expense_category', JsonToken);
        ExpenseCategory := JsonToken.AsValue().AsText();
        RequestJson.Get('account_no', JsonToken);
        GLAccount := JsonToken.AsValue().AsText();
        // RequestJson.Get('description', JsonToken);
        // Description := JsonToken.AsValue().AsText();
        RequestJson.Get('item_specification', JsonToken);
        ItemSpecification := JsonToken.AsValue().AsText();
        RequestJson.Get('quantity', JsonToken);
        Quantity := JsonToken.AsValue().AsInteger();
        RequestJson.Get('unit_cost', JsonToken);
        UnitCost := JsonToken.AsValue().AsDecimal();

        PurchasesHeaderTable.Reset();
        PurchasesHeaderTable.SetRange("No.", ImprestNumber);
        if PurchasesHeaderTable.Find('-') then begin
            PurchasesLineTable.Reset();
            PurchasesLineTable.SetRange("Line No.", LineNo);
            PurchasesLineTable.SetRange("Document No.", PurchasesHeaderTable."No.");
            if PurchasesLineTable.Find('-') then begin
                PurchasesLineTable."No." := GLAccount;
                PurchasesLineTable.Validate("No.");

                if PurchasesLineTable.Modify(true) then begin
                    PurchasesLineTable.Reset();
                    PurchasesLineTable.SetRange("Line No.", LineNo);
                    PurchasesLineTable.SetRange("Document No.", PurchasesHeaderTable."No.");
                    if PurchasesLineTable.Find('-') then begin
                        PurchasesLineTable."Expense Category" := ExpenseCategory;
                        PurchasesLineTable."Document No." := PurchasesHeaderTable."No.";
                        PurchasesLineTable."Description 2" := ItemSpecification;
                        PurchasesLineTable.Quantity := Quantity;
                        PurchasesLineTable."Direct Unit Cost" := UnitCost;
                        PurchasesLineTable."Line Amount" := Quantity * UnitCost;
                        if PurchasesLineTable.Modify(true) then begin
                            RedistributeTotalsOnAfterValidate(PurchasesLineTable."Document Type", PurchasesLineTable."Document No.", PurchasesLineTable);
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
                PurchasesLineTable.Type := PurchasesLineTable.Type::"G/L Account";
                PurchasesLineTable."No." := GLAccount;
                PurchasesLineTable."Currency Code" := PurchasesHeaderTable."Currency Code";
                PurchasesLineTable."Direct Unit Cost" := UnitCost;
                PurchasesLineTable."Shortcut Dimension 1 Code" := PurchasesHeaderTable."Shortcut Dimension 1 Code";
                PurchasesLineTable."Shortcut Dimension 2 Code" := PurchasesHeaderTable."Shortcut Dimension 2 Code";
                // PurchasesLineTable.Validate(Type);
                PurchasesLineTable.Validate("No.");
                if PurchasesLineTable.Insert(true) then begin
                    PurchasesLineTable.Reset();
                    PurchasesLineTable.SetRange("Line No.", LineNo);
                    PurchasesLineTable.SetRange("Document No.", PurchasesHeaderTable."No.");
                    if PurchasesLineTable.Find('-') then begin
                        PurchasesLineTable."Expense Category" := ExpenseCategory;
                        PurchasesLineTable."Document No." := PurchasesHeaderTable."No.";
                        PurchasesLineTable."Description 2" := ItemSpecification;
                        PurchasesLineTable.Quantity := Quantity;
                        PurchasesLineTable."Direct Unit Cost" := UnitCost;
                        PurchasesLineTable."Line Amount" := Quantity * UnitCost;
                        // PurchasesLineTable.Validate("No.");

                        if PurchasesLineTable.Modify(true) then begin
                            RedistributeTotalsOnAfterValidate(PurchasesLineTable."Document Type", PurchasesLineTable."Document No.", PurchasesLineTable);
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
                PurchasesHeaderTable."No." := NumberSeries.GetNextNo(PurchasesandPayablesSetup."Surrender Nos.", Today, true);
                PurchasesHeaderTable."Employee No" := PurchasesTable2."Employee No";
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
                PurchasesHeaderTable."Buy-from Vendor No." := 'FM-V00052';
                PurchasesHeaderTable."Vendor Posting Group" := 'TRADERS';
                PurchasesHeaderTable."Currency Code" := PurchasesTable2."Currency Code";
                PurchasesHeaderTable."Mission Proposal No" := PurchasesTable2."Mission Proposal No";
                PurchasesHeaderTable."Responsibility Center" := EmployeeTable."User ID";
                PurchasesHeaderTable."Assigned User ID" := EmployeeTable."User ID";
                PurchasesHeaderTable."User ID" := EmployeeTable."User ID";
                PurchasesHeaderTable.Validate("Currency Code");

                if (PurchasesHeaderTable.Insert(true) = true) then begin
                    PurchaseLines2.Reset;
                    PurchaseLines2.SetRange("Document No.", ImprestNumber);
                    if PurchaseLines2.Find('-') then begin
                        repeat
                            PurchasesLineTable.Init;

                            LineNo := LineNo + 1000;
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
                            PurchasesLineTable.Insert(true);

                        until PurchaseLines2.Next = 0;
                    end;
                end;
            end;
            exit(Format(AddResponseHead(OutputJson, true)));
        end;

        exit(format(AddResponseHead(outputjson, false)));
    end;

    local procedure RedistributeTotalsOnAfterValidate(DocumentType: enum "Purchase Document Type"; DocumentNo: Code[20]; Rec: record "Purchase Line")
    var
        DocumentTotals: Codeunit "Document Totals";
        VATAmount: decimal;
        TotalPurchaseLine: Record "Purchase Line";
    begin

        PurchasesHeaderTable.Get(DocumentType, DocumentNo);
        if DocumentTotals.PurchaseCheckNumberOfLinesLimit(PurchasesHeaderTable) then
            DocumentTotals.PurchaseRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalPurchaseLine);
    end;

    procedure FnUpdateSetup(): Text
    begin
        PurchasesandPayablesSetup.Get();
        PurchasesandPayablesSetup."Payment Memo Nos." := 'PM';
        PurchasesandPayablesSetup.Modify();
        exit(PurchasesandPayablesSetup."Payment Memo Nos.");

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
                    exit(Format(OutputJson));
                end;
            end;
        end;
        exit(Format(AddResponseHead(OutputJson, false)));
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
    begin

        RequestJson.Get('employee_id', JsonToken);
        StaffID := JsonToken.AsValue().AsText();
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
                    line.Add('description', PurchasesLineTable."Description 2");
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

            exit(format(outputjson));
        end;
        exit(Format(AddResponseHead(outputjson, false)));
    end;


    local procedure UpdateMissionProposalLines(RequestJson: JsonObject): Text
    var
        MissionObjectives: JsonObject;
        RolesandResponsibilities: JsonObject;
        Activities: JsonObject;
        BudgetInformation: JsonObject;
        BudgetNotes: JsonObject;
        JsonToken: JsonToken;

    begin
        RequestJson.Get('mission', JsonToken);
        // ElementInformation := JsonToken.AsObject();
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