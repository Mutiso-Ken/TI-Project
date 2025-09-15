#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 80007 STAFFPortalIntegration
{

    trigger OnRun()
    begin
    end;

    var
        HREmployees: Record "HR Employees";
        objPayrollEmployee: Record "Payroll Employee_AU";
        GenLedgerSetup: Record "Purchases & Payables Setup";
        objHRLeaveApplication: Record "HR Leave Application";
        objHRSetup: Record "HR Setup";
        objNumSeries: Codeunit NoSeriesManagement;
        objHREmployees: Record "HR Employees";
        objUsers: Record "User Setup";
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        objCustomer: Record Customer;
        ObjApprovalEntries: Record "Approval Entry";
        CUApprovalMgt: Codeunit "Approvals Mgmt.";
        ObjPrPeriods: Record "Payroll Calender_AU";
        ObjHRLeaveTypes: Record "HR Leave Types";
        BaseCalendarChange: Record "Base Calendar Change";
        ObjImprestLines: Record "Purchase Line";
        RecPay: Record "Payment Terms";
        objHREmployees2: Record "HR Employees";
        filename: Text;
        FILESPATH: label 'E:\EMMANUEL PORTAL\CODFSTAFFPortal\Downloads\';
        FP: label 'E:\Payslips\';
        counter: Integer;
        SalCard: Record "Payroll Employee_AU";
        BaseCalendar: Record "Base Calendar Change";
        UserSetup: Record "User Setup";
        GeneralOptions: Record "HR Setup";
        variantrec: Variant;
        JSONTextWriter: Codeunit "Json Text Reader/Writer";

        JSON: Codeunit DotNet_String;
        StringWriter2: Codeunit DotNet_StreamWriter;

        StringBuilder: Codeunit DotNet_StringBuilder;


        //StringWriter: dotnet StringWriter;
        //StringBuilder: dotnet StringBuilder;
        AssignmentMatrix: Record "Payroll Transaction Code_AU";
        encrypt01: Codeunit "Cryptography Management";
        ecnryptedpassword: Text;
        purchaseheader: Record "Purchase Header";
        purchaseline: Record "Purchase Line";
        dimensionvalues: Record "Dimension Value";
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalLine2: Record "Gen. Journal Line";
        TrainingRequests: Record "Training Requests";
        hrsetup: Record "HR Setup";
        ApprovalsMgt1: Codeunit "Custom Approvals Codeunit";
        ApprovalMgt1: Codeunit "Custom Approvals Codeunit";
        documents: Record "Company Documents";
        attachments: Record Attachment;
        attachments2: Record Attachment;
        documents2: Record "Company Documents";
        inttemplate: Record "Interaction Tmpl. Language";
        Value: Text;
        Fileset: array[2] of Text;
        ObjImprestRequisition: Record "Purchase Header";
        Trainingscehdule: Record "Training Schedule";
        currencycodes: Record Currency;
        purchaseheader2: Record "Purchase Header";
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        p9report: Record "Payroll Employee P9_AU";
        notice: Record "Notice Board";
        approvalentries: Record "Approval Entry";
        hrdocuments: Record "HR Documents";
        EmailMessge: Codeunit "Email Message";
        EmailSend: Codeunit Email;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        PurchaseLine6: Record "Purchase Line";
        PayrollEmployeeP9_AU6: Record "Payroll Employee P9_AU";
        NNo: Code[10];
        p9: Report P9Report;
        HREmployees6: Record "HR Employees";
        lJObject: JsonObject;
        lJsonArray: JsonArray;
        JsonToken: JsonToken;
        JsonValue: JsonValue;
        lArrayString: Text;
        lJSONString: Text;
        TimesheetHeader: Record "TE Time Sheet1";
        Doc: Code[100];
        TimesheetHeader1: Record "Purchase Header";
        Counter2: Integer;
        TextManagement: Codeunit "Filter Tokens";
        TimesheetHeader3: Record "TE Time Sheet1";

    local procedure fnGetUser(EmployeeNo: Code[100]) empUserId: Text
    begin
        objHREmployees.Reset;
        objHREmployees.SetRange(objHREmployees."No.", EmployeeNo);
        if objHREmployees.Find('-') then begin
            empUserId := objHREmployees."User ID";
        end;
        exit(empUserId);
    end;

    procedure FnLeaveApplication(EmployeeNo: Code[100]; LeaveType: Code[100]; AppliedDays: Decimal; StartDate: Date; Reliever: Code[100]; pendingtasks: Text)
    var
        NextLeaveApplicationNo: Code[100];
        EndDate: Date;
        ReturnDate: Date;
        SenderComments: Text;
        ResponsibilityCenter: Code[100];
    begin
        objHRSetup.Get();

        objHRLeaveApplication.Init;
        if AppliedDays < 1 then begin
            ReturnDate := StartDate;
            EndDate := StartDate;
        end else begin
            FnValidateStartDate(StartDate);
            ReturnDate := DetermineLeaveReturnDate(StartDate, AppliedDays, LeaveType);
            EndDate := CalcEndDate(StartDate, AppliedDays, LeaveType);
        end;
        NextLeaveApplicationNo := objNumSeries.GetNextNo(objHRSetup."Leave Application Nos.", 0D, true);
        objHREmployees.Reset;
        objHREmployees.SetRange("No.", EmployeeNo);
        if objHREmployees.Find('-')
        then begin
            ResponsibilityCenter := objHREmployees."Responsibility Center";
            objHRLeaveApplication."User ID" := objHREmployees."User ID";
            objHRLeaveApplication."Application Code" := NextLeaveApplicationNo;
            objHRLeaveApplication."Employee No" := EmployeeNo;
            objHRLeaveApplication.Insert;
            objHRLeaveApplication.Names := objHREmployees."First Name" + '  ' + objHREmployees."Middle Name";
            //objHRLeaveApplication."Department Code":=objHREmployees."Department Code";
            objHRLeaveApplication."E-mail Address" := objHREmployees."Company E-Mail";
            //objHRLeaveApplication.INSERT;
            // objHRLeaveApplication."Application Code":= NextLeaveApplicationNo;
            objHRLeaveApplication."Leave Type" := LeaveType;
            objHRLeaveApplication."Days Applied" := AppliedDays;
            objHRLeaveApplication.Validate(objHRLeaveApplication."Days Applied");
            objHRLeaveApplication."Application Date" := Today;
            objHRLeaveApplication."No series" := 'LEAVE';
            objHRLeaveApplication."Start Date" := StartDate;
            objHRLeaveApplication.Validate("Start Date");
            objHRLeaveApplication."Return Date" := ReturnDate;
            objHRLeaveApplication."End Date" := ReturnDate;
            objHRLeaveApplication."Responsibility Center" := ResponsibilityCenter;
            objHRLeaveApplication.Reliever := Reliever;
            objHRLeaveApplication.Validate(objHRLeaveApplication.Reliever);
            objHRLeaveApplication.Description := SenderComments;
            objHRLeaveApplication.Validate("Employee No");
            objHRLeaveApplication."Pending Tasks" := pendingtasks;
            objHRLeaveApplication.Modify;
        end;
    end;


    procedure DetermineLeaveReturnDate(fBeginDate: Date; fDays: Decimal; "Leave Type": Code[100]) fReturnDate: Date
    var
        varDaysApplied: Decimal;
    begin
        ObjHRLeaveTypes.Reset;
        ObjHRLeaveTypes.SetRange(Code, "Leave Type");
        if ObjHRLeaveTypes.Find('-') then begin
            varDaysApplied := fDays;
            fReturnDate := fBeginDate;
            repeat
                if DetermineIfIncludesNonWorking("Leave Type") = false then begin
                    fReturnDate := CalcDate('1D', fReturnDate);
                    if DetermineIfIsNonWorking(fReturnDate, ObjHRLeaveTypes) then
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
        if ObjHRLeaveTypes.Get(fLeaveCode) then begin
            if ObjHRLeaveTypes."Inclusive of Non Working Days" = true then
                exit(true);
        end;
    end;

    local procedure DetermineIfIsNonWorking(bcDate: Date; var ltype: Record "HR Leave Types") ItsNonWorking: Boolean
    var
        dates: Record Date;
    begin

        Clear(ItsNonWorking);
        GeneralOptions.Find('-');
        BaseCalendar.Reset;
        BaseCalendar.SetFilter(BaseCalendar."Base Calendar Code", GeneralOptions."Base Calendar");
        BaseCalendar.SetRange(BaseCalendar.Date, bcDate);
        if BaseCalendar.Find('-') then begin
            if BaseCalendar.Nonworking = true then
                ItsNonWorking := true;
        end;

        // For Annual Holidays
        BaseCalendar.Reset;
        BaseCalendar.SetFilter(BaseCalendar."Base Calendar Code", GeneralOptions."Base Calendar");
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
                end else if dates."Period Name" = 'Saturday' then begin
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


    procedure FnValidateStartDate("Start Date": Date)
    var
        BaseCalendar: Record "Base Calendar Change";
    begin
        BaseCalendar.Reset;
        BaseCalendar.SetFilter(BaseCalendar."Base Calendar Code", objHRSetup."Base Calendar");
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
        BaseCalendar.SetFilter(BaseCalendar."Base Calendar Code", objHRSetup."Base Calendar");
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

        //IF "Start Date"<TODAY THEN
        //ERROR('You cannot Start your leave before the application date');
    end;







    procedure fnLeaveApprovalRequest(LeaveApplicationCode: Code[50])
    begin
        objHRLeaveApplication.Reset;
        objHRLeaveApplication.SetRange(objHRLeaveApplication."Application Code", LeaveApplicationCode);
        if objHRLeaveApplication.Find('-') then begin
            if objHRLeaveApplication.Status = objHRLeaveApplication.Status::New then begin
                variantrec := objHRLeaveApplication;
                if ApprovalMgt1.CheckApprovalsWorkflowEnabled(variantrec) then
                    ApprovalMgt1.OnSendDocForApproval(variantrec);
            end;
        end;

    end;









    procedure fnGetPayslip("Employee No": Code[20]; PayPeriod: Date; var Base64Txt: Text)
    var
        Filename: Text[100];
        TempBlob: Codeunit "Temp Blob";
        StatementOutstream: OutStream;
        StatementInstream: InStream;
        MemberStatement: Report 80011;
        Base64Convert: Codeunit "Base64 Convert";
    begin
        objHREmployees.Reset;
        objHREmployees.SetRange(objHREmployees."No.", "Employee No");
        if objHREmployees.Find('-') then begin
            MemberStatement.SetTableView(objHREmployees);
            TempBlob.CreateOutStream(StatementOutstream);
            if MemberStatement.SaveAs('', ReportFormat::Pdf, StatementOutstream) then begin
                TempBlob.CreateInStream(StatementInstream);
                Base64Txt := Base64Convert.ToBase64(StatementInstream, true);
            end;
        end;
    end;





    procedure fnGetLeaveDocument(ApplicationNo: Code[20]; var BigText: Text)
    var
        Filename: Text[100];
        TempBlob: Codeunit "Temp Blob";
        StatementOutstream: OutStream;
        StatementInstream: InStream;
        MemberStatement: Report 80011;
        Base64Convert: Codeunit "Base64 Convert";
    begin
        objHRLeaveApplication.Reset;
        objHRLeaveApplication.SetRange(objHRLeaveApplication."Application Code", ApplicationNo);
        if objHRLeaveApplication.Find('-') then begin
            MemberStatement.SetTableView(objHRLeaveApplication);
            TempBlob.CreateOutStream(StatementOutstream);
            if MemberStatement.SaveAs('', ReportFormat::Pdf, StatementOutstream) then begin
                TempBlob.CreateInStream(StatementInstream);
                BigText := Base64Convert.ToBase64(StatementInstream, true);
            end;
        end;
    end;




    procedure FnApproveRecords(DocumentNumber: Code[50]; ApproverId: Code[100])
    begin
        ObjApprovalEntries.Reset;
        ObjApprovalEntries.SetRange(ObjApprovalEntries."Approver ID", ApproverId);
        ObjApprovalEntries.SetRange(ObjApprovalEntries."Document No.", DocumentNumber);
        ObjApprovalEntries.SetRange(ObjApprovalEntries.Status, ObjApprovalEntries.Status::Open);
        if ObjApprovalEntries.FindLast then begin
            CUApprovalMgt.ApproveApprovalRequests(ObjApprovalEntries);
        end;
    end;





    procedure fnRejectApprovalRequest(DocumentNumber: Code[50]; ApproverId: Code[100])
    begin
        ObjApprovalEntries.Reset;
        ObjApprovalEntries.SetRange(ObjApprovalEntries."Approver ID", ApproverId);
        ObjApprovalEntries.SetRange(ObjApprovalEntries."Document No.", DocumentNumber);
        ObjApprovalEntries.SetRange(ObjApprovalEntries.Status, ObjApprovalEntries.Status::Open);
        if ObjApprovalEntries.FindLast then begin
            CUApprovalMgt.RejectApprovalRequests(ObjApprovalEntries);
        end;
    end;


    procedure UpdateLeave(LeaveNo: Code[30]; Leavetype: Code[40]; Applieddays: Decimal; Startdate: Date; Enddate: Date; returndate: Date; sendercomments: Text; relieverno: Code[30]; responsibilitycenter: Code[40])
    begin
    end;




    procedure CheckLeaveDaysAvailable(LeaveType: Text; EmpNo: Code[100]) DaysAvailable: Decimal
    begin

        HREmployees.Reset;
        HREmployees.SetRange("No.", EmpNo);
        if HREmployees.Get(EmpNo) then begin
            if (LeaveType = 'ANNUAL') then
                HREmployees.CalcFields(HREmployees."Annual Leave Account");
            DaysAvailable := HREmployees."Annual Leave Account";
        end else if (LeaveType = 'COMPASSIONATE') then begin
            HREmployees.CalcFields(HREmployees."Compassionate Leave Acc.");
            DaysAvailable := HREmployees."Compassionate Leave Acc.";
        end else if (LeaveType = 'MATERNITY') then begin
            HREmployees.CalcFields(HREmployees."Maternity Leave Acc.");
            DaysAvailable := HREmployees."Maternity Leave Acc.";
        end else if (LeaveType = 'PATERNITY') then begin
            HREmployees.CalcFields(HREmployees."Paternity Leave Acc.");
            DaysAvailable := HREmployees."Paternity Leave Acc.";
        end else if (LeaveType = 'SICK') then begin
            HREmployees.CalcFields(HREmployees."Sick Leave Acc.");
            DaysAvailable := HREmployees."Sick Leave Acc.";
        end else if (LeaveType = 'CTO') then begin
            HREmployees.CalcFields(HREmployees."CTO  Leave Acc.");
            DaysAvailable := HREmployees."CTO  Leave Acc.";

            //END;
        end;
    end;

    local procedure CreateJsonAttribute(Attributename: Text; Value: Variant)
    begin
        JSONTextWriter.WriteProperty(Attributename);
        JSONTextWriter.WriteValue(Format(Value));
    end;

    procedure fnGetEmployeeDetails(EmployeeNo: Code[30]): Text
    var
        JsonObject: JsonObject;
        JsonOut: Text;
        picture: BigText;
    begin
        // Initialize the JsonObject and add attributes to it
        JsonObject.Add('No', HREmployees."No.");
        JsonObject.Add('FirstName', HREmployees."First Name");
        JsonObject.Add('LastName', HREmployees."Last Name");
        JsonObject.Add('IdNumber', HREmployees."ID Number");
        JsonObject.Add('Department', HREmployees."Department Code");
        JsonObject.Add('JobId', HREmployees."Job Title");
        JsonObject.Add('EmailAddress', HREmployees."E-Mail");
        JsonObject.Add('OfficialAddress', HREmployees."E-Mail");
        JsonObject.Add('MobilePhone', HREmployees."Cellular Phone Number");
        JsonObject.Add('TotalLeavedays', HREmployees."Total (Leave Days)");
        JsonObject.Add('LeavedaysAllocated', HREmployees."Allocated Leave Days");
        JsonObject.Add('LeaveDaysReimbursed', HREmployees."Reimbursed Leave Days");
        JsonObject.Add('LeaveDaysTaken', HREmployees."Total Leave Taken");
        JsonObject.Add('LeaveBalance', HREmployees."Annual Leave Account");
        JsonObject.Add('AnnualLeaveAcc', HREmployees."Annual Leave Account");
        JsonObject.Add('CompassionateLeaveAcc', HREmployees."Compassionate Leave Acc.");
        JsonObject.Add('SickLeaveAcc', HREmployees."Sick Leave Acc.");
        JsonObject.Add('PaternityLeaveAcc', HREmployees."Paternity Leave Acc.");
        JsonObject.Add('StudyLeaveAcc', HREmployees."Study Leave Acc");
        JsonObject.Add('MaternityLeaveAcc', HREmployees."Maternity Leave Acc.");
        //JsonObject.Add('Cto', HREmployees."CTO Leave Acc.");

        // Check if hrsetup exists and add additional details
        if hrsetup.Get() then begin
            //fnAppreciation(picture);
            // JsonObject.Add('Picture', picture);
            JsonObject.Add('Title', hrsetup."Appreciation Title");
            JsonObject.Add('Summary', hrsetup."Appreciation Narration");
            JsonObject.Add('Name', '');
        end;

        // Add notice board information
        JsonObject.Add('Notice', Format(fnGetNoticeBoard()));

        JsonObject.WriteTo(JsonOut);
        exit(JsonOut);
    end;

    procedure fnGetPaymentInformation(No: Code[50]): Text
    var
        JsonOut: JsonObject;
        ReturnOut: Text;
    begin
        if objPayrollEmployee.Get(No) then begin
            JsonOut.Add('BankAccount', objPayrollEmployee."Bank Account No");
            JsonOut.Add('KRAPin', objPayrollEmployee."PIN No");
            JsonOut.Add('Nhif', objPayrollEmployee."NHIF No");
            JsonOut.Add('Nssf', objPayrollEmployee."NSSF No");
            JsonOut.Add('BankBranch', objPayrollEmployee."Branch Name");
            JsonOut.Add('hourlyPay', Format(ROUND(objPayrollEmployee."Hourly Rate", 0.01, '>')));
            JsonOut.Add('MonthlyRate', Format(0));
        end;
        JsonOut.WriteTo(ReturnOut);
        exit(ReturnOut);
    end;

    procedure fnGetSummaryPayment(No: Code[60]; payPeriod: Text): Text
    var
        JsonOut: JsonObject;
        ReturnOut: Text;
    begin
        if objPayrollEmployee.Get(No) then begin
            // Apply filter based on pay period
            objPayrollEmployee.SetFilter("Period Filter", Format(payPeriod));

            // Calculate required flowfields
            objPayrollEmployee.CalcFields(
                "Cummulative Basic Pay",
                "Cummulative Allowances",
                "Cummulative Deductions",
                "Cummulative Net Pay");

            // Build JSON object
            JsonOut.Add('BasicPay', Format(objPayrollEmployee."Cummulative Basic Pay"));
            JsonOut.Add('TotalAllowances', Format(objPayrollEmployee."Cummulative Allowances"));
            JsonOut.Add('TotalDeductions', Format(objPayrollEmployee."Cummulative Deductions"));
            JsonOut.Add('NetPay', Format(objPayrollEmployee."Cummulative Net Pay"));
        end;

        // Serialize JSON to text
        JsonOut.WriteTo(ReturnOut);
        Message(ReturnOut);
        exit(ReturnOut);
    end;

    procedure fnlogin(user: Code[60]; password: Text) Allow: Boolean
    begin
        objHREmployees.Reset;
        objHREmployees.SetRange("No.", user);
        //password:=encrypt01.Decrypt(password);
        objHREmployees.SetRange("Portal Password", password);
        objHREmployees.SetRange(Registered, true);
        if objHREmployees.Find('-') then begin
            Allow := true;
        end
        else
            Allow := false;

        //encrypt.Encrypt(pass
    end;

    procedure fnRegister(empno: Code[40]; regcode: Text; newpassword: Text) register: Boolean
    begin
        objHREmployees.Reset;
        objHREmployees.SetRange("No.", empno);
        //regcode:=encrypt01.Decrypt(regcode);
        objHREmployees.SetRange("Portal Password", regcode);
        if objHREmployees.Find('-') then begin
            objHREmployees.Registered := true;
            objHREmployees."Portal Password" := newpassword;
            objHREmployees.Modify;
            register := true;
        end else
            register := false;
    end;

    procedure fninserreccode(empno: Code[50]; idnumber: Code[40]; email: Text) success: Boolean
    var
        randomnumber: Integer;
        inpassword: Text;
        EmailBody: Text;
        EmailSubject: Text;
    begin
        objHREmployees.Reset;
        objHREmployees.SetRange("No.", empno);
        objHREmployees.SetRange("ID Number", idnumber);
        objHREmployees.SetRange("E-Mail", email);
        if objHREmployees.Find('-') then begin
            //ENCRYPT(inpassword);
            randomnumber := Random(99999);
            //ecnryptedpassword:= encrypt01.Encrypt(FORMAT(randomnumber));
            objHREmployees."Portal Password" := Format(randomnumber);

            if objHREmployees.Registered = true then
                objHREmployees.Registered := false;
            objHREmployees.Modify;
            success := true;
            EmailSubject := 'MMM Self service password';
            EmailBody := 'Dear Sir/Madam' + '<br></br>' + 'your Self service portal one time password is ' + '<br></br>'
                        + Format(randomnumber) + ' please use this code for the next step';
            //Send to email
            EmailMessge.Create(email, EmailSubject, EmailBody, true);
            EmailSend.Send(EmailMessge);

        end else
            success := false;

        exit(success);
    end;

    procedure fnGetPeriods(): Text
    var
        JsonArray: JsonArray;
        JsonObj: JsonObject;
        ReturnOut: Text;
    begin
        ObjPrPeriods.Reset();
        if ObjPrPeriods.FindSet() then begin
            repeat
                clear(JsonObj);
                JsonObj.Add('Period', ObjPrPeriods."Period Name");
                JsonObj.Add('Name', Format(ObjPrPeriods."Period Name"));
                JsonArray.Add(JsonObj);
            until ObjPrPeriods.Next() = 0;
        end;

        JsonArray.WriteTo(ReturnOut);
        Message(ReturnOut);
        exit(ReturnOut);
    end;

    procedure fnleaveinformation(empNo: Code[60]) returnout: Text
    var
        JsonArray: JsonArray;
        JsonObj: JsonObject;
    begin


        if HREmployees.Get(empNo) then begin
            HREmployees.CalcFields("Total Leave Taken", "Reimbursed Leave Days", "Allocated Leave Days");
            clear(JsonObj);

            JsonObj.Add('EmailAddress', HREmployees."E-Mail");
            JsonObj.Add('officialAddress', Format(HREmployees."E-Mail"));
            JsonObj.Add('MobilePhone', HREmployees."Cellular Phone Number");
            JsonObj.Add('TotalLeavedays', HREmployees."Total (Leave Days)");
            JsonObj.Add('LeavedaysAllocated', HREmployees."Allocated Leave Days");
            JsonObj.Add('LeaveDaysreimbursed', HREmployees."Reimbursed Leave Days");
            JsonObj.Add('LeavedaysTaken', HREmployees."Total Leave Taken");
            JsonObj.Add('LeaveBalance', HREmployees."Leave Balance");
            JsonArray.Add(JsonObj);
        end;


        JsonArray.WriteTo(ReturnOut);
        exit(ReturnOut);
    end;

    procedure fnLeaveList(empNo: Code[50]): Text
    var
        LeaveArray: JsonArray;
        LeaveObject: JsonObject;
        returnout: Text;
    begin
        objHRLeaveApplication.Reset();
        objHRLeaveApplication.SetRange("Employee No", empNo);

        if objHRLeaveApplication.Find('-') then begin
            repeat
                Clear(LeaveObject);

                LeaveObject.Add('No', objHRLeaveApplication."Application Code");
                LeaveObject.Add('Status', Format(objHRLeaveApplication.Status));
                LeaveObject.Add('StartDate', Format(objHRLeaveApplication."Start Date", 0, '<Standard Format>'));
                LeaveObject.Add('ReturnDate', Format(objHRLeaveApplication."Return Date", 0, '<Standard Format>'));
                LeaveObject.Add('NoOfDays', Format(objHRLeaveApplication."Days Applied")); // Fixed typo
                LeaveObject.Add('LeaveType', Format(objHRLeaveApplication."Leave Type"));
                LeaveObject.Add('RelieverCode', objHRLeaveApplication."Reliever Name");
                LeaveObject.Add('EndDate', Format(objHRLeaveApplication."End Date", 0, '<Standard Format>'));
                LeaveObject.Add('ApplicationDate', Format(objHRLeaveApplication."Application Date", 0, '<Standard Format>'));
                LeaveObject.Add('ApprovedDays', Format(objHRLeaveApplication."Approved days"));
                LeaveObject.Add('PendingTasks', Format(objHRLeaveApplication."Pending Tasks"));

                LeaveArray.Add(LeaveObject);
            until objHRLeaveApplication.Next() = 0;
        end;
        LeaveArray.WriteTo(ReturnOut);
        exit(ReturnOut);
    end;

    procedure fnLeaveCard(empNo: Code[50]; leavecode: Code[40]): Text
    var
        LeaveObject: JsonObject;
        returnout: Text;
        LeaveArray: JsonArray;
    begin
        objHRLeaveApplication.Reset();
        objHRLeaveApplication.SetRange("Employee No", empNo);
        objHRLeaveApplication.SetRange("Application Code", leavecode);
        if objHRLeaveApplication.FindFirst() then begin
            LeaveObject.Add('No', objHRLeaveApplication."Application Code");
            LeaveObject.Add('Status', Format(objHRLeaveApplication.Status));
            LeaveObject.Add('StartDate', Format(objHRLeaveApplication."Start Date", 0, '<Standard Format>'));
            LeaveObject.Add('ReturnDate', Format(objHRLeaveApplication."Return Date", 0, '<Standard Format>'));
            LeaveObject.Add('NoOfDays', Format(objHRLeaveApplication."Days Applied")); // Corrected typo
            LeaveObject.Add('LeaveType', Format(objHRLeaveApplication."Leave Type"));
            LeaveObject.Add('RelieverCode', objHRLeaveApplication."Reliever Name");
            LeaveObject.Add('EndDate', Format(objHRLeaveApplication."End Date", 0, '<Standard Format>'));
            LeaveObject.Add('ApplicationDate', Format(objHRLeaveApplication."Application Date", 0, '<Standard Format>'));
            LeaveObject.Add('ApprovedDays', Format(objHRLeaveApplication."Approved days"));
            LeaveArray.Add(LeaveObject);
        end;

        LeaveArray.WriteTo(returnout);
        exit(returnout);
    end;

    procedure fnGetLeaveTypes(): Text
    var
        LeaveTypeArray: JsonArray;
        LeaveTypeObject: JsonObject;
        returnout: Text;
    begin
        ObjHRLeaveTypes.Reset();
        // Uncomment and adjust if Setup filter is needed:
        // ObjHRLeaveTypes.SetRange(Setup, false);

        if ObjHRLeaveTypes.FindFirst() then begin
            repeat
                Clear(LeaveTypeObject);
                LeaveTypeObject.Add('Code', ObjHRLeaveTypes.Code);
                LeaveTypeArray.Add(LeaveTypeObject);
            until ObjHRLeaveTypes.Next() = 0;
        end;

        LeaveTypeArray.WriteTo(returnout);
        exit(returnout);
    end;

    procedure fnHrEmployees(): Text
    var
        EmployeesArray: JsonArray;
        EmployeeObject: JsonObject;
        returnout: Text;
    begin
        objHREmployees.Reset();
        objHREmployees.SetRange(Status, objHREmployees.Status::Active);

        if objHREmployees.FindFirst() then begin
            repeat
                Clear(EmployeeObject);
                EmployeeObject.Add('EmpNo', objHREmployees."No.");
                EmployeeObject.Add('Name', objHREmployees."First Name" + ' ' + objHREmployees."Last Name");
                EmployeesArray.Add(EmployeeObject);
            until objHREmployees.Next() = 0;
        end;

        EmployeesArray.WriteTo(returnout);
        exit(returnout);
    end;

    procedure FnEditApplication(EmployeeNo: Code[100]; LeaveType: Code[100]; AppliedDays: Integer; StartDate: Date; Reliever: Code[100]; ApplicationNo: Code[50]; pendingtasks: Text)
    var
        NextLeaveApplicationNo: Code[100];
        EndDate: Date;
        ReturnDate: Date;
        SenderComments: Text;
        ResponsibilityCenter: Code[100];
    begin
        objHRSetup.Get();

        objHRLeaveApplication.Init;
        FnValidateStartDate(StartDate);
        NextLeaveApplicationNo := objNumSeries.GetNextNo(objHRSetup."Leave Application Nos.", 0D, true);
        ReturnDate := DetermineLeaveReturnDate(StartDate, AppliedDays, LeaveType);
        EndDate := CalcEndDate(StartDate, AppliedDays, LeaveType);


        objHREmployees.Reset;
        objHREmployees.SetRange("No.", EmployeeNo);
        if objHREmployees.Find('-')
        then begin
            ResponsibilityCenter := objHREmployees."Responsibility Center";
            if objHRLeaveApplication.Get(ApplicationNo) then begin
                objHRLeaveApplication."User ID" := objHREmployees."User ID";
                objHRLeaveApplication."Application Code" := ApplicationNo;
                objHRLeaveApplication."Employee No" := EmployeeNo;
                // objHRLeaveApplication.INSERT;
                objHRLeaveApplication.Names := objHREmployees."First Name" + '  ' + objHREmployees."Middle Name";
                //objHRLeaveApplication."Department Code":=objHREmployees."Department Code";
                objHRLeaveApplication."E-mail Address" := objHREmployees."Company E-Mail";
                //objHRLeaveApplication.INSERT;
                // objHRLeaveApplication."Application Code":= NextLeaveApplicationNo;
                objHRLeaveApplication."Leave Type" := LeaveType;
                objHRLeaveApplication."Days Applied" := AppliedDays;
                objHRLeaveApplication.Validate(objHRLeaveApplication."Days Applied");
                objHRLeaveApplication."Application Date" := Today;
                objHRLeaveApplication."No series" := 'LEAVE';
                objHRLeaveApplication."Start Date" := StartDate;
                objHRLeaveApplication.Validate("Start Date");
                objHRLeaveApplication."Return Date" := ReturnDate;
                objHRLeaveApplication."End Date" := ReturnDate;
                objHRLeaveApplication."Responsibility Center" := ResponsibilityCenter;
                if HREmployees.Get(Reliever) then begin
                    objHRLeaveApplication.Reliever := Reliever;
                    objHRLeaveApplication.Validate(objHRLeaveApplication.Reliever);
                end;
                objHRLeaveApplication.Description := SenderComments;
                objHRLeaveApplication.Validate("Employee No");
                objHRLeaveApplication."Pending Tasks" := pendingtasks;
                objHRLeaveApplication.Modify;
            end;
        end;
    end;

    procedure fnDelete(leaveCode: Code[40])
    begin
        objHRLeaveApplication.Reset;
        //objHRLeaveApplication.SETRANGE(Posted, FALSE);
        objHRLeaveApplication.SetRange(Status, objHRLeaveApplication.Status::New);
        objHRLeaveApplication.SetRange("Application Code", leaveCode);

        if objHRLeaveApplication.Find('-') then begin
            objHRLeaveApplication.Delete;
        end;
    end;

    procedure fnGetleaveStatement("Employee No": Text; var BigText: BigText)
    var
        objPREmployee: Record "Payroll Employee_AU";
        Filename: Text[100];
        Outputstream: OutStream;
        p9repor: Report "VAT Statement";
    begin



        objHREmployees.Reset;
        objHREmployees.SetRange(objHREmployees."No.", "Employee No");
        if objHREmployees.Find('-') then begin

            // Report.SaveAsPdf(80029, Filename, objHREmployees);


        end;
    end;


    procedure fnGetP9Report("Employee No": Code[20]; "starting date": Date; "ending date": Date; var BigText: BigText)
    var
        objPREmployee: Record "Payroll Employee_AU";
        Filename: Text[100];

        Outputstream: OutStream;
    begin



        //day := DATE2DMY(PayPeriod,2); month := DATE2DMY(PayPeriod,1); year := DATE2DMY(PayPeriod,3);
        // Filename := Path.GetTempPath() + Path.GetRandomFileName();

        // HREmployees6.Reset;
        // HREmployees6.SetRange(HREmployees6."No.", "Employee No");
        // //P9report.SETFILTER(P9report."Period Year",FORMAT(PayPeriod));
        // if HREmployees6.Find('-') then begin
        //     p9report.Reset;
        //     // P9report.SETFILTER(P9report."Period Year",FORMAT(PayPeriod));
        //     p9report.SetFilter(p9report."Period Year", Format(Date2dmy("starting date", 3)));

        //     if p9report.FindFirst then
        //         p9.SetTableview(p9report);
        //     p9.SetTableview(HREmployees6);
        //     p9.SaveAsPdf(Filename);
        //     // REPORT.SAVEASPDF(50184,Filename,objPayrollEmployee);
        //     FileMode := 4;
        //     FileAccess := 1;

        //     FileStream := _File.Open(Filename, FileMode, FileAccess);

        //     MemoryStream := MemoryStream.MemoryStream();

        //     MemoryStream.SetLength(FileStream.Length);
        //     FileStream.Read(MemoryStream.GetBuffer(), 0, FileStream.Length);

        //     BigText.AddText((Convert.ToBase64String(MemoryStream.GetBuffer())));
        //     MemoryStream.Close();
        //     MemoryStream.Dispose();
        //     FileStream.Close();
        //     FileStream.Dispose();
        //     //MESSAGE(FORMAT(Path));
        //     _File.Delete(Filename);
        // end;

    end;

    procedure fnLeaveDelete(empNo: Code[50]; LeaveNo: Code[20]): Text
    var
        LeaveArray: JsonArray;
        LeaveObject: JsonObject;
        returnout: Text;
    begin
        if objHRLeaveApplication.Get(LeaveNo) then
            objHRLeaveApplication.Delete();

        objHRLeaveApplication.Reset();
        objHRLeaveApplication.SetRange("Employee No", empNo);

        if objHRLeaveApplication.FindFirst() then begin
            repeat
                Clear(LeaveObject);
                LeaveObject.Add('No', objHRLeaveApplication."Application Code");
                LeaveObject.Add('Status', Format(objHRLeaveApplication.Status));
                LeaveObject.Add('StartDate', Format(objHRLeaveApplication."Start Date", 0, '<Standard Format>'));
                LeaveObject.Add('ReturnDate', Format(objHRLeaveApplication."Return Date", 0, '<Standard Format>'));
                LeaveObject.Add('NoOfDays', Format(objHRLeaveApplication."Days Applied")); // Fixed typo
                LeaveObject.Add('LeaveType', Format(objHRLeaveApplication."Leave Type"));
                LeaveObject.Add('RelieverCode', objHRLeaveApplication."Reliever Name");
                LeaveObject.Add('EndDate', Format(objHRLeaveApplication."End Date", 0, '<Standard Format>'));
                LeaveObject.Add('ApplicationDate', Format(objHRLeaveApplication."Application Date", 0, '<Standard Format>'));
                LeaveObject.Add('ApprovedDays', Format(objHRLeaveApplication."Approved days"));
                LeaveArray.Add(LeaveObject);
            until objHRLeaveApplication.Next() = 0;
        end;

        LeaveArray.WriteTo(returnout);
        exit(returnout);
    end;

    procedure fnImprestCard(
     empNo: Code[50];
     departmentcode: Code[20];
     directoratecode: Code[20];
     purpose: Text;
     responsibilitycenter: Code[20];
     startdate: Date;
     enddate: Date
 ): Text
    var
        ObjImprestHeader: Record "Purchase Header";
        ObjHREmployee: Record "HR Employees";
        ObjUserSetup: Record "User Setup";
        GenLedgerSetup: Record "General Ledger Setup";
        ObjNumSeries: Codeunit NoSeriesManagement;
        returnJson: JsonObject;
        JsaonAs: JsonArray;
        ImprestNo: Code[20];
    begin
        if ObjHREmployee.Get(empNo) then begin
            GenLedgerSetup.Get();
            //ImprestNo := ObjNumSeries.GetNextNo(GenLedgerSetup."Mission Proposal Nos.", 0D, true);

            ObjImprestHeader.Init();
            ObjImprestHeader."No." := ImprestNo;
            ObjImprestHeader."Document Date" := Today;
            ObjImprestHeader."Shortcut Dimension 1 Code" := departmentcode;
            ObjImprestHeader.Validate("Shortcut Dimension 1 Code");
            ObjImprestHeader."Shortcut Dimension 2 Code" := directoratecode;
            ObjImprestHeader.Validate("Shortcut Dimension 2 Code");
            ObjImprestHeader."Posting Description" := purpose;
            ObjImprestHeader."Responsibility Center" := responsibilitycenter;
            ObjImprestHeader.Status := ObjImprestHeader.Status::Open;
            ObjImprestHeader."Expected Receipt Date" := startdate; // Using as StartDate
            ObjImprestHeader."Due Date" := enddate; // Using as EndDate
            ObjImprestHeader."IM" := true;

            if ObjUserSetup.Get(ObjHREmployee."User ID") then begin
                // Optionally set account fields here if needed
            end;

            if ObjImprestHeader.Insert(true) then begin
                ObjImprestHeader.CalcFields(Amount);

                returnJson.Add('No', ObjImprestHeader."No.");
                returnJson.Add('Document_Date', Format(ObjImprestHeader."Document Date", 0, '<Standard Format>'));
                returnJson.Add('Status', Format(ObjImprestHeader.Status));
                returnJson.Add('ResponsibilityCenter', ObjImprestHeader."Responsibility Center");
                returnJson.Add('Amount', Format(ObjImprestHeader.Amount));
                returnJson.Add('DepartmentCode', ObjImprestHeader."Shortcut Dimension 1 Code");
                returnJson.Add('StartDate', Format(ObjImprestHeader."Expected Receipt Date", 0, '<Standard Format>'));
                returnJson.Add('EndDate', Format(ObjImprestHeader."Due Date", 0, '<Standard Format>'));
                returnJson.Add('DirectorateCode', ObjImprestHeader."Shortcut Dimension 2 Code");
                returnJson.Add('Purpose', ObjImprestHeader."Posting Description");
                JsaonAs.Add(returnJson);
            end;
        end;

        //exit(returnJson.ToString());
    end;

    procedure fnImprestCardEdit(ImprestNo: Code[20]): Text
    var
        ObjImprestHeader: Record "Purchase Header";
        JsonObject: JsonObject;
        returnout: Text;
        jsonarray: JsonArray;
    begin
        if ObjImprestHeader.Get(ObjImprestHeader."Document Type"::Quote, ImprestNo) then begin
            ObjImprestHeader.CalcFields(Amount);
            JsonObject.Add('No', ObjImprestHeader."No.");
            JsonObject.Add('Document_Date', ObjImprestHeader."Document Date");
            JsonObject.Add('Status', Format(ObjImprestHeader.Status));
            JsonObject.Add('ResponsibilityCenter', ObjImprestHeader."Responsibility Center");
            JsonObject.Add('Amount', ObjImprestHeader.Amount);
            JsonObject.Add('DepartmentCode', ObjImprestHeader."Shortcut Dimension 1 Code");
            JsonObject.Add('StartDate', ObjImprestHeader."Document Date");
            JsonObject.Add('EndDate', ObjImprestHeader."Document Date");
            JsonObject.Add('DirectorateCode', ObjImprestHeader."Shortcut Dimension 2 Code");
            JsonObject.Add('Purpose', ObjImprestHeader."Posting Description");

            jsonarray.WriteTo(returnout);
            exit(returnout);
        end;


    end;

    procedure fnPettyCashBank(): Text
    var
        ObjBank: Record "Bank Account";
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        returnout: Text;
    begin
        ObjBank.Reset;
        if ObjBank.FindFirst() then
            repeat

                JsonObject.Add('Code', ObjBank."No.");
                JsonObject.Add('Name', ObjBank.Name);
                JsonArray.Add(JsonObject);
            until ObjBank.Next() = 0;
        JsonArray.WriteTo(returnout);
        exit(returnout);
    end;


    procedure fnPaymentTypes(PaymentType: Option " ",Receipt,Payment,Imprest,Claim): Text
    var
        JsonOut: Text;
        ObjPaymentType: Record "G/L Account";
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStr: InStream;
    begin
        ObjPaymentType.Reset;
        ObjPaymentType.SetFilter("Direct Posting", 'Yes');
        if ObjPaymentType.FindFirst then
            repeat
                JsonObject.Add('Code', ObjPaymentType."No.");
                JsonObject.Add('Description', ObjPaymentType.Name);
                JsonObject.Add('Type', Format(ObjPaymentType."Account Type"));
                JsonArray.Add(JsonObject);
            until ObjPaymentType.Next = 0;
        TempBlob.CreateOutStream(OutStr);
        JsonArray.WriteTo(OutStr);

        TempBlob.CreateInStream(InStr);
        InStr.ReadText(JsonOut);

        exit(JsonOut);
    end;

    procedure fnImprestLineDelete(ImprestNo: Code[20]; LineNo: Integer): Text
    var
        JsonOut: Text;
        ObjImprestLine: Record "Purchase Line";
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStr: InStream;
    begin
        // Delete the specified line
        ObjImprestLine.Reset;
        ObjImprestLine.SetRange("Document No.", ImprestNo);
        ObjImprestLine.SetRange("Line No.", LineNo);
        if ObjImprestLine.FindFirst then
            ObjImprestLine.Delete;

        // Re-fetch and serialize the updated lines
        ObjImprestLine.Reset;
        ObjImprestLine.SetRange("Document No.", ImprestNo);
        if ObjImprestLine.FindFirst then
            repeat

                JsonObject.Add('No', ObjImprestLine."Document No.");
                JsonObject.Add('AccountNo', ObjImprestLine."No.");
                JsonObject.Add('AccountName', ObjImprestLine.Description);
                JsonObject.Add('Amount', ObjImprestLine.Amount);
                JsonObject.Add('LineNo', ObjImprestLine."Line No.");
                JsonObject.Add('Type', ObjImprestLine.Type);
                JsonArray.Add(JsonObject);
            until ObjImprestLine.Next = 0;

        // Use TempBlob to write JsonArray to Text
        TempBlob.CreateOutStream(OutStr);
        JsonArray.WriteTo(OutStr);

        TempBlob.CreateInStream(InStr);
        InStr.ReadText(JsonOut);

        exit(JsonOut);
    end;

    procedure fnImprestLine(ImprestNo: Code[20]): Text
    var
        JsonOut: Text;
        ObjImprestLine: Record "Purchase Line";
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStr: InStream;
    begin

        ObjImprestLine.Reset;
        ObjImprestLine.SetRange("Document No.", ImprestNo);

        if ObjImprestLine.FindFirst then
            repeat

                JsonObject.Add('No', ObjImprestLine."Document No.");
                JsonObject.Add('AccountNo', ObjImprestLine."No.");
                JsonObject.Add('AccountName', ObjImprestLine.Description);
                JsonObject.Add('LineNo', ObjImprestLine."Line No.");
                JsonObject.Add('Type', Format(ObjImprestLine.Type));
                JsonObject.Add('ExpenseCategory', ObjImprestLine."Expense Category");
                JsonObject.Add('Description', ObjImprestLine."Description 2");
                JsonObject.Add('AmountSpent', ObjImprestLine."Amount Spent");
                JsonObject.Add('CashRefund', ObjImprestLine."Cash Refund");
                JsonObject.Add('Amount', ObjImprestLine.Amount);
                JsonObject.Add('currency', ObjImprestLine."Currency Code");
                JsonObject.Add('unitcost', ObjImprestLine."Unit Cost");
                JsonObject.Add('quantity', ObjImprestLine.Quantity);

                JsonArray.Add(JsonObject);
            until ObjImprestLine.Next = 0;

        // Convert JsonArray to text using TempBlob
        TempBlob.CreateOutStream(OutStr);
        JsonArray.WriteTo(OutStr);
        TempBlob.CreateInStream(InStr);
        InStr.ReadText(JsonOut);

        exit(JsonOut);
    end;

    procedure fnImprestLineCard(ImprestNo: Code[20]; LineNo: Integer): Text
    var
        JsonOut: Text;
        ObjImprestLine: Record "Purchase Line";
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStr: InStream;
    begin


        ObjImprestLine.Reset;
        ObjImprestLine.SetRange("Document No.", ImprestNo);
        ObjImprestLine.SetRange("Line No.", LineNo);

        if ObjImprestLine.FindFirst then begin
            repeat

                JsonObject.Add('No', ObjImprestLine."Document No.");
                JsonObject.Add('AccountNo', ObjImprestLine."No.");
                JsonObject.Add('AccountName', ObjImprestLine.Description);
                JsonObject.Add('Amount', ObjImprestLine.Amount);
                JsonObject.Add('LineNo', ObjImprestLine."Line No.");

                JsonArray.Add(JsonObject);
            until ObjImprestLine.Next = 0;
        end;

        // Serialize JsonArray to text using TempBlob
        TempBlob.CreateOutStream(OutStr);
        JsonArray.WriteTo(OutStr);
        TempBlob.CreateInStream(InStr);
        InStr.ReadText(JsonOut);

        exit(JsonOut);
    end;

    procedure fnImprestLineCardEdit(ImprestNo: Code[20]; Type: Code[20]; Amount: Decimal): Text
    var
        JsonOut: Text;
        ObjImprestLine: Record "Purchase Line";
        GLAccount: Record "G/L Account";
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStr: InStream;
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        LineNoText: Code[20];
    begin
        // Prepare a new line
        ObjImprestLine.Init;
        ObjImprestLine.Type := ObjImprestLine.Type::"G/L Account";
        ObjImprestLine."Document No." := ImprestNo;

        // Get next line number using No. Series
        PurchasesPayablesSetup.Get();
        LineNoText := NoSeriesMgt.GetNextNo(PurchasesPayablesSetup."Line Nos.", Today, true);
        Evaluate(ObjImprestLine."Line No.", LineNoText);

        ObjImprestLine."No." := Type;

        if GLAccount.Get(Type) then
            ObjImprestLine.Description := GLAccount.Name;

        ObjImprestLine."Document Type" := ObjImprestLine."Document Type"::Quote;
        ObjImprestLine.Amount := Amount;

        if ObjImprestLine.Insert(true) then begin
            ObjImprestLine.Reset;
            ObjImprestLine.SetRange("Document No.", ImprestNo);

            if ObjImprestLine.FindFirst then
                repeat

                    JsonObject.Add('No', ObjImprestLine."Document No.");
                    JsonObject.Add('AccountNo', ObjImprestLine."No.");
                    JsonObject.Add('AccountName', ObjImprestLine.Description);
                    JsonObject.Add('Amount', ObjImprestLine.Amount);
                    JsonObject.Add('LineNo', ObjImprestLine."Line No.");
                    JsonArray.Add(JsonObject);
                until ObjImprestLine.Next = 0;

            // Convert JSON array to text
            TempBlob.CreateOutStream(OutStr);
            JsonArray.WriteTo(OutStr);
            TempBlob.CreateInStream(InStr);
            InStr.ReadText(JsonOut);
        end;

        exit(JsonOut);
    end;

    procedure ApprovalList(empNo: Code[50]): Text
    var
        ObjApproval: Record "Approval Entry";
        ObjHrEmployee: Record "HR Employees";
        JsonArray: JsonArray;
        JsonObj: JsonObject;
        ReturnOut: Text;
    begin
        Clear(JsonArray);

        if ObjHrEmployee.Get(empNo) then begin
            ObjApproval.Reset();
            ObjApproval.SetRange("Approver ID", ObjHrEmployee."User ID");
            // Optional: uncomment to filter only open approvals
            // ObjApproval.SetFilter(Status, '%1', ObjApproval.Status::Open);

            if ObjApproval.FindFirst() then
                repeat
                    Clear(JsonObj);  // Clear previous object

                    JsonObj.Add('DocumentNo', ObjApproval."Document No.");
                    JsonObj.Add('SenderID', ObjApproval."Sender ID");
                    JsonObj.Add('ApproverID', ObjApproval."Approver ID");
                    JsonObj.Add('DateTimeSent', Format(ObjApproval."Date-Time Sent for Approval"));
                    JsonObj.Add('Amount', Format(ObjApproval.Amount));
                    JsonObj.Add('Status', Format(ObjApproval.Status));

                    JsonArray.Add(JsonObj);
                until ObjApproval.Next() = 0;
        end;

        JsonArray.WriteTo(ReturnOut);
        exit(ReturnOut);
    end;


    procedure fnDepartment(): Text
    var
        ObjDimensionValue: Record "Dimension Value";
        JsonArray: JsonArray;
        JsonObj: JsonObject;
        ReturnOut: Text;
    begin
        ObjDimensionValue.Reset();
        ObjDimensionValue.SetRange("Global Dimension No.", 1);

        if ObjDimensionValue.FindFirst() then
            repeat
                Clear(JsonObj);

                JsonObj.Add('Code', ObjDimensionValue.Code);
                JsonObj.Add('Name', ObjDimensionValue.Name);

                JsonArray.Add(JsonObj);
            until ObjDimensionValue.Next() = 0;

        JsonArray.WriteTo(ReturnOut);
        exit(ReturnOut);
    end;

    procedure fnRolecenter() ReturnOut: Text
    var
        ObjRolecenter: Record "Responsibility Center";
        JsonArray: JsonArray;
        JsonObj: JsonObject;
    begin
        ObjRolecenter.Reset();

        if ObjRolecenter.FindSet() then
            repeat
                Clear(JsonObj);
                JsonObj.Add('Code', ObjRolecenter.Code);
                JsonObj.Add('Name', ObjRolecenter.Name);
                JsonArray.Add(JsonObj);
            until ObjRolecenter.Next() = 0;

        JsonArray.WriteTo(ReturnOut);
        exit(ReturnOut);
    end;

    procedure fnImprestList(empNo: Code[50]): Text
    var
        ObjImprestHeader: Record "Purchase Header";
        ObjHrEmployee: Record "HR Employees";
        ImprestArray: JsonArray;
        ImprestObject: JsonObject;
        returnout: Text;
    begin


        if ObjHrEmployee.Get(empNo) then begin
            ObjImprestHeader.Reset();
            ObjImprestHeader.SetRange(IM, true);
            ObjImprestHeader.SetRange("Employee No", empNo);

            if ObjImprestHeader.FindFirst() then begin
                repeat
                    ObjImprestHeader.CalcFields(Amount);

                    //crea JsonObject.Create();

                    ImprestObject.Add('No', ObjImprestHeader."No.");
                    ImprestObject.Add('Document_Date', Format(ObjImprestHeader."Document Date", 0, '<Standard Format>'));
                    ImprestObject.Add('Status', Format(ObjImprestHeader.Status));
                    ImprestObject.Add('Amount', Format(ObjImprestHeader.Amount));
                    ImprestObject.Add('DepartmentCode', ObjImprestHeader."Shortcut Dimension 1 Code");
                    ImprestObject.Add('DirectorateCode', ObjImprestHeader."Shortcut Dimension 2 Code");

                    // Using native AL date formatting for StartDate and EndDate
                    ImprestObject.Add('StartDate', Format(ObjImprestHeader."Document Date", 0, '<Standard Format>'));
                    ImprestObject.Add('EndDate', Format(ObjImprestHeader."Document Date", 0, '<Standard Format>'));

                    ImprestObject.Add('Completed', Format(ObjImprestHeader.Completed));
                    ImprestObject.Add('Posted', Format(ObjImprestHeader.Completed));

                    ImprestObject.Add('BudgetDimension', ObjImprestHeader."Shortcut Dimension 3 Code");
                    ImprestObject.Add('DepartmentDimension', ObjImprestHeader."Shortcut Dimension 4 Code");
                    ImprestObject.Add('BudgetDescription', ObjImprestHeader."Shortcut Dimension 5 Code");

                    ImprestObject.Add('MissionNo', ObjImprestHeader."Mission Proposal No");
                    ImprestObject.Add('ProjectTitle', ObjImprestHeader."Project Title");
                    ImprestObject.Add('PurchaseRequisition', ObjImprestHeader."Requisition No");

                    // Surrendered flag
                    ImprestObject.Add('Surrendered', Format(ObjImprestHeader.Surrendered));

                    ImprestArray.Add(ImprestObject);
                until ObjImprestHeader.Next() = 0;
            end;
        end;

        ImprestArray.WriteTo(returnout);
        exit(returnout);
    end;

    procedure fnLeaveCardEdit(empNo: Code[50]; leavecode: Code[40]; Startdate: Date; Responsibilitycenter: Code[50]; LeaveType: Code[20]; DayApplied: Decimal; Releavecode: Code[50]): Text
    var
        ObjHRLeaveApplication: Record "HR Leave Application";
        ObjHREmployee: Record "HR Employees";
        LeaveArray: JsonArray;
        LeaveObject: JsonObject;
        returnout: Text;
    begin


        ObjHRLeaveApplication.Reset();
        ObjHRLeaveApplication.SetRange("Application Code", leavecode);

        if ObjHRLeaveApplication.FindFirst() then begin
            // Edit the leave application fields
            ObjHRLeaveApplication."Leave Type" := LeaveType;
            ObjHRLeaveApplication."Responsibility Center" := Responsibilitycenter;
            ObjHRLeaveApplication."Days Applied" := DayApplied;
            ObjHRLeaveApplication."Start Date" := Startdate;
            ObjHRLeaveApplication.Reliever := Releavecode;
            ObjHRLeaveApplication.Validate("Start Date");

            // Modify the record if it exists
            if ObjHRLeaveApplication.Modify() then begin
                ObjHRLeaveApplication.Reset();
                ObjHRLeaveApplication.SetRange("Employee No", empNo);

                if ObjHRLeaveApplication.FindFirst() then begin
                    repeat
                        LeaveObject.Add('No', ObjHRLeaveApplication."Application Code");
                        LeaveObject.Add('Status', Format(ObjHRLeaveApplication.Status));
                        LeaveObject.Add('StartDate', Format(ObjHRLeaveApplication."Start Date", 0, '<Standard Format>'));
                        LeaveObject.Add('ReturnDate', Format(ObjHRLeaveApplication."Return Date", 0, '<Standard Format>'));
                        LeaveObject.Add('NoofDays', Format(ObjHRLeaveApplication."Days Applied"));
                        LeaveObject.Add('LeaveType', ObjHRLeaveApplication."Leave Type");
                        LeaveObject.Add('RelieverCode', ObjHRLeaveApplication."Reliever Name");
                        LeaveObject.Add('EndDate', Format(ObjHRLeaveApplication."End Date", 0, '<Standard Format>'));
                        LeaveObject.Add('ApplicationDate', Format(ObjHRLeaveApplication."Application Date", 0, '<Standard Format>'));
                        LeaveObject.Add('ApprovedDays', Format(ObjHRLeaveApplication."Approved days"));
                        LeaveArray.Add(LeaveObject);
                    until ObjHRLeaveApplication.Next() = 0;
                end;
            end;
        end;

        // Convert the JSON array to a string and return it
        LeaveArray.WriteTo(returnout);
        exit(returnout);
    end;

    procedure fnMissionProposalsList(empNo: Code[50]): Text
    var
        ObjImprestHeader: Record "Purchase Header";
        ObjHrEmployee: Record "HR Employees";
        MissionProposalsArray: JsonArray;
        MissionProposalObject: JsonObject;
        returnout: Text;
    begin


        ObjHrEmployee.Get(empNo);
        ObjImprestHeader.Reset();
        ObjImprestHeader.SetRange(MP, true);
        ObjImprestHeader.SetRange(Archived, false);
        ObjImprestHeader.SetRange("Employee No", empNo);

        if ObjImprestHeader.FindFirst() then begin
            repeat
                ObjImprestHeader.CalcFields(Amount);


                // Adding attributes to the JSON object
                MissionProposalObject.Add('No', ObjImprestHeader."No.");
                MissionProposalObject.Add('Document_Date', Format(ObjImprestHeader."Document Date", 0, '<Standard Format>'));
                MissionProposalObject.Add('Status', ObjImprestHeader.Status);
                MissionProposalObject.Add('Amount', ObjImprestHeader.Amount);
                MissionProposalObject.Add('DepartmentCode', ObjImprestHeader."Shortcut Dimension 1 Code");
                MissionProposalObject.Add('DirectorateCode', ObjImprestHeader."Shortcut Dimension 2 Code");
                MissionProposalObject.Add('StartDate', Format(ObjImprestHeader."Document Date", 0, '<Standard Format>'));
                MissionProposalObject.Add('EndDate', Format(ObjImprestHeader."Document Date", 0, '<Standard Format>'));
                MissionProposalObject.Add('Completed', ObjImprestHeader.Completed);
                MissionProposalObject.Add('StrategicFocusArea', ObjImprestHeader."Strategic Focus Area");
                MissionProposalObject.Add('SubPillar', ObjImprestHeader."Sub Pillar");
                MissionProposalObject.Add('ProjectTitle', ObjImprestHeader."Project Title");
                MissionProposalObject.Add('Country', ObjImprestHeader.Country);
                MissionProposalObject.Add('County', ObjImprestHeader.County);
                MissionProposalObject.Add('DateOfActivity', ObjImprestHeader."Date(s) of Activity");
                MissionProposalObject.Add('MissionTeam', ObjImprestHeader."Mission Team");
                MissionProposalObject.Add('InvitedMembers', ObjImprestHeader."Invited Members/Partners");
                MissionProposalObject.Add('FundCode', ObjImprestHeader."Shortcut Dimension 1 Code");
                MissionProposalObject.Add('ProgramCode', ObjImprestHeader."Shortcut Dimension 2 Code");
                MissionProposalObject.Add('budgetdimension', ObjImprestHeader."Shortcut Dimension 3 Code");
                MissionProposalObject.Add('departmentdimension', ObjImprestHeader."Shortcut Dimension 4 Code");
                MissionProposalObject.Add('budgetdescription', ObjImprestHeader."Shortcut Dimension 5 Code");
                MissionProposalObject.Add('Background', ObjImprestHeader.Background);
                MissionProposalObject.Add('StrategicFocus', ObjImprestHeader."Contribution to focus");
                MissionProposalObject.Add('Outcome', ObjImprestHeader."Main Outcome");

                // Add the JSON object to the array
                MissionProposalsArray.Add(MissionProposalObject);

            until ObjImprestHeader.Next() = 0;
        end;

        // Convert the JSON array to a string and return it
        MissionProposalsArray.WriteTo(returnout);
        exit(returnout);
    end;

    procedure fnGetProfilePicture(empno: Code[30]; var PictureText: BigText)
    var
        PictureInStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        TempBlobBase64: Text;
    begin
        HREmployees.Reset();
        HREmployees.SetRange("No.", empno);
        if HREmployees.FindFirst() then begin
            HREmployees.CalcFields(Picture);
            if HREmployees.Picture.HasValue then begin
                Clear(PictureText);
                HREmployees.Picture.CreateInStream(PictureInStream);
                //  TempBlob.(PictureInStream, TempBlobBase64);
                PictureText.AddText(TempBlobBase64);
            end;
        end;
    end;


    procedure fnGetStandardText(): Text
    var
        standardtext: Record "Standard Text";
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        returnout: Text;
    begin
        if standardtext.FindFirst() then
            repeat
                JsonObject.Add('Code', standardtext.Code);
                JsonObject.Add('Name', standardtext.Description);
                JsonObject.Add('Type', Format(standardtext.Type));
                JsonArray.Add(JsonObject);
            until standardtext.Next() = 0;
        JsonArray.WriteTo(returnout);
        exit(returnout);
    end;

    procedure fnGetContryregions(): Text
    var
        countryRegions: Record "Country/Region";
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        returnout: Text;
    begin
        if countryRegions.FindFirst() then
            repeat
                JsonObject.Add('Code', countryRegions.Code);
                JsonObject.Add('Name', countryRegions.Name);
                JsonObject.Add('Type', Format(countryRegions.Type));
                JsonArray.Add(JsonObject);
            until countryRegions.Next() = 0;
        JsonArray.WriteTo(returnout);
        exit(returnout);
    end;

    procedure fnInsertMissionProporsal(stratrgicFocusarea: Code[60]; subpillar: Code[60]; projecttitle: Text; country: Code[80]; county: Code[90]; datesofActivities: Text; missionteam: Text; invitedmebers: Text; fundcode: Code[90]; programcode: Code[90]; departmentdimension: Code[50]; budgetdimesion: Code[50]; budgetdescription: Code[60]; background: Text; strategicfocus: Text; outcome: Text; empno: Code[40]) mssno: Code[60]
    begin
        purchaseheader.Init;
        GenLedgerSetup.Get();
        purchaseheader."No." := objNumSeries.GetNextNo(GenLedgerSetup."Mission Proposal Nos.", 0D, true);
        purchaseheader."No. Series" := GenLedgerSetup."Mission Proposal Nos.";
        purchaseheader."Strategic Focus Area" := stratrgicFocusarea;
        purchaseheader."Sub Pillar" := subpillar;
        purchaseheader."Project Title" := projecttitle;
        purchaseheader.Country := country;
        purchaseheader.County := county;
        purchaseheader."Date(s) of Activity" := datesofActivities;
        purchaseheader."Mission Team" := missionteam;
        purchaseheader."Invited Members/Partners" := invitedmebers;
        purchaseheader."Shortcut Dimension 1 Code" := programcode;
        purchaseheader."Shortcut Dimension 2 Code" := fundcode;
        purchaseheader.MP := true;
        purchaseheader.Status := purchaseheader.Status::Open;
        purchaseheader."User ID" := UserId;
        purchaseheader."Shortcut Dimension 3 Code" := budgetdimesion;
        purchaseheader."Shortcut Dimension 4 Code" := departmentdimension;
        purchaseheader."Shortcut Dimension 5 Code" := budgetdescription;
        purchaseheader."Main Outcome" := outcome;
        purchaseheader.Background := background;
        purchaseheader."Contribution to focus" := strategicfocus;
        if empno = '' then Error('Session timeout please login and try again');
        purchaseheader."Employee No" := empno;
        purchaseheader.Validate("Employee No");
        purchaseheader.Insert;


        mssno := purchaseheader."No.";
    end;

    procedure fnUpdateMissionProporsal(stratrgicFocusarea: Code[60]; subpillar: Code[60]; projecttitle: Text; country: Code[80]; county: Code[90]; datesofActivities: Text; missionteam: Text; invitedmebers: Text; fundcode: Code[90]; programcode: Code[90]; No: Code[50]; departmentdimension: Code[50]; budgetdimesion: Code[50]; budgetdescription: Code[60]; background: Text; strategicfocus: Text; outcome: Text) msnno: Code[40]
    begin

        //GenLedgerSetup.GET();
        purchaseheader.Get(purchaseheader."document type"::Quote, No);
        //purchaseheader."No.":=No;
        //purchaseheader."No. Series":=GenLedgerSetup."Mission Proposal Nos.";
        purchaseheader."Strategic Focus Area" := stratrgicFocusarea;
        purchaseheader."Sub Pillar" := subpillar;
        purchaseheader."Project Title" := projecttitle;
        purchaseheader.Country := country;
        purchaseheader.County := county;
        purchaseheader."Date(s) of Activity" := datesofActivities;
        purchaseheader."Mission Team" := missionteam;
        purchaseheader."Invited Members/Partners" := invitedmebers;
        purchaseheader."Shortcut Dimension 1 Code" := fundcode;
        purchaseheader."Shortcut Dimension 2 Code" := programcode;
        purchaseheader.MP := true;
        purchaseheader.Status := purchaseheader.Status::Open;
        purchaseheader."User ID" := UserId;
        purchaseheader."User ID" := UserId;
        purchaseheader."Shortcut Dimension 3 Code" := budgetdimesion;
        purchaseheader."Shortcut Dimension 4 Code" := departmentdimension;
        purchaseheader."Shortcut Dimension 5 Code" := budgetdescription;
        purchaseheader."Main Outcome" := outcome;
        purchaseheader.Background := background;
        purchaseheader."Contribution to focus" := strategicfocus;
        purchaseheader.Modify;
        msnno := purchaseheader."No.";
    end;

    procedure fnPurchaseRequisitionList(empNo: Code[50]): Text
    var
        ObjImprestHeader: Record "Purchase Header";
        ObjHrEmployee: Record "HR Employees";
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        returnout: Text;
    begin
        if ObjHrEmployee.Get(empNo) then begin
            ObjImprestHeader.Reset();
            ObjImprestHeader.SetRange(PR, true);
            ObjImprestHeader.SetRange("Employee No", empNo);

            if ObjImprestHeader.FindFirst() then
                repeat
                    ObjImprestHeader.CalcFields(Amount);
                    JsonObject.Add('No', ObjImprestHeader."No.");
                    JsonObject.Add('Document_Date', ObjImprestHeader."Expected Receipt Date");
                    JsonObject.Add('Status', Format(ObjImprestHeader.Status));
                    JsonObject.Add('Amount', ObjImprestHeader.Amount);
                    JsonObject.Add('DepartmentCode', ObjImprestHeader."Shortcut Dimension 1 Code");
                    JsonObject.Add('DirectorateCode', ObjImprestHeader."Shortcut Dimension 2 Code");
                    JsonObject.Add('StartDate', ObjImprestHeader."Expected Receipt Date");
                    JsonObject.Add('EndDate', ObjImprestHeader."Document Date");
                    JsonObject.Add('Completed', ObjImprestHeader.Completed);
                    JsonObject.Add('StrategicFocusArea', ObjImprestHeader."Strategic Focus Area");
                    JsonObject.Add('SubPillar', ObjImprestHeader."Sub Pillar");
                    JsonObject.Add('ProjectTitle', ObjImprestHeader."Project Title");
                    JsonObject.Add('Country', ObjImprestHeader.Country);
                    JsonObject.Add('County', ObjImprestHeader.Country);
                    JsonObject.Add('DateOfActivity', ObjImprestHeader."Date(s) of Activity");
                    JsonObject.Add('MissionTeam', ObjImprestHeader."Mission Team");
                    JsonObject.Add('InvitedMembers', ObjImprestHeader."Invited Members/Partners");
                    JsonObject.Add('FundCode', ObjImprestHeader."Shortcut Dimension 1 Code");
                    JsonObject.Add('ProgramCode', ObjImprestHeader."Shortcut Dimension 2 Code");
                    JsonObject.Add('missionNo', ObjImprestHeader."Mission Proposal No");
                    JsonObject.Add('budgetdminesion', ObjImprestHeader."Shortcut Dimension 3 Code");
                    JsonObject.Add('departmentdimension', ObjImprestHeader."Shortcut Dimension 5 Code");
                    JsonObject.Add('budgetdescription', ObjImprestHeader."Shortcut Dimension 4 Code");

                    JsonArray.Add(JsonObject);
                until ObjImprestHeader.Next() = 0;
        end;

        JsonArray.WriteTo(returnout);
        exit(returnout);
    end;

    procedure fnInsertPurchaseRequest(fundcode: Code[90]; programcode: Code[90]; daterequried: Date; missionno: Code[50]; departmentdimension: Code[50]; budgetdimesion: Code[50]; budgetdescription: Code[60]; empno: Code[40])
    begin
        purchaseheader.Init;
        GenLedgerSetup.Get();
        purchaseheader."No." := objNumSeries.GetNextNo(GenLedgerSetup."Requisition Nos.", 0D, true);
        purchaseheader."No. Series" := GenLedgerSetup."Requisition Nos.";
        purchaseheader."Document Type" := purchaseheader."document type"::Quote;
        purchaseheader.DocApprovalType := purchaseheader.Docapprovaltype::Requisition;

        purchaseheader."Expected Receipt Date" := daterequried;
        purchaseheader."Mission Proposal No" := missionno;
        purchaseheader."Shortcut Dimension 1 Code" := fundcode;
        purchaseheader."Shortcut Dimension 2 Code" := programcode;
        purchaseheader.PR := true;
        purchaseheader.Requisition := true;
        purchaseheader.Status := purchaseheader.Status::Open;
        purchaseheader."User ID" := UserId;
        purchaseheader."Shortcut Dimension 3 Code" := budgetdimesion;
        purchaseheader."Shortcut Dimension 4 Code" := departmentdimension;
        purchaseheader."Shortcut Dimension 5 Code" := budgetdescription;
        purchaseheader."Employee No" := empno;
        purchaseheader.Validate("Employee No");
        purchaseheader.Insert;
    end;

    procedure fninsertimprestnew(fundcode: Code[50]; programcode: Code[50]; purpose: Code[100]; departmentdimension: Code[50]; budgetdimesion: Code[50]; budgetdescription: Code[60]; empno: Code[60]; missionproporsal: Code[100]; purchaserequestNo: Code[50]) impno: Code[50]
    begin
        purchaseheader.Init;
        GenLedgerSetup.Get();
        purchaseheader."No." := objNumSeries.GetNextNo(GenLedgerSetup."Imprest Nos.", 0D, true);
        purchaseheader."No. Series" := GenLedgerSetup."Imprest Nos.";
        purchaseheader."Document Type" := purchaseheader."document type"::Quote;
        //purchaseheader.DocApprovalType:=purchaseheader.DocApprovalType::;
        purchaseheader."Posting Description" := purpose;
        purchaseheader."Posting Date" := Today;
        //purchaseheader."Employee No":=empno;
        if objHREmployees.Get(empno) then begin
            //  ObjImprestRequisition.Cashier:=objHREmployees."User ID";
            //  IF UserSetup.GET(objHREmployees."User ID")THEN BEGIN
            //  UserSetup.TESTFIELD(UserSetup.ImprestAccount);
            // purchaseheader ."Account Type":=ObjImprestRequisition."Account Type"::Customer;
            purchaseheader."Account No" := objHREmployees.Travelaccountno;
            purchaseheader.Validate("Account No");
            // END; //ELSE

            // ERROR('User must be setup under User Setup and their respective Account Entered');
        end;

        //purchaseheader."Requested Receipt Date":=daterequried;
        //purchaseheader."Mission Proposal No":=missionno;
        purchaseheader."Shortcut Dimension 1 Code" := fundcode;
        purchaseheader."Shortcut Dimension 2 Code" := programcode;
        purchaseheader.IM := true;
        purchaseheader."Requisition No" := purchaserequestNo;
        purchaseheader.Status := purchaseheader.Status::Open;
        purchaseheader."User ID" := UserId;
        purchaseheader."Shortcut Dimension 3 Code" := budgetdimesion;
        purchaseheader."Shortcut Dimension 4 Code" := departmentdimension;
        purchaseheader."Shortcut Dimension 5 Code" := budgetdescription;
        purchaseheader."Mission Proposal No" := missionproporsal;
        purchaseheader."Employee No" := empno;
        purchaseheader.Validate("Employee No");
        purchaseheader.Insert;

        impno := purchaseheader."No.";
    end;

    procedure fnimprestlineinsert(expensecategory: Code[50]; description: Text; unitcost: Decimal; currency: Code[10]; amount: Decimal; documentno: Code[50])
    begin
        purchaseline.Init;
        purchaseline."Document No." := documentno;
        PurchasesPayablesSetup.Get;
        Evaluate(purchaseline."Line No.", objNumSeries.GetNextNo(PurchasesPayablesSetup."Line Nos.", Today, true));
        purchaseline."Expense Category" := expensecategory;
        purchaseline.Validate("Expense Category");
        purchaseline.Description := description;
        purchaseline."Direct Unit Cost" := unitcost;
        purchaseline."Currency Code" := currency;
        purchaseline.Validate("Currency Code");
        purchaseline.Quantity := amount;
        purchaseline.Validate("Direct Unit Cost");
        purchaseline.Insert;
    end;

    procedure fninsertPurchasenew(fundcode: Code[50]; programcode: Code[50]; purpose: Code[40]; daterequired: Date; departmentdimension: Code[50]; budgetdimesion: Code[50]; budgetdescription: Code[60]; missionno: Code[50]; empno: Code[50]) impno: Code[50]
    begin
        purchaseheader.Init;
        GenLedgerSetup.Get();
        purchaseheader."No." := objNumSeries.GetNextNo(GenLedgerSetup."Requisition Nos.", 0D, true);
        purchaseheader."No. Series" := GenLedgerSetup."Requisition Nos.";
        purchaseheader."Document Type" := purchaseheader."document type"::Quote;
        purchaseheader.DocApprovalType := purchaseheader.Docapprovaltype::Requisition;
        purchaseheader."Posting Description" := purpose;
        purchaseheader."Posting Date" := Today;
        purchaseheader."Mission Proposal No" := missionno;
        purchaseheader."Expected Receipt Date" := daterequired;
        //purchaseheader."Mission Proposal No":=missionno;
        purchaseheader."Shortcut Dimension 2 Code" := fundcode;
        purchaseheader."Shortcut Dimension 1 Code" := programcode;
        purchaseheader.PR := true;
        purchaseheader.Requisition := true;
        purchaseheader.Status := purchaseheader.Status::Open;
        purchaseheader."User ID" := UserId;
        purchaseheader."Shortcut Dimension 3 Code" := budgetdimesion;
        purchaseheader."Shortcut Dimension 5 Code" := departmentdimension;
        purchaseheader."Shortcut Dimension 4 Code" := budgetdescription;
        purchaseheader."Employee No" := empno;
        purchaseheader.Validate("Employee No");
        purchaseheader.Insert;

        impno := purchaseheader."No.";
    end;

    procedure fnPurchaselineinsert(expensecategory: Code[50]; description: Text; unicost: Decimal; currency: Code[10]; amount: Decimal; documentno: Code[50])
    begin
        purchaseline.Init;
        PurchasesPayablesSetup.Get;
        Evaluate(purchaseline."Line No.", objNumSeries.GetNextNo(PurchasesPayablesSetup."Line Nos.", Today, true));
        purchaseline."Document No." := documentno;
        purchaseline."Expense Category" := expensecategory;
        purchaseline.Validate("Expense Category");
        purchaseline."Direct Unit Cost" := unicost;
        purchaseline.Quantity := amount;
        purchaseline."Currency Code" := currency;
        purchaseline.Validate("Currency Code");
        purchaseline.Validate("Direct Unit Cost");
        purchaseline."Description 2" := description;

        purchaseline.Insert;
    end;

    procedure fnDimensionValuesList(fundcode: Code[50]) returnout: Text
    var
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        countryRegions: Record "Dimension Value";
    begin

        if fundcode <> '' then
            //countryRegions.SetRange("Fund Code", fundcode);

            // Check if there are any records to process
            if countryRegions.Find('-') then
                repeat
                    JsonObject.Add('Code', countryRegions.Code);
                    JsonObject.Add('Name', countryRegions.Name);
                    JsonObject.Add('Type', countryRegions."Global Dimension No.");
                    JsonArray.Add(JsonObject);

                until countryRegions.Next = 0;

        JsonArray.WriteTo(returnout);
        exit(returnout);
    end;

    procedure fnApproval(no: Code[50])
    begin
        purchaseheader.Reset;
        purchaseheader.SetRange("No.", no);
        if purchaseheader.Find('-') then begin
            if (ApprovalMgt.CheckPurchaseApprovalPossible(purchaseheader)) then
                ApprovalMgt.OnSendPurchaseDocForApproval(purchaseheader);
        end;
    end;

    procedure fncancelApproval(no: Code[50])
    begin
        purchaseheader.Reset;
        purchaseheader.SetRange("No.", no);
        if purchaseheader.Find('-') then begin
            if (ApprovalMgt.CheckPurchaseApprovalPossible(purchaseheader)) then
                ApprovalMgt.OnCancelPurchaseApprovalRequest(purchaseheader);
        end;
    end;

    procedure fnSurrenderList(empNo: Code[50]) returnout: Text
    var
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        ObjImprestHeader: Record "Purchase Header";
        ObjHrEmployee: Record "HR Employees";
        dimensionvalues: Record "Dimension Value";
    begin
        if ObjHrEmployee.Get(empNo) then begin

            ObjImprestHeader.Reset;
            ObjImprestHeader.SetRange(SR, true);
            ObjImprestHeader.SetRange("Employee No", empNo);
            if ObjImprestHeader.Find('-') then
                repeat
                    ObjImprestHeader.CalcFields(Amount);
                    JsonObject.Add('No', ObjImprestHeader."No.");
                    JsonObject.Add('Document_Date', ObjImprestHeader."Document Date");
                    JsonObject.Add('Status', ObjImprestHeader.Status);
                    JsonObject.Add('Amount', ObjImprestHeader.Amount);
                    JsonObject.Add('DepartmentCode', ObjImprestHeader."Shortcut Dimension 1 Code");
                    JsonObject.Add('DirectorateCode', ObjImprestHeader."Shortcut Dimension 2 Code");
                    JsonObject.Add('StartDate', ObjImprestHeader."Document Date");
                    JsonObject.Add('EndDate', ObjImprestHeader."Document Date");
                    JsonObject.Add('Completed', ObjImprestHeader.Completed);
                    JsonObject.Add('StrategicFocusArea', ObjImprestHeader."Strategic Focus Area");
                    JsonObject.Add('SubPillar', ObjImprestHeader."Sub Pillar");
                    JsonObject.Add('ProjectTitle', ObjImprestHeader."Project Title");
                    JsonObject.Add('Country', ObjImprestHeader.Country);
                    JsonObject.Add('County', ObjImprestHeader.Country);
                    JsonObject.Add('DateOfActivity', ObjImprestHeader."Date(s) of Activity");
                    JsonObject.Add('MissionTeam', ObjImprestHeader."Mission Team");
                    JsonObject.Add('InvitedMembers', ObjImprestHeader."Invited Members/Partners");
                    JsonObject.Add('FundCode', ObjImprestHeader."Shortcut Dimension 1 Code");
                    JsonObject.Add('ProgramCode', ObjImprestHeader."Shortcut Dimension 2 Code");
                    JsonObject.Add('Completed', ObjImprestHeader."Imprest No");
                    dimensionvalues.Reset;
                    dimensionvalues.SetRange("Dimension Code", ObjImprestHeader."Shortcut Dimension 4 Code");

                    JsonObject.Add('budgetdimension', ObjImprestHeader."Shortcut Dimension 3 Code");

                    if dimensionvalues.FindFirst then
                        JsonObject.Add('departmentdimension', dimensionvalues.Name);
                    JsonObject.Add('budgetdescription', ObjImprestHeader."Shortcut Dimension 5 Code");

                    // Add the JsonObject to the JsonArray
                    JsonArray.Add(JsonObject);

                until ObjImprestHeader.Next = 0;
        end;

        JsonArray.WriteTo(returnout);
        exit(returnout);
    end;

    procedure fnInstImrSrNew(imprestno: Code[50]; empno: Code[50]) impsurrno: Code[50]
    begin
        purchaseheader.Init;
        GenLedgerSetup.Get();
        HREmployees.Get(empno);
        purchaseheader."No." := objNumSeries.GetNextNo(GenLedgerSetup."Surrender Nos.", 0D, true);
        purchaseheader."No. Series" := GenLedgerSetup."Surrender Nos.";
        purchaseheader."Document Type" := purchaseheader."document type"::Quote;
        purchaseheader.DocApprovalType := purchaseheader.Docapprovaltype::Requisition;
        purchaseheader."Account No" := HREmployees.Travelaccountno;
        purchaseheader.Validate("Account No");
        purchaseheader."Document Date" := Today;
        purchaseheader."Posting Date" := Today;
        purchaseheader."Employee No" := empno;
        purchaseheader.Validate("Employee No");
        //purchaseheader."Requested Receipt Date":=daterequried;
        purchaseheader.Insert;

        //purchaseheader."Shortcut Dimension 1 Code":=fundcode;
        //purchaseheader."Shortcut Dimension 2 Code":=programcode;
        purchaseheader.SR := true;
        purchaseheader."Imprest No" := imprestno;
        purchaseheader.Validate("Imprest No");
        purchaseheader.InsertPortal := true;
        purchaseheader.Validate(InsertPortal);
        purchaseheader.Status := purchaseheader.Status::Open;
        purchaseheader."User ID" := UserId;
        //purchaseheader."Shortcut Dimension 3 Code":=budgetdimesion;
        //purchaseheader."Shortcut Dimension 4 Code":=departmentdimension;
        //purchaseheader."Shortcut Dimension 5 Code":=budgetdescription;
        //purchaseheader.VALIDATE("Shortcut Dimension 1 Code");
        //purchaseheader.VALIDATE("Shortcut Dimension 2 Code");
        //purchaseheader.VALIDATE("Shortcut Dimension 3 Code");
        //purchaseheader.VALIDATE("Shortcut Dimension 4 Code");
        //purchaseheader.VALIDATE("Shortcut Dimension 5 Code");
        purchaseheader.Modify;

        impsurrno := purchaseheader."No.";
    end;

    procedure fninsertbudgetinfo(budgetitem: Text; identifiedvendor: Text; documentno: Code[50]; noofdays: Decimal; noofpas: Decimal; ksh: Decimal; othercurrency: Decimal; missionexpensecategory: Code[50]; currencycode: Code[50])
    begin
        purchaseline.Init;
        //purchaseline."Line No.":=RANDOM(1000)+RANDOM(1000);
        PurchasesPayablesSetup.Get;
        Evaluate(purchaseline."Line No.", objNumSeries.GetNextNo(PurchasesPayablesSetup."Line Nos.", Today, true));
        purchaseline."Description 2" := budgetitem;
        purchaseline."Description 3" := identifiedvendor;
        purchaseline."Document No." := documentno;
        purchaseline."No of days" := noofdays;
        purchaseline."No of pax" := noofpas;
        purchaseline."Line Type" := purchaseline."line type"::"Budget Info";
        purchaseline.Ksh := ksh;
        purchaseline."other currency" := othercurrency;
        purchaseline."Currency Code" := currencycode;
        purchaseline.Validate("Currency Code");
        purchaseline.Validate(Ksh);
        purchaseline.Validate("other currency");
        purchaseline."Mission Expense Category" := missionexpensecategory;
        purchaseline.Insert;
    end;

    procedure fninsertteamroles(name: Text; responsibility: Text; documentno: Code[50])
    begin
        purchaseline.Init;
        //purchaseline."Line No.":=RANDOM(1000)+RANDOM(1000);
        PurchasesPayablesSetup.Get;
        Evaluate(purchaseline."Line No.", objNumSeries.GetNextNo(PurchasesPayablesSetup."Line Nos.", Today, true));
        purchaseline."Document No." := documentno;
        purchaseline."Description 2" := name;
        purchaseline."Description 3" := responsibility;
        purchaseline."Line Type" := purchaseline."line type"::"Team Roles";
        purchaseline.Insert;
    end;

    procedure fninsertmisssionobjectives(description: Text; documentno: Code[50])
    begin
        purchaseline.Init;
        //purchaseline."Line No.":=RANDOM(1000)+RANDOM(1000);
        PurchasesPayablesSetup.Get;
        Evaluate(purchaseline."Line No.", objNumSeries.GetNextNo(PurchasesPayablesSetup."Line Nos.", Today, true));
        purchaseline."Document No." := documentno;
        purchaseline."Description 2" := description;
        purchaseline."Line Type" := purchaseline."line type"::Objectives;
        purchaseline.Insert;
    end;

    procedure fninsertmissionactivities(date: Date; activity: Text; documentno: Code[50]; duration: Text; output: Text)
    var
        LINENO: Integer;
    begin
        purchaseline.Init;
        //purchaseline."Line No.":=RANDOM(1000)+RANDOM(1000);
        PurchasesPayablesSetup.Get;
        Evaluate(purchaseline."Line No.", objNumSeries.GetNextNo(PurchasesPayablesSetup."Line Nos.", Today, true));
        purchaseline."Document No." := documentno;
        purchaseline."Expected Receipt Date" := date;

        purchaseline."Description 3" := activity;
        purchaseline."Unit of Measure" := duration;
        purchaseline."Description 2" := output;
        purchaseline."Line Type" := purchaseline."line type"::Activity;
        purchaseline.Insert;
    end;

    procedure fnpurchaseLines(DocumentNo: Code[20]) returnout: Text
    var
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        ObjImprestLine: Record "Purchase Line";

    begin
        ObjImprestLine.Reset;
        ObjImprestLine.SetRange("Document No.", DocumentNo);
        if ObjImprestLine.FindFirst then
            repeat
                JsonObject.Add('DocumentNo', ObjImprestLine."Document No.");
                JsonObject.Add('Description2', ObjImprestLine."Description 2");
                JsonObject.Add('Description3', ObjImprestLine."Description 3");
                JsonObject.Add('LineType', ObjImprestLine."Line Type");
                JsonObject.Add('UOM', ObjImprestLine."Unit of Measure");
                JsonObject.Add('ExpectedReceiptDate', ObjImprestLine."Expected Receipt Date");
                JsonObject.Add('NoOfDays', ObjImprestLine."No of days");
                JsonObject.Add('NoOfPax', ObjImprestLine."No of pax");
                JsonObject.Add('Ksh', ObjImprestLine.Ksh);
                JsonObject.Add('OtherCurrency', ObjImprestLine."other currency");
                JsonObject.Add('ExpenseCategory', ObjImprestLine."Mission Expense Category");
                JsonObject.Add('Totalksh', ObjImprestLine."Total Ksh");
                JsonObject.Add('TotalCurrency', ObjImprestLine."Total Other Currency");
                JsonObject.Add('DocumentType', ObjImprestLine."Document Type");
                JsonObject.Add('AmountSpent', ObjImprestLine."Amount Spent");
                JsonObject.Add('CashRefund', ObjImprestLine."Cash Refund");
                JsonObject.Add('details', ObjImprestLine."Description 3");
                JsonObject.Add('Vendor1', ObjImprestLine."Description 2");
                JsonObject.Add('Vendor2', ObjImprestLine."Description 4");
                JsonObject.Add('Vendor3', ObjImprestLine."Description 5");
                JsonObject.Add('Comments', ObjImprestLine."Description 6");
                JsonObject.Add('currencyCode', ObjImprestLine."Currency Code");
                if currencycodes.Get(ObjImprestLine."Currency Code") then
                    JsonObject.Add('currencyName', currencycodes.Description);
                JsonObject.Add('LineNo', ObjImprestLine."Line No.");
                JsonArray.Add(JsonObject);

            until ObjImprestLine.Next = 0;
        JsonArray.WriteTo(returnout);
        exit(returnout);
    end;

    procedure fnInsertGeneralJournal(PostingDate: Date; DocumentNo: Code[50]; PayingBank: Code[50]; Amount: Decimal; Descirption: Text; empNo: Code[60]; glaccount: Code[40]; fundCode: Code[40]; currency: Code[15])
    var
        usertemplate: Code[50];
        lineno: Integer;
    begin
        HREmployees.Reset;
        HREmployees.SetRange("No.", empNo);
        if HREmployees.Find('-') then begin


            if UserSetup.Get(HREmployees."User ID") then begin
                usertemplate := UserSetup."Payments Batch";
            end else begin
                usertemplate := HREmployees."Payments Batch";
            end;
            //GenJournalLine2.
            lineno := GenJournalLine2.Count() + 2000;
            GenJournalLine.Init;
            GenJournalLine."Line No." := lineno;
            GenJournalLine."Journal Batch Name" := usertemplate;
            GenJournalLine."Journal Template Name" := 'PAYMENTS';
            GenJournalLine.Description := Descirption;
            GenJournalLine.Amount := Amount;
            GenJournalLine."Account No." := glaccount;
            GenJournalLine."Currency Code" := currency;
            GenJournalLine.Validate("Currency Code");
            GenJournalLine."Shortcut Dimension 1 Code" := fundCode;
            GenJournalLine."Document No." := DocumentNo;
            GenJournalLine.Validate("Document No.");
            GenJournalLine.Validate("Journal Template Name");
            GenJournalLine."Posting Date" := PostingDate;
            GenJournalLine.Validate("Posting Date");
            GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::"Bank Account";
            GenJournalLine."Bal. Account No." := PayingBank;
            //GenJournalLine.VALIDATE("Bal. Account No.");
            //GenJournalLine.VALIDATE("Bal. Account Type");
            GenJournalLine.Validate(Amount);
            if GenJournalLine.Amount <> 0 then begin
                GenJournalLine2.Reset;
                GenJournalLine2.SetRange("Document No.", DocumentNo);
                if not GenJournalLine2.Find('-') then
                    GenJournalLine.Insert;
            end;
        end;
    end;

    procedure fnJournalLines(empno: Code[20]; payingBank: Code[60]) returnout: Text
    var
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        HREmployees: Record "HR Employees";
        UserSetup: Record "User Setup";
        templatename: Code[100];
    begin

        HREmployees.Reset;
        if HREmployees.Get(empno) then begin
            UserSetup.Reset;
            if UserSetup.Get(HREmployees."User ID") then
                templatename := UserSetup."Payments Batch"
            else
                templatename := HREmployees."Payments Batch";
        end;

        GenJournalLine.Reset;
        GenJournalLine.SetFilter("Journal Template Name", 'PAYMENTS');
        GenJournalLine.SetFilter("Journal Batch Name", templatename);
        GenJournalLine.SetRange("Bal. Account No.", payingBank);
        if GenJournalLine.Find('-') then
            repeat
                JsonObject.Add('description', GenJournalLine.Description);
                JsonObject.Add('glAccount', GenJournalLine."Account No.");
                JsonObject.Add('fundCode', GenJournalLine."Shortcut Dimension 1 Code");
                JsonObject.Add('postingDate', GenJournalLine."Posting Date");
                JsonObject.Add('documentNo', GenJournalLine."Document No.");
                JsonObject.Add('bank', payingBank);
                JsonObject.Add('amount', GenJournalLine.Amount);
                JsonObject.Add('lineno', GenJournalLine."Line No.");
                JsonObject.Add('currency', GenJournalLine."Currency Code");

                JsonArray.Add(JsonObject);
            until GenJournalLine.Next = 0;
        JsonArray.WriteTo(returnout);
        exit(returnout);

    end;

    procedure fnUpdatebudgetinfo(budgetitem: Text; identifiedvendor: Text; documentno: Code[50]; noofdays: Decimal; noofpas: Decimal; ksh: Decimal; othercurrency: Decimal; missionexpensecategory: Code[50]; Documenttype: Code[60]; Lineno: Integer; linetype: Integer; date: Date; activity: Text; duration: Text; output: Text; name: Text; responsibility: Text; description: Text; currenccycode: Code[50])
    begin
        purchaseline."Line No." := Lineno;

        purchaseline."Document No." := documentno;
        purchaseline."No of days" := noofdays;
        purchaseline."No of pax" := noofpas;
        purchaseline."Line Type" := linetype;
        purchaseline.Ksh := ksh;
        purchaseline."other currency" := othercurrency;
        purchaseline.Validate(Ksh);
        purchaseline.Validate("other currency");
        purchaseline."Mission Expense Category" := missionexpensecategory;
        purchaseline."Currency Code" := currenccycode;
        purchaseline.Validate("Currency Code");
        if linetype = 4 then begin
            purchaseline."Description 2" := budgetitem;
            purchaseline."Description 3" := identifiedvendor;
        end;
        if linetype = 3 then begin
            purchaseline."Expected Receipt Date" := date;
            purchaseline."Description 3" := activity;
            purchaseline."Unit of Measure" := duration;
            purchaseline."Description 2" := output;
        end;
        if linetype = 2 then begin
            purchaseline."Description 2" := name;
            purchaseline."Description 3" := responsibility;
        end;

        if linetype = 1 then begin
            purchaseline."Description 2" := description;
        end;

        purchaseline.Modify;
    end;

    procedure fnUpdatePurchasenew(fundcode: Code[50]; programcode: Code[50]; purpose: Code[40]; daterequired: Date; departmentdimension: Code[50]; budgetdimesion: Code[50]; budgetdescription: Code[60]; missionno: Code[50]; reqne: Code[50]) reqNo: Code[60]
    begin
        purchaseheader.Init;
        GenLedgerSetup.Get();
        purchaseheader."No." := reqne;
        purchaseheader2.Get(purchaseheader2."document type"::Quote, reqne);
        //purchaseheader."No. Series":=GenLedgerSetup."Requisition Nos.";
        purchaseheader."Document Type" := purchaseheader."document type"::Quote;
        purchaseheader.DocApprovalType := purchaseheader.Docapprovaltype::Requisition;
        purchaseheader."Posting Description" := purpose;
        purchaseheader."Posting Date" := Today;
        purchaseheader."Mission Proposal No" := missionno;
        purchaseheader."Expected Receipt Date" := daterequired;
        //purchaseheader."Mission Proposal No":=missionno;
        purchaseheader."Shortcut Dimension 1 Code" := fundcode;
        purchaseheader."Shortcut Dimension 2 Code" := programcode;
        purchaseheader.PR := true;
        purchaseheader.Requisition := true;
        purchaseheader.Status := purchaseheader.Status::Open;
        purchaseheader."User ID" := UserId;
        purchaseheader."Shortcut Dimension 3 Code" := budgetdimesion;
        purchaseheader."Shortcut Dimension 5 Code" := departmentdimension;
        purchaseheader."Shortcut Dimension 4 Code" := budgetdescription;
        purchaseheader."Employee No" := purchaseheader2."Employee No";
        purchaseheader.Validate("Employee No");
        purchaseheader.Modify;

        reqNo := reqne;
    end;

    procedure fngetLeaveBalanceType(empNo: Code[50]; leavetype: Code[50]) balance: Code[40]
    begin
        HREmployees.Reset;
        HREmployees.SetRange("No.", empNo);
        if HREmployees.Find('-') then begin
            HREmployees.CalcFields("Maternity Leave Acc.", "Paternity Leave Acc.", "Annual Leave Account", "Compassionate Leave Acc.", "Sick Leave Acc.", "Study Leave Acc", "CTO  Leave Acc.");
            if leavetype = 'COMPASSIONATE' then
                balance := Format(HREmployees."Compassionate Leave Acc.");
            if leavetype = 'EXAM' then
                balance := Format(HREmployees."Study Leave Acc");
            if leavetype = 'MATERNITY' then
                balance := Format(HREmployees."Maternity Leave Acc.");
            if leavetype = 'PATERNITY' then
                balance := Format(HREmployees."Paternity Leave Acc.");
            if leavetype = 'ANNUAL' then
                balance := Format(HREmployees."Annual Leave Account");
            if leavetype = 'SICK' then
                balance := Format(HREmployees."Sick Leave Acc.");
            if leavetype = 'CTO' then
                balance := Format(HREmployees."CTO  Leave Acc.");
        end;
    end;

    procedure fnInsertTrainingRequest(need: Text; empployees: Text; link: Text; purpose: Text; outcome: Text; details: Text; otherdetails: Text; empno: Code[60])
    begin
        TrainingRequests.Init;
        hrsetup.Get();
        TrainingRequests."Application Code" := objNumSeries.GetNextNo(hrsetup."Training Application Nos.", 0D, true);
        TrainingRequests.Validate("Application Code");
        TrainingRequests."No series" := hrsetup."Training Application Nos.";
        TrainingRequests."Employee Code" := empno;
        TrainingRequests.Validate("Employee Code");
        TrainingRequests."Training Need" := need;
        TrainingRequests."Employees Involved" := empployees;
        TrainingRequests."Business Linkage" := link;
        TrainingRequests."Job Relation" := purpose;
        TrainingRequests."Hope to Learn" := outcome;
        TrainingRequests."Details of Training" := details;
        TrainingRequests."Other Details" := otherdetails;
        TrainingRequests.Insert(true);
    end;

    procedure FnTrainingList(empno: Code[60]) returnout: Text
    var
        JsonArray: JsonArray;
        JsonObject: JsonObject;
    begin

        TrainingRequests.Reset;
        TrainingRequests.SetRange("Employee Code", empno);
        if TrainingRequests.Find('-') then
            repeat

                JsonObject.Add('ApplicationNo', TrainingRequests."Application Code");
                JsonObject.Add('need', TrainingRequests."Training Need");
                JsonObject.Add('employees', TrainingRequests."Employees Involved");
                JsonObject.Add('link', TrainingRequests."Business Linkage");
                JsonObject.Add('purpose', TrainingRequests."Job Relation");
                JsonObject.Add('outcome', TrainingRequests."Hope to Learn");
                JsonObject.Add('details', TrainingRequests."Details of Training");
                JsonObject.Add('otherdetails', TrainingRequests."Other Details");
                JsonObject.Add('status', TrainingRequests.Status);

                JsonArray.Add(JsonObject);
            until TrainingRequests.Next = 0;
        JsonArray.WriteTo(returnout);
        exit(returnout);
    end;

    procedure fnUpdateTrainingRequest(need: Text; empployees: Text; link: Text; purpose: Text; outcome: Text; details: Text; otherdetails: Text; empno: Code[60]; ApplicationNo: Code[60])
    begin
        TrainingRequests.Init;
        hrsetup.Get();
        TrainingRequests.Reset;
        TrainingRequests.SetRange("Application Code", ApplicationNo);
        if TrainingRequests.Find('-') then begin
            TrainingRequests."Application Code" := objNumSeries.GetNextNo(hrsetup."Training Application Nos.", 0D, true);
            TrainingRequests.Validate("Application Code");
            TrainingRequests."No series" := hrsetup."Training Application Nos.";
            TrainingRequests."Employee Code" := empno;
            TrainingRequests.Validate("Employee Code");
            TrainingRequests."Training Need" := need;
            TrainingRequests."Employees Involved" := empployees;
            TrainingRequests."Business Linkage" := link;
            TrainingRequests."Job Relation" := purpose;
            TrainingRequests."Hope to Learn" := outcome;
            TrainingRequests."Details of Training" := details;
            TrainingRequests."Other Details" := otherdetails;
            TrainingRequests.Modify;
        end;
    end;

    procedure fnReqTrainingApproval(no: Code[50])
    var
        variancerec: Variant;
    begin
        TrainingRequests.Reset;
        TrainingRequests.SetRange("Application Code", no);
        if TrainingRequests.Find('-') then begin
            variancerec := TrainingRequests;

            ApprovalsMgt1.CheckApprovalsWorkflowEnabled(variancerec);
            ApprovalsMgt1.OnSendDocForApproval(variancerec);
        end;
    end;

    // procedure fnInsertAttachments(Extension: Text; File: BigText; DocumentNo: Code[50]; Description: Text)
    // var
    //     Bytes: dotnet Array;
    //     Convert: dotnet Convert;
    //     MemoryStream: dotnet MemoryStream;
    //     Ostream: OutStream;
    //     counter: Integer;
    // begin
    //     FName := Description;
    //     Seperator := '.';
    //     Values := FName.Split(Seperator.ToCharArray());
    //     counter := 1;
    //     foreach Value in Values do begin
    //         Fileset[counter] := Value;
    //         counter := counter + 1;
    //     end;

    //     documents.Init;
    //     documents2.SetCurrentkey("Attachment No.");
    //     documents2.Ascending := true;
    //     if documents2.FindLast then
    //         documents."Attachment No." := documents2."Attachment No." + 1
    //     else
    //         documents."Attachment No." := 1;
    //     documents."Doc No." := DocumentNo;
    //     documents."Document Description" := Fileset[1];
    //     documents.Validate("Document Description");
    //     documents.Attachment := documents.Attachment::Yes;

    //     attachments.Init;
    //     attachments."No." := documents."Attachment No.";
    //     attachments."File Extension" := Fileset[2];

    //     attachments.Insert;
    //     attachments2.Reset;
    //     attachments2.Get(documents."Attachment No.");
    //     Bytes := Convert.FromBase64String(File);
    //     MemoryStream := MemoryStream.MemoryStream(Bytes);
    //     attachments2."Attachment File".CreateOutstream(Ostream);
    //     MemoryStream.WriteTo(Ostream);
    //     attachments2.Modify;
    //     //END;
    //     inttemplate.Init;
    //     inttemplate."Attachment No." := documents."Attachment No.";
    //     inttemplate."Interaction Template Code" := DocumentNo;
    //     inttemplate.Description := Fileset[1];
    //     inttemplate.Insert;

    //     documents.Insert;
    // end;

    procedure fnUploadedDocuments(documentNo: Code[60]) returnout: Text
    var
        JsonArray: JsonArray;
        JsonObject: JsonObject;

    begin
        documents.Reset;
        documents.SetRange("Doc No.", documentNo);
        documents.SetRange(Attachment, documents.Attachment::Yes);
        if documents.Find('-') then
            repeat

                JsonObject.Add('AttachmentNo', documents."Attachment No.");
                JsonObject.Add('DocumentDescription', documents."Document Description");
                JsonObject.Add('DocumentNo', documents."Doc No.");
                JsonObject.Add('jnlDocument', documents."Document Link");
                JsonArray.Add(JsonObject);
            until documents.Next = 0;
        JsonArray.WriteTo(returnout);
        exit(returnout);
    end;

    procedure fnSurrenderLineUpdate(lineno: Integer; amountsepnt: Decimal; document: Code[50]; cashrefund: Decimal)
    begin
        //purchaseline.INIT;

        purchaseline.Reset;
        purchaseline.SetRange("Document No.", document);
        purchaseline.SetRange("Line No.", lineno);
        if purchaseline.Find('-') then begin

            //purchaseline."Line No.":=lineno;
            purchaseline."Amount Spent" := amountsepnt;
            purchaseline."Cash Refund" := cashrefund;
            //purchaseline."Document No.":=document;
            purchaseline.Validate("Amount Spent");
            purchaseline.Modify;
        end;
    end;

    procedure fnTrainingSchedule() returnout: Text
    var
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        Trainingscehdule: Record "Training Schedule";
    begin
        Trainingscehdule.Reset;
        if Trainingscehdule.Find('-') then
            repeat

                JsonObject.Add('topic', Trainingscehdule.Topic);
                JsonObject.Add('Year', Trainingscehdule.Year);
                JsonObject.Add('Facilitator', Trainingscehdule.Facilitator);
                JsonObject.Add('ScheduledDate', Format(Trainingscehdule."Scheduled date"));
                JsonObject.Add('Employees', Trainingscehdule."No. of Staff trained");
                JsonObject.Add('Evidence', Trainingscehdule."Evidence of training");
                JsonObject.Add('status', Trainingscehdule.Status);
                JsonArray.Add(JsonObject);
            until Trainingscehdule.Next = 0;

        JsonArray.WriteTo(returnout);
        exit(returnout);
    end;


    procedure fininserttrainingschedule(year: Text; facilitator: Text; scheduleDate: Date; Employees: Text; evidence: Text; department: Text; topic: Text)
    begin
        Trainingscehdule.Init;
        Trainingscehdule.Year := year;
        Trainingscehdule.Facilitator := facilitator;
        Trainingscehdule."Scheduled date" := scheduleDate;
        Trainingscehdule.Validate("Scheduled date");
        Trainingscehdule."No. of Staff trained" := Employees;
        Trainingscehdule."Evidence of training" := evidence;
        Trainingscehdule."Department/Organization" := department;
        Trainingscehdule.Topic := topic;
        Trainingscehdule.Status := Trainingscehdule.Status::Pending;
        Trainingscehdule.Insert;
    end;

    procedure fnDeletePurchaseLine(lineno: Integer; documentNo: Code[20])
    begin
        purchaseline.Get(purchaseline."document type"::Quote, documentNo, lineno);
        purchaseline.Delete;
    end;

    procedure fnimprestlinemodify(expensecategory: Code[50]; description: Text; unitcost: Decimal; currency: Code[10]; amount: Decimal; documentno: Code[50]; lienno: Integer)
    begin
        purchaseline.Init;
        purchaseline."Document No." := documentno;
        purchaseline."Line No." := lienno;
        purchaseline."Document Type" := purchaseline."document type"::Quote;
        purchaseline."Expense Category" := expensecategory;
        purchaseline.Validate("Expense Category");
        purchaseline."Direct Unit Cost" := unitcost;
        purchaseline."Currency Code" := currency;

        purchaseline.Quantity := amount;
        purchaseline.Validate("Direct Unit Cost");
        purchaseline.Validate("Currency Code");
        purchaseline.Modify;
    end;

    procedure fninsertimprestModify(fundcode: Code[50]; programcode: Code[50]; purpose: Code[40]; departmentdimension: Code[50]; budgetdimesion: Code[50]; budgetdescription: Code[60]; empno: Code[60]; missionproporsal: Code[40]; purchaserequestNo: Code[50]; document: Code[50])
    begin
        purchaseheader.Init;
        GenLedgerSetup.Get();
        purchaseheader."No." := document;
        purchaseheader."No. Series" := GenLedgerSetup."Imprest Nos.";
        purchaseheader."Document Type" := purchaseheader."document type"::Quote;
        //purchaseheader.DocApprovalType:=purchaseheader.DocApprovalType::;
        purchaseheader."Posting Description" := purpose;
        purchaseheader."Posting Date" := Today;
        //purchaseheader."Employee No":=empno;
        if objHREmployees.Get(empno) then begin
            //  ObjImprestRequisition.Cashier:=objHREmployees."User ID";
            if UserSetup.Get(objHREmployees."User ID") then begin
                UserSetup.TestField(UserSetup."Staff Travel Account");
                purchaseheader."Account No" := UserSetup."Staff Travel Account";
                purchaseheader.Validate("Account No");
            end; //ELSE
                 // ERROR('User must be setup under User Setup and their respective Account Entered');
        end;

        //purchaseheader."Requested Receipt Date":=daterequried;
        //purchaseheader."Mission Proposal No":=missionno;
        purchaseheader."Shortcut Dimension 1 Code" := fundcode;
        purchaseheader."Shortcut Dimension 2 Code" := programcode;
        purchaseheader.IM := true;
        purchaseheader."Requisition No" := purchaserequestNo;
        purchaseheader.Status := purchaseheader.Status::Open;
        purchaseheader."User ID" := UserId;
        purchaseheader."Shortcut Dimension 3 Code" := budgetdimesion;
        purchaseheader."Shortcut Dimension 4 Code" := departmentdimension;
        purchaseheader."Shortcut Dimension 5 Code" := budgetdescription;
        purchaseheader."Mission Proposal No" := missionproporsal;
        purchaseheader.Modify;

        //impno:=purchaseheader."No.";
    end;

    procedure fnPurchaselineModify(expensecategory: Code[50]; description: Text; unitcost: Decimal; currency: Code[20]; amount: Decimal; documentno: Code[50]; lineno: Integer)
    begin
        //purchaseline.INIT;
        purchaseline.Get(purchaseline."document type"::Quote, documentno, lineno);
        //purchaseline."Line No.":=lineno;
        //purchaseline."Document No.":=documentno;
        //purchaseline."Document Type":=purchaseline."Document Type"::Quote;
        purchaseline."Expense Category" := expensecategory;
        purchaseline.Validate("Expense Category");
        purchaseline."Direct Unit Cost" := unitcost;

        //purchaseline."Unit Cost":=unitcost;
        purchaseline."Currency Code" := currency;

        purchaseline.Quantity := amount;
        purchaseline.Validate("Currency Code");
        purchaseline.Validate("Direct Unit Cost");
        purchaseline."Description 2" := description;
        purchaseline.Modify;
    end;

    procedure fninsertBudgetNotes(details: Text; vendor1: Text; vendor2: Text; vendor3: Text; comments: Text; document: Code[60])
    begin
        purchaseline.Init;
        //purchaseline."Line No.":=RANDOM(1000)+RANDOM(1000);
        PurchasesPayablesSetup.Get;
        Evaluate(purchaseline."Line No.", objNumSeries.GetNextNo(PurchasesPayablesSetup."Line Nos.", Today, true));
        purchaseline."Description 2" := vendor1;
        purchaseline."Description 3" := details;
        purchaseline."Description 4" := vendor2;
        purchaseline."Description 5" := vendor3;
        purchaseline."Description 6" := comments;
        purchaseline."Document No." := document;
        purchaseline."Line Type" := purchaseline."line type"::"Budget Notes";
        purchaseline.Insert;
    end;

    procedure fnUdpateBudgetNotes(details: Text; vendor1: Text; vendor2: Text; vendor3: Text; comments: Text; document: Code[60]; lineno: Integer)
    begin
        //purchaseline.INIT;
        purchaseline."Line No." := lineno;
        purchaseline."Description 2" := vendor1;
        purchaseline."Description 3" := details;
        purchaseline."Description 4" := vendor2;
        purchaseline."Description 5" := vendor3;
        purchaseline."Description 6" := comments;
        purchaseline."Document No." := document;
        purchaseline."Line Type" := purchaseline."line type"::"Budget Notes";
        purchaseline.Modify;
    end;

    procedure fnGetcurrencyCodes() returnout: Text
    var
        JsonArray: JsonArray;
        JsonObject: JsonObject;

    begin
        JsonObject.Add('code', '');
        JsonObject.Add('name', '');
        JsonArray.Add(JsonObject);
        currencycodes.Reset;
        if currencycodes.Find('-') then
            repeat
                JsonObject.Add('code', currencycodes.Code);
                JsonObject.Add('name', currencycodes.Description);
                JsonArray.Add(JsonObject);
            until currencycodes.Next = 0;
        JsonArray.WriteTo(returnout);
        exit(returnout);
    end;

    // procedure fnGetAttachment(attachment: Integer; var PictureText: BigText) fileextension: Text
    // var
    //     PictureInStream: InStream;
    //     PictureOutStream: OutStream;
    //     TempBlob: Record TempBlob;
    // begin
    //     attachments.Reset;
    //     attachments.SetRange("No.", attachment);
    //     if attachments.Find('-') then begin
    //         attachments.CalcFields("Attachment File");
    //         if attachments."Attachment File".Hasvalue then begin
    //             //  PictureText.ADDTEXT(HREmployees
    //             Clear(PictureText);
    //             Clear(PictureInStream);
    //             HREmployees.Picture.CreateInstream(PictureInStream);
    //             TempBlob.DeleteAll;
    //             TempBlob.Init;
    //             TempBlob.Blob.CreateOutstream(PictureOutStream);
    //             CopyStream(PictureOutStream, PictureInStream);
    //             TempBlob.Insert;
    //             TempBlob.CalcFields(Blob);
    //             PictureText.AddText(TempBlob.ToBase64String);
    //         end;
    //     end;
    // end;

    procedure fnDeleteAttachment(attachment: Integer)
    begin
        attachments.Reset;
        attachments.SetRange("No.", attachment);
        if attachments.Find('-') then begin


            documents.Reset;
            documents.SetRange("Attachment No.", attachment);
            if documents.Find('-') then begin
                documents.Delete;
            end;
            attachments.Delete;
        end;
    end;

    local procedure fnGetNoticeBoard() returnout: Text
    var
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        notice: Record "Notice Board";
    begin
        notice.Reset;
        if notice.Find('-') then
            repeat
                JsonObject.Add('text', notice.Announcement);
                JsonObject.Add('date', Format(notice."Date of Announcement"));
                JsonObject.Add('by', notice."Department Announcing");
                JsonArray.Add(JsonObject);
            until notice.Next = 0;
        JsonArray.WriteTo(returnout);
        exit(returnout);
    end;

    // local procedure fnAppreciation(var PictureText: BigText)
    // var
    //     PictureInStream: InStream;
    //     PictureOutStream: OutStream;
    //     TempBlob: Record TempBlob;
    // begin

    //     if hrsetup.Get() then begin
    //         hrsetup.CalcFields("Employee Picture");
    //         if hrsetup."Employee Picture".Hasvalue then begin
    //             //  PictureText.ADDTEXT(HREmployees
    //             Clear(PictureText);
    //             Clear(PictureInStream);
    //             hrsetup."Employee Picture".CreateInstream(PictureInStream);
    //             TempBlob.DeleteAll;
    //             TempBlob.Init;
    //             TempBlob.Blob.CreateOutstream(PictureOutStream);
    //             CopyStream(PictureOutStream, PictureInStream);
    //             TempBlob.Insert;
    //             TempBlob.CalcFields(Blob);
    //             PictureText.AddText(TempBlob.ToBase64String);
    //         end;
    //     end;
    // end;

    procedure fnGetApprovalEntries(DocumentNo: Code[40]) returnout: Text
    var
        JsonArray: JsonArray;
        JsonObject: JsonObject;

    begin
        approvalentries.Reset;
        approvalentries.SetRange("Document No.", DocumentNo);
        approvalentries.SetCurrentkey("Entry No.");
        approvalentries.Ascending(true);

        if approvalentries.Find('-') then begin
            repeat
                JsonObject.Add('approverid', approvalentries."Approver ID");
                JsonObject.Add('status', approvalentries.Status);
                JsonObject.Add('lastmodified', approvalentries."Last Date-Time Modified");
                JsonObject.Add('comments', approvalentries.Comments);
                JsonArray.Add(JsonObject);
            until approvalentries.Next = 0;
        end;
        JsonArray.WriteTo(returnout);
        exit(returnout);
    end;

    // procedure fnUploadedDocuments2(documentNo: Code[60]) returnout: Text
    // var
    //     JsonOut: dotnet String;
    //     PictureInStream: InStream;
    //     PictureOutStream: OutStream;
    //     TempBlob: Record TempBlob;
    //     PictureText: BigText;
    // begin
    //     StringBuilder := StringBuilder.StringBuilder;
    //     StringWriter := StringWriter.StringWriter(StringBuilder);
    //     JSONTextWriter := JSONTextWriter.JsonTextWriter(StringWriter);
    //     JSONTextWriter.WriteStartArray;
    //     documents.Reset;
    //     documents.SetRange("Doc No.", documentNo);
    //     documents.SetRange(Attachment, documents.Attachment::Yes);
    //     if documents.Find('-') then begin
    //         repeat

    //             attachments.Reset;
    //             //  attachments.SETRANGE("No.", documents."Attachment No.");
    //             if attachments.Get(documents."Attachment No.") then begin

    //                 JSONTextWriter.WriteStartObject;
    //                 CreateJsonAttribute('AttachmentNo', documents."Attachment No.");
    //                 CreateJsonAttribute('DocumentDescription', documents."Document Description");
    //                 CreateJsonAttribute('DocumentNo', documents."Doc No.");
    //                 CreateJsonAttribute('ext', attachments."File Extension");
    //                 Clear(PictureText);
    //                 Clear(PictureInStream);
    //                 attachments."Attachment File".CreateInstream(PictureInStream);
    //                 TempBlob.DeleteAll;
    //                 TempBlob.Init;
    //                 TempBlob.Blob.CreateOutstream(PictureOutStream);
    //                 CopyStream(PictureOutStream, PictureInStream);
    //                 TempBlob.Insert;
    //                 TempBlob.CalcFields(Blob);
    //                 PictureText.AddText(TempBlob.ToBase64String);
    //                 JSONTextWriter.WritePropertyName('attachment');
    //                 JSONTextWriter.WriteValue(PictureText);
    //                 JSONTextWriter.WriteEndObject;
    //             end;
    //         until documents.Next = 0;
    //     end;
    //     JSONTextWriter.WriteEndArray;
    //     JsonOut := StringBuilder.ToString;
    //     returnout := JsonOut;
    // end;

    procedure fnhrdocuments(): Text
    var
        hrdocuments: Record "HR Documents";
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        returnout: Text;
    begin
        hrdocuments.Reset();

        if hrdocuments.FindFirst() then begin
            repeat
                JsonObject.Add('code', hrdocuments.Code);
                JsonObject.Add('name', hrdocuments.Description);

                JsonArray.Add(JsonObject);
            until hrdocuments.Next() = 0;
        end;
        JsonArray.WriteTo(returnout);
        exit(returnout);
    end;

    // procedure fnGetdocuments(attachmentno: Integer; var PictureText: BigText) fieext: Text
    // var
    //     PictureInStream: InStream;
    //     PictureOutStream: OutStream;
    //     TempBlob: Record TempBlob;
    // begin
    //     attachments.Reset;
    //     attachments.SetRange("No.", attachmentno);
    //     if attachments.Find('-') then begin
    //         attachments.CalcFields("Attachment File");
    //         fieext := attachments."File Extension";
    //         if attachments."Attachment File".Hasvalue then begin
    //             //  PictureText.ADDTEXT(HREmployees
    //             Clear(PictureText);
    //             Clear(PictureInStream);
    //             attachments."Attachment File".CreateInstream(PictureInStream);
    //             TempBlob.DeleteAll;
    //             TempBlob.Init;
    //             TempBlob.Blob.CreateOutstream(PictureOutStream);
    //             CopyStream(PictureOutStream, PictureInStream);
    //             TempBlob.Insert;
    //             TempBlob.CalcFields(Blob);
    //             PictureText.AddText(TempBlob.ToBase64String);
    //         end;
    //     end;
    // end;

    procedure fnsuggestionbox(suggestion: Text; anonymous: Boolean; empno: Code[50])
    var
        receivingmail: Text;
        senderaddress: Text;
        senderemail: Text;
        senderpassword: Text;
        EmailMess: Text;
        EmailMessSub: Text;
    begin
        objHRSetup.Get();
        receivingmail := objHRSetup."Feedback Email";
        HREmployees.Get(empno);
        if anonymous = true then begin
            EmailMessSub := 'Grievance';
            EmailMess := '<h3>This is a confidential email</h3>' + '<p> ' + suggestion + ' </p> </br> </br> </br>  </hr> From, Anonymous';
            EmailMessge.Create(receivingmail, EmailMessSub, EmailMess, true);
            EmailSend.Send(EmailMessge);
        end;
        if anonymous = false then begin
            EmailMess := '';
            EmailMessSub := 'Grievance';
            EmailMess := '<h3>This is a confidential email</h3>' + '<p> ' + suggestion + ' </p> </br> </br> </br>  </hr> From, Anonymous From, ' + HREmployees."First Name"
            + ' ' + HREmployees."Last Name" + 'Employee No, ' + HREmployees."No." + 'Email, ' + HREmployees."E-Mail";
            EmailMessge.Create(receivingmail, EmailMessSub, EmailMess, true);
            EmailSend.Send(EmailMessge);

        end;
    end;

    procedure fnAppraisals(empno: Code[60]) returnout: Text
    var
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        purchaseheader: Record "Purchase Header";
    begin


        purchaseheader.Reset;
        purchaseheader.SetRange("Employee No", empno);
        // purchaseheader.SetRange("Document Type", purchaseheader."document type"::Appraisal);
        if purchaseheader.Find('-') then begin
            repeat
                JsonObject.Add('apprasalcode', purchaseheader."Appraisal Code");
                JsonObject.Add('background', purchaseheader.Background);
                JsonObject.Add('emno', purchaseheader."Employee No");
                JsonObject.Add('status', Format(purchaseheader.Status));
                JsonObject.Add('no', purchaseheader."No.");
                JsonArray.Add(JsonObject);
            until purchaseheader.Next = 0;
        end;
        JsonArray.WriteTo(returnout);
        exit(returnout);
    end;

    procedure fnNewappraisal(empno: Code[30]; background: Text) appno: Code[60]
    begin
        purchaseheader.Init;
        hrsetup.Get;
        purchaseheader."No." := NoSeriesManagement.GetNextNo(hrsetup."Appraisal Nos.", Today, true);
        purchaseheader.Background := background;
        purchaseheader."Employee No" := empno;
        purchaseheader.Insert;



        purchaseheader.Validate("Employee No");
        purchaseheader.APP := true;
        purchaseheader.Modify;

        appno := purchaseheader."No.";


        purchaseline.Init;
        purchaseline."Document No." := appno;
        purchaseline.Insert;
    end;

    procedure fnEditappraisal(appraisalno: Code[50]; background: Text)
    begin
        if purchaseheader.Get(purchaseheader."document type"::Quote, appraisalno) then begin

            //purchaseheader."No.":=appraisalno;
            purchaseheader.Background := background;
            purchaseheader.APP := true;
            purchaseheader.Modify;
        end;
    end;

    procedure fngrievances(suggestion: Text; anonymous: Boolean; empno: Code[50])
    var
        receivingmail: Text;
        senderaddress: Text;
        senderemail: Text;
        senderpassword: Text;
        EmailMess: Text;
        EmailMessSub: Text;
    begin
        objHRSetup.Get();
        receivingmail := objHRSetup.Email;
        HREmployees.Get(empno);
        if anonymous = true then begin
            EmailMessSub := 'Grievance';
            EmailMess := '<h3>This is a confidential email</h3>' + '<p> ' + suggestion + ' </p> </br> </br> </br>  </hr> From, Anonymous';
            EmailMessge.Create(receivingmail, EmailMessSub, EmailMess, true);
            EmailSend.Send(EmailMessge);
        end;


        if anonymous = false then begin
            EmailMess := '';
            EmailMessSub := 'Grievance';
            EmailMess := '<h3>This is a confidential email</h3>' + '<p> ' + suggestion + ' </p> </br> </br> </br>  </hr> From, Anonymous From, ' + HREmployees."First Name"
            + ' ' + HREmployees."Last Name" + 'Employee No, ' + HREmployees."No." + 'Email, ' + HREmployees."E-Mail";
            EmailMessge.Create(receivingmail, EmailMessSub, EmailMess, true);
            EmailSend.Send(EmailMessge);

        end;
    end;

    procedure fnExitInterview(empNo: Code[60]; Designation: Text; "main reason(s) for your exit": Text; "overall impression": Text; "clear objectives": Text; "your performance reviewed": Text; "received enough recognition": Text; "career aspirations": Text; "relationship with your": Text; "with your immediate team": Text; "perception on TI-Kenya’s": Text; "most fulfilling": Text; "greatest accomplishments": Text; "most frustrating": Text; "better place": Text; "TI-Kenya in the future": Text; "constructive feedback": Text; "next step": Text; "Intervire Conducted By": Text)
    var
        exitInterview: Record "Exit Interviews";
    begin
        exitInterview.Reset;
        exitInterview.SetRange("Employee No", empNo);
        if not exitInterview.Find('-') then begin
            exitInterview."Employee No" := empNo;
            exitInterview.Validate("Employee No");
            exitInterview.Insert;
            exitInterview.Designation := Designation;
            exitInterview."main reason(s) for your exit" := "main reason(s) for your exit";
            exitInterview."overall impression" := "overall impression";
            exitInterview."clear objectives" := "clear objectives";
            exitInterview."your performance reviewed" := "your performance reviewed";
            exitInterview."received enough recognition" := "received enough recognition";
            exitInterview."career aspirations" := "career aspirations";
            exitInterview."relationship with your" := "relationship with your";
            exitInterview."with your immediate team" := "with your immediate team";
            exitInterview."greatest accomplishments" := "greatest accomplishments";
            exitInterview."perception on TI-Kenya’s" := "perception on TI-Kenya’s";
            exitInterview."most fulfilling" := "most fulfilling";
            exitInterview."most frustrating" := "most frustrating";
            exitInterview."better place" := "better place";
            exitInterview."TI-Kenya in the future" := "TI-Kenya in the future";
            exitInterview."next step" := "next step";
            exitInterview."constructive feedback" := "constructive feedback";
            exitInterview."Intervire Conducted By" := "Intervire Conducted By";
            exitInterview."Interview Date" := Today;
            exitInterview.Modify;
        end else begin
            exitInterview.Get(empNo);
            exitInterview.Designation := Designation;
            exitInterview."main reason(s) for your exit" := "main reason(s) for your exit";
            exitInterview."overall impression" := "overall impression";
            exitInterview."clear objectives" := "clear objectives";
            exitInterview."your performance reviewed" := "your performance reviewed";
            exitInterview."received enough recognition" := "received enough recognition";
            exitInterview."career aspirations" := "career aspirations";
            exitInterview."relationship with your" := "relationship with your";
            exitInterview."with your immediate team" := "with your immediate team";
            exitInterview."greatest accomplishments" := "greatest accomplishments";
            exitInterview."perception on TI-Kenya’s" := "perception on TI-Kenya’s";
            exitInterview."most fulfilling" := "most fulfilling";
            exitInterview."most frustrating" := "most frustrating";
            exitInterview."better place" := "better place";
            exitInterview."TI-Kenya in the future" := "TI-Kenya in the future";
            exitInterview."next step" := "next step";
            exitInterview."constructive feedback" := "constructive feedback";
            exitInterview."Intervire Conducted By" := "Intervire Conducted By";
            exitInterview."Interview Date" := Today;
            exitInterview.Modify;
        end;
    end;

    procedure fnGetExitInterview(EmpNo: Code[60]) returnout: Text
    var
        exitInterview: Record "Exit Interviews";
        JsonOut: Text;
        JsonObject: JsonObject;
        JsanArray: JsonArray;
    begin
        if exitInterview.Get(EmpNo) then begin

            // Adding fields to the JsonObject
            JsonObject.Add('EmpNo', exitInterview."Employee No");
            JsonObject.Add('mainReason', exitInterview."main reason(s) for your exit");
            JsonObject.Add('overallImpression', exitInterview."overall impression");
            JsonObject.Add('clearObjectives', exitInterview."clear objectives");
            JsonObject.Add('performanceReviewed', exitInterview."your performance reviewed");
            JsonObject.Add('enoughRecognition', exitInterview."received enough recognition");
            JsonObject.Add('careerAspirations', exitInterview."career aspirations");
            JsonObject.Add('relationship_supervisor', exitInterview."relationship with your");
            JsonObject.Add('relationship_supervisor_team', exitInterview."with your immediate team");
            JsonObject.Add('accomplishments', exitInterview."greatest accomplishments");
            JsonObject.Add('fulfillingWorking', exitInterview."most fulfilling");
            JsonObject.Add('whatToChange', exitInterview."TI-Kenya in the future");
            JsonObject.Add('nextStep', exitInterview."next step");
            JsonObject.Add('feedback', exitInterview."constructive feedback");
            JsonObject.Add('conductedBy', exitInterview."Intervire Conducted By");
            JsonObject.Add('tiPerception', exitInterview."perception on TI-Kenya’s");
            JsanArray.Add(JsonObject);
            // Convert the JsonObject to string and return it
            JsanArray.WriteTo(returnout);
            returnout := JsonOut;
        end;
    end;

    procedure fnGetInductionSchedule(Employee: Code[60]) returnout: Text
    var
        inductionSchedule: Record "Induction Schedule";
        JsonOut: Text;
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        DateTimeInducted: DateTime;
    begin


        inductionSchedule.Reset;
        inductionSchedule.SetRange("Inducting Employee No", Employee);

        if inductionSchedule.Find('-') then begin
            repeat

                // Adding attributes to the JsonObject
                JsonObject.Add('employee_no', inductionSchedule."Employee No");
                JsonObject.Add('employee_name', inductionSchedule."Employee Name");
                JsonObject.Add('inducted', inductionSchedule.Inducted);
                JsonObject.Add('comments', inductionSchedule.Comments);
                DateTimeInducted := CreateDateTime(inductionSchedule."Date Inducted", inductionSchedule."Time Inducted");
                JsonObject.Add('date_inducted', DateTimeInducted);

                JsonObject.Add('inducting_employee', Employee);

                JsonArray.Add(JsonObject);
            until inductionSchedule.Next = 0;
        end;

        // Convert the JsonArray to string and return it
        JsonArray.WriteTo(returnout);
        exit(returnout);
    end;

    procedure fnInduct(inductingEmployee: Code[50]; emloyee: Code[50]; induct: Boolean; comments: Text)
    var
        inductionschedule: Record "Induction Schedule";
    begin
        inductionschedule.Reset;
        inductionschedule.SetRange("Inducting Employee No", inductingEmployee);
        inductionschedule.SetRange("Employee No", emloyee);
        if inductionschedule.Find('-') then begin

            inductionschedule.Inducted := induct;
            inductionschedule.Comments := comments;
            inductionschedule."Time Inducted" := Time;
            inductionschedule."Date Inducted" := Today;
            inductionschedule.Modify;
        end;
    end;

    procedure fnPaymentMemosList(empNo: Code[50]) returnout: Text
    var
        JsonOut: Text;
        ObjImprestHeader: Record "Purchase Header";
        ObjImprestLine: Record "Purchase Line";
        ObjHrEmployee: Record "HR Employees";
        JsonArray: JsonArray;
        JsonObject: JsonObject;
    begin


        if ObjHrEmployee.Get(empNo) then begin
            ObjImprestHeader.Reset;
            ObjImprestHeader.SetRange(PM, true);
            ObjImprestHeader.SetRange(Archived, false);
            ObjImprestHeader.SetRange("Employee No", empNo);

            if ObjImprestHeader.Find('-') then begin
                repeat
                    ObjImprestHeader.CalcFields(Amount);


                    // Adding attributes to the JsonObject
                    JsonObject.Add('No', ObjImprestHeader."No.");
                    JsonObject.Add('Document_Date', ObjImprestHeader."Document Date");
                    JsonObject.Add('Status', ObjImprestHeader.Status);
                    JsonObject.Add('Amount', ObjImprestHeader.Amount);
                    JsonObject.Add('DepartmentCode', ObjImprestHeader."Shortcut Dimension 1 Code");
                    JsonObject.Add('DirectorateCode', ObjImprestHeader."Shortcut Dimension 2 Code");
                    JsonObject.Add('StartDate', ObjImprestHeader."Document Date");
                    JsonObject.Add('EndDate', ObjImprestHeader."Document Date");
                    JsonObject.Add('Completed', ObjImprestHeader.Completed);
                    JsonObject.Add('StrategicFocusArea', ObjImprestHeader."Strategic Focus Area");
                    JsonObject.Add('SubPillar', ObjImprestHeader."Sub Pillar");
                    JsonObject.Add('ProjectTitle', ObjImprestHeader."Project Title");
                    JsonObject.Add('Country', ObjImprestHeader.Country);
                    JsonObject.Add('County', ObjImprestHeader.County);
                    JsonObject.Add('DateOfActivity', ObjImprestHeader."Date(s) of Activity");
                    JsonObject.Add('MissionTeam', ObjImprestHeader."Mission Team");
                    JsonObject.Add('InvitedMembers', ObjImprestHeader."Invited Members/Partners");
                    JsonObject.Add('FundCode', ObjImprestHeader."Shortcut Dimension 1 Code");
                    JsonObject.Add('ProgramCode', ObjImprestHeader."Shortcut Dimension 2 Code");
                    JsonObject.Add('budgetdminesion', ObjImprestHeader."Shortcut Dimension 3 Code");
                    JsonObject.Add('departmentdimension', ObjImprestHeader."Shortcut Dimension 4 Code");
                    JsonObject.Add('budgetdescription', ObjImprestHeader."Shortcut Dimension 5 Code");
                    JsonObject.Add('Background', ObjImprestHeader.Background);
                    JsonObject.Add('StrategicFocus', ObjImprestHeader."Contribution to focus");
                    JsonObject.Add('Outcome', ObjImprestHeader."Main Outcome");
                    JsonObject.Add('Ref', ObjImprestHeader."Your Reference");
                    JsonObject.Add('Subject', ObjImprestHeader.Background);
                    JsonObject.Add('missionNo', ObjImprestHeader."Mission Proposal No");
                    JsonObject.Add('purchaseRequisition', ObjImprestHeader."Requisition No");

                    // Add the JsonObject to the JsonArray
                    JsonArray.Add(JsonObject);
                until ObjImprestHeader.Next = 0;
            end;
        end;

        JsonArray.WriteTo(returnout);
        exit(returnout);
    end;

    procedure fnInsertPaymentmemo(datesofActivities: Date; fundcode: Code[90]; programcode: Code[90]; departmentdimension: Code[50]; budgetdimesion: Code[50]; budgetdescription: Code[60]; background: Text; empno: Code[40]; ref: Text; purchaseRequest: Code[40]; missionproposal: Code[40]) mssno: Code[60]
    begin
        purchaseheader.Init;
        GenLedgerSetup.Get();
        NNo := '';
        purchaseheader."No." := objNumSeries.GetNextNo(GenLedgerSetup."Payment Memo Nos.", 0D, true);
        purchaseheader."No. Series" := GenLedgerSetup."Payment Memo Nos.";
        NNo := purchaseheader."No.";
        purchaseheader."Document Date" := datesofActivities;

        purchaseheader."Shortcut Dimension 1 Code" := fundcode;
        purchaseheader."Shortcut Dimension 2 Code" := programcode;
        purchaseheader.PM := true;
        purchaseheader."Your Reference" := ref;
        purchaseheader.Status := purchaseheader.Status::Open;
        purchaseheader."User ID" := UserId;
        purchaseheader."Shortcut Dimension 3 Code" := budgetdimesion;
        purchaseheader."Shortcut Dimension 4 Code" := budgetdescription;
        purchaseheader."Shortcut Dimension 5 Code" := departmentdimension;
        purchaseheader."Mission Proposal No" := missionproposal;
        purchaseheader."Requisition No" := purchaseRequest;

        purchaseheader.Background := background;
        if empno = '' then Error('Session timeout please login and try again');
        purchaseheader."Employee No" := empno;
        purchaseheader.Validate("Employee No");
        purchaseheader.Insert;

        purchaseline.Init;
        purchaseline."Document No." := NNo;
        purchaseline."Line No." := 10000;
        purchaseline.Insert;


        mssno := purchaseheader."No.";
    end;

    procedure fnupdatePaymentmemo(datesofActivities: Date; fundcode: Code[90]; programcode: Code[90]; departmentdimension: Code[50]; budgetdimesion: Code[50]; budgetdescription: Code[60]; background: Text; empno: Code[40]; ref: Text; no: Code[50]; purchaseRequest: Code[40]; missionProporsal: Code[40]) mssno: Code[60]
    begin
        purchaseheader.Get(purchaseheader."document type"::Quote, no);

        purchaseheader."Document Date" := datesofActivities;

        purchaseheader."Shortcut Dimension 1 Code" := fundcode;
        purchaseheader."Shortcut Dimension 2 Code" := programcode;
        purchaseheader.PM := true;
        purchaseheader."Your Reference" := ref;
        purchaseheader.Status := purchaseheader.Status::Open;
        purchaseheader."User ID" := UserId;
        purchaseheader."Shortcut Dimension 3 Code" := budgetdimesion;
        purchaseheader."Shortcut Dimension 4 Code" := budgetdescription;
        purchaseheader."Shortcut Dimension 5 Code" := departmentdimension;
        purchaseheader."Requisition No" := purchaseRequest;
        purchaseheader."Mission Proposal No" := missionProporsal;

        purchaseheader.Background := background;
        if empno = '' then Error('Session timeout please login and try again');
        purchaseheader."Employee No" := empno;
        purchaseheader.Validate("Employee No");
        purchaseheader.Modify;


        mssno := purchaseheader."No.";
    end;

    //    procedure FnInsertAppraisal(JsonData: Text)
    // var
    //     lineNo: Integer;
    //     target: Decimal;
    //     weighting: Decimal;
    //     fromDate: DateTime;
    //     toDate: DateTime;
    //     appraisalNeeds: Record "Appraisal Needs";
    //     purchaseheader: Record "Purchase Header";
    //     purchaseline: Record "Purchase Line";
    //     hrsetup: Record "HR Setup";
    //     lJsonArray: JsonArray;
    //     lJsonObject: JsonObject;
    //     lJSONString: Text;
    // begin
    //     lJSONString := JsonData;

    //     // Parse JSON if JsonData is provided
    //     if lJSONString <> '' then begin
    //         lJsonObject := JsonObject.Create;
    //         lJsonObject.ReadFrom(lJSONString);
    //     end;

    //     // Initialize the Purchase Header record
    //     purchaseheader.Init;
    //     hrsetup.Get;

    //     // Get the next number for the Appraisal document
    //     purchaseheader."No." := objNumSeries.GetNextNo(hrsetup."Appraisal Nos.", 0D, true);
    //     purchaseheader."No. Series" := hrsetup."Appraisal Nos.";
    //     purchaseheader."Document Type" := purchaseheader."Document Type"::Appraisal;

    //     // Parse 'reviewFrom' and 'reviewTo' dates from JSON
    //     if lJsonObject.GetValue('reviewFrom') <> '' then
    //         Evaluate(fromDate, Format(lJsonObject.GetValue('reviewFrom')));
    //     if lJsonObject.GetValue('reviewTo') <> '' then
    //         Evaluate(toDate, Format(lJsonObject.GetValue('reviewTo')));

    //     purchaseheader."Employee No" := Format(lJsonObject.GetValue('emno'));
    //     purchaseheader.Validate("Employee No");
    //     purchaseheader."Review From" := Dt2Date(fromDate);
    //     purchaseheader."Review To" := Dt2Date(toDate);

    //     // Performance section processing
    //     if lJsonObject.GetValue('Performance') <> '' then begin
    //         lJsonArray := JsonArray.Create;
    //         lJsonArray.ReadFrom(Format(lJsonObject.GetValue('Performance')));

    //         lineNo := 1000;
    //         foreach lJsonObject in lJsonArray do begin
    //             purchaseline.Init;
    //             purchaseline."Line No." := lineNo;
    //             purchaseline."Document No." := purchaseheader."No.";
    //             purchaseline."Line Type" := purchaseline."Line Type"::Performance;

    //             // Extract and assign values from JSON object
    //             Evaluate(target, Format(lJsonObject.GetValue('target')));
    //             Evaluate(weighting, Format(lJsonObject.GetValue('weighting')));

    //             purchaseline.keyResultAreas := Format(lJsonObject.GetValue('keyResultAreas'));
    //             purchaseline.keyActivities := Format(lJsonObject.GetValue('keyActivities'));
    //             purchaseline.performanceMeasures := Format(lJsonObject.GetValue('performanceMeasures'));
    //             purchaseline.target := target;
    //             purchaseline.commentsOnAchievedResults := Format(lJsonObject.GetValue('commentsOnAchievedResults'));
    //             purchaseline.weighting := weighting;

    //             // Insert line into Purchase Line table
    //             purchaseline.Insert;

    //             lineNo += 1000;
    //         end;
    //     end;

    //     // Appraisal Needs section processing
    //     appraisalNeeds.Find('-');
    //     repeat
    //         purchaseline.Init;
    //         purchaseline."Line No." := lineNo;
    //         purchaseline."Document No." := purchaseheader."No.";
    //         purchaseline."Line Type" := purchaseline."Line Type"::Sections;
    //         purchaseline.appraisalType := appraisalNeeds.AppraisalType;
    //         purchaseline.appraisalDescription := appraisalNeeds.Description;

    //         // Insert section into Purchase Line table
    //         purchaseline.Insert;
    //         lineNo += 1000;
    //     until appraisalNeeds.Next = 0;

    //     // Insert the Purchase Header record
    //     purchaseheader.Insert;
    // end;

    // procedure FnUpdateAppraisal(JsonData: Text)
    // var
    //     lineNo: Integer;
    //     target: Decimal;
    //     weighting: Decimal;
    //     fromDate: DateTime;
    //     toDate: DateTime;
    // begin

    //     lJSONString := JsonData;
    //     if lJSONString <> '' then
    //         lJObject := lJObject.Parse(Format(lJSONString));
    //     purchaseheader.Init;
    //     GenLedgerSetup.Get();
    //     purchaseheader."No." := Format(lJObject.GetValue('no'));
    //     purchaseheader."Document Type" := purchaseheader."document type"::Appraisal;
    //     Evaluate(fromDate, Format(lJObject.GetValue('reviewFrom')));
    //     Evaluate(toDate, Format(lJObject.GetValue('reviewTo')));
    //     purchaseheader."Employee No" := Format(lJObject.GetValue('emno'));
    //     purchaseheader.Validate("Employee No");
    //     purchaseheader."Review From" := Dt2Date(fromDate);
    //     purchaseheader."Review To" := Dt2Date(toDate);
    //     // Peformance
    //     lArrayString := lJObject.SelectToken('Performance').ToString;
    //     Clear(lJObject);
    //     lJsonArray := lJsonArray.Parse(lArrayString);
    //     lineNo := 1000;
    //     foreach lJObject in lJsonArray do begin
    //         Evaluate(purchaseline."Line No.", Format(lJObject.GetValue('lineNo')));
    //         if purchaseline."Line No." = 0 then begin
    //             purchaseline.Init;
    //             purchaseline."Line No." := lineNo;
    //             purchaseline."Document No." := purchaseheader."No.";
    //             purchaseline."Line Type" := purchaseline."line type"::Performance;
    //             Evaluate(target, Format(lJObject.GetValue('target')));
    //             Evaluate(weighting, Format(lJObject.GetValue('weighting')));

    //             purchaseline.keyResultAreas := Format(lJObject.GetValue('keyResultAreas'));
    //             purchaseline.keyActivities := Format(lJObject.GetValue('keyActivities'));

    //             purchaseline.performanceMeasures := Format(lJObject.GetValue('performanceMeasures'));

    //             purchaseline.target := target;
    //             purchaseline.commentsOnAchievedResults := Format(lJObject.GetValue('commentsOnAchievedResults'));
    //             purchaseline.weighting := weighting;

    //             purchaseline.Insert;


    //         end else begin
    //             purchaseline."Document No." := purchaseheader."No.";
    //             purchaseline."Line Type" := purchaseline."line type"::Performance;
    //             purchaseline."Document Type" := purchaseline."document type"::Quote;
    //             Evaluate(target, Format(lJObject.GetValue('target')));
    //             Evaluate(weighting, Format(lJObject.GetValue('weighting')));

    //             purchaseline.keyResultAreas := Format(lJObject.GetValue('keyResultAreas'));
    //             purchaseline.keyActivities := Format(lJObject.GetValue('keyActivities'));

    //             purchaseline.performanceMeasures := Format(lJObject.GetValue('performanceMeasures'));

    //             purchaseline.target := target;
    //             purchaseline.commentsOnAchievedResults := Format(lJObject.GetValue('commentsOnAchievedResults'));
    //             purchaseline.weighting := weighting;

    //             purchaseline.Modify;
    //         end;
    //         lineNo += 1000;
    //     end;

    //     purchaseheader.Modify;
    // end;

    procedure fnAppraisalList(empNo: Code[50]) Return: Text
    var
        jsonArray: JsonArray;
        jsonObject: JsonObject;
        purchaseheader: Record "Purchase Header";
        purchaseline: Record "Purchase Line";
        hrLeaveTypes: Record "HR Leave Types";
    begin


        // Process Purchase Header for Appraisal documents related to the employee
        purchaseheader.Reset;
        purchaseheader.SetRange("Employee No", empNo);
        //purchaseheader.SetRange("Document Type", purchaseheader."Document Type"::Appraisal);
        if purchaseheader.Find('-') then begin
            repeat


                // Adding the basic information for the appraisal
                jsonObject.Add('no', purchaseheader."No.");
                jsonObject.Add('reviewFrom', purchaseheader."Review From");
                jsonObject.Add('reviewTo', purchaseheader."Review To");
                jsonObject.Add('emno', purchaseheader."Employee No");
                jsonObject.Add('Status', purchaseheader.Status);

                // Performance section
                jsonObject.Add('Performance', GetPerformance(purchaseheader."No."));

                // Sections section
                jsonObject.Add('Sections', GetSections(purchaseheader."No."));

                // PersonalQualities section
                jsonObject.Add('PersonalQualities', GetPersonalQualities(purchaseheader."No."));

                // Reflections section
                jsonObject.Add('Reflections', GetReflections(purchaseheader."No."));

                // CapacityNeeds section
                jsonObject.Add('CapacityNeeds', GetCapacityNeeds(purchaseheader."No."));

                // ActionPoints section
                jsonObject.Add('ActionPoints', GetActionPoints(purchaseheader."No."));

                // Add the JSON object for this appraisal to the array
                jsonArray.Add(jsonObject);

            until purchaseheader.Next = 0;
        end;

        // Convert the JsonArray to string and return it
        jsonArray.WriteTo(Return);
        exit(Return);
    end;

    procedure GetPerformance(docNo: Code[20]): JsonArray
    var
        performanceArray: JsonArray;
        line: Record "Purchase Line";
        performanceObject: JsonObject;
    begin

        line.Reset;
        line.SetRange("Document No.", docNo);
        line.SetRange("Line Type", line."Line Type"::Performance);
        if line.Find('-') then begin
            repeat

                performanceObject.Add('documentNo', line."Document No.");
                performanceObject.Add('lineNo', line."Line No.");
                performanceObject.Add('keyResultAreas', line.keyResultAreas);
                performanceObject.Add('keyActivities', line.keyActivities);
                performanceObject.Add('performanceMeasures', line.performanceMeasures);
                performanceObject.Add('commentsOnAchievedResults', line.commentsOnAchievedResults);
                performanceObject.Add('target', line.target);
                performanceObject.Add('actualAchieved', line.actualAchieved);
                performanceObject.Add('percentageOfTarget', line.percentageOfTarget);
                performanceObject.Add('rating', line.rating);
                performanceObject.Add('weightingRating', line.weightingRating);
                performanceObject.Add('weighting', line.weighting);

                performanceArray.Add(performanceObject);

            until line.Next = 0;
        end;
        exit(performanceArray);
    end;

    procedure GetSections(docNo: Code[20]): JsonArray
    var
        sectionsArray: JsonArray;
        line: Record "Purchase Line";
        sectionObject: JsonObject;
    begin


        line.Reset;
        line.SetRange("Document No.", docNo);
        line.SetRange("Line Type", line."Line Type"::Sections);
        if line.Find('-') then begin
            repeat

                sectionObject.Add('documentNo', line."Document No.");
                sectionObject.Add('lineNo', line."Line No.");
                sectionObject.Add('appraisalType', line.appraisalType);
                sectionObject.Add('appraisalDescription', line.appraisalDescription);
                sectionObject.Add('staffRating', line.staffRating);
                sectionObject.Add('supervisorRating', line.supervisorRating);

                sectionsArray.Add(sectionObject);

            until line.Next = 0;
        end;

        exit(sectionsArray);
    end;

    procedure GetPersonalQualities(docNo: Code[20]): JsonArray
    var
        qualitiesArray: JsonArray;
        line: Record "Purchase Line";
        qualityObject: JsonObject;
    begin

        line.Reset;
        line.SetRange("Document No.", docNo);
        line.SetRange("Line Type", line."Line Type"::PersonalQualities);
        if line.Find('-') then begin
            repeat

                qualityObject.Add('documentNo', line."Document No.");
                qualityObject.Add('lineNo', line."Line No.");
                qualityObject.Add('personalDescription', line.personalDescription);
                qualityObject.Add('score', line.score);
                qualityObject.Add('comments', line.comments);

                qualitiesArray.Add(qualityObject);

            until line.Next = 0;
        end;

        exit(qualitiesArray);
    end;

    procedure GetReflections(docNo: Code[20]): JsonArray
    var
        reflectionsArray: JsonArray;
        line: Record "Purchase Line";
        reflectionObject: JsonObject;
    begin

        line.Reset;
        line.SetRange("Document No.", docNo);
        line.SetRange("Line Type", line."Line Type"::Reflections);
        if line.Find('-') then begin
            repeat
                reflectionObject.Add('documentNo', line."Document No.");
                reflectionObject.Add('lineNo', line."Line No.");
                reflectionObject.Add('reflectionDescription', line.reflectionDescription);
                reflectionObject.Add('selfAppraisal', line.selfAppraisal);
                reflectionObject.Add('supervisorsFeedback', line.supervisorsFeedback);

                reflectionsArray.Add(reflectionObject);

            until line.Next = 0;
        end;

        exit(reflectionsArray);
    end;

    procedure GetCapacityNeeds(docNo: Code[20]): JsonArray
    var
        capacityNeedsArray: JsonArray;
        line: Record "Purchase Line";
        capacityNeedObject: JsonObject;
    begin


        line.Reset;
        line.SetRange("Document No.", docNo);
        line.SetRange("Line Type", line."Line Type"::CapacityNeeds);
        if line.Find('-') then begin
            repeat

                capacityNeedObject.Add('documentNo', line."Document No.");
                capacityNeedObject.Add('lineNo', line."Line No.");
                capacityNeedObject.Add('capacity', line.capacity);
                capacityNeedObject.Add('completionDate', line.completionDate);
                capacityNeedObject.Add('capacityNeedsDescription', line.capacityNeedsDescription);
                capacityNeedObject.Add('remedialMeasures', line.remedialMeasures);

                capacityNeedsArray.Add(capacityNeedObject);

            until line.Next = 0;
        end;

        exit(capacityNeedsArray);
    end;

    procedure GetActionPoints(docNo: Code[20]): JsonArray
    var
        actionPointsArray: JsonArray;
        line: Record "Purchase Line";
        actionPointObject: JsonObject;
    begin


        line.Reset;
        line.SetRange("Document No.", docNo);
        line.SetRange("Line Type", line."Line Type"::ActionPoints);
        if line.Find('-') then begin
            repeat

                actionPointObject.Add('documentNo', line."Document No.");
                actionPointObject.Add('lineNo', line."Line No.");
                actionPointObject.Add('planning', line.planning);
                actionPointObject.Add('personResponsible', line.personResponsible);
                actionPointObject.Add('agreedActionPoints', line.agreedActionPoints);
                actionPointObject.Add('timelines', line.timelines);

                actionPointsArray.Add(actionPointObject);

            until line.Next = 0;
        end;

        exit(actionPointsArray);
    end;

    procedure fnInsertTimeSheet(name: Text; projectCode: Code[250]; startdate: DateTime; employee: Code[50]; year: Integer; enddate: DateTime; hours: Integer) "code": Integer
    var
        noOfDays: Integer;
        leaveTypes: Record "HR Leave Types";
        date: Date;
        noDaysUp: Integer;
        dayeofweek: Integer;
    begin
        hrsetup.Get();

        if year = 0 then begin
            Doc := NoSeriesManagement.GetNextNo(hrsetup."Timesheet Nos.", Today, true);
            purchaseheader.Init;
            purchaseheader."No." := Doc;
            purchaseheader.Validate("Employee No", employee);
            purchaseheader."Document Date" := Today;
            purchaseheader."Date From" := startdate;
            purchaseheader."Date To" := enddate;
            purchaseheader.Narration := name;
            purchaseheader.TM := true;
            if hours > 0 then
                purchaseheader.Insert;

            PurchaseLine6.Init;
            PurchaseLine6."Document No." := Doc;
            PurchaseLine6.Insert;
        end else begin
            purchaseheader.Reset;
            purchaseheader.SetRange("Employee No", employee);
            purchaseheader.SetRange(TM, true);
            if purchaseheader.FindLast then Doc := purchaseheader."No.";
            // Doc:=NoSeriesManagement.GetNextNo(hrsetup."Timesheet Nos.",TODAY,TRUE);

        end;





        noOfDays := CalcDate('+1D', Dt2Date(enddate)) - Dt2Date(startdate);

        date := CalcDate('-1D', Dt2Date(startdate));
        noDaysUp := 1;
        repeat

            TimesheetHeader.Init;
            if leaveTypes.Get(projectCode) then begin
                TimesheetHeader."Leave Type" := projectCode;
                TimesheetHeader.Validate("Leave Type");
            end else begin
                TimesheetHeader."Global Dimension 1 Code" := projectCode;
                TimesheetHeader.Validate("Global Dimension 1 Code");
            end;
            TimesheetHeader.Date := CalcDate('+' + Format(noDaysUp) + 'D', date);
            TimesheetHeader.Validate(Date);
            TimesheetHeader."Employee No" := employee;
            TimesheetHeader.Status := TimesheetHeader.Status::ApprovalPending;
            TimesheetHeader.Hours := hours;
            TimesheetHeader.Narration := name;
            TimesheetHeader.Validate(Hours);
            TimesheetHeader.Validate("Employee No");
            if TimesheetHeader.Hours <> 0 then begin


                // TimesheetHeader.FINDLAST;
                // TimesheetHeader.Entry:=TimesheetHeader.COUNT()+RANDOM(99999);
                TimesheetHeader.Code := Doc;
                //dayeofweek:=DATE2DMY(TimesheetHeader.Date,1);
                if Format(TimesheetHeader.Date, 0, '<Weekday Text>') <> 'Sunday' then begin
                    if Format(TimesheetHeader.Date, 0, '<Weekday Text>') <> 'Saturday' then
                        TimesheetHeader.Insert(true);
                end;

                Commit;
            end;
            noOfDays -= 1;
            noDaysUp += 1;
        until noOfDays = 0;
    end;

    procedure fnModifyTimeSheet(name: Code[50]; projectCode: Code[40]; startdate: DateTime; "code": Code[40]; employee: Code[40]; year: Integer; entryNo: Integer; endDate: DateTime) Timecode: Integer
    var
        entryN: Integer;
    begin

        TimesheetHeader.Reset;
        TimesheetHeader.SetRange("Employee No", employee);
        TimesheetHeader.SetRange(Code, name);
        TimesheetHeader.SetRange(Date, Dt2Date(startdate));
        TimesheetHeader.SetRange(Description, projectCode);
        if TimesheetHeader.FindLast then begin
            TimesheetHeader.Hours := year;
            TimesheetHeader.Modify;
            Commit;
        end

    end;

    //     procedure GetTimesheets(employee: Code[50]): Text
    // var
    //     TimesheetHeader1: Record "Timesheet Header";
    //     TimesheetHeader: Record "Timesheet Line";
    //     JsonArray: JsonArray;
    //     JsonObject: JsonObject;
    //     JsonLinesArray: JsonArray;
    //     LineObject: JsonObject;
    //     returnText: Text;
    //     TempBlob: Codeunit "Temp Blob";
    //     OutStream: OutStream;
    // begin
    //     Clear(JsonArray);

    //     TimesheetHeader1.Reset();
    //     TimesheetHeader1.SetRange(TM, true);
    //     TimesheetHeader1.SetRange(emp, employee);
    //     TimesheetHeader1.Ascending(true);

    //     if TimesheetHeader1.FindSet() then begin
    //         repeat
    //             Clear(JsonObject);
    //             JsonObject.Add('code', TimesheetHeader1."No.");
    //             JsonObject.Add('name', TimesheetHeader1.Narration);
    //             JsonObject.Add('startdate', TimesheetHeader1."Date From");
    //             JsonObject.Add('endDate', TimesheetHeader1."Date To");
    //             JsonObject.Add('year', TimesheetHeader1."No of THours");

    //             case TimesheetHeader1.Status of
    //                 TimesheetHeader1.Status::Open:
    //                     JsonObject.Add('status', 'Open');
    //                 TimesheetHeader1.Status::"Pending Approval":
    //                     JsonObject.Add('status', 'ApprovalPending');
    //                 TimesheetHeader1.Status::Released:
    //                     JsonObject.Add('status', 'Approved');
    //             end;

    //             // Add Timesheet Lines
    //             JsonLinesArray.Clear();
    //             TimesheetHeader.Reset();
    //             TimesheetHeader.SetRange(Code, TimesheetHeader1."No.");
    //             if TimesheetHeader.FindSet() then begin
    //                 repeat
    //                     Clear(LineObject);
    //                     LineObject.Add('projectCode', TimesheetHeader.Description);
    //                     LineObject.Add('projectText', TimesheetHeader.Description);
    //                     LineObject.Add('hours', TimesheetHeader.Hours);
    //                     LineObject.Add('comments', TimesheetHeader.Narration);
    //                     LineObject.Add('date', TimesheetHeader.Date);
    //                     LineObject.Add('entryno', Format(TimesheetHeader.Entry));
    //                     JsonLinesArray.Add(LineObject);
    //                 until TimesheetHeader.Next() = 0;
    //             end;

    //             JsonObject.Add('Timesheetlines', JsonLinesArray);
    //             JsonArray.Add(JsonObject);
    //         until TimesheetHeader1.Next() = 0;
    //     end;

    //     TempBlob.CreateOutStream(OutStream);
    //     JsonArray.WriteTo(OutStream);
    //     returnText := TempBlob.ToText();

    //     exit(returnText);
    // end;

    procedure fnDepartmentValueLeave(empNo: Code[40]) Value: Text

    var
        ObjDimensionValue: Record "Dimension Value";

        jsonArray: JsonArray;
        jsonObject: JsonObject;
        StaffProjectAllocation: Record "Staff Project Allocation";
        HRLeaveTypes: Record "HR Leave Types";
    begin
        StaffProjectAllocation.Reset;
        StaffProjectAllocation.SetRange("Staff Code", empNo);
        if StaffProjectAllocation.Find('-') then begin
            repeat
                ObjDimensionValue.Reset;
                ObjDimensionValue.SetRange("Dimension Code", 'FUND');
                ObjDimensionValue.SetRange(Blocked, false);
                ObjDimensionValue.SetRange(Code, StaffProjectAllocation."Fund Code");
                if ObjDimensionValue.FindFirst then
                    repeat
                        jsonObject.Add('Code', ObjDimensionValue.Code);
                        jsonObject.Add('Name', ObjDimensionValue.Code);
                        jsonArray.Add(jsonObject);
                    until ObjDimensionValue.Next = 0;
            until StaffProjectAllocation.Next = 0;
        end;

        // Process HR Leave Types
        HRLeaveTypes.Reset;
        if HRLeaveTypes.FindFirst then begin
            repeat
                jsonObject.Add('Code', HRLeaveTypes.Code);
                jsonObject.Add('Name', HRLeaveTypes.Description);
                jsonArray.Add(jsonObject);
            until HRLeaveTypes.Next = 0;
        end;

        // Convert JSON array to string
        jsonArray.WriteTo(Value);
        exit(Value);
    end;

    procedure GetGLAccounts(): Text
    var
        glAccounts: Record "G/L Account";
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        returnText: Text;
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
        InStream: InStream;
        TempText: Text;
    begin
        glAccounts.Reset();
        glAccounts.SetRange("Used for Pettycash", true);

        if glAccounts.FindSet() then begin
            repeat
                Clear(JsonObject);
                JsonObject.Add('Code', glAccounts."No.");
                JsonObject.Add('Name', glAccounts.Name);
                JsonArray.Add(JsonObject);
            until glAccounts.Next() = 0;
        end;
        TempBlob.CreateOutStream(OutStream);
        JsonArray.WriteTo(OutStream);
        TempBlob.CreateInStream(InStream);
        InStream.ReadText(TempText);
        returnText := TempText;
        exit(returnText);
    end;




}