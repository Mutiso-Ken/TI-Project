#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80010 "Bank Schedule_AU"
{
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Layouts/Bank Schedule_AU.rdlc';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("Payroll Employee_AU"; "Payroll Employee_AU")
        {
            RequestFilterFields = "Bank Code", "Branch Code";

            column(Acc_No; "Payroll Employee_AU"."Bank Account No")
            {
            }
            column(Net_Pay; NetPay)
            {
            }
            column(Name; StrName)
            {
            }
            column(Period; Period)
            {
            }
            column(BankName_PayrollEmployeeAU; "Payroll Employee_AU"."Bank Name")
            {
            }
            column(BranchName_PayrollEmployeeAU; "Payroll Employee_AU"."Branch Name")
            {
            }
            trigger OnPreDataItem();
            begin
                info.Reset;
                if info.Get then info.CalcFields(info.Picture);
                //Pict:=info.Picture;
                CompName := info.Name;
                Addr1 := info.Address;
                Addr2 := info.City;
                Email := info."E-Mail";
                TotalNetAmount := 0;

            end;

            trigger OnAfterGetRecord();
            begin
                NetPay := 0; // Inserted by ForNAV
                NetPay := 0;
                NCount := 0;
                PCPeriods := periods;
                StrName := "Payroll Employee_AU".Surname + ' ' + "Payroll Employee_AU".Firstname + ' ' + "Payroll Employee_AU".Lastname;
                if "Payroll Employee_AU".Status = "Payroll Employee_AU".Status::Active then begin
                    prPeriodTransactions.Reset;
                    prPeriodTransactions.SetRange(prPeriodTransactions."No.", "Payroll Employee_AU"."No.");
                    prPeriodTransactions.SetRange(prPeriodTransactions."Payroll Period", periods);
                    prPeriodTransactions.CalcFields("Contract Type");
                    // prPeriodTransactions.SETRANGE(prPeriodTransactions."Contract Type","Payroll Employee_AU"."Contract Type");
                    prPeriodTransactions.SetRange(prPeriodTransactions."Transaction Code", 'NPAY');
                    if prPeriodTransactions.Find('-') then begin
                        NetPay := prPeriodTransactions.Amount;
                        //   NetPay:=ROUND(NetPay,1,'=');
                        TNpay := TNpay + NetPay;
                        //MESSAGE(FORMAT(TotalNetAmount));
                        if NetPay > 0 then
                            NCount := NCount + 1;
                    end;
                end else begin
                    CurrReport.Skip;
                end;
                TotalNetAmount := TotalNetAmount + NetPay;
                PCalender.Reset;
                if PCalender.Get(periods) then
                    Period := PCalender."Period Name";
                TNET := TNET + NetPay;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", periods);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'NPAY');
                PayrollMonthly.SetFilter(Amount, '>%1', 0);
                if PayrollMonthly.FindSet then begin
                    repeat
                        Tnet2 := Tnet2 + ROUND(PayrollMonthly.Amount, 1, '=');
                    until PayrollMonthly.Next = 0;
                end;
                //Tnet2:=ROUND(Tnet2,1,'=');
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
                field(Period; periods)
                {
                    ApplicationArea = Basic;
                    Caption = 'Period:';
                    TableRelation = "Payroll Calender_AU"."Date Opened";
                }

            }
        }

    }

    trigger OnPreReport()
    begin
        if UserSetup.Get(UserId) then begin
            if UserSetup."View Payroll" = false then Error('You dont have permissions for payroll, Contact your system administrator! ')
        end;


    end;

    var
        UserSetup: Record "User Setup";
        StrName: Text[100];
        prPeriodTransactions: Record "Payroll Monthly Trans_AU";
        periods: Date;
        info: Record "Company Information";
        CompName: Text[50];
        Addr1: Text[50];
        Addr2: Text[50];
        Email: Text[50];
        NetPay: Decimal;
        NCount: Integer;
        Period: Text;
        PCalender: Record "Payroll Calender_AU";
        PCPeriods: Date;
        TNpay: Decimal;
        TotalNetAmount: Decimal;
        Bankname: Text;
        branchname: Text;
        TNET: Decimal;
        Tnet2: Decimal;
        PayrollMonthly: Record "Payroll Monthly Trans_AU";

    trigger OnInitReport();
    begin

    end;

}