#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80001 "Deductions Summary_AU"
{
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Layouts/Deductions Summary_AU.rdlc';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("Payroll Monthly Trans_AU"; "Payroll Monthly Trans_AU")
        {

            column(CompanyInfo_Picture_Control1102756014; CompanyInfo.Picture)
            {
            }
            column(DetDate; DetDate)
            {
            }
            column(EmpNo; "Payroll Monthly Trans_AU"."No.")
            {
            }
            column(empName; empName)
            {
            }
            column(EmpAmount; "Payroll Monthly Trans_AU".Amount)
            {
            }
            column(Transaction; "Payroll Monthly Trans_AU"."Transaction Code" + ': ' + "Payroll Monthly Trans_AU"."Transaction Name")
            {
            }
            column(TotLabel; "Payroll Monthly Trans_AU"."Transaction Code" + ': ' + "Payroll Monthly Trans_AU"."Transaction Name")
            {
            }
            column(LoanNo; "Payroll Monthly Trans_AU"."Loan Number")
            {
            }
            column(BankName; BankName)
            {
            }
            column(BranchName; BranchName)
            {
            }
            column(AccountNo; AccountNo)
            {
            }
            column(BankCode; BankCode)
            {
            }
            column(BranchCode; BranchCode)
            {
            }
            trigger OnPreDataItem();
            begin
                if CompanyInfo.Get() then
                    CompanyInfo.CalcFields(CompanyInfo.Picture);
                CompName := CompanyInfo.Name;
                Addr1 := CompanyInfo.Address;
                Addr2 := CompanyInfo.City;
                Email := CompanyInfo."E-Mail";
                //LastFieldNo := FIELDNO("Period Year");
                "Payroll Monthly Trans_AU".SetFilter("Payroll Monthly Trans_AU"."Payroll Period", '=%1', SelectedPeriod);

            end;

            trigger OnAfterGetRecord();
            begin
                //  IF NOT (((("Payroll Monthly Transactions"."Grouping"=1) AND
                //   ("Payroll Monthly Transactions"."SubGrouping"<>1)) OR
                //  ("Payroll Monthly Transactions"."Grouping"=3) OR
                //   (("Payroll Monthly Transactions"."Grouping"=4) AND
                //	("Payroll Monthly Transactions"."SubGrouping"<>0)))) THEN
                "prPayroll Periods".Reset;
                "prPayroll Periods".SetRange("prPayroll Periods"."Date Opened", SelectedPeriod);
                if "prPayroll Periods".Find('-') then begin
                    Clear(DetDate);
                    DetDate := Format("prPayroll Periods"."Period Name");
                end;
                Clear(empName);
                if emps.Get("Payroll Monthly Trans_AU"."No.") then
                    empName := emps.Firstname + ' ' + emps.Lastname + ' ' + emps.Surname;
                "Payroll Monthly Trans_AU".SetRange("Payroll Period", SelectedPeriod);
                if not (((("Payroll Monthly Trans_AU".Grouping = 7) and
                     (("Payroll Monthly Trans_AU".SubGrouping <> 6)
                    and ("Payroll Monthly Trans_AU".SubGrouping <> 5))) or
                    (("Payroll Monthly Trans_AU".Grouping = 8) and
                     ("Payroll Monthly Trans_AU".SubGrouping <> 9)))) then begin
                    CurrReport.Skip;
                end;
                //Transaction Bank Details
                TransCodes.Reset;
                TransCodes.SetRange(TransCodes."Transaction Code", "Payroll Monthly Trans_AU"."Transaction Code");
                if TransCodes.Find('-') then begin
                    BankCode := TransCodes."Payable Bank Ac";
                    BankName := TransCodes."Bank Name";
                    BranchCode := TransCodes."Branch Code";
                    BranchName := TransCodes."Branch Name";
                    AccountNo := TransCodes."Account Number";
                end;

            end;

        }
    }
    requestpage
    {
        SaveValues = false;
        layout
        {
            area(Content)
            {
                field(periodfilter; PeriodFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Period Filter';
                    TableRelation = "Payroll Calender_AU"."Date Opened";
                }

            }
        }

    }

    trigger OnInitReport()
    begin
        objPeriod.Reset;
        objPeriod.SetRange(objPeriod.Closed, false);
        if objPeriod.Find('-') then;
        PeriodFilter := objPeriod."Date Opened";


    end;

    trigger OnPreReport()
    begin
        if UserSetup.Get(UserId) then begin
            if UserSetup."View Payroll" = false then Error('You dont have permissions for payroll, Contact your system administrator! ')
        end else begin
            Error('You have been setup in the user setup!');
        end;
        SelectedPeriod := PeriodFilter;
        objPeriod.Reset;
        objPeriod.SetRange(objPeriod."Date Opened", SelectedPeriod);
        if objPeriod.Find('-') then begin
            PeriodName := objPeriod."Period Name";
        end;
        if CompanyInfo.Get() then
            CompanyInfo.CalcFields(CompanyInfo.Picture);
        Clear(rows);
        Clear(GPY);
        Clear(STAT);
        Clear(DED);
        Clear(NETS);


    end;

    var
        UserSetup: Record "User Setup";
        CompName: Text[50];
        Addr1: Text[50];
        Addr2: Text[50];
        Email: Text[50];
        empName: Text[250];
        DetDate: Text[100];
        found: Boolean;
        countz: Integer;
        PeriodFilter: Date;
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        PeriodTrans: Record "Payroll Monthly Trans_AU";
        objPeriod: Record "Payroll Calender_AU";
        SelectedPeriod: Date;
        PeriodName: Text[30];
        CompanyInfo: Record "Company Information";
        TotalsAllowances: Decimal;
        Dept: Boolean;
        PaymentDesc: Text[200];
        DeductionDesc: Text[200];
        GroupText1: Text[200];
        GroupText2: Text[200];
        PaymentAmount: Decimal;
        DeductAmount: Decimal;
        PayTrans: array[70] of Text[250];
        PayTransAmt: array[70] of Decimal;
        DedTrans: array[70] of Text[250];
        DedTransAmt: array[70] of Decimal;
        rows: Integer;
        rows2: Integer;
        GPY: Decimal;
        NETS: Decimal;
        STAT: Decimal;
        DED: Decimal;
        TotalFor: label 'Total for ';
        GroupOrder: label '3';
        TransBal: array[2, 60] of Text[250];
        Addr: array[2, 10] of Text[250];
        RecordNo: Integer;
        NoOfColumns: Integer;
        ColumnNo: Integer;
        emps: Record "Payroll Employee_AU";
        "prPayroll Periods": Record "Payroll Calender_AU";
        TransCodes: Record "Payroll Transaction Code_AU";
        BankName: Text;
        BranchName: Text;
        AccountNo: Text;
        BankCode: Code[20];
        BranchCode: Code[20];

}