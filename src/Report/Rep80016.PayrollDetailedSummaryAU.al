#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80016 "Payroll Detailed Summary_AU"
{
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Layouts/Payroll Detailed Summary_AU.rdlc';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("Payroll Employee_AU"; "Payroll Employee_AU")
        {

            column(No; "Payroll Employee_AU"."No.")
            {
            }
            column(Basic; Basicc)
            {
            }
            column(HouseAllowance; PerdiumAllowance)
            {
            }
            column(CommuterAllowance; CommuterAllowance)
            {
            }
            column(OtherAllowance; OtherAllowance)
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
            column(NSSF; NSSF)
            {
            }
            column(PAYE; PAYE)
            {
            }
            column(Pension; Pension)
            {
            }
            column(IRelief; IRelief)
            {
            }
            column(PRelief; PRelief)
            {
            }
            column(NHIF; NHIF)
            {
            }
            column(ELIMU; ELIMU)
            {
            }
            column(HELB; HELB)
            {
            }
            column(ICEA; ICEA)
            {
            }
            column(MHASIBU; MHASIBU)
            {
            }
            column(SALADV; SALADV)
            {
            }
            column(Vouchers; "Vouchers&Meals")
            {
            }
            column(SalArrears; SalArrears)
            {
            }
            column(WelfareMembership; WelfareMembership)
            {
            }
            column(HL; HL)
            {
            }
            column(RECOVERY; RECOVERY)
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
                HL := 0; // Inserted by ForNAV
                SALADV := 0; // Inserted by ForNAV
                RECOVERY := 0; // Inserted by ForNAV
                ICEA := 0; // Inserted by ForNAV
                HELB := 0; // Inserted by ForNAV
                WelfareMembership := 0; // Inserted by ForNAV
                MHASIBU := 0; // Inserted by ForNAV
                ELIMU := 0; // Inserted by ForNAV
                PRelief := 0; // Inserted by ForNAV
                IRelief := 0; // Inserted by ForNAV
                Pension := 0; // Inserted by ForNAV
                PAYE := 0; // Inserted by ForNAV
                NHIF := 0; // Inserted by ForNAV
                NSSF := 0; // Inserted by ForNAV
                OtherAllowance := 0; // Inserted by ForNAV
                "Vouchers&Meals" := 0; // Inserted by ForNAV
                CommuterAllowance := 0; // Inserted by ForNAV
                PerdiumAllowance := 0; // Inserted by ForNAV
                SalArrears := 0; // Inserted by ForNAV
                Basicc := 0; // Inserted by ForNAV
                if "Payroll Employee_AU".Status <> "Payroll Employee_AU".Status::Active then CurrReport.Skip;
                Name := "Payroll Employee_AU".Surname + ' ' + "Payroll Employee_AU".Firstname + ' ' + "Payroll Employee_AU".Lastname;
                PerdiumAllowance := 0;
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
                Pension := 0;
                IRelief := 0;
                PRelief := 0;
                PAYE := 0;
                COOPLOAN := 0;
                COOPSHARE := 0;
                ELIMU := 0;
                HELB := 0;
                ICEA := 0;
                INSURANCE := 0;
                MHASIBU := 0;
                SALADV := 0;
                Commision := 0;
                RES := 0;
                UFLOAT := 0;
                OTHERDED := 0;
                "Vouchers&Meals" := 0;
                "Non Cash Vouchers&Meals" := 0;
                "OVER EXP" := 0;
                Basicc := 0;
                Noncashdeduction := 0;
                NoncashEarning := 0;
                SalArrears := 0;
                WelfareMembership := 0;
                imprestr := 0;
                "EXTRA MILE" := 0;
                "EXTRA MILE." := 0;
                HL := 0;
                RECOVERY := 0;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'BPAY');
                if PayrollMonthly.Find('-') then begin
                    Basicc := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'OTHER DEDU');
                if PayrollMonthly.Find('-') then begin
                    OTHERDED := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'HL');
                if PayrollMonthly.Find('-') then begin
                    HL := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'REFUND');
                if PayrollMonthly.Find('-') then begin
                    imprestr := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'NONCASH AL');
                if PayrollMonthly.Find('-') then begin
                    NoncashEarning := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'JAN RELIEF');
                if PayrollMonthly.Find('-') then begin
                    Noncashdeduction := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'VOUCHER');
                if PayrollMonthly.Find('-') then begin
                    "Vouchers&Meals" := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'EXTRA MILE');
                if PayrollMonthly.Find('-') then begin
                    "EXTRA MILE" := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'EXTRAMILE.');
                if PayrollMonthly.Find('-') then begin
                    "EXTRA MILE." := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'VOUCHERS.');
                if PayrollMonthly.Find('-') then begin
                    "Non Cash Vouchers&Meals" := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'ARREARS');
                if PayrollMonthly.Find('-') then begin
                    SalArrears := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'BENEFIT TE');
                if PayrollMonthly.Find('-') then begin
                    PerdiumAllowance := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'RESP ALLOW');
                if PayrollMonthly.Find('-') then begin
                    RES := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'UNACTFLOT');
                if PayrollMonthly.Find('-') then begin
                    UFLOAT := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'E0002');
                if PayrollMonthly.Find('-') then begin
                    Commision := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'EXCESS PEN');
                if PayrollMonthly.Find('-') then begin
                    CommuterAllowance := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'PENSION');
                if PayrollMonthly.Find('-') then begin
                    Pension := PayrollMonthly.Amount;
                end;
                Housing := 0;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'RECOVERY');
                if PayrollMonthly.Find('-') then begin
                    RECOVERY := PayrollMonthly.Amount;
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
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'INSRLF');
                if PayrollMonthly.Find('-') then begin
                    IRelief := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'PSNR');
                if PayrollMonthly.Find('-') then begin
                    PRelief := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'PAYE');
                if PayrollMonthly.Find('-') then begin
                    PAYE := Statutory + PayrollMonthly.Amount;
                end;
                Statutory := NSSF + NHIF + PAYE;
                //Deductions
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'COOP LOAN');
                if PayrollMonthly.Find('-') then begin
                    COOPLOAN := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'OVER EXP');
                if PayrollMonthly.Find('-') then begin
                    "OVER EXP" := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'COOP SHARE');
                if PayrollMonthly.Find('-') then begin
                    COOPSHARE := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'KIMSACCO');
                if PayrollMonthly.Find('-') then begin
                    ELIMU := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'HELB DED');
                if PayrollMonthly.Find('-') then begin
                    HELB := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'CASH ADVA');
                if PayrollMonthly.Find('-') then begin
                    ICEA := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'INSURANCE');
                if PayrollMonthly.Find('-') then begin
                    INSURANCE := Statutory + PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'WELF CONT');
                if PayrollMonthly.Find('-') then begin
                    MHASIBU := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'WELF-MEMB');
                if PayrollMonthly.Find('-') then begin
                    WelfareMembership := PayrollMonthly.Amount;
                end;
                PayrollMonthly.Reset;
                PayrollMonthly.SetRange(PayrollMonthly."No.", "Payroll Employee_AU"."No.");
                PayrollMonthly.SetRange(PayrollMonthly."Payroll Period", Period);
                PayrollMonthly.SetRange(PayrollMonthly."Transaction Code", 'FINLMSACC');
                if PayrollMonthly.Find('-') then begin
                    SALADV := PayrollMonthly.Amount;
                end;
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
                    until PayrollMonthly.Next = 0;
                end;
                //Tnet:=ROUND(Tnet,1,'=');
                Netpay := ROUND(Netpay, 1, '=');
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
        PerdiumAllowance: Decimal;
        CommuterAllowance: Decimal;
        OtherAllowance: Decimal;
        PayrollMonthly: Record "Payroll Monthly Trans_AU";
        GrossPay: Decimal;
        Period: Date;
        Housing: Decimal;
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
        Pension: Decimal;
        IRelief: Decimal;
        PRelief: Decimal;
        UserSetup: Record "User Setup";
        Commision: Decimal;
        COOPLOAN: Decimal;
        COOPSHARE: Decimal;
        ELIMU: Decimal;
        HELB: Decimal;
        ICEA: Decimal;
        INSURANCE: Decimal;
        MHASIBU: Decimal;
        SALADV: Decimal;
        RES: Decimal;
        UFLOAT: Decimal;
        OTHERDED: Decimal;
        Tnet: Decimal;
        "Vouchers&Meals": Decimal;
        "Non Cash Vouchers&Meals": Decimal;
        "OVER EXP": Decimal;
        Basicc: Decimal;
        NoncashEarning: Decimal;
        Noncashdeduction: Decimal;
        SalArrears: Decimal;
        WelfareMembership: Decimal;
        imprestr: Decimal;
        "EXTRA MILE": Decimal;
        "EXTRA MILE.": Decimal;
        HL: Decimal;
        RECOVERY: Decimal;

    trigger OnInitReport();
    begin

    end;

    trigger OnPreReport();
    begin

    end;

}