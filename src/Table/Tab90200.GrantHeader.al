table 90200 "Grant Header"
{
    DataCaptionFields = "No.", Title, Narration, "Donor Name";
    DrillDownPageID = "Grant Lookup";
    LookupPageID = "Grant Lookup";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            Editable = false;
        }
        field(2; "Created By"; Code[50])
        {
            Caption = 'Created By';

            Editable = false;
        }
        field(3; "Created Date"; Date)
        {

            Editable = false;
        }
        field(4; Title; Text[100])
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                Dimvalue.Reset();
                Dimvalue.SetRange("Dimension Code", 'GRANT');
                Dimvalue.SetRange(Code, "No.");
                if not Dimvalue.FindFirst() then begin
                    Dimvalue.init;
                    Dimvalue.Code := "No.";
                    Dimvalue."Dimension Code" := 'GRANT';
                    Dimvalue.Name := Title;
                    Dimvalue."Global Dimension No." := 3;
                    Dimvalue.Description := Title;
                    Dimvalue.Insert(true)
                end else begin
                    Dimvalue.Name := Title;
                    Dimvalue.Description := Title;
                    Dimvalue.Modify(true);
                end;
            end;
        }
        field(5; Narration; Text[250])
        {

        }
        field(6; Status; Option)
        {

            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(7; "No. Series"; Code[20])
        {

            TableRelation = "No. Series";
        }
        field(8; "Donor No."; Code[20])
        {

            TableRelation = "Dimension Value".code where("Dimension Code" = filter('DONOR'));

            trigger OnValidate();
            begin
                Dimvalue.Reset();
                Dimvalue.SetRange(Code, "Donor No.");
                if Dimvalue.FindFirst() then
                    "Donor Name" := Dimvalue.Name;
            END;
        }
        field(9; "Donor Name"; Text[100])
        {

            Editable = false;
        }
        field(10; Goal; Text[400])
        {

        }
        field(11; "Grant Created"; Boolean)
        {

        }
        field(12; "Starting Date"; Date)
        {

        }
        field(13; "Ending Date"; Date)
        {

        }
        field(14; "Project Manager"; Code[50])
        {
            Caption = 'Project Manager';

            TableRelation = "User Setup";
        }
        field(15; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';

            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate();
            begin
            end;
        }
        field(16; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';

            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate();
            begin
            end;
        }
        field(17; "Consolidation Budget"; Code[20])
        {

            TableRelation = "G/L Budget Name".Name;
        }
        field(18; "Approval Status"; Option)
        {

            Editable = false;
            OptionCaption = 'New,Approval Pending,Approved';
            OptionMembers = New,"Approval Pending",Approved;
        }
        field(19; "Grant Incomes"; Decimal)
        {
            CalcFormula = - Sum("G/L Entry".Amount WHERE("Shortcut Dimension 3 Code" = FIELD("No."),
                                                         "G/L Account No." = FIELD(FILTER("Income Accounts"))));
            Editable = false;
            FieldClass = FlowField;
        }

        field(20; "Income Accounts"; Text[250])
        {
            Caption = 'Income Accounts';

            trigger OnValidate();
            begin
                CALCFIELDS("Grant Expenditure");
                CALCFIELDS("Grant Incomes");
            end;
        }
        field(21; "Expense Accounts"; Text[250])
        {
            Caption = 'Expense Accounts';


            trigger OnValidate();
            begin
                CALCFIELDS("Grant Expenditure");
                CALCFIELDS("Grant Incomes");
            end;
        }
        field(22; "Grant Expenditure"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Shortcut Dimension 3 Code" = FIELD("No."),
                                                        "G/L Account No." = FIELD(FILTER("Expense Accounts"))));
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; "Grant Budget"; Decimal)
        {
            CalcFormula = Sum("Grant Detail Lines"."Total Cost" WHERE("Grant Code" = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(24; Blocked; Boolean)
        {
            trigger OnValidate()
            var
                dimvalue: Record "Dimension Value";
            begin
                if Blocked = true then begin
                    dimvalue.Reset();
                    dimvalue.SetRange(Code, "No.");
                    if dimvalue.FindFirst() then
                        dimvalue.Blocked := true;
                end;

            end;

        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; Title)
        {
        }
        key(Key3; Narration)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Title, Narration)
        {
        }
    }

    trigger OnDelete();
    begin
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD("Grant Admin", TRUE);
    end;

    trigger OnInsert();
    begin
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD("Grant Admin", TRUE);
        GeneralLedgerSetup.GET;
        GeneralLedgerSetup.TESTFIELD("Grant Nos.");
        "No." := NoSeriesManagement.GetNextNo(GeneralLedgerSetup."Grant Nos.", TODAY, TRUE);
        "Created By" := USERID;
        "Created Date" := TODAY;
    end;

    trigger OnModify();
    begin
        UserSetup.GET(USERID);
    end;

    trigger OnRename();
    begin
        UserSetup.GET(USERID);
    end;

    var
        Customer: Record Customer;

        Dimvalue: Record "Dimension Value";

        GeneralLedgerSetup: Record "General Ledger Setup";
        NoSeriesManagement: Codeunit "No. Series";
        UserSetup: Record "User Setup";
}
