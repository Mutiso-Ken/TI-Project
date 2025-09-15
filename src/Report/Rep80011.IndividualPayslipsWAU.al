#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80011 "Individual Payslips W_AU"
{
    RDLCLayout = 'Layouts/Individual Payslips W_AU.rdlc';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("Payroll Employee_AU"; "Payroll Employee_AU")
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = false;
            RequestFilterFields = "No.", "Period Filter";

            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(Title; JObtitle)
            {
            }
            column(TransAmt_1__1_; TransAmt[1] [1])
            {
            }
            column(TransAmt_1__2_; TransAmt[1] [2])
            {
            }
            column(Trans_1__2_; Trans[1] [2])
            {
            }
            column(TransAmt_1__3_; TransAmt[1] [3])
            {
            }
            column(TransAmt_1__4_; TransAmt[1] [4])
            {
            }
            column(TransAmt_1__5_; TransAmt[1] [5])
            {
            }
            column(TransAmt_1__6_; TransAmt[1] [6])
            {
            }
            column(Trans_1__4_; Trans[1] [4])
            {
            }
            column(Trans_1__5_; Trans[1] [5])
            {
            }
            column(Trans_1__6_; Trans[1] [6])
            {
            }
            column(TransAmt_1__7_; TransAmt[1] [7])
            {
            }
            column(TransAmt_1__8_; TransAmt[1] [8])
            {
            }
            column(TransAmt_1__9_; TransAmt[1] [9])
            {
            }
            column(Trans_1__7_; Trans[1] [7])
            {
            }
            column(Trans_1__8_; Trans[1] [8])
            {
            }
            column(Trans_1__9_; Trans[1] [9])
            {
            }
            column(TransAmt_1__10_; TransAmt[1] [10])
            {
            }
            column(TransAmt_1__12_; TransAmt[1] [12])
            {
            }
            column(TransAmt_1__13_; TransAmt[1] [13])
            {
            }
            column(Trans_1__10_; Trans[1] [10])
            {
            }
            column(Trans_1__12_; Trans[1] [12])
            {
            }
            column(Trans_1__13_; Trans[1] [13])
            {
            }
            column(TransAmt_1__14_; TransAmt[1] [14])
            {
            }
            column(TransAmt_1__15_; TransAmt[1] [15])
            {
            }
            column(TransAmt_1__16_; TransAmt[1] [16])
            {
            }
            column(TransAmt_1__17_; TransAmt[1] [17])
            {
            }
            column(TransAmt_1__18_; TransAmt[1] [18])
            {
            }
            column(TransAmt_1__19_; TransAmt[1] [19])
            {
            }
            column(TransAmt_1__11_; TransAmt[1] [11])
            {
            }
            column(TransAmt_1__20_; TransAmt[1] [20])
            {
            }
            column(Trans_1__14_; Trans[1] [14])
            {
            }
            column(Trans_1__15_; Trans[1] [15])
            {
            }
            column(Trans_1__16_; Trans[1] [16])
            {
            }
            column(Trans_1__17_; Trans[1] [17])
            {
            }
            column(Trans_1__18_; Trans[1] [18])
            {
            }
            column(Trans_1__19_; Trans[1] [19])
            {
            }
            column(Trans_1__11_; Trans[1] [11])
            {
            }
            column(Trans_1__20_; Trans[1] [20])
            {
            }
            column(Addr_1__1_; 'PF NO.:	   ' + Format(Addr[1] [1]))
            {
            }
            column(Addr_1__3_; 'PERIOD:  ' + Addr[1] [3])
            {
            }
            column(TransAmt_1__21_; TransAmt[1] [21])
            {
            }
            column(TransAmt_1__22_; TransAmt[1] [22])
            {
            }
            column(TransAmt_1__23_; TransAmt[1] [23])
            {
            }
            column(TransAmt_1__24_; TransAmt[1] [24])
            {
            }
            column(Trans_1__21_; Trans[1] [21])
            {
            }
            column(Trans_1__23_; Trans[1] [23])
            {
            }
            column(Trans_1__24_; Trans[1] [24])
            {
            }
            column(Trans_1__22_; Trans[1] [22])
            {
            }
            column(TransAmt_1__25_; TransAmt[1] [25])
            {
            }
            column(Trans_1__25_; Trans[1] [25])
            {
            }
            column(TransAmt_1__26_; TransAmt[1] [26])
            {
            }
            column(Trans_1__26_; Trans[1] [26])
            {
            }
            column(TransAmt_1__27_; TransAmt[1] [27])
            {
            }
            column(Trans_1__27_; Trans[1] [27])
            {
            }
            column(TransAmt_1__28_; TransAmt[1] [28])
            {
            }
            column(Trans_1__28_; Trans[1] [28])
            {
            }
            column(TransAmt_1__29_; TransAmt[1] [29])
            {
            }
            column(Trans_1__29_; Trans[1] [29])
            {
            }
            column(TransAmt_1__30_; TransAmt[1] [30])
            {
            }
            column(Trans_1__30_; Trans[1] [30])
            {
            }
            column(TransAmt_1__31_; TransAmt[1] [31])
            {
            }
            column(Trans_1__31_; Trans[1] [31])
            {
            }
            column(TransAmt_1__32_; TransAmt[1] [32])
            {
            }
            column(TransAmt_1__33_; TransAmt[1] [33])
            {
            }
            column(TransAmt_1__34_; TransAmt[1] [34])
            {
            }
            column(TransAmt_1__35_; TransAmt[1] [35])
            {
            }
            column(TransAmt_1__36_; TransAmt[1] [36])
            {
            }
            column(TransAmt_1__37_; TransAmt[1] [37])
            {
            }
            column(TransAmt_1__38_; TransAmt[1] [38])
            {
            }
            column(TransAmt_1__39_; TransAmt[1] [39])
            {
            }
            column(TransAmt_1__40_; TransAmt[1] [40])
            {
            }
            column(Trans_1__32_; Trans[1] [32])
            {
            }
            column(Trans_1__34_; Trans[1] [34])
            {
            }
            column(Trans_1__35_; Trans[1] [35])
            {
            }
            column(Trans_1__33_; Trans[1] [33])
            {
            }
            column(Trans_1__36_; Trans[1] [36])
            {
            }
            column(Trans_1__37_; Trans[1] [37])
            {
            }
            column(Trans_1__38_; Trans[1] [38])
            {
            }
            column(Trans_1__39_; Trans[1] [39])
            {
            }
            column(Trans_1__40_; Trans[1] [40])
            {
            }
            column(TransAmt_1__42_; TransAmt[1] [42])
            {
            }
            column(Trans_1__42_; Trans[1] [42])
            {
            }
            column(TransAmt_1__43_; TransAmt[1] [43])
            {
            }
            column(Trans_1__43_; Trans[1] [43])
            {
            }
            column(TransAmt_1__44_; TransAmt[1] [44])
            {
            }
            column(Trans_1__44_; Trans[1] [44])
            {
            }
            column(Trans_1__41_; Trans[1] [41])
            {
            }
            column(TransAmt_1__41_; TransAmt[1] [41])
            {
            }
            column(EmptyStringCaption; EmptyStringCaptionLbl)
            {
            }
            column(AMOUNTCaption; AMOUNTCaptionLbl)
            {
            }
            trigger OnPreDataItem();
            begin
                /*
				PeriodFilter:="prSalary Card"."Period Filter";
				//IF PeriodFilter=0D THEN ERROR('You must specify the period filter');
				SelectedPeriod:="prSalary Card".GETRANGEMIN("Period Filter");
				//SelectedPeriod:=PeriodFilter;
				objPeriod.RESET;
				IF objPeriod.GET(SelectedPeriod) THEN PeriodName:=objPeriod."Period Name"+'-'+FORMAT(objPeriod."Period Year");
				*/
                //IF PeriodFilter=0D THEN ERROR('You must specify the period filter');
                SelectedPeriod := "Payroll Employee_AU".GetRangeMin("Period Filter");
                //"prSalary Card".GETRANGEMIN("Period Filter");
                objPeriod.Reset;
                if objPeriod.Get(SelectedPeriod) then PeriodName := objPeriod."Period Name";
                NoOfRecords := Count;
                NoOfColumns := 2;
                strNssfNo := '.';
                strNhifNo := '.';
                strBank := '.';
                strBranch := '.';
                strAccountNo := '.';
                Bankno := '';
                Branchno := '';
                strPin := '';
                dept := '';

            end;

            trigger OnAfterGetRecord();
            begin
                // xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
                //xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
                strNssfNo := '.';
                strNhifNo := '.';
                strBank := '.';
                strBranch := '.';
                strAccountNo := '.';
                Bankno := '';
                Branchno := '';
                strPin := '';
                dept := '';
                JObtitle := '';
                strEmpName := '';
                strPin := "Payroll Employee_AU"."PIN No";
                strNssfNo := "Payroll Employee_AU"."NSSF No";
                strNhifNo := "Payroll Employee_AU"."NHIF No";
                Bankno := "Payroll Employee_AU"."Bank Code";
                strBranch := "Payroll Employee_AU"."Branch Name";
                strAccountNo := "Payroll Employee_AU"."Bank Account No";
                strBank := "Payroll Employee_AU"."Bank Name";
                //dept:=objEmp."Cost Center Name";
                strEmpName := "Payroll Employee_AU".Firstname + ' ' + "Payroll Employee_AU".Lastname + ' ' + "Payroll Employee_AU".Surname;
                if HREmployees6.Get("Payroll Employee_AU"."No.") then JObtitle := HREmployees6."Job Title" else JObtitle := '';
                if ((ColumnNo = 1) or (ColumnNo = 0)) then begin
                    ColumnNo := ColumnNo + 1;
                end else if ColumnNo = 2 then begin ColumnNo := 1; end;
                RecordNo := RecordNo + 1;
                /*If the Employee's Pay is suspended, OR  the guy is active DO NOT execute the following code
				*****************************************************************************************************/
                //IF ("Suspend Pay"=FALSE) THEN
                //BEGIN
                //CLEAR(objOcx);
                strEmpCode := "Payroll Employee_AU"."No.";
                //objOcx.fnProcesspayroll(strEmpCode,dtDOE,"Basic Pay","Pays PAYE","Pays NSSF","Pays NHIF",SelectedPeriod,STATUS,
                //dtOfLeaving,"Served Notice Period", dept);
                //END;
                /******************************************************************************************************/
                //Clear headers
                Addr[ColumnNo] [1] := '';
                Addr[ColumnNo] [2] := '';
                Addr[ColumnNo] [3] := '';
                Addr[ColumnNo] [4] := '';
                Addr[ColumnNo] [5] := '';
                Addr[ColumnNo] [6] := '';
                Addr[ColumnNo] [7] := '';
                Addr[ColumnNo] [8] := '';
                Addr[ColumnNo] [9] := '';
                Addr[ColumnNo] [10] := '';
                //Clear previous Transaction entries 53
                for intRow := 1 to 53 do begin
                    Trans[ColumnNo, intRow] := '';
                    TransAmt[ColumnNo, intRow] := '';
                    TransBal[ColumnNo, intRow] := '';
                end;
                //Loop through the transactions
                PeriodTrans.Reset;
                PeriodTrans.SetRange(PeriodTrans."No.", "Payroll Employee_AU"."No.");
                PeriodTrans.SetRange(PeriodTrans."Payroll Period", SelectedPeriod);
                PeriodTrans.SetRange(PeriodTrans."Company Deduction", false);
                //dennis to filter our company deductions
                PeriodTrans.SetCurrentkey(PeriodTrans."No.", PeriodTrans."Period Month", PeriodTrans."Period Year",
                PeriodTrans.Grouping, PeriodTrans.SubGrouping);
                Addr[ColumnNo] [1] := '[' + "Payroll Employee_AU"."No." + ']' + '  ' + Format(strEmpName);
                Addr[ColumnNo] [2] := dept;
                Addr[ColumnNo] [3] := PeriodName;
                Addr[ColumnNo] [10] := strPin;
                /*Fill-in the other staff information
				*******************************************************************************/
                Index := 1;
                strGrpText := '';
                if PeriodTrans.Find('-') then
                    repeat
                        //Check if the group has changed
                        if strGrpText <> PeriodTrans."Group Text" then begin
                            if PeriodTrans.Grouping <> 1 then begin
                                Index := Index + 1;
                                Trans[ColumnNo, Index] := '..................................................................';
                                TransAmt[ColumnNo, Index] := '....................................................................';
                                //  TransBal[ColumnNo,Index]:='......................................';
                            end;
                            if (PeriodTrans."Group Text" <> 'BASIC SALARY') and (PeriodTrans."Group Text" <> 'GROSS PAY') and
                            (PeriodTrans."Group Text" <> 'NET PAY') then begin
                                Index := Index + 1;
                                strGrpText := PeriodTrans."Group Text";
                                Trans[ColumnNo, Index] := strGrpText;
                                TransAmt[ColumnNo, Index] := '.';
                                //  TransBal[ColumnNo,Index]:='.';
                            end;
                            // IF )>0 THEN
                            // BEGIN
                            Index := Index + 1;
                            Trans[ColumnNo, Index] := PeriodTrans."Transaction Name";
                            Evaluate(TransAmt[ColumnNo, Index], Format(ROUND(PeriodTrans.Amount, 1, '=')));
                            if PeriodTrans.Balance = 0 then
                                Evaluate(TransBal[ColumnNo, Index], Format('									   '))
                            else
                                Evaluate(TransBal[ColumnNo, Index], Format(PeriodTrans.Balance))
                        end else begin
                            //IF PeriodTrans.Amount>0 THEN
                            //BEGIN
                            if (PeriodTrans."Group Text" <> 'BASIC SALARY') and (PeriodTrans."Group Text" <> 'GROSS PAY')
                                        and (PeriodTrans."Group Text" <> 'NET PAY') then begin
                                Index := Index + 1;
                                strGrpText := PeriodTrans."Group Text";
                                Trans[ColumnNo, Index] := PeriodTrans."Transaction Name";
                                Evaluate(TransAmt[ColumnNo, Index], Format(ROUND(PeriodTrans.Amount, 1, '=')));
                                if PeriodTrans.Balance = 0 then
                                    Evaluate(TransBal[ColumnNo, Index], Format('									   '))
                                else
                                    Evaluate(TransBal[ColumnNo, Index], Format(PeriodTrans.Balance))
                            end;
                            if PeriodTrans.Balance > 0 then begin
                                Index := Index + 1;
                                Trans[ColumnNo, Index] := PeriodTrans."Transaction Name" + '{Balance}';
                                Evaluate(TransAmt[ColumnNo, Index], Format(PeriodTrans.Balance));
                            end;
                        end;
                        PeriodTrans.CalcFields(PeriodTrans."Total Statutories");
                        if PeriodTrans."Transaction Code" = 'TOTAL-DED' then
                            Evaluate(TransAmt[ColumnNo, Index], Format((ROUND(PeriodTrans.Amount + PeriodTrans."Total Statutories", 1, '='))));
                    until PeriodTrans.Next = 0;
                Index += 1;
                Trans[ColumnNo, Index] := '......................................';
                Evaluate(TransAmt[ColumnNo, Index], '......................................');
                //other staff information not needed Logistics
                Index += 1;
                Trans[ColumnNo, Index] := 'Staff Information:';
                Evaluate(TransAmt[ColumnNo, Index], '.');
                //N.S.S.F No:
                Index += 1;
                Trans[ColumnNo, Index] := 'N.S.S.F No:';
                Evaluate(TransAmt[ColumnNo, Index], Format(strNssfNo));
                //N.H.I.F No:
                Index += 1;
                Trans[ColumnNo, Index] := 'N.H.I.F No:';
                Evaluate(TransAmt[ColumnNo, Index], Format(strNhifNo));
                //Bank:
                Index += 1;
                Trans[ColumnNo, Index] := 'Bank:';
                Evaluate(TransAmt[ColumnNo, Index], Format(strBank));
                //Branch:
                Index += 1;
                Trans[ColumnNo, Index] := 'Branch:';
                Evaluate(TransAmt[ColumnNo, Index], Format(strBranch));
                //Account No:
                Index += 1;
                Trans[ColumnNo, Index] := 'Account No:';
                Evaluate(TransAmt[ColumnNo, Index], Format(strAccountNo));
                //Account No:
                Index += 1;
                Trans[ColumnNo, Index] := 'PIN No:';
                Evaluate(TransAmt[ColumnNo, Index], Format(strPin));
                //Payslip message
                Index += 1;

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
                    Visible = false;
                }

            }
        }

    }

    trigger OnPreReport()
    begin
        if UserSetup.Get(UserId) then begin
            if UserSetup."View Payroll" = false then Error('You dont have permissions for payroll, Contact your system administrator! ')
        end;
        if CompanyInfo.Get() then
            CompanyInfo.CalcFields(CompanyInfo.Picture);


    end;

    var
        UserSetup: Record "User Setup";
        Deptcode: Code[20];
        emp1: Record "HR Employees";
        Addr: array[2, 10] of Text[250];
        NoOfRecords: Integer;
        RecordNo: Integer;
        NoOfColumns: Integer;
        ColumnNo: Integer;
        intInfo: Integer;
        i: Integer;
        PeriodTrans: Record "Payroll Monthly Trans_AU";
        intRow: Integer;
        Index: Integer;
        objEmp: Record "HR Employees";
        strEmpName: Text[250];
        strPin: Text[30];
        Trans: array[2, 60] of Text[250];
        TransAmt: array[2, 60] of Text[250];
        TransBal: array[2, 60] of Text[250];
        strGrpText: Text[100];
        strNssfNo: Text[30];
        strNhifNo: Text[30];
        strBank: Text[100];
        strBranch: Text[100];
        strAccountNo: Text[100];
        strMessage: Text[100];
        PeriodName: Text[30];
        PeriodFilter: Date;
        SelectedPeriod: Date;
        objPeriod: Record "Payroll Calender_AU";
        dtDOE: Date;
        strEmpCode: Text[30];
        STATUS: Text[30];
        dtOfLeaving: Date;
        "Served Notice Period": Boolean;
        dept: Text[100];
        bankStruct: Record "Payroll Bank Codes_AU";
        emploadva: Record "Payroll Monthly Trans_AU";
        Bankno: Code[50];
        Branchno: Code[50];
        CompanyInfo: Record "Company Information";
        objOcx: Codeunit "Payroll Management_AU";
        Dimm: Record "Dimension Value";
        Employee_CaptionLbl: label 'Employee:';
        EmptyStringCaptionLbl: label '............................................................................................................';
        Department_CaptionLbl: label 'Department:';
        Period_CaptionLbl: label 'Period:';
        P_I_N_No_CaptionLbl: label '..................EMPLOYEE DETAIL...................';
        Employee_Caption_Control1102755158Lbl: label 'Employee:';
        Department_Caption_Control1102755159Lbl: label 'Department:';
        Period_Caption_Control1102755163Lbl: label 'Period:';
        P_I_N_No_Caption_Control1102755165Lbl: label 'P.I.N No:';
        EmptyStringCaption_Control1102755166Lbl: label '............................................................................................................';
        BALANCECaptionLbl: label 'BALANCE';
        AMOUNTCaptionLbl: label 'AMOUNT';
        AMOUNTCaption_Control1102755320Lbl: label 'AMOUNT';
        BALANCECaption_Control1102755321Lbl: label 'BALANCE';
        ObjPrPeriods: Record "Payroll Calender_AU";
        HREmployees6: Record "HR Employees";
        JObtitle: Text;

    trigger OnInitReport();
    begin

    end;

}