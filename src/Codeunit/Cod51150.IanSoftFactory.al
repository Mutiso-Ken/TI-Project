codeunit 51150 "IanSoftFactory"
{
    procedure FnDirectPostingControl(AccountNo: Code[20]);
    begin
    end;

    var
        GlSetUp: Record "General Ledger Setup";

    procedure IanGetBudgetedAmount(GLAccount: Code[20]; BudgetYear: Code[20]; Station: Code[20]; Department: Code[20]) Amount: Decimal;
    var
        BudgetEntryLine: Record "G/L Budget Entry";

    begin
        Amount := 0;
        GlSetUp.GET;

        IF (Station = '') AND (Department = '') THEN BEGIN
            BudgetEntryLine.RESET;
            BudgetEntryLine.SETRANGE("G/L Account No.", GLAccount);
            BudgetEntryLine.SETRANGE("Budget Name", BudgetYear);
            BudgetEntryLine.SETRANGE(Date, GlSetUp."Current Budget Start Date", GlSetUp."Current Budget End Date");
            IF BudgetEntryLine.FINDSET THEN BEGIN
                BudgetEntryLine.CALCSUMS(Amount);
                Amount := BudgetEntryLine.Amount;
            END;
        END;

        IF (Station = '') AND (Department <> '') THEN BEGIN
            BudgetEntryLine.RESET;
            BudgetEntryLine.SETRANGE("G/L Account No.", GLAccount);
            BudgetEntryLine.SETRANGE("Budget Name", BudgetYear);
            BudgetEntryLine.SETRANGE(Date, GlSetUp."Current Budget Start Date", GlSetUp."Current Budget End Date");
            BudgetEntryLine.SETRANGE("Global Dimension 1 Code", Department);
            IF BudgetEntryLine.FINDSET THEN BEGIN
                BudgetEntryLine.CALCSUMS(Amount);
                Amount := BudgetEntryLine.Amount;
            END;
        END;

        IF (Station <> '') AND (Department = '') THEN BEGIN
            BudgetEntryLine.RESET;
            BudgetEntryLine.SETRANGE("G/L Account No.", GLAccount);
            BudgetEntryLine.SETRANGE("Budget Name", BudgetYear);
            BudgetEntryLine.SETRANGE(Date, GlSetUp."Current Budget Start Date", GlSetUp."Current Budget End Date");
            BudgetEntryLine.SETRANGE("Global Dimension 2 Code", Station);
            IF BudgetEntryLine.FINDSET THEN BEGIN
                BudgetEntryLine.CALCSUMS(Amount);
                Amount := BudgetEntryLine.Amount;
            END;
        END;

        IF (Station <> '') AND (Department <> '') THEN BEGIN
            BudgetEntryLine.RESET;
            BudgetEntryLine.SETRANGE("G/L Account No.", GLAccount);
            BudgetEntryLine.SETRANGE("Budget Name", BudgetYear);
            BudgetEntryLine.SETRANGE(Date, GlSetUp."Current Budget Start Date", GlSetUp."Current Budget End Date");
            BudgetEntryLine.SETRANGE("Global Dimension 1 Code", Department);
            //BudgetEntryLine.SETRANGE("Global Dimension 2 Code",Station);
            IF BudgetEntryLine.FINDSET THEN BEGIN
                BudgetEntryLine.CALCSUMS(Amount);
                Amount := BudgetEntryLine.Amount;
            END;
        END;


        EXIT(Amount);
    end;

    procedure IanGetTotalExpenditure(GLAccount: Code[20]; BudgetYear: Code[20]; Station: Code[20]; Department: Code[20]) Amount: Decimal;
    var
        BudgetEntryLine: Record "G/L Entry";
    begin
        GlSetUp.GET;
        Amount := 0;

        IF (Station = '') AND (Department = '') THEN BEGIN
            BudgetEntryLine.RESET;
            BudgetEntryLine.SETRANGE("G/L Account No.", GLAccount);
            BudgetEntryLine.SETRANGE("Budget Code", BudgetYear);
            BudgetEntryLine.SETRANGE("Posting Date", GlSetUp."Current Budget Start Date", GlSetUp."Current Budget End Date");
            IF BudgetEntryLine.FINDSET THEN
                REPEAT
                    Amount := Amount + BudgetEntryLine.Amount;
                UNTIL BudgetEntryLine.NEXT = 0;
        END;

        IF (Station = '') AND (Department <> '') THEN BEGIN
            BudgetEntryLine.RESET;
            BudgetEntryLine.SETRANGE("G/L Account No.", GLAccount);
            BudgetEntryLine.SETRANGE("Budget Code", BudgetYear);
            BudgetEntryLine.SETRANGE("Posting Date", GlSetUp."Current Budget Start Date", GlSetUp."Current Budget End Date");
            BudgetEntryLine.SETRANGE("Global Dimension 1 Code", Department);
            IF BudgetEntryLine.FINDSET THEN
                REPEAT
                    Amount := Amount + BudgetEntryLine.Amount;
                UNTIL BudgetEntryLine.NEXT = 0;
        END;

        IF (Station <> '') AND (Department = '') THEN BEGIN
            BudgetEntryLine.RESET;
            BudgetEntryLine.SETRANGE("G/L Account No.", GLAccount);
            BudgetEntryLine.SETRANGE("Budget Code", BudgetYear);
            BudgetEntryLine.SETRANGE("Posting Date", GlSetUp."Current Budget Start Date", GlSetUp."Current Budget End Date");
            BudgetEntryLine.SETRANGE("Global Dimension 2 Code", Station);
            IF BudgetEntryLine.FINDSET THEN
                REPEAT
                    Amount := Amount + BudgetEntryLine.Amount;
                UNTIL BudgetEntryLine.NEXT = 0;
        END;

        IF (Station <> '') AND (Department <> '') THEN BEGIN
            BudgetEntryLine.RESET;
            BudgetEntryLine.SETRANGE("G/L Account No.", GLAccount);
            BudgetEntryLine.SETRANGE("Budget Code", BudgetYear);
            BudgetEntryLine.SETRANGE("Posting Date", GlSetUp."Current Budget Start Date", GlSetUp."Current Budget End Date");
            BudgetEntryLine.SETRANGE("Global Dimension 1 Code", Department);
            BudgetEntryLine.SETRANGE("Global Dimension 2 Code", Station);
            IF BudgetEntryLine.FINDSET THEN
                REPEAT
                    Amount := Amount + BudgetEntryLine.Amount;
                UNTIL BudgetEntryLine.NEXT = 0;
        END;


        EXIT(Amount);
    end;

    procedure IanGetCommittedAmount(GLAccountNo: Code[20]; BudgetCode: Code[20]; Department: Code[20]; ProjectCode: Code[20]): Decimal;
    begin
        exit(0);
    end;

    procedure IanGetAccountToCommit(TypeParam: Option "G/L Account","Fixed Asset",Item; TypeNo: Code[50]) AccountNo: Code[50];
    var
        Item: Record Item;
        FixedAsset: Record "Fixed Asset";
        GLAccount: Record "G/L Account";
        FAPostingGroup: Record "FA Posting Group";
        InventoryPostingGroup: Record "Inventory Posting Group";
        InventoryPostingSetup: Record "Inventory Posting Setup";
    begin
        if TypeParam = TypeParam::"Fixed Asset" then begin
            if FixedAsset.Get(TypeNo) then
                if FAPostingGroup.Get(FixedAsset."FA Posting Group") then
                    AccountNo := FAPostingGroup."Acquisition Cost Account";
        end;

        if TypeParam = TypeParam::Item then begin
            if Item.Get(TypeNo) then
                if InventoryPostingGroup.Get(Item."Inventory Posting Group") then begin
                    InventoryPostingSetup.Reset();
                    InventoryPostingSetup.SetRange("Invt. Posting Group Code", InventoryPostingGroup.Code);
                    if InventoryPostingSetup.FindFirst() then
                        AccountNo := InventoryPostingSetup."Inventory Account";
                end;
        end;

        if TypeParam = TypeParam::"G/L Account" then
            if GLAccount.Get(TypeNo) then
                if GLAccount."Income/Balance" = GLAccount."Income/Balance"::"Income Statement" then
                    AccountNo := GLAccount."No.";

        exit(AccountNo);
    end;

    procedure IanSendEmailWithoutAttachement(SenderName: Text; SenderAddress: Text; Recipients: Text; Subject: Text; Body: Text);
    begin
        // IF (Recipients <> '') AND (Subject <> '') AND (Body <> '') THEN BEGIN
        //     GlSetUp.GET;
        //     IF NOT GlSetUp."Deactivate Mails" THEN
        //         Clear(SendToList);
        //     SendToList.Add(Recipients);
        //     SMTPMail.Create(SendToList, Subject, Body, true);
        //     SendEmail.Send(SMTPMail, Enum::"Email Scenario"::Default);
        // END;
    end;
}
