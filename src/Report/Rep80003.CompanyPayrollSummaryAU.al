#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80003 "Company Payroll Summary_AU"
{
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Layouts/Company Payroll Summary_AU.rdlc';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("Payroll Calender_AU"; "Payroll Calender_AU")
        {

            column(CompanyInfo_Picture_Control1102756014; CompanyInfo.Picture)
            {
            }
            column(DetDate; DetDate)
            {
            }
            column(GPY; GPY)
            {
            }
            column(NETS; NETS)
            {
            }
            column(STAT; STAT)
            {
            }
            column(DED; DED)
            {
            }
            column(payTrans_1; PayTrans[1])
            {
            }
            column(payTrans_2; PayTrans[2])
            {
            }
            column(payTrans_3; PayTrans[3])
            {
            }
            column(payTrans_4; PayTrans[4])
            {
            }
            column(payTrans_5; PayTrans[5])
            {
            }
            column(payTrans_6; PayTrans[6])
            {
            }
            column(payTrans_7; PayTrans[7])
            {
            }
            column(payTrans_8; PayTrans[8])
            {
            }
            column(payTrans_9; PayTrans[9])
            {
            }
            column(payTrans_10; PayTrans[10])
            {
            }
            column(payTrans_11; PayTrans[11])
            {
            }
            column(payTrans_12; PayTrans[12])
            {
            }
            column(payTrans_13; PayTrans[13])
            {
            }
            column(payTrans_14; PayTrans[14])
            {
            }
            column(payTrans_15; PayTrans[15])
            {
            }
            column(payTrans_16; PayTrans[16])
            {
            }
            column(payTrans_17; PayTrans[17])
            {
            }
            column(payTrans_18; PayTrans[18])
            {
            }
            column(payTrans_19; PayTrans[19])
            {
            }
            column(payTrans_20; PayTrans[20])
            {
            }
            column(payTrans_21; PayTrans[21])
            {
            }
            column(payTrans_22; PayTrans[22])
            {
            }
            column(payTrans_23; PayTrans[23])
            {
            }
            column(payTrans_24; PayTrans[24])
            {
            }
            column(PayTransAmt_1; PayTransAmt[1])
            {
            }
            column(PayTransAmt_2; PayTransAmt[2])
            {
            }
            column(PayTransAmt_3; PayTransAmt[3])
            {
            }
            column(PayTransAmt_4; PayTransAmt[4])
            {
            }
            column(PayTransAmt_5; PayTransAmt[5])
            {
            }
            column(PayTransAmt_6; PayTransAmt[6])
            {
            }
            column(PayTransAmt_7; PayTransAmt[7])
            {
            }
            column(PayTransAmt_8; PayTransAmt[8])
            {
            }
            column(PayTransAmt_9; PayTransAmt[9])
            {
            }
            column(PayTransAmt_10; PayTransAmt[10])
            {
            }
            column(PayTransAmt_11; PayTransAmt[11])
            {
            }
            column(PayTransAmt_12; PayTransAmt[12])
            {
            }
            column(PayTransAmt_13; PayTransAmt[13])
            {
            }
            column(PayTransAmt_14; PayTransAmt[14])
            {
            }
            column(PayTransAmt_15; PayTransAmt[15])
            {
            }
            column(PayTransAmt_16; PayTransAmt[16])
            {
            }
            column(PayTransAmt_17; PayTransAmt[17])
            {
            }
            column(PayTransAmt_18; PayTransAmt[18])
            {
            }
            column(PayTransAmt_19; PayTransAmt[19])
            {
            }
            column(PayTransAmt_20; PayTransAmt[20])
            {
            }
            column(PayTransAmt_21; PayTransAmt[21])
            {
            }
            column(PayTransAmt_22; PayTransAmt[22])
            {
            }
            column(PayTransAmt_23; PayTransAmt[23])
            {
            }
            column(PayTransAmt_24; PayTransAmt[24])
            {
            }
            column(DedTrans_1; DedTrans[1])
            {
            }
            column(DedTrans_2; DedTrans[2])
            {
            }
            column(DedTrans_3; DedTrans[3])
            {
            }
            column(DedTrans_4; DedTrans[4])
            {
            }
            column(DedTrans_5; DedTrans[5])
            {
            }
            column(DedTrans_6; DedTrans[6])
            {
            }
            column(DedTrans_7; DedTrans[7])
            {
            }
            column(DedTrans_8; DedTrans[8])
            {
            }
            column(DedTrans_9; DedTrans[9])
            {
            }
            column(DedTrans_10; DedTrans[10])
            {
            }
            column(DedTrans_11; DedTrans[11])
            {
            }
            column(DedTrans_12; DedTrans[12])
            {
            }
            column(DedTrans_13; DedTrans[13])
            {
            }
            column(DedTrans_14; DedTrans[14])
            {
            }
            column(DedTrans_15; DedTrans[15])
            {
            }
            column(DedTrans_16; DedTrans[16])
            {
            }
            column(DedTrans_17; DedTrans[17])
            {
            }
            column(DedTrans_18; DedTrans[18])
            {
            }
            column(DedTrans_19; DedTrans[19])
            {
            }
            column(DedTrans_20; DedTrans[20])
            {
            }
            column(DedTrans_21; DedTrans[21])
            {
            }
            column(DedTrans_22; DedTrans[22])
            {
            }
            column(DedTrans_23; DedTrans[23])
            {
            }
            column(DedTrans_24; DedTrans[24])
            {
            }
            column(DedTrans_25; DedTrans[25])
            {
            }
            column(DedTrans_26; DedTrans[26])
            {
            }
            column(DedTrans_27; DedTrans[27])
            {
            }
            column(DedTrans_28; DedTrans[28])
            {
            }
            column(DedTrans_29; DedTrans[29])
            {
            }
            column(DedTrans_30; DedTrans[30])
            {
            }
            column(DedTrans_31; DedTrans[31])
            {
            }
            column(DedTrans_32; DedTrans[32])
            {
            }
            column(DedTrans_33; DedTrans[33])
            {
            }
            column(DedTrans_34; DedTrans[34])
            {
            }
            column(DedTrans_35; DedTrans[35])
            {
            }
            column(DedTrans_36; DedTrans[36])
            {
            }
            column(DedTrans_37; DedTrans[37])
            {
            }
            column(DedTrans_38; DedTrans[38])
            {
            }
            column(DedTrans_39; DedTrans[39])
            {
            }
            column(DedTrans_40; DedTrans[40])
            {
            }
            column(DedTrans_41; DedTrans[41])
            {
            }
            column(DedTrans_42; DedTrans[42])
            {
            }
            column(DedTrans_43; DedTrans[43])
            {
            }
            column(DedTrans_44; DedTrans[44])
            {
            }
            column(DedTrans_45; DedTrans[45])
            {
            }
            column(DedTrans_46; DedTrans[46])
            {
            }
            column(DedTrans_47; DedTrans[47])
            {
            }
            column(DedTrans_48; DedTrans[48])
            {
            }
            column(DedTrans_49; DedTrans[49])
            {
            }
            column(DedTrans_50; DedTrans[50])
            {
            }
            column(DedTrans_51; DedTrans[51])
            {
            }
            column(DedTrans_52; DedTrans[52])
            {
            }
            column(DedTrans_53; DedTrans[53])
            {
            }
            column(DedTrans_54; DedTrans[54])
            {
            }
            column(DedTrans_55; DedTrans[55])
            {
            }
            column(DedTrans_56; DedTrans[56])
            {
            }
            column(DedTrans_57; DedTrans[57])
            {
            }
            column(DedTrans_58; DedTrans[58])
            {
            }
            column(DedTrans_59; DedTrans[59])
            {
            }
            column(DedTrans_60; DedTrans[60])
            {
            }
            column(DedTrans_61; DedTrans[61])
            {
            }
            column(DedTrans_62; DedTrans[62])
            {
            }
            column(DedTrans_63; DedTrans[63])
            {
            }
            column(DedTrans_64; DedTrans[64])
            {
            }
            column(DedTrans_65; DedTrans[65])
            {
            }
            column(DedTrans_66; DedTrans[66])
            {
            }
            column(DedTrans_67; DedTrans[67])
            {
            }
            column(DedTrans_68; DedTrans[68])
            {
            }
            column(DedTrans_69; DedTrans[69])
            {
            }
            column(DedTrans_70; DedTrans[70])
            {
            }
            column(DedTransAmt_1; DedTransAmt[1])
            {
            }
            column(DedTransAmt_2; DedTransAmt[2])
            {
            }
            column(DedTransAmt_3; DedTransAmt[3])
            {
            }
            column(DedTransAmt_4; DedTransAmt[4])
            {
            }
            column(DedTransAmt_5; DedTransAmt[5])
            {
            }
            column(DedTransAmt_6; DedTransAmt[6])
            {
            }
            column(DedTransAmt_7; DedTransAmt[7])
            {
            }
            column(DedTransAmt_8; DedTransAmt[8])
            {
            }
            column(DedTransAmt_9; DedTransAmt[9])
            {
            }
            column(DedTransAmt_10; DedTransAmt[10])
            {
            }
            column(DedTransAmt_11; DedTransAmt[11])
            {
            }
            column(DedTransAmt_12; DedTransAmt[12])
            {
            }
            column(DedTransAmt_13; DedTransAmt[13])
            {
            }
            column(DedTransAmt_14; DedTransAmt[14])
            {
            }
            column(DedTransAmt_15; DedTransAmt[15])
            {
            }
            column(DedTransAmt_16; DedTransAmt[16])
            {
            }
            column(DedTransAmt_17; DedTransAmt[17])
            {
            }
            column(DedTransAmt_18; DedTransAmt[18])
            {
            }
            column(DedTransAmt_19; DedTransAmt[19])
            {
            }
            column(DedTransAmt_20; DedTransAmt[20])
            {
            }
            column(DedTransAmt_21; DedTransAmt[21])
            {
            }
            column(DedTransAmt_22; DedTransAmt[22])
            {
            }
            column(DedTransAmt_23; DedTransAmt[23])
            {
            }
            column(DedTransAmt_24; DedTransAmt[24])
            {
            }
            column(DedTransAmt_25; DedTransAmt[25])
            {
            }
            column(DedTransAmt_26; DedTransAmt[26])
            {
            }
            column(DedTransAmt_27; DedTransAmt[27])
            {
            }
            column(DedTransAmt_28; DedTransAmt[28])
            {
            }
            column(DedTransAmt_29; DedTransAmt[29])
            {
            }
            column(DedTransAmt_30; DedTransAmt[30])
            {
            }
            column(DedTransAmt_31; DedTransAmt[31])
            {
            }
            column(DedTransAmt_32; DedTransAmt[32])
            {
            }
            column(DedTransAmt_33; DedTransAmt[33])
            {
            }
            column(DedTransAmt_34; DedTransAmt[34])
            {
            }
            column(DedTransAmt_35; DedTransAmt[35])
            {
            }
            column(DedTransAmt_36; DedTransAmt[36])
            {
            }
            column(DedTransAmt_37; DedTransAmt[37])
            {
            }
            column(DedTransAmt_38; DedTransAmt[38])
            {
            }
            column(DedTransAmt_39; DedTransAmt[39])
            {
            }
            column(DedTransAmt_40; DedTransAmt[40])
            {
            }
            column(DedTransAmt_41; DedTransAmt[41])
            {
            }
            column(DedTransAmt_42; DedTransAmt[42])
            {
            }
            column(DedTransAmt_43; DedTransAmt[43])
            {
            }
            column(DedTransAmt_44; DedTransAmt[44])
            {
            }
            column(DedTransAmt_45; DedTransAmt[45])
            {
            }
            column(DedTransAmt_46; DedTransAmt[46])
            {
            }
            column(DedTransAmt_47; DedTransAmt[47])
            {
            }
            column(DedTransAmt_48; DedTransAmt[48])
            {
            }
            column(DedTransAmt_49; DedTransAmt[49])
            {
            }
            column(DedTransAmt_50; DedTransAmt[50])
            {
            }
            column(DedTransAmt_51; DedTransAmt[51])
            {
            }
            column(DedTransAmt_52; DedTransAmt[52])
            {
            }
            column(DedTransAmt_53; DedTransAmt[53])
            {
            }
            column(DedTransAmt_54; DedTransAmt[54])
            {
            }
            column(DedTransAmt_55; DedTransAmt[55])
            {
            }
            column(DedTransAmt_56; DedTransAmt[56])
            {
            }
            column(DedTransAmt_57; DedTransAmt[57])
            {
            }
            column(DedTransAmt_58; DedTransAmt[58])
            {
            }
            column(DedTransAmt_59; DedTransAmt[59])
            {
            }
            column(DedTransAmt_60; DedTransAmt[60])
            {
            }
            column(DedTransAmt_61; DedTransAmt[61])
            {
            }
            column(DedTransAmt_62; DedTransAmt[62])
            {
            }
            column(DedTransAmt_63; DedTransAmt[63])
            {
            }
            column(DedTransAmt_64; DedTransAmt[64])
            {
            }
            column(DedTransAmt_65; DedTransAmt[65])
            {
            }
            column(DedTransAmt_66; DedTransAmt[66])
            {
            }
            column(DedTransAmt_67; DedTransAmt[67])
            {
            }
            column(DedTransAmt_68; DedTransAmt[68])
            {
            }
            column(DedTransAmt_69; DedTransAmt[69])
            {
            }
            column(DedTransAmt_70; DedTransAmt[70])
            {
            }
            trigger OnPreDataItem();
            begin
                //LastFieldNo := FIELDNO("Period Year");
                "Payroll Calender_AU".SetFilter("Payroll Calender_AU"."Date Opened", '=%1', SelectedPeriod);
                UserSetup.Get(UserId);
                if UserSetup."View Payroll" = false then
                    Error('You do not have permissions to view the report');

            end;

            trigger OnAfterGetRecord();
            begin
                Clear(rows);
                Clear(rows2);
                prPeriod_Transactions.Reset;
                prPeriod_Transactions.SetRange("Payroll Period", SelectedPeriod);
                prPeriod_Transactions.SetFilter(Grouping, '=1|3|4|7|8|9|11');
                prPeriod_Transactions.CalcFields(prPeriod_Transactions."Contract Type");
                //prPeriod_Transactions.SETRANGE(prPeriod_Transactions."Contract Type",prPeriod_Transactions."Contract Type"::"Full Time");
                //"prPeriod Transactions".SETFILTER("prPeriod Transactions"."SubGrouping",'=2');
                prPeriod_Transactions.SetCurrentkey("Payroll Period", Grouping, SubGrouping);
                if prPeriod_Transactions.Find('-') then begin
                    Clear(DetDate);
                    DetDate := Format("Payroll Calender_AU"."Period Name");
                    repeat
                    begin
                        if prPeriod_Transactions.Amount > 0 then begin
                            if ((prPeriod_Transactions.Grouping = 4) and (prPeriod_Transactions.SubGrouping = 0)) then
                                GPY := GPY + prPeriod_Transactions.Amount;
                            if ((prPeriod_Transactions.Grouping = 7) and
                            ((prPeriod_Transactions.SubGrouping = 3) or (prPeriod_Transactions.SubGrouping = 1) or
                             (prPeriod_Transactions.SubGrouping = 2))) then
                                STAT := STAT + prPeriod_Transactions.Amount;
                            if ((prPeriod_Transactions.Grouping = 8) and
                            ((prPeriod_Transactions.SubGrouping = 1) or (prPeriod_Transactions.SubGrouping = 0))) then
                                DED := DED + prPeriod_Transactions.Amount;
                            if ((prPeriod_Transactions.Grouping = 9) and (prPeriod_Transactions.SubGrouping = 0)) then
                                NETS := NETS + prPeriod_Transactions.Amount;
                            //TotalsAllowances:=TotalsAllowances+"prPeriod Transactions".Amount;
                            if ((prPeriod_Transactions.Grouping = 1) or
                            (prPeriod_Transactions.Grouping = 3) or
                             ((prPeriod_Transactions.Grouping = 4) and (prPeriod_Transactions.SubGrouping <> 0))) then begin // A Payment
                                Clear(countz);
                                // countz:=1;
                                Clear(found);
                                repeat
                                begin
                                    countz := countz + 1;
                                    if (PayTrans[countz]) = prPeriod_Transactions."Transaction Name" then found := true;
                                end;
                                until ((countz = (ArrayLen(PayTransAmt))) or ((PayTrans[countz]) = prPeriod_Transactions."Transaction Name")
                                or ((PayTrans[countz]) = ''));
                                rows := countz;
                                PayTrans[rows] := prPeriod_Transactions."Transaction Name";
                                PayTransAmt[rows] := PayTransAmt[rows] + prPeriod_Transactions.Amount;
                            end else if (((prPeriod_Transactions.Grouping = 7) and ((prPeriod_Transactions.SubGrouping <> 6)
                            and (prPeriod_Transactions.SubGrouping <> 5))) or
                            ((prPeriod_Transactions.Grouping = 8) and (prPeriod_Transactions.SubGrouping <> 9))) then begin
                                Clear(countz);
                                // countz:=1;
                                Clear(found);
                                // prPeriod_Transactions.setcurrentkey("Transaction Name");
                                repeat
                                begin
                                    countz := countz + 1;
                                    if (DedTrans[countz]) = prPeriod_Transactions."Transaction Name" then found := true;
                                end;
                                until ((countz = (ArrayLen(DedTransAmt))) or ((DedTrans[countz]) = prPeriod_Transactions."Transaction Name")
                                or ((DedTrans[countz]) = ''));
                                rows := countz;
                                DedTrans[rows] := prPeriod_Transactions."Transaction Name";
                                DedTransAmt[rows] := DedTransAmt[rows] + prPeriod_Transactions.Amount;
                            end;
                        end; // If Amount >0;
                    end;
                    until prPeriod_Transactions.Next = 0;
                end;// End prPeriod_Transactions Repeat
                    // MESSAGE('Heh'+FORMAT(rows)+', '+FORMAT(rows2));
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
        prPeriod_Transactions: Record "Payroll Monthly Trans_AU";

}