#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80006 "Third Rule_AU"
{
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Layouts/ThirdRule_AU.rdlc';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("Payroll Employee_AU"; "Payroll Employee_AU")
        {
            DataItemTableView = where(Status = const(Active), "Contract Type" = filter("Full Time"));
            RequestFilterFields = "Bank Code", "Branch Code";
            column(PF_No; "Payroll Employee_AU"."No.")
            {
            }
            column(pic; info.Picture)
            {
            }
            column(Net_Pay; NetPay)
            {
            }
            column(Name; StrName)
            {
            }
            column(basic; "Payroll Employee_AU"."Basic Pay")
            {
            }
            column(ThirdAmount; ThirdAmount)
            {
            }
            column(periods; periods)
            {
            }
            column(Difference; Difference)
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

            end;

            trigger OnAfterGetRecord();
            begin
                StrName := "Payroll Employee_AU".Surname + ' ' + "Payroll Employee_AU".Firstname + ' ' + "Payroll Employee_AU".Lastname;
                if "Payroll Employee_AU".Status = "Payroll Employee_AU".Status::Active then begin
                    prPeriodTransactions.Reset;
                    prPeriodTransactions.SetRange(prPeriodTransactions."Payroll Period", periods);
                    prPeriodTransactions.SetRange(prPeriodTransactions."No.", "Payroll Employee_AU"."No.");
                    prPeriodTransactions.SetRange(prPeriodTransactions."Transaction Code", 'NPAY');
                    if prPeriodTransactions.Find('-') then begin
                        NetPay := prPeriodTransactions.Amount;
                    end
                end else begin
                    CurrReport.Skip;
                end;
                ThirdAmount := 0;
                ThirdAmount := (1 / 3 * "Payroll Employee_AU"."Basic Pay");
                Difference := 0;
                Difference := NetPay - ThirdAmount;
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
        ThirdAmount: Decimal;
        Difference: Decimal;

    trigger OnInitReport();
    begin

    end;

}