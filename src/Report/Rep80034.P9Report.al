#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80034 P9Report
{
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Layouts/P9Report.rdlc';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("HR Employees"; "HR Employees")
        {
            RequestFilterFields = "No.";


            column(No_HREmployees; "HR Employees"."No.")
            {
            }
            column(FirstName_HREmployees; "HR Employees"."First Name")
            {
            }
            column(MiddleName_HREmployees; "HR Employees"."Middle Name")
            {
            }
            column(LastName_HREmployees; "HR Employees"."Last Name")
            {
            }
            column(PIN; PINNo)
            {
            }
            dataitem("Payroll Employee P9"; "Payroll Employee P9_AU")
            {
                DataItemLink = "Employee Code" = field("No.");
                RequestFilterFields = "Period Year";

                column(Benefits_PayrollEmployeeP9; "Payroll Employee P9".Benefits)
                {
                }
                column(ValueOfQuarters_PayrollEmployeeP9; "Payroll Employee P9"."Value Of Quarters")
                {
                }
                column(OwnerOccupierInterest_PayrollEmployeeP9; "Payroll Employee P9"."Owner Occupier Interest")
                {
                }
                column(GrossPay_PayrollEmployeeP9; "Payroll Employee P9"."Gross Pay")
                {
                }
                column(PeriodYear_PayrollEmployeeP9; "Payroll Employee P9"."Period Year")
                {
                }
                column(MonthText; MonthText)
                {
                    IncludeCaption = false;
                }
                column(FixedContribution; FixedContribution)
                {
                }
                column(Bpay; Bpay)
                {
                }
                column(TXBP; TXBP)
                {
                }
                column(TXCHRG; TXCHRG)
                {
                }
                column(PSNR; PSNR)
                {
                }
                column(INSRLF; INSRLF)
                {
                }
                column(PAYE; "Payroll Employee P9".PAYE)
                {
                }
                column(E2; E2)
                {
                }
                trigger OnPreDataItem();
                begin

                end;

                trigger OnAfterGetRecord();
                begin
                    PAYE := 0; // Inserted by ForNAV
                    INSRLF := 0; // Inserted by ForNAV
                    PSNR := 0; // Inserted by ForNAV
                    TXCHRG := 0; // Inserted by ForNAV
                    TXBP := 0; // Inserted by ForNAV
                    E2 := 0; // Inserted by ForNAV
                    Bpay := 0; // Inserted by ForNAV
                    FixedContribution := 0; // Inserted by ForNAV
                                            //MESSAGE('%1',"Payroll Employee P9".Pension);
                    PensionAmt := 0;
                    NSSFAmt := 0;
                    PenNSSF := 0;
                    PensionAmt := "Payroll Employee P9".Pension;
                    NSSFAmt := "Payroll Employee P9".NSSF;
                    PenNSSF := PensionAmt;
                    if PenNSSF = 0 then
                        PenNSSF := NSSFAmt;
                    case "Period Month" of
                        1:
                            MonthText := 'January';
                        2:
                            MonthText := 'February';
                        3:
                            MonthText := 'March';
                        4:
                            MonthText := 'April';
                        5:
                            MonthText := 'May';
                        6:
                            MonthText := 'June';
                        7:
                            MonthText := 'July';
                        8:
                            MonthText := 'August';
                        9:
                            MonthText := 'September';
                        10:
                            MonthText := 'October';
                        11:
                            MonthText := 'November';
                        12:
                            MonthText := 'December';
                        else
                            MonthText := '';
                    end;
                    if (NSSF) > 20000 then begin
                        ColG := 20000 + "Owner Occupier Interest";
                    end
                    else begin
                        ColG := (NSSF) + "Owner Occupier Interest";
                    end;
                    FixedContribution := 20000;
                    HTotal := "Gross Pay" - ColG;
                    Amount1 := 0;
                    Amount2 := 0;
                    Amount3 := 0;
                    if PenNSSF < FixedContribution then
                        Amount1 := PenNSSF
                    else if FixedContribution < PenNSSF then
                        Amount1 := FixedContribution;
                    Amount2 := Amount1 + "Payroll Employee P9"."Owner Occupier Interest";
                    Amount3 := "Payroll Employee P9"."Gross Pay" - Amount2;
                    Bpay := 0;
                    PayrollMonthlyTransactions.Reset;
                    PayrollMonthlyTransactions.SetRange("No.", "Payroll Employee P9"."Employee Code");
                    PayrollMonthlyTransactions.SetRange("Period Month", "Payroll Employee P9"."Period Month");
                    PayrollMonthlyTransactions.SetRange("Period Year", "Payroll Employee P9"."Period Year");
                    PayrollMonthlyTransactions.SetRange("Transaction Code", 'BPAY');
                    if PayrollMonthlyTransactions.FindFirst then
                        Bpay := PayrollMonthlyTransactions.Amount;
                    TXBP := 0;
                    PayrollMonthlyTransactions.Reset;
                    PayrollMonthlyTransactions.SetRange("No.", "Payroll Employee P9"."Employee Code");
                    PayrollMonthlyTransactions.SetRange("Period Month", "Payroll Employee P9"."Period Month");
                    PayrollMonthlyTransactions.SetRange("Period Year", "Payroll Employee P9"."Period Year");
                    PayrollMonthlyTransactions.SetRange("Transaction Code", 'TXBP');
                    if PayrollMonthlyTransactions.FindFirst then
                        TXBP := PayrollMonthlyTransactions.Amount;
                    TXCHRG := 0;
                    PayrollMonthlyTransactions.Reset;
                    PayrollMonthlyTransactions.SetRange("No.", "Payroll Employee P9"."Employee Code");
                    PayrollMonthlyTransactions.SetRange("Period Month", "Payroll Employee P9"."Period Month");
                    PayrollMonthlyTransactions.SetRange("Period Year", "Payroll Employee P9"."Period Year");
                    PayrollMonthlyTransactions.SetRange("Transaction Code", 'TXCHRG');
                    if PayrollMonthlyTransactions.FindFirst then
                        TXCHRG := PayrollMonthlyTransactions.Amount;
                    PSNR := 0;
                    PayrollMonthlyTransactions.Reset;
                    PayrollMonthlyTransactions.SetRange("No.", "Payroll Employee P9"."Employee Code");
                    PayrollMonthlyTransactions.SetRange("Period Month", "Payroll Employee P9"."Period Month");
                    PayrollMonthlyTransactions.SetRange("Period Year", "Payroll Employee P9"."Period Year");
                    PayrollMonthlyTransactions.SetRange("Transaction Code", 'PSNR');
                    if PayrollMonthlyTransactions.FindFirst then
                        PSNR := PayrollMonthlyTransactions.Amount;
                    INSRLF := 0;
                    PayrollMonthlyTransactions.Reset;
                    PayrollMonthlyTransactions.SetRange("No.", "Payroll Employee P9"."Employee Code");
                    PayrollMonthlyTransactions.SetRange("Period Month", "Payroll Employee P9"."Period Month");
                    PayrollMonthlyTransactions.SetRange("Period Year", "Payroll Employee P9"."Period Year");
                    PayrollMonthlyTransactions.SetRange("Transaction Code", 'INSRLF');
                    if PayrollMonthlyTransactions.FindFirst then
                        INSRLF := PayrollMonthlyTransactions.Amount;
                    PAYE := 0;
                    PayrollMonthlyTransactions.Reset;
                    PayrollMonthlyTransactions.SetRange("No.", "Payroll Employee P9"."Employee Code");
                    PayrollMonthlyTransactions.SetRange("Period Month", "Payroll Employee P9"."Period Month");
                    PayrollMonthlyTransactions.SetRange("Period Year", "Payroll Employee P9"."Period Year");
                    PayrollMonthlyTransactions.SetRange("Transaction Code", 'PAYE');
                    if PayrollMonthlyTransactions.FindFirst then
                        PAYE := PayrollMonthlyTransactions.Amount;
                    E2 := 0;
                    PayrollMonthlyTransactions.Reset;
                    PayrollMonthlyTransactions.SetRange("No.", "Payroll Employee P9"."Employee Code");
                    PayrollMonthlyTransactions.SetRange("Period Month", "Payroll Employee P9"."Period Month");
                    PayrollMonthlyTransactions.SetRange("Period Year", "Payroll Employee P9"."Period Year");
                    PayrollMonthlyTransactions.SetRange("Transaction Code", 'NSSF');
                    if PayrollMonthlyTransactions.FindFirst then
                        E2 := PayrollMonthlyTransactions.Amount;
                    PayrollMonthlyTransactions.Reset;
                    PayrollMonthlyTransactions.SetRange("No.", "Payroll Employee P9"."Employee Code");
                    PayrollMonthlyTransactions.SetRange("Period Month", "Payroll Employee P9"."Period Month");
                    PayrollMonthlyTransactions.SetRange("Period Year", "Payroll Employee P9"."Period Year");
                    PayrollMonthlyTransactions.SetRange("Transaction Code", 'PENSION');
                    if PayrollMonthlyTransactions.FindFirst then
                        E2 := E2 + PayrollMonthlyTransactions.Amount;
                end;

            }
            trigger OnPreDataItem();
            begin

            end;

            trigger OnAfterGetRecord();
            begin
                PINNo := '';
                PayrollEmployeee.Reset;
                PayrollEmployeee.SetRange(PayrollEmployeee."No.", "HR Employees"."No.");
                if PayrollEmployeee.Find('-') then
                    PINNo := PayrollEmployeee."PIN No";
                TotaA := 0;
                TotalB := 0;
                totalC := 0;
                totalD := 0;
                TotalE1 := 0;
                TotalE2 := 0;
                TotalE3 := 0;
                TotalF := 0;
                TotalG := 0;
                TotalH := 0;
                TotalJ := 0;
                TotalK := 0;
                TotalL := 0;
                P9.Reset;
                P9.SetRange(P9."Employee Code", "No.");
                P9.SetRange(P9."Period Year", 2016);
                if P9.Find('-') then begin
                    repeat
                        TotaA := TotaA + P9."Basic Pay";
                        TotalB := TotalB + P9.Benefits;
                        totalC := totalC + P9."Value Of Quarters";
                        totalD := totalD + P9."Gross Pay";
                        TotalE1 := TotalE1 + (P9."Basic Pay" * 0.3);
                        TotalE2 := TotalE2 + (P9.NSSF);
                        TotalE3 := TotalE3 + 20000;
                        TotalF := TotalF + P9."Owner Occupier Interest";
                        if P9.NSSF < 20000 then begin
                            TotalH := TotalH + (P9."Gross Pay" - (P9.NSSF));
                        end else begin
                            TotalH := TotalH + (P9."Gross Pay" - 20000);
                        end;
                        TotalJ := TotalJ + P9."Tax Charged";
                        TotalK := TotalK + (P9."Tax Relief" + P9."Insurance Relief");
                        TotalL := TotalL + P9.PAYE;
                    until P9.Next = 0;
                end;
            end;

        }
    }
    requestpage
    {
        SaveValues = true;
        layout
        {
        }

    }

    trigger OnInitReport()
    begin
        if ObjUserSetup.Get(UserId) then begin
            if ObjUserSetup."View Payroll" = false then Error('You dont have permissions for payroll, Contact your system administrator! ')
        end;


    end;

    var
        MonthText: Text;
        ObjUserSetup: Record "User Setup";
        ColG: Decimal;
        FixedContribution: Decimal;
        HTotal: Decimal;
        TotaA: Decimal;
        TotalB: Decimal;
        totalC: Decimal;
        totalD: Decimal;
        TotalE1: Decimal;
        TotalE2: Decimal;
        TotalE3: Decimal;
        TotalF: Decimal;
        TotalG: Decimal;
        TotalH: Decimal;
        TotalI: Decimal;
        TotalJ: Decimal;
        TotalK: Decimal;
        TotalL: Decimal;
        P9: Record "Payroll Employee P9_AU";
        PensionAmt: Decimal;
        NSSFAmt: Decimal;
        PenNSSF: Decimal;
        Amount1: Decimal;
        Amount2: Decimal;
        Amount3: Decimal;
        PayrollEmployeee: Record "Payroll Employee_AU";
        PINNo: Code[20];
        Bpay: Decimal;
        PayrollMonthlyTransactions: Record "Payroll Monthly Trans_AU";
        TXBP: Decimal;
        TXCHRG: Decimal;
        PSNR: Decimal;
        INSRLF: Decimal;
        PAYE: Decimal;
        E2: Decimal;

    trigger OnPreReport();
    begin

    end;

}