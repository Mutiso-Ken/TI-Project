#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80013 "Pension Report_AU"
{
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Layouts/Pension Report_AU.rdlc';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("Payroll Employee_AU"; "Payroll Employee_AU")
        {
            DataItemTableView = where(Status = const(Active), "Contract Type" = const("Full Time"));

            column(No; "Payroll Employee_AU"."No.")
            {
            }
            column(Basic; "Payroll Employee_AU"."Basic Pay")
            {
            }
            column(Name; Name)
            {
            }
            column(Pic; CompanyInfo.Picture)
            {
            }
            column(Period; Period)
            {
            }
            column(EmployerPension; EmployerPension)
            {
            }
            column(EmployeePension; EmployeePension)
            {
            }
            column(TotalPension; TotalPension)
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
                TotEmployeePension := 0;
                TotEmployerPension := 0;
                UserSetup.Get(UserId);
                if UserSetup."View Payroll" = false then
                    Error('You do not have permissions to view the report');

            end;

            trigger OnAfterGetRecord();
            begin
                TotalPension := 0; // Inserted by ForNAV
                EmployerPension := 0; // Inserted by ForNAV
                EmployeePension := 0; // Inserted by ForNAV
                Name := "Payroll Employee_AU".Surname + "Payroll Employee_AU".Firstname + "Payroll Employee_AU".Lastname;
                EmployeePension := 0;
                EmployerPension := 0;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", '2003');
                if PayrollMonthly.Find('-') then begin
                    EmployeePension := PayrollMonthly.Amount;
                    EmployerPension := (EmployeePension * 2);
                    TotEmployerPension := TotEmployeePension + EmployeePension;
                    TotEmployerPension := TotEmployerPension + EmployerPension;
                end;
                TotalPension := EmployeePension + EmployerPension;
                //Transaction Bank Details
                TransCodes.Reset;
                TransCodes.SetRange(TransCodes."Transaction Code", '2003');
                if TransCodes.Find('-') then begin
                    BankCode := TransCodes."Payable Bank Ac";
                    BankName := TransCodes."Bank Name";
                    BranchCode := TransCodes."Branch Code";
                    BranchName := TransCodes."Branch Name";
                    AccountNo := TransCodes."Account Number";
                end;
                //MESSAGE(FORMAT(TotalPension));
                /*EmployeePensionP:=0;
				EmployerPensionP:=0;
				PayrollMonthly.RESET;
				PayrollMonthly.SETRANGE(PayrollMonthly."No.","Payroll Employee"."No.");
				PayrollMonthly.SETRANGE(PayrollMonthly."Payroll Period",Period);
				PayrollMonthly.SETRANGE(PayrollMonthly."Transaction Code",'2003');
				IF PayrollMonthly.FIND('-') THEN BEGIN
				  REPEAT
					  EmployeePensionP:=PayrollMonthly.Amount;
					  EmployerPensionP:=(EmployeePensionP*2);
					TotalPension:=TotalPension+EmployeePensionP+EmployerPensionP;
				  UNTIL PayrollMonthly.NEXT=0;
				END;
				*/
                if EmployeePension = 0 then CurrReport.Skip;

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
                field(Period; Period)
                {
                    ApplicationArea = Basic;
                    Caption = 'Period';
                    TableRelation = "Payroll Calender_AU"."Date Opened";
                }

            }
        }

    }

    trigger OnInitReport()
    begin
        TotalPension := 0;


    end;

    var
        Period: Date;
        Statutory: Decimal;
        Deductions: Decimal;
        Benefits: Decimal;
        TDeductions: Decimal;
        Netpay: Decimal;
        TransCodes: Record "Payroll Transaction Code_AU";
        Name: Text;
        CompanyInfo: Record "Company Information";
        NSSF: Decimal;
        NHIF: Decimal;
        PAYE: Decimal;
        EmployeePension: Decimal;
        PayrollMonthly: Record "Payroll Monthly Trans_AU";
        EmployerPension: Decimal;
        TotEmployeePension: Decimal;
        TotEmployerPension: Decimal;
        TotalPension: Decimal;
        EmployeePensionP: Decimal;
        EmployerPensionP: Decimal;
        BankName: Text;
        BranchName: Text;
        AccountNo: Text;
        BankCode: Code[20];
        BranchCode: Code[20];
        UserSetup: Record "User Setup";

    trigger OnPreReport();
    begin

    end;

}