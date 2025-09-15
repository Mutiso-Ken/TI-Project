#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80012 "Payroll Summary P_AU"
{
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Layouts/PayrollSummaryP_AU.rdlc';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("Payroll Employee_AU"; "Payroll Employee_AU")
        {

            column(No; "Payroll Employee_AU"."No.")
            {
            }
            column(Basic; "Payroll Employee_AU"."Basic Pay")
            {
            }
            column(Perdiem; Perdiem)
            {
            }
            column(CommuterAllowance; CommuterAllowance)
            {
            }
            column(OtherAllowance; OtherAllowance)
            {
            }
            column(GrossPay; GrossPay)
            {
            }
            column(Deductions; Deductions)
            {
            }
            column(Benefits; Benefits)
            {
            }
            column(TDeductions; TDeductions)
            {
            }
            column(Netpay; Netpay)
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
            column(Statutory; Statutory)
            {
            }
            trigger OnPreDataItem();
            begin
                if CompanyInfo.Get() then
                    CompanyInfo.CalcFields(CompanyInfo.Picture);
                UserSetup.Get(UserId);
                if UserSetup."View Payroll" = false then
                    Error('You do not have permissions to view the report');

            end;

            trigger OnAfterGetRecord();
            begin
                Netpay := 0; // Inserted by ForNAV
                TDeductions := 0; // Inserted by ForNAV
                Benefits := 0; // Inserted by ForNAV
                Statutory := 0; // Inserted by ForNAV
                Deductions := 0; // Inserted by ForNAV
                GrossPay := 0; // Inserted by ForNAV
                OtherAllowance := 0; // Inserted by ForNAV
                CommuterAllowance := 0; // Inserted by ForNAV
                Perdiem := 0; // Inserted by ForNAV
                if "Payroll Employee_AU".Status <> "Payroll Employee_AU".Status::Active then CurrReport.Skip;
                Name := "Payroll Employee_AU".Surname + ' ' + "Payroll Employee_AU".Firstname + ' ' + "Payroll Employee_AU".Lastname;
                Perdiem := 0;
                CommuterAllowance := 0;
                OtherAllowance := 0;
                GrossPay := 0;
                Statutory := 0;
                Deductions := 0;
                TDeductions := 0;
                Netpay := 0;
                Benefits := 0;
                NSSF := 0;
                NHIF := 0;
                PAYE := 0;
                NCount := 0;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'PERDIUM');
                if PayrollMonthly.Find('-') then begin
                    Perdiem := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'COMMUTER');
                if PayrollMonthly.Find('-') then begin
                    CommuterAllowance := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'GPAY');
                if PayrollMonthly.Find('-') then begin
                    GrossPay := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'NHIF');
                if PayrollMonthly.Find('-') then begin
                    NHIF := Statutory + PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'NSSF');
                if PayrollMonthly.Find('-') then begin
                    NSSF := Statutory + PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'PAYE');
                if PayrollMonthly.Find('-') then begin
                    PAYE := Statutory + PayrollMonthly.Amount;
                end;
                Statutory := NSSF + NHIF + PAYE;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                if PayrollMonthly.Find('-') then begin
                    repeat
                        TransCodes.Reset;
                        TransCodes.SetRange(TransCodes."Transaction Code", PayrollMonthly."Transaction Code");
                        TransCodes.SetRange(TransCodes."Transaction Type", TransCodes."transaction type"::Deduction);
                        if TransCodes.Find('-') then
                            Deductions := Deductions + PayrollMonthly.Amount;
                    until PayrollMonthly.Next = 0;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                if PayrollMonthly.Find('-') then begin
                    repeat
                        TransCodes.Reset;
                        TransCodes.SetRange(TransCodes."Transaction Code", PayrollMonthly."Transaction Code");
                        TransCodes.SetRange(TransCodes."Transaction Type", TransCodes."transaction type"::Income);
                        if TransCodes.Find('-') then
                            if (PayrollMonthly."Transaction Code" <> '1001') and (PayrollMonthly."Transaction Code" <> '1003') then
                                OtherAllowance := OtherAllowance + PayrollMonthly.Amount;
                    until PayrollMonthly.Next = 0;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                if PayrollMonthly.Find('-') then begin
                    repeat
                        TransCodes.Reset;
                        TransCodes.SetRange(TransCodes."Transaction Code", PayrollMonthly."Transaction Code");
                        TransCodes.SetRange(TransCodes."Special Transaction", TransCodes."special transaction"::"Prescribed Benefit");
                        if TransCodes.Find('-') then
                            Benefits := Benefits + PayrollMonthly.Amount;
                    until PayrollMonthly.Next = 0;
                end;
                TDeductions := Statutory + Benefits + Deductions;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'NPAY');
                if PayrollMonthly.Find('-') then begin
                    Netpay := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'NPAY');
                PayrollMonthly.SetFilter(Amount, '>%1', 0);
                if PayrollMonthly.FindSet then begin
                    repeat
                        Tnet := Tnet + ROUND(PayrollMonthly.Amount, 1, '=');
                        ;
                    until PayrollMonthly.Next = 0;
                end;
                Netpay := ROUND(Netpay, 1, '=');
                //Tnet:=ROUND(Tnet,1,'=');
                if Netpay > 0 then NCount := NCount + 1;
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
        Tnet: Decimal;

    trigger OnInitReport();
    begin

    end;

    trigger OnPreReport();
    begin

    end;

}