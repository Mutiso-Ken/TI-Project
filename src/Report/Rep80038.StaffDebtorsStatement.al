#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80038 "Staff Debtors Statement"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Staff Debtors Statement.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            RequestFilterFields = "No.";
            column(ReportForNavId_83; 83)
            {
            }
            dataitem("Cust. Ledger Entry";"Cust. Ledger Entry")
            {
                CalcFields = Amount,"Amount (LCY)","Remaining Amount","Remaining Amt. (LCY)";
                DataItemLink = "Customer No."=field("No.");
                RequestFilterFields = "Posting Date";
                column(ReportForNavId_1102755000; 1102755000)
                {
                }
                column(EntryNo_CustLedgerEntry;"Cust. Ledger Entry"."Entry No.")
                {
                }
                column(CustomerNo_CustLedgerEntry;"Cust. Ledger Entry"."Customer No.")
                {
                }
                column(PostingDate_CustLedgerEntry;"Cust. Ledger Entry"."Posting Date")
                {
                }
                column(DocumentType_CustLedgerEntry;"Cust. Ledger Entry"."Document Type")
                {
                }
                column(DocumentNo_CustLedgerEntry;"Cust. Ledger Entry"."Document No.")
                {
                }
                column(Description_CustLedgerEntry;"Cust. Ledger Entry".Description)
                {
                }
                column(CustomerName_CustLedgerEntry;"Cust. Ledger Entry"."Customer Name")
                {
                }
                column(CurrencyCode_CustLedgerEntry;"Cust. Ledger Entry"."Currency Code")
                {
                }
                column(Amount_CustLedgerEntry;"Cust. Ledger Entry".Amount)
                {
                }
                column(RemainingAmount_CustLedgerEntry;"Cust. Ledger Entry"."Remaining Amount")
                {
                }
                column(OriginalAmtLCY_CustLedgerEntry;"Cust. Ledger Entry"."Original Amt. (LCY)")
                {
                }
                column(RemainingAmtLCY_CustLedgerEntry;"Cust. Ledger Entry"."Remaining Amt. (LCY)")
                {
                }
                column(AmountLCY_CustLedgerEntry;"Cust. Ledger Entry"."Amount (LCY)")
                {
                }
                column(SalesLCY_CustLedgerEntry;"Cust. Ledger Entry"."Sales (LCY)")
                {
                }
                column(ProfitLCY_CustLedgerEntry;"Cust. Ledger Entry"."Profit (LCY)")
                {
                }
                column(InvDiscountLCY_CustLedgerEntry;"Cust. Ledger Entry"."Inv. Discount (LCY)")
                {
                }
                column(SelltoCustomerNo_CustLedgerEntry;"Cust. Ledger Entry"."Sell-to Customer No.")
                {
                }
                column(CustomerPostingGroup_CustLedgerEntry;"Cust. Ledger Entry"."Customer Posting Group")
                {
                }
                column(GlobalDimension1Code_CustLedgerEntry;"Cust. Ledger Entry"."Global Dimension 1 Code")
                {
                }
                column(GlobalDimension2Code_CustLedgerEntry;"Cust. Ledger Entry"."Global Dimension 2 Code")
                {
                }
                column(SalespersonCode_CustLedgerEntry;"Cust. Ledger Entry"."Salesperson Code")
                {
                }
                column(UserID_CustLedgerEntry;"Cust. Ledger Entry"."User ID")
                {
                }
                column(SourceCode_CustLedgerEntry;"Cust. Ledger Entry"."Source Code")
                {
                }
                column(OnHold_CustLedgerEntry;"Cust. Ledger Entry"."On Hold")
                {
                }
                column(AppliestoDocType_CustLedgerEntry;"Cust. Ledger Entry"."Applies-to Doc. Type")
                {
                }
                column(AppliestoDocNo_CustLedgerEntry;"Cust. Ledger Entry"."Applies-to Doc. No.")
                {
                }
                column(Open_CustLedgerEntry;"Cust. Ledger Entry".Open)
                {
                }
                column(DueDate_CustLedgerEntry;"Cust. Ledger Entry"."Due Date")
                {
                }
                column(PmtDiscountDate_CustLedgerEntry;"Cust. Ledger Entry"."Pmt. Discount Date")
                {
                }
                column(OriginalPmtDiscPossible_CustLedgerEntry;"Cust. Ledger Entry"."Original Pmt. Disc. Possible")
                {
                }
                column(PmtDiscGivenLCY_CustLedgerEntry;"Cust. Ledger Entry"."Pmt. Disc. Given (LCY)")
                {
                }
                column(Positive_CustLedgerEntry;"Cust. Ledger Entry".Positive)
                {
                }
                column(ClosedbyEntryNo_CustLedgerEntry;"Cust. Ledger Entry"."Closed by Entry No.")
                {
                }
                column(ClosedatDate_CustLedgerEntry;"Cust. Ledger Entry"."Closed at Date")
                {
                }
                column(ClosedbyAmount_CustLedgerEntry;"Cust. Ledger Entry"."Closed by Amount")
                {
                }
                column(AppliestoID_CustLedgerEntry;"Cust. Ledger Entry"."Applies-to ID")
                {
                }
                column(JournalBatchName_CustLedgerEntry;"Cust. Ledger Entry"."Journal Batch Name")
                {
                }
                column(ReasonCode_CustLedgerEntry;"Cust. Ledger Entry"."Reason Code")
                {
                }
                column(BalAccountType_CustLedgerEntry;"Cust. Ledger Entry"."Bal. Account Type")
                {
                }
                column(BalAccountNo_CustLedgerEntry;"Cust. Ledger Entry"."Bal. Account No.")
                {
                }
                column(TransactionNo_CustLedgerEntry;"Cust. Ledger Entry"."Transaction No.")
                {
                }
                column(ClosedbyAmountLCY_CustLedgerEntry;"Cust. Ledger Entry"."Closed by Amount (LCY)")
                {
                }
                column(DebitAmount_CustLedgerEntry;"Cust. Ledger Entry"."Debit Amount")
                {
                }
                column(CreditAmount_CustLedgerEntry;"Cust. Ledger Entry"."Credit Amount")
                {
                }
                column(DebitAmountLCY_CustLedgerEntry;"Cust. Ledger Entry"."Debit Amount (LCY)")
                {
                }
                column(CreditAmountLCY_CustLedgerEntry;"Cust. Ledger Entry"."Credit Amount (LCY)")
                {
                }
                column(DocumentDate_CustLedgerEntry;"Cust. Ledger Entry"."Document Date")
                {
                }
                column(ExternalDocumentNo_CustLedgerEntry;"Cust. Ledger Entry"."External Document No.")
                {
                }
                column(CalculateInterest_CustLedgerEntry;"Cust. Ledger Entry"."Calculate Interest")
                {
                }
                column(ClosingInterestCalculated_CustLedgerEntry;"Cust. Ledger Entry"."Closing Interest Calculated")
                {
                }
                column(NoSeries_CustLedgerEntry;"Cust. Ledger Entry"."No. Series")
                {
                }
                column(ClosedbyCurrencyCode_CustLedgerEntry;"Cust. Ledger Entry"."Closed by Currency Code")
                {
                }
                column(ClosedbyCurrencyAmount_CustLedgerEntry;"Cust. Ledger Entry"."Closed by Currency Amount")
                {
                }
                column(AdjustedCurrencyFactor_CustLedgerEntry;"Cust. Ledger Entry"."Adjusted Currency Factor")
                {
                }
                column(OriginalCurrencyFactor_CustLedgerEntry;"Cust. Ledger Entry"."Original Currency Factor")
                {
                }
                column(OriginalAmount_CustLedgerEntry;"Cust. Ledger Entry"."Original Amount")
                {
                }
                column(DateFilter_CustLedgerEntry;"Cust. Ledger Entry"."Date Filter")
                {
                }
                column(RemainingPmtDiscPossible_CustLedgerEntry;"Cust. Ledger Entry"."Remaining Pmt. Disc. Possible")
                {
                }
                column(PmtDiscToleranceDate_CustLedgerEntry;"Cust. Ledger Entry"."Pmt. Disc. Tolerance Date")
                {
                }
                column(MaxPaymentTolerance_CustLedgerEntry;"Cust. Ledger Entry"."Max. Payment Tolerance")
                {
                }
                column(LastIssuedReminderLevel_CustLedgerEntry;"Cust. Ledger Entry"."Last Issued Reminder Level")
                {
                }
                column(AcceptedPaymentTolerance_CustLedgerEntry;"Cust. Ledger Entry"."Accepted Payment Tolerance")
                {
                }
                column(AcceptedPmtDiscTolerance_CustLedgerEntry;"Cust. Ledger Entry"."Accepted Pmt. Disc. Tolerance")
                {
                }
                column(PmtToleranceLCY_CustLedgerEntry;"Cust. Ledger Entry"."Pmt. Tolerance (LCY)")
                {
                }
                column(AmounttoApply_CustLedgerEntry;"Cust. Ledger Entry"."Amount to Apply")
                {
                }
                column(ICPartnerCode_CustLedgerEntry;"Cust. Ledger Entry"."IC Partner Code")
                {
                }
                column(ApplyingEntry_CustLedgerEntry;"Cust. Ledger Entry"."Applying Entry")
                {
                }
                column(Reversed_CustLedgerEntry;"Cust. Ledger Entry".Reversed)
                {
                }
                column(ReversedbyEntryNo_CustLedgerEntry;"Cust. Ledger Entry"."Reversed by Entry No.")
                {
                }
                column(ReversedEntryNo_CustLedgerEntry;"Cust. Ledger Entry"."Reversed Entry No.")
                {
                }
                column(Prepayment_CustLedgerEntry;"Cust. Ledger Entry".Prepayment)
                {
                }
                column(PaymentMethodCode_CustLedgerEntry;"Cust. Ledger Entry"."Payment Method Code")
                {
                }
                column(AppliestoExtDocNo_CustLedgerEntry;"Cust. Ledger Entry"."Applies-to Ext. Doc. No.")
                {
                }
                column(RecipientBankAccount_CustLedgerEntry;"Cust. Ledger Entry"."Recipient Bank Account")
                {
                }
                column(MessagetoRecipient_CustLedgerEntry;"Cust. Ledger Entry"."Message to Recipient")
                {
                }
                column(ExportedtoPaymentFile_CustLedgerEntry;"Cust. Ledger Entry"."Exported to Payment File")
                {
                }
                column(DimensionSetID_CustLedgerEntry;"Cust. Ledger Entry"."Dimension Set ID")
                {
                }
                column(DirectDebitMandateID_CustLedgerEntry;"Cust. Ledger Entry"."Direct Debit Mandate ID")
                {
                }
                column(CompanyINfoName;CompanyINfo.Name)
                {
                }
                column(CompanyINfoAdd;CompanyINfo.Address)
                {
                }
                column(CompanyINfoPicture;CompanyINfo.Picture)
                {
                }
                column(CustName;CustName)
                {
                }
                column(Sdate;"Surrender date")
                {
                }
                column(Samt;"Surrender Amt")
                {
                }
                column(Sdno;"Surender document No")
                {
                }
                column(Surrenderdesc;Surrenderdesc)
                {
                }
                column(issued;issued)
                {
                }
                column(surrendered;surrendered)
                {
                }

                trigger OnAfterGetRecord()
                begin

                    Surrenderdesc:='';
                    "Surrender Amt":=0;

                    //IF "Cust. Ledger Entry".Amount<0 THEN CurrReport.SKIP;
                      //IF "Cust. Ledger Entry".Reversed=TRUE THEN CurrReport.SKIP;

                      CustName:='';
                      if Customer2.Get("Cust. Ledger Entry"."Customer No.") then
                        CustName:=Customer.Name;

                    if CustLedgerEntry.Get("Cust. Ledger Entry"."Closed by Entry No.") then begin
                      "Surender document No":=CustLedgerEntry."Document No.";
                      CustLedgerEntry.CalcFields("Amount (LCY)");
                      "Surrender Amt":=CustLedgerEntry."Amount (LCY)";
                      "Surrender date":=CustLedgerEntry."Posting Date";
                      Surrenderdesc:=CustLedgerEntry.Description;
                      end;

                    CustLedgerEntry.Reset;
                    CustLedgerEntry.SetRange("Customer No.","Cust. Ledger Entry"."Customer No." );
                    if CustLedgerEntry.FindSet then begin
                      repeat
                        CustLedgerEntry.CalcFields("Amount (LCY)");
                        if CustLedgerEntry."Amount (LCY)">0 then
                        issued:=issued+CustLedgerEntry."Amount (LCY)";
                        if CustLedgerEntry."Amount (LCY)"<0 then
                        surrendered:=surrendered+CustLedgerEntry."Amount (LCY)";
                       until CustLedgerEntry.Next=0
                    end;
                    //IF "Cust. Ledger Entry"."Remaining Amount"=0 THEN
                end;
            }

            trigger OnAfterGetRecord()
            begin
                issued:=0;
                surrendered:=0;
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
    }

    trigger OnPreReport()
    begin
        CompanyINfo.Get;
        CompanyINfo.CalcFields(Picture);
        SNo:=0;
        Dim1Name:='';
        Dim2Name:='';
    end;

    var
        CompanyINfo: Record "Company Information";
        Inventory: Decimal;
        SNo: Integer;
        Item: Record Item;
        DimVal: Record "Dimension Value";
        Dim1Name: Text;
        Dim2Name: Text;
        "Surrender date": Date;
        "Surrender Amt": Decimal;
        "Surender document No": Code[10];
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Customer2: Record Customer;
        CustName: Text;
        Surrenderdesc: Text;
        issued: Decimal;
        surrendered: Decimal;
}

