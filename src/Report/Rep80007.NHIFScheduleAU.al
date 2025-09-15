#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80007 "NHIF Schedule_AU"
{
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Layouts/NHIF Schedule_AU.rdlc';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("Payroll Employee_AU"; "Payroll Employee_AU")
        {
            DataItemTableView = where(Status = const(Active));
            RequestFilterFields = "Period Filter", "No.";

            column(PeriodName; PeriodName)
            {
            }
            column(Companyinfo_Picture; Companyinfo.Picture)
            {
            }
            column(NhifAmount; NhifAmount)
            {
            }
            column(IDNumber; "Payroll Employee_AU"."ID No/Passport No")
            {
            }
            column(NhifNo; NhifNo)
            {
            }
            column(EmployeeName; EmployeeName)
            {
            }
            column(prSalary_Card__prSalary_Card___Employee_Code_; "Payroll Employee_AU"."No.")
            {
            }
            column(NATIONAL_HOSPITAL_INSURANCE_FUNDCaption; NATIONAL_HOSPITAL_INSURANCE_FUNDCaptionLbl)
            {
            }
            column(User_Name_Caption; User_Name_CaptionLbl)
            {
            }
            column(Print_Date_Caption; Print_Date_CaptionLbl)
            {
            }
            column(Period_Caption; Period_CaptionLbl)
            {
            }
            column(Page_Nov_Caption; Page_No_CaptionLbl)
            {
            }
            column(PERIOD_Caption_Control1102755032; PERIOD_Caption_Control1102755032Lbl)
            {
            }
            column(AmountCaption; AmountCaptionLbl)
            {
            }
            column(ID_Number_Caption; ID_Number_CaptionLbl)
            {
            }
            column(NHIF_No_Caption; NHIF_No_CaptionLbl)
            {
            }
            column(Employee_NameCaption; Employee_NameCaptionLbl)
            {
            }
            column(No_Caption; No_CaptionLbl)
            {
            }
            column(Total_NHIF_Caption; Total_NHIF_CaptionLbl)
            {
            }
            trigger OnPreDataItem();
            begin
                if CompInfoSetup.Get() then
                    //EmployerNHIFNo:=CompInfoSetup."N.H.I.F No";
                    //CompPINNo:=CompInfoSetup."Company P.I.N";
                    Address := CompInfoSetup.Address;
                Tel := CompInfoSetup."Phone No.";
                Clear(TotNhifAmount);

            end;

            trigger OnAfterGetRecord();
            begin
                Clear(NhifAmount);
                objEmp.Reset;
                objEmp.SetRange(objEmp."No.", "No.");
                if objEmp.Find('-') then;
                EmployeeName := objEmp.Firstname + ' ' + objEmp.Lastname + ' ' + objEmp.Surname;
                NhifNo := objEmp."NHIF No";
                IDNumber := objEmp."National ID No";
                //Dob:=objEmp.dat;
                PeriodTrans.Reset;
                PeriodTrans.SetRange(PeriodTrans."No.", "No.");
                PeriodTrans.SetRange(PeriodTrans."Payroll Period", SelectedPeriod);
                PeriodTrans.SetRange(PeriodTrans.Grouping, 7);
                PeriodTrans.SetRange(PeriodTrans.SubGrouping, 2);
                PeriodTrans.SetCurrentkey(PeriodTrans."No.", PeriodTrans."Period Month", PeriodTrans."Period Year",
                PeriodTrans.Grouping, PeriodTrans.SubGrouping);
                NhifAmount := 0;
                if PeriodTrans.Find('-') then begin
                    if PeriodTrans.Amount = 0 then CurrReport.Skip;
                    NhifAmount := PeriodTrans.Amount;
                    TotNhifAmount := TotNhifAmount + PeriodTrans.Amount;
                end;
                if NhifAmount = 0 then CurrReport.Skip;
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
        //PeriodFilter:="prSalary Card".GETFILTER("Period Filter");
        if PeriodFilter = 0D then Error('You must specify the period filter');
        SelectedPeriod := PeriodFilter;
        objPeriod.Reset;
        if objPeriod.Get(SelectedPeriod) then PeriodName := objPeriod."Period Name";
        if Companyinfo.Get() then
            Companyinfo.CalcFields(Companyinfo.Picture);
        Clear(NhifAmount);


    end;

    var
        UserSetup: Record "User Setup";
        PeriodTrans: Record "Payroll Monthly Trans_AU";
        NhifAmount: Decimal;
        TotNhifAmount: Decimal;
        EmployeeName: Text[150];
        NhifNo: Text[30];
        IDNumber: Text[30];
        objPeriod: Record "Payroll Calender_AU";
        SelectedPeriod: Date;
        PeriodName: Text[30];
        PeriodFilter: Date;
        objEmp: Record "Payroll Employee_AU";
        CompInfoSetup: Record "Company Information";
        EmployerNHIFNo: Code[20];
        CompPINNo: Code[20];
        Address: Text[90];
        Tel: Text[30];
        Dob: Date;
        Companyinfo: Record "Company Information";
        NATIONAL_HOSPITAL_INSURANCE_FUNDCaptionLbl: label 'NATIONAL HOSPITAL INSURANCE FUND';
        User_Name_CaptionLbl: label 'User Name:';
        Print_Date_CaptionLbl: label 'Print Date:';
        Period_CaptionLbl: label 'Period:';
        Page_No_CaptionLbl: label 'Page No:';
        PERIOD_Caption_Control1102755032Lbl: label 'PERIOD:';
        ADDRESS_CaptionLbl: label 'ADDRESS:';
        EMPLOYER_CaptionLbl: label 'EMPLOYER:';
        EMPOLOYER_NO_CaptionLbl: label 'EMPOLOYER NO:';
        EMPLOYER_PIN_NO_CaptionLbl: label 'EMPLOYER PIN NO:';
        TEL_NO_CaptionLbl: label 'TEL NO:';
        AmountCaptionLbl: label 'Amount';
        ID_Number_CaptionLbl: label 'ID Number:';
        NHIF_No_CaptionLbl: label 'NHIF No:';
        Employee_NameCaptionLbl: label 'Employee Name';
        No_CaptionLbl: label 'No:';
        Date_Of_BirthCaptionLbl: label 'Date Of Birth';
        Prepared_by_______________________________________Date_________________CaptionLbl: label 'Prepared by……………………………………………………..				 Date……………………………………………';
        Checked_by________________________________________Date_________________CaptionLbl: label 'Checked by…………………………………………………..				   Date……………………………………………';
        Authorized_by____________________________________Date_________________CaptionLbl: label 'Authorized by……………………………………………………..			  Date……………………………………………';
        Total_NHIF_CaptionLbl: label 'Total NHIF:';
        Approved_by______________________________________Date_________________CaptionLbl: label 'Approved by……………………………………………………..				Date……………………………………………';

}