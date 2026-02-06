#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80017 "Payroll Journal Transfer"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Payroll Employee_AU"; "Payroll Employee_AU")
        {
            RequestFilterFields = "No.", "Period Filter";
            column(ReportForNavId_6207; 6207)
            {
            }

            trigger OnAfterGetRecord()
            begin
                //Get the staff details (header)
                objEmp.SetRange(objEmp."No.", "Payroll Employee_AU"."No.");
                if objEmp.Find('-') then begin
                    strEmpName := '[' + objEmp."No." + '] ' + objEmp.Lastname + ' ' + objEmp.Firstname + ' ' + objEmp.Surname;
                    GlobalDim1 := objEmp."Global Dimension 1";
                    GlobalDim2 := objEmp."Global Dimension 2";//objEmp.Office;
                end;

                LineNumber := LineNumber + 10;
                PeriodTrans.Reset;
                PeriodTrans.SetRange(PeriodTrans."No.", "Payroll Employee_AU"."No.");
                PeriodTrans.SetRange(PeriodTrans."Payroll Period", SelectedPeriod);
                if PeriodTrans.Find('-') then begin
                    repeat
                        AmountToDebit := 0;
                        AmountToCredit := 0;
                        if PeriodTrans."Posting Type" = PeriodTrans."posting type"::Debit then
                            AmountToDebit := PeriodTrans.Amount;
                        if PeriodTrans."Posting Type" = PeriodTrans."posting type"::Credit then
                            AmountToCredit := PeriodTrans.Amount;

                        if PeriodTrans."Account Type" = 1 then
                            IntegerPostAs := 0;
                        if PeriodTrans."Account Type" = 2 then
                            IntegerPostAs := 1;
                        //Negative NPay
                        if (PeriodTrans."Posting Type" = PeriodTrans."posting type"::Credit) and (PeriodTrans.Amount < 0) then begin
                            AmountToDebit := AmountToCredit * -1;
                            AmountToCredit := 0;
                            CreateJnlEntry(IntegerPostAs, "Payroll Employee_AU"."Expense Account",
                            GlobalDim1, GlobalDim2, PeriodTrans."Transaction Name" + '-' + PeriodTrans."No.", AmountToDebit, AmountToCredit,
                            PeriodTrans."posting type"::Debit, PeriodTrans."Loan Number", SaccoTransactionType, "Payroll Employee_AU"."No.");
                        end else begin
                            if PeriodTrans."Transaction Code" <> 'EXCESS PEN' then begin
                                CreateJnlEntry(IntegerPostAs, PeriodTrans."Account No",
                                                            GlobalDim1, GlobalDim2, PeriodTrans."Transaction Name" + '-' + PeriodTrans."No.", AmountToDebit, AmountToCredit,
                                                            PeriodTrans."Posting Type", PeriodTrans."Loan Number", SaccoTransactionType, "Payroll Employee_AU"."No.");
                            end;
                        end;

                        //Pension
                        if PeriodTrans."Co-Op parameters" = PeriodTrans."co-op parameters"::Pension then begin
                            //Get from Employer Deduction
                            EmployerDed.Reset;
                            EmployerDed.SetRange(EmployerDed."Employee Code", PeriodTrans."No.");
                            EmployerDed.SetRange(EmployerDed."Transaction Code", PeriodTrans."Transaction Code");
                            EmployerDed.SetRange(EmployerDed."Payroll Period", PeriodTrans."Payroll Period");
                            if EmployerDed.Find('-') then begin
                                //Credit Payables
                                CreateJnlEntry(0, PostingGroup."Pension Employee Acc",
                                GlobalDim1, GlobalDim2, PeriodTrans."Transaction Name" + '-' + PeriodTrans."No.", 0,
                                EmployerDed.Amount, PeriodTrans."Posting Type", '', SaccoTransactionType, "Payroll Employee_AU"."No.");

                                //Debit Staff Expense
                                CreateJnlEntry(0, "Payroll Employee_AU"."Expense Account",
                                GlobalDim1, GlobalDim2, PeriodTrans."Transaction Name" + '-' + PeriodTrans."No.", EmployerDed.Amount, 0, 1, '',
                                SaccoTransactionType, "Payroll Employee_AU"."No.");

                            end;
                        end;

                        //NSSF Employer Deduction*****Amos*****
                        //
                        if PeriodTrans."Transaction Code" = 'NSSF' then begin
                            //Credit Payables
                            //Credit Payables
                            CreateJnlEntry(0, "Payroll Employee_AU"."Expense Account",
                            GlobalDim1, GlobalDim2, PeriodTrans."Transaction Name" + '-' + PeriodTrans."No." + '' + 'EmpDed', 0, PeriodTrans.Amount,
                            PeriodTrans."Posting Type", '', SaccoTransactionType, "Payroll Employee_AU"."No.");

                            //Debit Staff Expense
                            CreateJnlEntry(0, PostingGroup."SSF Employer Account",
                            GlobalDim1, GlobalDim2, PeriodTrans."Transaction Name" + '-' + PeriodTrans."No." + '' + 'EmpDed', PeriodTrans.Amount, 0, 1, '',
                            SaccoTransactionType, "Payroll Employee_AU"."No.");

                            //nita
                            //Credit Payables
                            // CreateJnlEntry(0, '2204',
                            // GlobalDim1, GlobalDim2, PeriodTrans."Transaction Name" + '-' + PeriodTrans."No." + '' + 'Nita', 0, 50,
                            // PeriodTrans."Posting Type", '', SaccoTransactionType, "Payroll Employee_AU"."No.");

                            //Debit Staff Expense
                            // CreateJnlEntry(0, PostingGroup.Nita,
                            // GlobalDim1, GlobalDim2, PeriodTrans."Transaction Name" + '-' + PeriodTrans."No." + '' + 'Nita', 50, 0, 1, '',
                            // SaccoTransactionType, "Payroll Employee_AU"."No.");
                            //end nita
                        end;
                        //Pension Employer Deduction*****Amos*****
                        if PeriodTrans."Transaction Code" = 'PENSION' then begin
                            //Credit Payables
                            //Credit Payables
                            CreateJnlEntry(0, PostingGroup."Pension Employee Acc",
                            GlobalDim1, GlobalDim2, PeriodTrans."Transaction Name" + '-' + PeriodTrans."No." + '' + 'EmpDed', 0, PeriodTrans.Amount * 2,
                            PeriodTrans."Posting Type", '', SaccoTransactionType, "Payroll Employee_AU"."No.");

                            //Debit Staff Expense
                            CreateJnlEntry(0, "Payroll Employee_AU"."Expense Account",
                            GlobalDim1, GlobalDim2, PeriodTrans."Transaction Name" + '-' + PeriodTrans."No." + '' + 'EmpDed', PeriodTrans.Amount * 2, 0, 1, '',
                            SaccoTransactionType, "Payroll Employee_AU"."No.");
                        end;
                        if PeriodTrans."Transaction Code" = 'EXCESS PEN' then begin
                            //Credit Payables
                            //Credit Payables
                            CreateJnlEntry(0, PostingGroup."Pension Employee Acc",
                            GlobalDim1, GlobalDim2, PeriodTrans."Transaction Name" + '-' + PeriodTrans."No." + ' ' + ' Excess Pension', 0, PeriodTrans.Amount,
                            PeriodTrans."Posting Type", '', SaccoTransactionType, "Payroll Employee_AU"."No.");

                            // //Debit Staff Expense
                            CreateJnlEntry(0, "Payroll Employee_AU"."Expense Account",
                            GlobalDim1, GlobalDim2, PeriodTrans."Transaction Name" + '-' + PeriodTrans."No." + ' ' + ' Excess Pension', PeriodTrans.Amount, 0, 1, '',
                            SaccoTransactionType, "Payroll Employee_AU"."No.");
                        end;

                        if PeriodTrans."Transaction Code" = 'HL' then begin

                            //Credit Payables
                            CreateJnlEntry(0, '2232',
                            GlobalDim1, GlobalDim2, PeriodTrans."Transaction Name" + '-' + PeriodTrans."No." + '' + ' Housing', 0, PeriodTrans.Amount,
                            PeriodTrans."Posting Type", '', SaccoTransactionType, "Payroll Employee_AU"."No.");

                            //Debit Staff Expense
                            CreateJnlEntry(0, "Payroll Employee_AU"."Expense Account",
                            GlobalDim1, GlobalDim2, PeriodTrans."Transaction Name" + '-' + PeriodTrans."No." + '' + ' housing', PeriodTrans.Amount, 0, 1, '',
                            SaccoTransactionType, "Payroll Employee_AU"."No.");
                        end;


                        //K.U Pension Employer Deduction*****Amos*****
                        if PeriodTrans."Transaction Code" = '2207' then begin
                            //Credit Payables
                            //Credit Payables
                            CreateJnlEntry(0, PostingGroup."Pension Employee Acc",
                            GlobalDim1, GlobalDim2, PeriodTrans."Transaction Name" + '-' + PeriodTrans."No." + '' + 'EmpDed', 0, PeriodTrans.Amount * 2,
                            PeriodTrans."Posting Type", '', SaccoTransactionType, "Payroll Employee_AU"."No.");

                            //Debit Staff Expense
                            CreateJnlEntry(0, "Payroll Employee_AU"."Expense Account",
                            GlobalDim1, GlobalDim2, PeriodTrans."Transaction Name" + '-' + PeriodTrans."No." + '' + 'EmpDed', PeriodTrans.Amount * 2, 0, 1, '',
                            SaccoTransactionType, "Payroll Employee_AU"."No.");
                            //END;
                            //Pension
                            //
                        end;
                    until PeriodTrans.Next = 0;
                end;
            end;

            trigger OnPostDataItem()
            begin
                //CreateRealJournal();
                Message('Journals Created Successfully');



            end;

            trigger OnPreDataItem()
            begin
                //"Payroll Employee_AU".SETRANGE("Payroll Employee_AU".Status,"Payroll Employee_AU".Status::Active);
                LineNumber := 10000;

                //Create batch*****************************************************************************
                GenJnlBatch.Reset;
                GenJnlBatch.SetRange(GenJnlBatch."Journal Template Name", 'GENERAL');
                GenJnlBatch.SetRange(GenJnlBatch.Name, 'SALARIES');
                if GenJnlBatch.Find('-') = false then begin
                    GenJnlBatch.Init;
                    GenJnlBatch."Journal Template Name" := 'GENERAL';
                    GenJnlBatch.Name := 'SALARIES';
                    GenJnlBatch.Insert;
                end;
                // End Create Batch

                // Clear the journal Line
                GeneraljnlLine.Reset;
                GeneraljnlLine.SetRange(GeneraljnlLine."Journal Batch Name", 'SALARIES');
                if GeneraljnlLine.Find('-') then
                    GeneraljnlLine.DeleteAll;





                "Slip/Receipt No" := UpperCase(objPeriod."Period Name");
                PostingGroup.Reset;
                PostingGroup.SetRange(PostingGroup."Posting Code", 'SALARY');
                if PostingGroup.Find('-') then begin
                    // PostingGroup.TestField("SSF Employer Account");
                    // PostingGroup.TestField("SSF Employee Account");
                    // PostingGroup.TestField("Pension Employer Acc");
                    // PostingGroup.TestField("Pension Employee Acc");
                end;
            end;
        }

    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(PeriodDate; PeriodDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Period Date';
                    TableRelation = "Payroll Calender_AU"."Date Opened";
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        /*
        PeriodFilter:=PeriodDate;//"prSalary Card".GETFILTER("Period Filter");
        IF PeriodFilter='' THEN ERROR('You must specify the period filter');
                     */

        if PeriodDate = 0D then Error('You must specify the period filter');
        SelectedPeriod := PeriodDate;//"prSalary Card".GETRANGEMIN("Period Filter");
        objPeriod.Reset;
        if objPeriod.Get(SelectedPeriod) then PeriodName := objPeriod."Period Name";

        //PostingDate:=CALCDATE('1M-1D',SelectedPeriod);
        PostingDate := CalcDate('CM', SelectedPeriod);

    end;

    trigger OnPostReport()
    var
        myInt: Integer;
    begin
        GeneraljnlLine.Reset;
        GeneraljnlLine.SetRange(GeneraljnlLine."Journal Template Name", 'GENERAL');
        GeneraljnlLine.SetRange(GeneraljnlLine."Journal Batch Name", 'SALARIES');
        if GeneraljnlLine.Find('-') then
            Page.Run(page::"General Journal", GeneraljnlLine);
    end;

    var
        PeriodTrans: Record "Payroll Monthly Trans_AU";
        objEmp: Record "Payroll Employee_AU";
        PeriodName: Text[30];
        PeriodFilter: Text[30];
        SelectedPeriod: Date;
        objPeriod: Record "Payroll Calender_AU";
        strEmpName: Text[150];
        GeneraljnlLine: Record "Gen. Journal Line";
        GenJnlBatch: Record "Gen. Journal Batch";
        "Slip/Receipt No": Code[50];
        LineNumber: Integer;

        TaxableAmount: Decimal;
        PostingGroup: Record "Payroll Posting Groups_AU";
        GlobalDim1: Code[10];
        GlobalDim2: Code[10];

        PostingDate: Date;
        AmountToDebit: Decimal;
        AmountToCredit: Decimal;
        IntegerPostAs: Integer;
        SaccoTransactionType: Option " ","Registration Fee",Loan,Repayment,Withdrawal,"Interest Due","Interest Paid","Welfare Contribution","Deposit Contribution","Loan Penalty","Application Fee","Appraisal Fee",Investment,"Unallocated Funds","Shares Capital","Loan Adjustment",Dividend,"Withholding Tax","Administration Fee","Welfare Contribution 2";
        EmployerDed: Record "Payroll Employer Deductions_AU";
        PeriodDate: Date;
        GLS: Record "General Ledger Setup";
        GLAC: Code[30];
        PayrollProjectAllocation: Record "Payroll Project Allocation";
        RealGeneraljnlLine: Record "Gen. Journal Line";
        GeneraljnlLine2: Record "Gen. Journal Line";
        Amt: Decimal;
        GLAccount: Record "G/L Account";


    procedure CreateJnlEntry(AccountType: enum "Gen. Journal Account Type"; AccountNo: Code[20];
                                              GlobalDime1: Code[20];
                                              GlobalDime2: Code[20];
                                              Description: Text[50];
                                              DebitAmount: Decimal;
                                              CreditAmount: Decimal;
                                              PostAs: Option " ",Debit,Credit;
                                              LoanNo: Code[20];
                                              TransType: Option " ","Registration Fee",Loan,Repayment,Withdrawal,"Interest Due","Interest Paid","Welfare Contribution","Deposit Contribution","Loan Penalty","Application Fee","Appraisal Fee",Investment,"Unallocated Funds","Shares Capital","Loan Adjustment",Dividend,"Withholding Tax","Administration Fee","Welfare Contribution 2";
                                              "Employee Code": Code[100])
    begin
        PayrollProjectAllocation.Reset;
        PayrollProjectAllocation.SetRange("Employee No", "Employee Code");
        PayrollProjectAllocation.SetRange(Period, PeriodDate);
        if PayrollProjectAllocation.FindSet then begin
            repeat
                LineNumber := LineNumber + 100;
                GeneraljnlLine.Init;
                GeneraljnlLine."Journal Template Name" := 'GENERAL';
                GeneraljnlLine."Journal Batch Name" := 'SALARIES';
                GeneraljnlLine."Line No." := LineNumber;
                GeneraljnlLine."Document No." := "Slip/Receipt No";
                //GeneraljnlLine."Loan No":=LoanNo;
                //GeneraljnlLine."Transaction Type":=TransType;
                GeneraljnlLine."Posting Date" := PostingDate;
                // GeneraljnlLine."Posting Date":=TODAY;
                GeneraljnlLine."Account Type" := AccountType;
                GeneraljnlLine."Account No." := AccountNo;
                //GeneraljnlLine.Validate(GeneraljnlLine."Account No.");
                GeneraljnlLine.Description := Description;
                // if PostAs = Postas::Debit then begin
                //     GeneraljnlLine."Debit Amount" := DebitAmount;
                //     GeneraljnlLine.Validate("Debit Amount");
                // end else begin
                //     GeneraljnlLine."Credit Amount" := CreditAmount;
                //     GeneraljnlLine.Validate("Credit Amount");
                // end;
                if DebitAmount <> 0 then
                    GeneraljnlLine.Amount := ROUND(DebitAmount * (PayrollProjectAllocation.Allocation / 100), 0.01, '=');

                if CreditAmount <> 0 then
                    GeneraljnlLine.Amount := -1 * ROUND((CreditAmount * (PayrollProjectAllocation.Allocation / 100)), 0.01, '=');
                GeneraljnlLine."Shortcut Dimension 2 Code" := PayrollProjectAllocation."Project Code";
                GeneraljnlLine.Validate(GeneraljnlLine."Shortcut Dimension 2 Code");
                GeneraljnlLine.Validate(Amount);
                GeneraljnlLine.Correction := false;

                // GeneraljnlLine."Shortcut Dimension 2 Code" := PayrollProjectAllocation."Budget Line Code";
                // GeneraljnlLine.Validate(GeneraljnlLine."Shortcut Dimension 2 Code");

                if GeneraljnlLine.Amount <> 0 then
                    GeneraljnlLine.Insert;
            until PayrollProjectAllocation.Next = 0;
        end;
    end;

    local procedure CreateRealJournal()
    begin
        //Copy staff cost

        GeneraljnlLine.Reset;
        GeneraljnlLine.SetRange("Journal Template Name", 'GENERAL');
        GeneraljnlLine.SetRange("Journal Batch Name", 'SALARIES');
        //GeneraljnlLine.SETRANGE("Account No.",'5207');
        if GeneraljnlLine.FindSet then begin
            repeat
                Amt := 0;
                GeneraljnlLine2.Reset;
                GeneraljnlLine2.SetRange("Journal Template Name", 'GENERAL');
                GeneraljnlLine2.SetRange("Journal Batch Name", 'SALARIES');
                GeneraljnlLine2.SetRange("Account No.", GeneraljnlLine."Account No.");
                GeneraljnlLine2.SetRange("Shortcut Dimension 1 Code", GeneraljnlLine."Shortcut Dimension 1 Code");
                GeneraljnlLine2.SetRange("Shortcut Dimension 2 Code", GeneraljnlLine."Shortcut Dimension 2 Code");
                if GeneraljnlLine2.FindSet then begin
                    repeat
                        Amt := Amt + GeneraljnlLine2.Amount
                     until GeneraljnlLine2.Next = 0;
                    //  GeneraljnlLine2.CALCSUMS(Amount);
                end;
                LineNumber := LineNumber + 100;
                RealGeneraljnlLine.Init;
                RealGeneraljnlLine."Journal Template Name" := 'GENERAL';
                RealGeneraljnlLine."Journal Batch Name" := 'SALARIES';
                RealGeneraljnlLine."Line No." := LineNumber;
                RealGeneraljnlLine."Document No." := GeneraljnlLine."Document No.";
                RealGeneraljnlLine."Posting Date" := GeneraljnlLine."Posting Date";
                RealGeneraljnlLine."Account Type" := GeneraljnlLine."Account Type";
                RealGeneraljnlLine."Account No." := GeneraljnlLine."Account No.";
                RealGeneraljnlLine.Validate(RealGeneraljnlLine."Account No.");
                GLAccount.Get(GeneraljnlLine."Account No.");
                RealGeneraljnlLine.Description := GeneraljnlLine."Document No." + ' ' + GLAccount.Name;
                RealGeneraljnlLine.Amount := Amt;
                RealGeneraljnlLine.Validate(RealGeneraljnlLine.Amount);
                RealGeneraljnlLine."Shortcut Dimension 1 Code" := GeneraljnlLine."Shortcut Dimension 1 Code";
                RealGeneraljnlLine.Validate(RealGeneraljnlLine."Shortcut Dimension 1 Code");
                RealGeneraljnlLine."Shortcut Dimension 2 Code" := GeneraljnlLine."Shortcut Dimension 2 Code";
                RealGeneraljnlLine.Validate(RealGeneraljnlLine."Shortcut Dimension 2 Code");
                if RealGeneraljnlLine.Amount <> 0 then
                    RealGeneraljnlLine.Insert;

                GeneraljnlLine2.Reset;
                GeneraljnlLine2.SetRange("Journal Template Name", 'GENERAL');
                GeneraljnlLine2.SetRange("Journal Batch Name", 'SALARIES');
                GeneraljnlLine2.SetRange("Account No.", GeneraljnlLine."Account No.");
                GeneraljnlLine2.SetRange("Shortcut Dimension 1 Code", GeneraljnlLine."Shortcut Dimension 1 Code");
                GeneraljnlLine2.SetRange("Shortcut Dimension 2 Code", GeneraljnlLine."Shortcut Dimension 2 Code");
                if GeneraljnlLine2.FindSet then begin
                    GeneraljnlLine2.DeleteAll;
                end;


            //END;

            until GeneraljnlLine.Next = 0;
        end;
    end;
}

