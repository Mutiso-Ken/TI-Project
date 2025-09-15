#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80014 "Pension Report (KU)_AU"
{
    WordLayout = 'Layouts/PensionReport(KU)_AU.docx';
    DefaultLayout = Word;

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
            column(TotalPension; TotalPension)
            {
            }
            trigger OnPreDataItem();
            begin
                if CompanyInfo.Get() then
                    CompanyInfo.CalcFields(CompanyInfo.Picture);

            end;

            trigger OnAfterGetRecord();
            begin
                TotalPension := 0; // Inserted by ForNAV
                EmployerPension := 0; // Inserted by ForNAV
                EmployeePension := 0; // Inserted by ForNAV
                Name := "Payroll Employee_AU".Surname + "Payroll Employee_AU".Firstname + "Payroll Employee_AU".Lastname;
                EmployeePension := 0;
                EmployerPension := 0;
                TotalPension := 0;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", '2061');
                if PayrollMonthly.Find('-') then begin
                    EmployeePension := PayrollMonthly.Amount;
                    EmployerPension := (EmployeePension * 2);
                    TotalPension := EmployeePension + EmployerPension;
                end;
                //Transaction Bank Details
                TransCodes.Reset;
                TransCodes.SetRange(TransCodes."Transaction Code", '2061');
                if TransCodes.Find('-') then begin
                    BankCode := TransCodes."Payable Bank Ac";
                    BankName := TransCodes."Bank Name";
                    BranchCode := TransCodes."Branch Code";
                    BranchName := TransCodes."Branch Name";
                    AccountNo := TransCodes."Account Number";
                end;
                if EmployerPension = 0 then CurrReport.Skip;
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
        BankName: Text;
        BranchName: Text;
        AccountNo: Text;
        BankCode: Code[20];
        BranchCode: Code[20];
        TotalPension: Decimal;

    trigger OnInitReport();
    begin

    end;

    trigger OnPreReport();
    begin

    end;
}