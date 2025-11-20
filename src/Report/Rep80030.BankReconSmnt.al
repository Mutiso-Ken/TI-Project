#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80030 "Bank Recon Smnt"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Bank Recon Smnt.rdlc';
    Caption = 'Bank Account Statement';

    dataset
    {
        dataitem("Bank Account Statement";"Bank Account Statement")
        {
            DataItemTableView = sorting("Bank Account No.","Statement No.");
            RequestFilterFields = "Bank Account No.","Statement No.";
            column(ReportForNavId_9909; 9909)
            {
            }
            column(StatementDate_BankAccountStatement;"Bank Account Statement"."Statement Date")
            {
            }
            column(BankAccountName;BankAccountName)
            {
            }
            column(StatementEndingBalance_BankAccountStatement;"Bank Account Statement"."Statement Ending Balance")
            {
            }
            column(BalanceLastStatement_BankAccountStatement;"Bank Account Statement"."Balance Last Statement")
            {
            }
            column(ComanyName;CompanyProperty.DisplayName)
            {
            }
            column(BankAccStmtTableCaptFltr;TableCaption + ': ' + BankAccStmtFilter)
            {
            }
            column(BankAccStmtFilter;BankAccStmtFilter)
            {
            }
            column(BankAccountStatementStatementDate;"Bank Account Statement"."Statement Date")
            {
            }
            column(StmtNo_BankAccStmt;"Statement No.")
            {
                IncludeCaption = true;
            }
            column(BankAccNo_BankAccStmt;"Bank Account No.")
            {
            }
            column(BankAccStmtCapt;BankAccStmtCaptLbl)
            {
            }
            column(CurrReportPAGENOCapt;CurrReportPAGENOCaptLbl)
            {
            }
            column(CreditAmount;CreditAmount)
            {
            }
            column(DebitAmount;DebitAmount)
            {
            }
            column(ComputerBankBal;ComputerBankBal)
            {
            }
            column(DiffBankBal;DiffBankBal)
            {
            }
            column(ReconBankBal;ReconBankBal)
            {
            }
            dataitem("Bank Account Ledger Entry";"Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No."=field("Bank Account No.");
                RequestFilterFields = "Posting Date";
                column(ReportForNavId_5; 5)
                {
                }
                column(CreditAppAmt;CreditAppAmt)
                {
                }
                column(DocumentNo_Caption;"Bank Account Ledger Entry"."Document No.")
                {
                }
                column(PostingDate_Caption;"Bank Account Ledger Entry"."Posting Date")
                {
                }
                column(Description_Caption;"Bank Account Ledger Entry".Description)
                {
                }
                column(Amount_Caption;"Bank Account Ledger Entry".Amount)
                {
                }
                column(EntryNo_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Entry No.")
                {
                }
                column(BankAccountNo_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Bank Account No.")
                {
                }
                column(PostingDate_BankAccountLedgerEntry;Format("Bank Account Ledger Entry"."Posting Date",0,'<Closing><Day,2>-<Month,2>-<Year>'))
                {
                }
                column(DocumentType_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Document Type")
                {
                }
                column(DocumentNo_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Document No.")
                {
                }
                column(Description_BankAccountLedgerEntry;"Bank Account Ledger Entry".Description)
                {
                }
                column(CurrencyCode_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Currency Code")
                {
                }
                column(Amount_BankAccountLedgerEntry;"Bank Account Ledger Entry".Amount)
                {
                }
                column(RemainingAmount_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Remaining Amount")
                {
                }
                column(AmountLCY_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Amount (LCY)")
                {
                }
                column(BankAccPostingGroup_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Bank Acc. Posting Group")
                {
                }
                column(GlobalDimension1Code_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Global Dimension 1 Code")
                {
                }
                column(GlobalDimension2Code_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Global Dimension 2 Code")
                {
                }
                column(OurContactCode_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Our Contact Code")
                {
                }
                column(UserID_BankAccountLedgerEntry;"Bank Account Ledger Entry"."User ID")
                {
                }
                column(SourceCode_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Source Code")
                {
                }
                column(Open_BankAccountLedgerEntry;"Bank Account Ledger Entry".Open)
                {
                }
                column(Positive_BankAccountLedgerEntry;"Bank Account Ledger Entry".Positive)
                {
                }
                column(ClosedbyEntryNo_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Closed by Entry No.")
                {
                }
                column(ClosedatDate_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Closed at Date")
                {
                }
                column(JournalBatchName_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Journal Batch Name")
                {
                }
                column(ReasonCode_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Reason Code")
                {
                }
                column(BalAccountType_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Bal. Account Type")
                {
                }
                column(BalAccountNo_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Bal. Account No.")
                {
                }
                column(TransactionNo_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Transaction No.")
                {
                }
                column(StatementStatus_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Statement Status")
                {
                }
                column(StatementNo_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Statement No.")
                {
                }
                column(StatementLineNo_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Statement Line No.")
                {
                }
                column(DebitAmount_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Debit Amount")
                {
                }
                column(CreditAmount_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Credit Amount")
                {
                }
                column(DebitAmountLCY_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Debit Amount (LCY)")
                {
                }
                column(CreditAmountLCY_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Credit Amount (LCY)")
                {
                }
                column(DocumentDate_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Document Date")
                {
                }
                column(ExternalDocumentNo_BankAccountLedgerEntry;"Bank Account Ledger Entry"."External Document No.")
                {
                }
                column(Reversed_BankAccountLedgerEntry;"Bank Account Ledger Entry".Reversed)
                {
                }
                column(ReversedbyEntryNo_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Reversed by Entry No.")
                {
                }
                column(ReversedEntryNo_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Reversed Entry No.")
                {
                }
                column(CheckLedgerEntries_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Check Ledger Entries")
                {
                }
                column(DimensionSetID_BankAccountLedgerEntry;"Bank Account Ledger Entry"."Dimension Set ID")
                {
                }

                trigger OnAfterGetRecord()
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
                    //    DebitAmount := DebitAmount + "Bank Account Ledger Entry".Amount;
                    //
                    // IF "Bank Account Ledger Entry".Amount < 0 THEN
                    //    CreditAmount := CreditAmount + "Bank Account Ledger Entry".Amount;
                    
                    //MESSAGE(FORMAT(DebitAmount));
                    //MESSAGE(FORMAT(CreditAmount));
                    
                    //ReconBankBal := "Bank Account Statement"."Statement Ending Balance" + DebitAmount + CreditAmount;
                    //DiffBankBal := ReconBankBal - ComputerBankBal;

                end;

                trigger OnPreDataItem()
                begin
                    //StartDate := 20000101D;
                    //GLAccountRec.SETFILTER("No.", '%1..%2|%3', '100', '200', '300');

                    "Bank Account Ledger Entry".SetRange(Open,true);
                    "Bank Account Ledger Entry".SetFilter("Posting Date",'%1..%2',20190101D,"Bank Account Statement"."Statement Date");
                    if "Bank Account Ledger Entry".Amount > 0 then
                        DebitAmount := DebitAmount + "Bank Account Ledger Entry".Amount;
                    if "Bank Account Ledger Entry".Amount < 0 then
                        CreditAmount := CreditAmount + "Bank Account Ledger Entry".Amount;
                end;
            }

            trigger OnAfterGetRecord()
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
                BankAcLedgerEntry.SetRange("Bank Account No.","Bank Account Statement"."Bank Account No.");
                BankAcLedgerEntry.SetFilter("Posting Date",'..%1',"Bank Account Statement"."Statement Date");
                if BankAcLedgerEntry.FindFirst then
                  repeat
                    ComputerBankBal += BankAcLedgerEntry.Amount;
                  until BankAcLedgerEntry.Next = 0;

                //Calculate debits and credits
                BankAcLedgerEntry.Reset;
                BankAcLedgerEntry.SetRange("Bank Account No.","Bank Account Statement"."Bank Account No.");
                BankAcLedgerEntry.SetFilter("Posting Date",'..%1',"Bank Account Statement"."Statement Date");
                BankAcLedgerEntry.SetRange(Open,true);
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

        layout
        {
        }

        actions
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
}

