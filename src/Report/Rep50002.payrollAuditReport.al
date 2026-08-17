#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50002 "payroll Audit Report."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/payroll Audit Report..rdlc';

    dataset
    {
        dataitem("Payroll Monthly Trans_AU"; "Payroll Monthly Trans_AU")
        {
            RequestFilterFields = "Payroll Period";
            column(ReportForNavId_1000000000; 1000000000) { }
            column(No_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."No.") { }
            column(TransactionCode_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Transaction Code")
            { }
            column(TransactionName_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Transaction Name")
            { }
            column(GlobalDimension1_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Global Dimension 1")
            { }
            column(GlobalDimension2_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Global Dimension 2")
            { }
            column(ShortcutDimension3_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Shortcut Dimension 3")
            { }
            column(ShortcutDimension4_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Shortcut Dimension 4")
            { }
            column(ShortcutDimension5_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Shortcut Dimension 5")
            { }
            column(ShortcutDimension6_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Shortcut Dimension 6")
            { }
            column(ShortcutDimension7_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Shortcut Dimension 7")
            { }
            column(ShortcutDimension8_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Shortcut Dimension 8")
            { }
            column(GroupText_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Group Text")
            { }
            column(Amount_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU".Amount)
            { }
            column(AmountLCY_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Amount(LCY)")
            { }
            column(Balance_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU".Balance)
            { }
            column(BalanceLCY_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Balance(LCY)")
            { }
            column(Grouping_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU".Grouping)
            { }
            column(SubGrouping_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU".SubGrouping)
            { }
            column(PeriodMonth_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Period Month")
            {
            }
            column(PeriodYear_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Period Year")
            {
            }
            column(PayrollPeriod_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Payroll Period")
            {
            }
            column(PeriodFilter_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Period Filter")
            {
            }
            column(ReferenceNo_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Reference No")
            {
            }
            column(Membership_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU".Membership)
            {
            }
            column(LumpSumItems_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU".LumpSumItems)
            {
            }
            column(TravelAllowance_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU".TravelAllowance)
            {
            }
            column(PostingType_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Posting Type")
            {
            }
            column(AccountType_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Account Type")
            {
            }
            column(AccountNo_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Account No")
            {
            }
            column(LoanNumber_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Loan Number")
            {
            }
            column(CoOpparameters_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Co-Op parameters")
            {
            }
            column(CompanyDeduction_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Company Deduction")
            {
            }
            column(EmployerAmount_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Employer Amount")
            {
            }
            column(EmployerAmountLCY_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Employer Amount(LCY)")
            {
            }
            column(EmployerBalance_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Employer Balance")
            {
            }
            column(EmployerBalanceLCY_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Employer Balance(LCY)")
            {
            }
            column(PaymentMode_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Payment Mode")
            {
            }
            column(PayrollCode_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Payroll Code")
            {
            }
            column(NoofUnits_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."No. of Units")
            {
            }
            column(TotalStatutories_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Total Statutories")
            {
            }
            column(ContractType_PayrollMonthlyTransAU; "Payroll Monthly Trans_AU"."Contract Type")
            {
            }
            column(Pic; CompanyInfo.Picture)
            {
            }
            column(NCount; NCount)
            {
            }
            column(Name; Name)
            {
            }
            column(Amt; Amt)
            {
            }
            column(pname2; pname2)
            {
            }
            column(empname; empname)
            {
            }
            column(cperiod; cperiod)
            {
            }
            column(Reason; Reason)
            {
            }
            column(amtthismonth; amtthismonth)
            {
            }
            column(Amtusd; Amt2)
            {
            }
            column(amtthismonthusd; amtthismonth2)
            {
            }

            trigger OnAfterGetRecord()
            begin


                if PayrollEmployee_AU.Get("Payroll Monthly Trans_AU"."No.") then
                    empname := PayrollEmployee_AU."Full Name";
                /*
                PayrollEmployee_AU.GET("Payroll Monthly Trans_AU"."No.");
                IF PayrollEmployee_AU."Employee Pay Currency"<>PayrollEmployee_AU."Employee Pay Currency"::KES THEN CurrReport.SKIP;
                Name:=PayrollEmployee_AU."Full Name";
                */
                Reason := 'No Change';
                Amt := 0;
                amtthismonth := 0;
                Amt2 := 0;
                amtthismonth2 := 0;
                ratecurrent := 0;
                rateprevious := 0;

                // amtthismonth:="Payroll Monthly Trans_AU".Amount;
                amtthismonth := "Payroll Monthly Trans_AU"."Amount(LCY)";
                amtthismonth2 := "Payroll Monthly Trans_AU"."Amount(LCY)";
                if objPeriod.Get("Payroll Monthly Trans_AU"."Payroll Period") then begin
                    cperiod := objPeriod."Period Name";
                    //ratecurrent:=objPeriod."USD/KSH Currency Factor";
                end;


                objPeriod.Reset;
                objPeriod.SetFilter("Date Opened", '<%1', "Payroll Monthly Trans_AU"."Payroll Period");
                if objPeriod.FindLast then begin
                    Selectedperiod2 := objPeriod."Date Opened";
                    pname2 := objPeriod."Period Name";
                    //rateprevious:=objPeriod."USD/KSH Currency Factor";
                end;

                Lastmonthtransactions.Reset;
                Lastmonthtransactions.SetRange("No.", "Payroll Monthly Trans_AU"."No.");
                Lastmonthtransactions.SetRange("Transaction Code", "Payroll Monthly Trans_AU"."Transaction Code");
                Lastmonthtransactions.SetRange("Payroll Period", Selectedperiod2);
                if Lastmonthtransactions.FindFirst then begin
                    /// Amt:=Lastmonthtransactions.Amount;
                    Amt := Lastmonthtransactions."Amount(LCY)";
                    Amt2 := Lastmonthtransactions."Amount(LCY)";
                    if CUrr = Curr::USD then
                        Amt := Lastmonthtransactions.Amount / rateprevious;
                    // Amt:=Lastmonthtransactions.Amount/ratecurrent;
                    Amt := Lastmonthtransactions."Amount(LCY)";
                    Amt2 := Lastmonthtransactions."Amount(LCY)";
                    if TransCodes.Get("Payroll Monthly Trans_AU"."Transaction Code") then
                        //IF TransCodes."Key Amount In KES"=TRUE THEN
                        Amt := Lastmonthtransactions.Amount;
                end;

                if CUrr = Curr::USD then begin
                    //amtthismonth:="Payroll Monthly Trans_AU".Amount/ratecurrent;
                    amtthismonth := "Payroll Monthly Trans_AU"."Amount(LCY)";
                    amtthismonth2 := "Payroll Monthly Trans_AU"."Amount(LCY)";
                    //  amtthismonth:="Payroll Monthly Trans_AU".Amount;
                    if TransCodes.Get("Payroll Monthly Trans_AU"."Transaction Code") then
                        //IF TransCodes."Key Amount In KES"=TRUE THEN
                        amtthismonth := "Payroll Monthly Trans_AU".Amount;
                end;

                if amtthismonth - Amt <> 0 then
                    Reason := 'Change';

                if PayrollEmployee_AU."Joining Date" > CalcDate('CM', Selectedperiod2) then
                    Reason := 'New Employees';

                if Employee.Get("Payroll Monthly Trans_AU"."No.") then begin
                    if (Employee."Inactive Date" > CalcDate('CM', Selectedperiod2)) and (Employee."Inactive Date" < CalcDate('CM', "Payroll Monthly Trans_AU"."Payroll Period")) then
                        Reason := 'Employees who have left';
                end;

            end;

            trigger OnPreDataItem()
            begin
                if CompanyInfo.Get() then
                    CompanyInfo.CalcFields(CompanyInfo.Picture);
                UserSetup.Get(UserId);
                if UserSetup."View Payroll" = false then
                    Error('You do not have permissions to view the report');
            end;
        }
    }

    requestpage
    {

        // layout
        // {
        //     area(content)
        //     {
        //         group(Currency)
        //         {
        //             field("Currency Code"; CUrr)
        //             {
        //                 ApplicationArea = Basic;
        //             }
        //         }
        //     }
        // }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Perdiem: Decimal;
        CommuterAllowance: Decimal;
        OtherAllowance: Decimal;
        PayrollMonthly: Record "Payroll Monthly Trans_AU";
        GrossPay: Decimal;
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
        NCount: Integer;
        UserSetup: Record "User Setup";
        "Other Staff Expenses": Decimal;
        Telephone: Decimal;
        Internet: Decimal;
        Saccos: Decimal;
        Loans: Decimal;
        Welfare: Decimal;
        Pension: Decimal;
        Helb: Decimal;
        Relief: Decimal;
        PayrollEmployee_AU: Record "Payroll Employee_AU";
        Lastmonthtransactions: Record "Payroll Monthly Trans_AU";
        Selectedperiod2: Date;
        Amt: Decimal;
        objPeriod: Record "Payroll Calender_AU";
        pname2: Text;
        cperiod: Text;
        empname: Text;
        Reason: Text;
        Employee: Record Employee;
        "Currency Code": Option ,USD,KES;
        ratecurrent: Decimal;
        rateprevious: Decimal;
        amtthismonth: Decimal;
        CUrr: Option ,USD,KES;
        Dedcode: Code[100];
        Amt2: Decimal;
        amtthismonth2: Decimal;
}

