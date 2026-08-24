#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
table 66006 "Procurement Plan Initiation"
{
    // version Procurement Iansoft


    fields
    {
        field(2; "Plan Name"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Financial Year"; Code[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Created By"; Code[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Employee No"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate();
            begin
                IF Employee.GET("Employee No") THEN
                    "Employee Name" := COPYSTR(Employee."First Name" + ' ' + Employee."Last Name", 1, MAXSTRLEN("Employee Name"))
                ELSE
                    "Employee Name" := '';
            end;
        }
        field(6; "Employee Name"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; Initiated; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(8; "Current Budget"; Code[70])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "G/L Budget Name".Name;
        }
        field(9; "Date Created"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Initiated By"; Code[70])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Initiated On"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Plan Period"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = '" ,Monthly,Quartely,Yearly"';
            OptionMembers = " ",Monthly,Quartely,Yearly;
        }
        field(13; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Plan Name")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        IF UserSetup.GET(USERID) THEN BEGIN
            UserSetup.TESTFIELD("Employee no");
            "Employee No" := UserSetup."Employee no";
            VALIDATE("Employee No");
        END;

        GeneralLedgerSetup.GET();
        GeneralLedgerSetup.TESTFIELD("Current Budget");
        GeneralLedgerSetup.TESTFIELD("Current Budget Start Date");
        GeneralLedgerSetup.TESTFIELD("Current Budget End Date");
        "Current Budget" := GeneralLedgerSetup."Current Budget";
        "Financial Year" := FORMAT(DATE2DMY(TODAY, 3));
        "Created By" := USERID;
        "Date Created" := TODAY;
    end;

    var
        Employee: Record "HR Employees";
        UserSetup: Record "User Setup";
        GeneralLedgerSetup: Record "General Ledger Setup";
}
