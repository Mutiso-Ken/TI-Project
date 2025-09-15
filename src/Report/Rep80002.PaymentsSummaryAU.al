#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80002 "Payments Summary_AU"
{
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Layouts/Payments Summary_AU.rdlc';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("Payroll Monthly Trans_AU"; "Payroll Monthly Trans_AU")
        {

            column(CompanyInfo_Picture_Control1102756014; CompanyInfo.Picture)
            {
            }
            column(CompName; CompName)
            {
            }
            column(Addr1; Addr1)
            {
            }
            column(Addr2; Addr2)
            {
            }
            column(Email; Email)
            {
            }
            column(DetDate; DetDate)
            {
            }
            column(EmpNo; "Payroll Monthly Trans_AU"."No.")
            {
            }
            column(empName; empName)
            {
            }
            column(EmpAmount; "Payroll Monthly Trans_AU".Amount)
            {
            }
            column(Transaction; "Payroll Monthly Trans_AU"."Transaction Code" + ': ' + "Payroll Monthly Trans_AU"."Transaction Name")
            {
            }
            column(TotLabel; "Payroll Monthly Trans_AU"."Transaction Code" + ': ' + "Payroll Monthly Trans_AU"."Transaction Name")
            {
            }
            trigger OnPreDataItem();
            begin
                if CompanyInfo.Get() then
                    CompanyInfo.CalcFields(CompanyInfo.Picture);
                CompName := CompanyInfo.Name;
                Addr1 := CompanyInfo.Address;
                Addr2 := CompanyInfo.City;
                Email := CompanyInfo."E-Mail";
                //LastFieldNo := FIELDNO("Period Year");
                "Payroll Monthly Trans_AU".SetFilter("Payroll Monthly Trans_AU"."Payroll Period", '=%1', SelectedPeriod);

            end;

            trigger OnAfterGetRecord();
            begin
                Clear(empName);
                if emps.Get("Payroll Monthly Trans_AU"."No.") then
                    empName := emps.Firstname + ' ' + emps.Lastname + ' ' + emps.Surname;
                if not (((("Payroll Monthly Trans_AU".Grouping = 1) and
                ("Payroll Monthly Trans_AU".SubGrouping <> 1)) or
               ("Payroll Monthly Trans_AU".Grouping = 3) or
                (("Payroll Monthly Trans_AU".Grouping = 4) and
                 ("Payroll Monthly Trans_AU".SubGrouping <> 0)))) then begin
                    CurrReport.Skip;
                end;
                "prPayroll Periods".Reset;
                "prPayroll Periods".SetRange("prPayroll Periods"."Date Opened", SelectedPeriod);
                if "prPayroll Periods".Find('-') then begin
                    Clear(DetDate);
                    DetDate := Format("prPayroll Periods"."Period Name");
                end;
                /*IF NOT ( ((("Payroll Monthly Transactions"."Grouping"=7) AND
					 (("Payroll Monthly Transactions"."SubGrouping"<>6)
					AND ("Payroll Monthly Transactions"."SubGrouping"<>5))) OR
					(("Payroll Monthly Transactions"."Grouping"=8) AND
					 ("Payroll Monthly Transactions"."SubGrouping"<>9)))) THEN BEGIN
					  CurrReport.SKIP;
					  END; */
                /*
              CLEAR(rows);
              CLEAR(rows2);
              "Payroll Monthly Transactions".RESET;
              "Payroll Monthly Transactions".SETRANGE("Payroll Period",SelectedPeriod);
              "Payroll Monthly Transactions".SETFILTER("Group Order",'=1|3|4|7|8|9');
              //"Payroll Monthly Transactions".SETFILTER("Payroll Monthly Transactions"."SubGrouping",'=2');
              "Payroll Monthly Transactions".SETCURRENTKEY("Payroll Period","Group Order","Sub Group Order");
              IF "Payroll Monthly Transactions".FIND('-') THEN BEGIN
              CLEAR(DetDate);
              DetDate:=FORMAT("prPayroll Periods"."Period Name");
              REPEAT
              BEGIN
              IF "Payroll Monthly Transactions".Amount>0 THEN BEGIN
              IF (("Payroll Monthly Transactions"."Grouping"=4) AND ("Payroll Monthly Transactions"."SubGrouping"=0)) THEN
                GPY:=GPY+"Payroll Monthly Transactions".Amount;
              IF (("Payroll Monthly Transactions"."Grouping"=7) AND
              (("Payroll Monthly Transactions"."SubGrouping"=3) OR ("Payroll Monthly Transactions"."SubGrouping"=1) OR
               ("Payroll Monthly Transactions"."SubGrouping"=2)))  THEN
                STAT:=STAT+"Payroll Monthly Transactions".Amount;
              IF (("Payroll Monthly Transactions"."Grouping"=8) AND
              (("Payroll Monthly Transactions"."SubGrouping"=1) OR ("Payroll Monthly Transactions"."SubGrouping"=0))) THEN
                 DED:=DED+"Payroll Monthly Transactions".Amount;
              IF (("Payroll Monthly Transactions"."Grouping"=9) AND ("Payroll Monthly Transactions"."SubGrouping"=0)) THEN
                NETS:=NETS+"Payroll Monthly Transactions".Amount;
              //TotalsAllowances:=TotalsAllowances+"Payroll Monthly Transactions".Amount;
                  IF ((("Payroll Monthly Transactions"."Grouping"=1) AND
                   ("Payroll Monthly Transactions"."SubGrouping"<>1)) OR
                  ("Payroll Monthly Transactions"."Grouping"=3) OR
                   (("Payroll Monthly Transactions"."Grouping"=4) AND
                    ("Payroll Monthly Transactions"."SubGrouping"<>0))) THEN BEGIN // A Payment
                    CLEAR(countz);
                   // countz:=1;
                    CLEAR(found);
                    REPEAT
                   BEGIN
                     countz:=countz+1;
                     IF (PayTrans[countz])="Payroll Monthly Transactions"."Transaction Name" THEN found:=TRUE;
                     END;
                    UNTIL ((countz=(ARRAYLEN(PayTransAmt))) OR ((PayTrans[countz])="Payroll Monthly Transactions"."Transaction Name")
                    OR ((PayTrans[countz])=''));
                   rows:= countz;
                  PayTrans[rows]:="Payroll Monthly Transactions"."Transaction Name";
                  PayTransAmt[rows]:=PayTransAmt[rows]+"Payroll Monthly Transactions".Amount;
                  END ELSE IF ((("Payroll Monthly Transactions"."Grouping"=7) AND
                   (("Payroll Monthly Transactions"."SubGrouping"<>6)
                  AND ("Payroll Monthly Transactions"."SubGrouping"<>5))) OR
                  (("Payroll Monthly Transactions"."Grouping"=8) AND
                   ("Payroll Monthly Transactions"."SubGrouping"<>9))) THEN BEGIN
                    CLEAR(countz);
                   // countz:=1;
                    CLEAR(found);
                    REPEAT
                   BEGIN
                     countz:=countz+1;
                     IF (DedTrans[countz])="Payroll Monthly Transactions"."Transaction Name" THEN found:=TRUE;
                     END;
                    UNTIL ((countz=(ARRAYLEN(DedTransAmt))) OR ((DedTrans[countz])="Payroll Monthly Transactions"."Transaction Name")
                    OR ((DedTrans[countz])=''));
                   rows:= countz;
                  DedTrans[rows]:="Payroll Monthly Transactions"."Transaction Name";
                  DedTransAmt[rows]:=DedTransAmt[rows]+"Payroll Monthly Transactions".Amount;
                  END;
                  END; // If Amount >0;
              END;
              UNTIL "Payroll Monthly Transactions".NEXT=0;
              END;// End prPeriod Transactions Repeat
              // MESSAGE('Heh'+FORMAT(rows)+', '+FORMAT(rows2));
                                    */

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
        SelectedPeriod := PeriodFilter;
        objPeriod.Reset;
        objPeriod.SetRange(objPeriod."Date Opened", SelectedPeriod);
        if objPeriod.Find('-') then begin
            PeriodName := objPeriod."Period Name";
        end;
        if CompanyInfo.Get() then
            CompanyInfo.CalcFields(CompanyInfo.Picture);
        Clear(rows);
        Clear(GPY);
        Clear(STAT);
        Clear(DED);
        Clear(NETS);


    end;

    var
        UserSetup: Record "User Setup";
        empName: Text[250];
        DetDate: Text[100];
        found: Boolean;
        countz: Integer;
        PeriodFilter: Date;
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        PeriodTrans: Record "Payroll Monthly Trans_AU";
        objPeriod: Record "Payroll Calender_AU";
        SelectedPeriod: Date;
        PeriodName: Text[30];
        CompanyInfo: Record "Company Information";
        TotalsAllowances: Decimal;
        Dept: Boolean;
        PaymentDesc: Text[200];
        DeductionDesc: Text[200];
        GroupText1: Text[200];
        GroupText2: Text[200];
        PaymentAmount: Decimal;
        DeductAmount: Decimal;
        PayTrans: array[70] of Text[250];
        CompName: Text[50];
        Addr1: Text[50];
        Addr2: Text[50];
        Email: Text[50];
        PayTransAmt: array[70] of Decimal;
        DedTrans: array[70] of Text[250];
        DedTransAmt: array[70] of Decimal;
        rows: Integer;
        rows2: Integer;
        GPY: Decimal;
        NETS: Decimal;
        STAT: Decimal;
        DED: Decimal;
        TotalFor: label 'Total for ';
        GroupOrder: label '3';
        TransBal: array[2, 60] of Text[250];
        Addr: array[2, 10] of Text[250];
        RecordNo: Integer;
        NoOfColumns: Integer;
        ColumnNo: Integer;
        emps: Record "Payroll Employee_AU";
        "prPayroll Periods": Record "Payroll Calender_AU";

}