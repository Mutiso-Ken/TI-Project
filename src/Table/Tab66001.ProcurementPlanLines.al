#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
table 66001 "Procurement Plan Lines"
{

    fields
    {
        field(1; "Plan No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(3; Category; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Goods,Services,work';
            OptionMembers = Goods,Services,work;
        }
        field(4; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = '" ,Service,Fixed Asset,Item"';
            OptionMembers = " ",Service,"Fixed Asset",Item;

            trigger OnValidate();
            begin
                IF Type = Type::Service THEN BEGIN
                    TESTFIELD("Item Category", 'Services');
                END;
            end;
        }
        field(5; No; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF (Type = CONST(Service)) "Proc. Line Service Types".Code
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"."No."
            ELSE
            IF (Type = CONST(Item)) Item."No.";

            trigger OnValidate();
            begin
                IF FixedAsset.GET(No) THEN BEGIN
                    Name := FixedAsset.Description;
                END;

                IF Item.GET(No) THEN BEGIN
                    Name := Item.Description;
                    "Unit of Measure" := Item."Base Unit of Measure";
                END;

                IF No <> '' THEN BEGIN
                    ProcurementPlanHeader.GET("Plan No.", "Global Dimension 2 Code", ProcurementPlanHeader.Type);
                    "Budget Account" := IanSoftFactory.IanGetAccountToCommit(Type, No);
                    "Budgeted Amount" := IanSoftFactory.IanGetBudgetedAmount("Budget Account", ProcurementPlanHeader."Current Budget",
                                                                            ProcurementPlanHeader."Global Dimension 2 Code",
                                                                            ProcurementPlanHeader."Global Dimension 1 Code");
                    "Total Expenditure" := IanSoftFactory.IanGetTotalExpenditure("Budget Account", ProcurementPlanHeader."Current Budget",
                                                                            ProcurementPlanHeader."Global Dimension 2 Code",
                                                                            ProcurementPlanHeader."Global Dimension 1 Code");

                    "Total Committed Amount" := IanSoftFactory.IanGetCommittedAmount("Budget Account", ProcurementPlanHeader."Current Budget",
                                                                            ProcurementPlanHeader."Global Dimension 2 Code",
                                                                            ProcurementPlanHeader."Global Dimension 1 Code");

                    "Available Amount" := "Budgeted Amount" - ("Total Expenditure" + "Total Committed Amount");
                END;

                IF ProcLineServiceTypes.GET(No) THEN BEGIN
                    Name := ProcLineServiceTypes."Service Name";
                    "Budget Account" := ProcLineServiceTypes."G/L Account";
                END;
            end;
        }
        field(6; Name; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Procurement Method"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = '" ,Tender,RFQ,Direct Procurement,RFP,Low Value,Contract Framework"';
            OptionMembers = " ",Tender,RFQ,"Direct Procurement",RFP,"Low Value","Contract Framework";
        }
        field(9; "Unit of Measure"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure";
        }
        field(10; Quantity; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                Quantity := ABS(Quantity);
                "Total Amount" := Quantity * "Unit Price";
            end;
        }
        field(11; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                "Unit Price" := ABS("Unit Price");
                "Total Amount" := Quantity * "Unit Price";
                VALIDATE("Total Amount");
            end;
        }
        field(12; "Total Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                IF "Total Amount" > "Available Amount" THEN BEGIN
                    Unbudgeted := TRUE;
                    MESSAGE('Exceeds budget by [%1]', ABS("Total Amount" - "Available Amount"));
                END ELSE
                    Unbudgeted := FALSE;
            end;
        }
        field(13; "Expected Date of Procurement"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                IF "Expected Date of Procurement" = 0D THEN
                    EXIT;
                IF ProcurementPlanHeader.GET("Plan No.") THEN
                    IF "Expected Date of Procurement" > ProcurementPlanHeader."End Date" THEN
                        ERROR('Date cannot be greater than %1', ProcurementPlanHeader."End Date");
            end;
        }
        field(14; "Budgeted Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Total Expenditure"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Total Committed Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Available Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(18; Unbudgeted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Budget Account"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Global Dimension 2 Code"; Code[50])
        {
            CaptionClass = '1,1,2';
            DataClassification = ToBeClassified;
        }
        field(70000; Quarter; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Q1,Q2,Q3,Q4';
            OptionMembers = Q1,Q2,Q3,Q4;
        }
        field(70001; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(70002; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(70003; "Item Category"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Categories"."Category Code";
        }
        field(70004; "Item Sub-Category"; Code[50])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup();
            begin
                ItemSubCategoriesRec.RESET;
                ItemSubCategoriesRec.SETRANGE("Category Code", "Item Category");
                IF PAGE.RUNMODAL(PAGE::"Item Sub Categories", ItemSubCategoriesRec) = ACTION::LookupOK THEN BEGIN
                    ItemSubCategoriesPage.EDITABLE(FALSE);
                    "Item Sub-Category" := ItemSubCategoriesRec.Description;
                END;
            end;
        }
        field(80000; "Budget Exceed"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(80001; "Plan Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Original,Revision';
            OptionMembers = Original,Revision;
        }
    }

    keys
    {
        key(Key1; "Plan No.", "Line No", "Global Dimension 2 Code", "Plan Type")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        IF ProcurementPlanHeader.GET(Rec."Plan No.") THEN
            "Plan Type" := ProcurementPlanHeader.Type;
    end;

    var
        GLAccount: Record "G/L Account";
        Item: Record "Item";
        FixedAsset: Record "Fixed Asset";
        IanSoftFactory: Codeunit "IanSoftFactory";
        CurrentBudget: Code[10];
        ProcurementPlanHeader: Record "Procurement Plan Header";
        ItemSubCategoriesRec: Record "Item Sub Categories";
        ItemSubCategoriesPage: Page "Item Sub Categories";
        ProcLineServiceTypes: Record "Proc. Line Service Types";
}
