#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 80002 "Payroll Employee Trans_AU"
{

    fields
    {
        field(10; "No."; Code[20])
        {
        }
        field(11; "Transaction Code"; Code[20])
        {

            trigger OnValidate()
            begin
                PayrollTrans.Reset;
                PayrollTrans.SetRange(PayrollTrans."Transaction Code", "Transaction Code");
                if PayrollTrans.FindFirst then begin
                    "Transaction Name" := PayrollTrans."Transaction Name";
                    "Transaction Type" := PayrollTrans."Transaction Type";
                    if PayrollTrans."Percent of Basic" <> 0 then begin
                        Employee.Reset;
                        Employee.SetRange(Employee."No.", "No.");
                        if Employee.FindFirst then begin
                            Amount := (PayrollTrans."Percent of Basic" / 100) * Employee."Basic Pay";
                            "Amount(LCY)" := (PayrollTrans."Percent of Basic" / 100) * Employee."Basic Pay";
                        end;
                    end;
                end;
            end;
        }
        field(12; "Transaction Name"; Text[100])
        {
            Editable = false;
        }
        field(13; "Transaction Type"; Option)
        {
            Editable = false;
            OptionCaption = 'Income,Deduction';
            OptionMembers = Income,Deduction;
        }
        field(14; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                Employee.Reset;
                Employee.SetRange(Employee."No.", "No.");
                if Employee.FindFirst then begin
                    if Employee."Currency Code" = '' then
                        "Amount(LCY)" := Amount
                    else
                        "Amount(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(Today, Employee."Currency Code", Amount, Employee."Currency Factor"));
                end;
            end;
        }
        field(15; "Amount(LCY)"; Decimal)
        {
            Editable = false;
        }
        field(16; Balance; Decimal)
        {
            Editable = true;
        }
        field(17; "Balance(LCY)"; Decimal)
        {
            Editable = true;
        }
        field(18; "Period Month"; Integer)
        {
            Editable = false;
        }
        field(19; "Period Year"; Integer)
        {
            Editable = false;
        }
        field(20; "Payroll Period"; Date)
        {
            Editable = false;
            TableRelation = "Payroll Calender_AU"."Date Opened";
        }
        field(21; "No of Repayments"; Decimal)
        {
        }
        field(22; Membership; Code[20])
        {
        }
        field(23; "Reference No"; Text[30])
        {
        }
        field(24; "Employer Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                Employee.Reset;
                Employee.SetRange(Employee."No.", "No.");
                if Employee.FindFirst then begin
                    if Employee."Currency Code" = '' then
                        "Employer Amount(LCY)" := "Employer Amount"
                    else
                        "Employer Amount(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(Today, Employee."Currency Code", "Employer Amount", Employee."Currency Factor"));
                end;
            end;
        }
        field(25; "Employer Amount(LCY)"; Decimal)
        {
            Editable = false;
        }
        field(26; "Employer Balance"; Decimal)
        {
            Editable = false;
        }
        field(27; "Employer Balance(LCY)"; Decimal)
        {
            Editable = false;
        }
        field(28; "Stop for Next Period"; Boolean)
        {
        }
        field(29; "Amtzd Loan Repay Amt"; Decimal)
        {

            trigger OnValidate()
            begin
                /*Employee.RESET;
                Employee.SETRANGE(Employee."Job No","No.");
                IF Employee.FINDFIRST THEN BEGIN
                  IF Employee."Currency Code" = '' THEN
                    "Amtzd Loan Repay Amt(LCY)" :="Amtzd Loan Repay Amt"
                  ELSE
                    "Amtzd Loan Repay Amt(LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(TODAY,Employee."Currency Code","Amtzd Loan Repay Amt",Employee."Currency Factor"));
                END;*/

            end;
        }
        field(30; "Amtzd Loan Repay Amt(LCY)"; Decimal)
        {
        }
        field(31; "Start Date"; Date)
        {
        }
        field(32; "End Date"; Date)
        {
        }
        field(33; "Loan Number"; Code[20])
        {
        }
        field(34; "Payroll Code"; Code[20])
        {
        }
        field(35; "No of Units"; Decimal)
        {
        }
        field(36; Suspended; Boolean)
        {
        }
        field(37; "Entry No"; Integer)
        {
        }
        field(38; "IsCoop/LnRep"; Boolean)
        {
        }
        field(39; Grants; Code[20])
        {
        }
        field(40; "Posting Group"; Code[20])
        {
        }
        field(41; "Original Amount"; Decimal)
        {
        }
        field(42; "Pension Formula"; Decimal)
        {

            trigger OnValidate()
            begin
                if PayrollEmployee.Get("No.") then
                    Amount := ("Pension Formula" / 100 * PayrollEmployee."Basic Pay");
                Modify;
            end;
        }
        field(43; "Not Prorate"; Boolean)
        {
        }
        field(44; "Contract Type"; Option)
        {
            CalcFormula = lookup("Payroll Employee_AU"."Contract Type" where("No." = field("No.")));
            Caption = 'Contract Status';
            FieldClass = FlowField;
            OptionCaption = 'Contract,Secondment,Casual,Temporary,Volunteer,Project Staff,Consultant-Contract,Consultant,Deployed,Board,Committee,Full Time';
            OptionMembers = Contract,Secondment,Casual,"Temporary",Volunteer,"Project Staff","Consultant-Contract",Consultant,Deployed,Board,Committee,"Full Time";
        }
    }

    keys
    {
        key(Key1; "No.", "Transaction Code", "Payroll Period", "Period Month", "Period Year")
        {
            Clustered = true;
        }
        key(Key2; "Transaction Code", "Payroll Period")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        PayrollCalender.Reset;
        PayrollCalender.SetRange(PayrollCalender.Closed, false);
        if PayrollCalender.FindFirst then begin
            "Period Month" := PayrollCalender."Period Month";
            "Period Year" := PayrollCalender."Period Year";
            "Payroll Period" := PayrollCalender."Date Opened";
        end;
    end;

    var
        Employee: Record "Payroll Employee_AU";
        CurrExchRate: Record "Currency Exchange Rate";
        PayrollCalender: Record "Payroll Calender_AU";
        PayrollTrans: Record "Payroll Transaction Code_AU";
        PayrollEmployee: Record "Payroll Employee_AU";
}

