Report 80030 "Bank Recon Smnt"
{
    Caption = 'Bank Account Statement';
    WordLayout = 'Layouts/BankReconSmnt.docx';
    DefaultLayout = Word;

    dataset
    {
        dataitem("Bank Account Statement"; "Bank Account Statement")
        {
            DataItemTableView = sorting("Bank Account No.", "Statement No.");
            RequestFilterFields = "Bank Account No.", "Statement No.";

            column(StatementDate_BankAccountStatement; "Bank Account Statement"."Statement Date")
            {
            }
            column(BankAccountName; BankAccountName)
            {
            }
            column(StatementEndingBalance_BankAccountStatement; "Bank Account Statement"."Statement Ending Balance")
            {
            }
            column(ComanyName; CompanyProperty.DisplayName)
            {
            }
            column(StmtNo_BankAccStmt; "Bank Account Statement"."Statement No.")
            {
                IncludeCaption = true;
            }
            column(BankAccNo_BankAccStmt; "Bank Account Statement"."Bank Account No.")
            {
            }
            column(CurrReportPAGENOCapt; CurrReportPAGENOCaptLbl)
            {
            }
            column(CreditAmount; CreditAmount)
            {
            }
            column(DebitAmount; DebitAmount)
            {
            }
            column(ComputerBankBal; ComputerBankBal)
            {
            }
            column(DiffBankBal; DiffBankBal)
            {
            }
            column(ReconBankBal; ReconBankBal)
            {
            }
            dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No." = field("Bank Account No.");
                RequestFilterFields = "Posting Date";

                column(PostingDate_BankAccountLedgerEntry; Format("Bank Account Ledger Entry"."Posting Date", 0, '<Closing><Day,2>-<Month,2>-<Year>'))
                {
                }
                column(DocumentNo_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Document No.")
                {
                }
                column(Description_BankAccountLedgerEntry; "Bank Account Ledger Entry".Description)
                {
                }
                column(Amount_BankAccountLedgerEntry; "Bank Account Ledger Entry".Amount)
                {
                }
                column(CreditAmount2; CreditAmount)
                {
                }
                column(DebitAmount2; DebitAmount)
                {
                }
                trigger OnPreDataItem();
                begin
                    //StartDate := 20000101D;
                    //GLAccountRec.SETFILTER("No.", '%1..%2|%3', '100', '200', '300');
                    "Bank Account Ledger Entry".SetRange(Open, true);
                    "Bank Account Ledger Entry".SetFilter("Posting Date", '%1..%2', 20190101D, "Bank Account Statement"."Statement Date");
                    if "Bank Account Ledger Entry".Amount > 0 then
                        DebitAmount := DebitAmount + "Bank Account Ledger Entry".Amount;
                    if "Bank Account Ledger Entry".Amount < 0 then
                        CreditAmount := CreditAmount + "Bank Account Ledger Entry".Amount;

                end;

                trigger OnAfterGetRecord();
                begin
                    //"Bank Account Ledger Entry".SETRANGE("Posting Date",20000101D,"Bank Account Statement"."Statement Date");
                    //"Bank Account Ledger Entry".SETRANGE("Bank Account Ledger Entry"."Posting Date",20190101D,"Bank Account Statement"."Statement Date");
                    /*//"Bank Account Ledger Entry".SETFILTER("Bank Account Ledger Entry".Amount,'>%1',0);
					IF "Bank Account Ledger Entry".FINDFIRST  THEN
					  REPEAT
						IF "Bank Account Ledger Entry".Amount > 0 THEN
						DebitAmount := DebitAmount + "Bank Account Ledger Entry".Amount;
					  UNTIL "Bank Account Ledger Entry".NEXT = 0;
					//"Bank Account Ledger Entry".SETFILTER("Bank Account Ledger Entry".Amount,'<%1',0);
					IF "Bank Account Ledger Entry".FINDFIRST  THEN
					  REPEAT
						IF "Bank Account Ledger Entry".Amount < 0 THEN
						CreditAmount := CreditAmount + "Bank Account Ledger Entry".Amount;
					  UNTIL "Bank Account Ledger Entry".NEXT = 0;*/
                    //"Bank Account Ledger Entry".SETFILTER("Posting Date",'<=%1',"Bank Account Statement"."Statement Date");
                    // IF "Bank Account Ledger Entry".Amount > 0 THEN
                    //	DebitAmount := DebitAmount + "Bank Account Ledger Entry".Amount;
                    //
                    // IF "Bank Account Ledger Entry".Amount < 0 THEN
                    //	CreditAmount := CreditAmount + "Bank Account Ledger Entry".Amount;
                    //MESSAGE(FORMAT(DebitAmount));
                    //MESSAGE(FORMAT(CreditAmount));
                    //ReconBankBal := "Bank Account Statement"."Statement Ending Balance" + DebitAmount + CreditAmount;
                    //DiffBankBal := ReconBankBal - ComputerBankBal;

                end;

            }
            trigger OnPreDataItem();
            begin

            end;

            trigger OnAfterGetRecord();
            begin
                CreditAmount := 0;
                DebitAmount := 0;
                ReconBankBal := 0;
                ComputerBankBal := 0;
                DiffBankBal := 0;
                if BankAccounts.Get("Bank Account Statement"."Bank Account No.") then begin
                    BankAccountName := BankAccounts.Name;
                    BankAccountBal := BankAccounts.Balance;
                end;
                //Get computer bank balance upto statement date
                BankAcLedgerEntry.SetRange("Bank Account No.", "Bank Account Statement"."Bank Account No.");
                BankAcLedgerEntry.SetFilter("Posting Date", '..%1', "Bank Account Statement"."Statement Date");
                if BankAcLedgerEntry.FindFirst then
                    repeat
                        ComputerBankBal += BankAcLedgerEntry.Amount;
                    until BankAcLedgerEntry.Next = 0;
                //Calculate debits and credits
                BankAcLedgerEntry.Reset;
                BankAcLedgerEntry.SetRange("Bank Account No.", "Bank Account Statement"."Bank Account No.");
                BankAcLedgerEntry.SetFilter("Posting Date", '..%1', "Bank Account Statement"."Statement Date");
                BankAcLedgerEntry.SetRange(Open, true);
                if BankAcLedgerEntry.FindFirst then
                    repeat
                        if BankAcLedgerEntry.Amount > 0 then
                            DebitAmount += BankAcLedgerEntry.Amount;
                        if BankAcLedgerEntry.Amount < 0 then
                            CreditAmount += BankAcLedgerEntry.Amount;
                    until BankAcLedgerEntry.Next = 0;
                ReconBankBal := "Bank Account Statement"."Statement Ending Balance" + DebitAmount + CreditAmount;
                DiffBankBal := ReconBankBal - ComputerBankBal;
            end;

        }
    }
    requestpage
    {
        SaveValues = false;
        layout
        {
        }

    }
    labels
    {
        TotalCaption = 'Total';
    }
    var
        BankAccStmtLines: Record "Bank Account Statement Line";
        BankAccStmtFilter: Text;
        BankAccStmtCaptLbl: label 'Bank Account Statement';
        CurrReportPAGENOCaptLbl: label 'Page';
        BnkAccStmtLinTrstnDteCaptLbl: label 'Transaction Date';
        BnkAcStmtLinValDteCaptLbl: label 'Value Date';
        CreditAppAmt: Decimal;
        DebitAppAmt: Decimal;
        CreditAmount: Decimal;
        DebitAmount: Decimal;
        BankAccounts: Record "Bank Account";
        BankAccountName: Text;
        BankAccountBal: Decimal;
        ReconBankBal: Decimal;
        ComputerBankBal1: Decimal;
        ComputerBankBal: Decimal;
        DiffBankBal: Decimal;
        StartDate: Date;
        "--JEFF--": Integer;
        BankAcLedgerEntry: Record "Bank Account Ledger Entry";

    trigger OnInitReport();
    begin

    end;

    trigger OnPreReport();
    begin
        ;

    end;

}