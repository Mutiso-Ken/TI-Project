#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
table 66000 "Procurement Plan Header"
{

    DrillDownPageID = "Procurement Plan List PA";
    LookupPageID = "Procurement Plan List PA";

    fields
    {
        field(1; Name; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(3; "Global Dimension 1 Code"; Code[50])
        {
            CaptionClass = '1,1,1';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = filter(false));
        }
        field(4; "Global Dimension 2 Code"; Code[50])
        {
            CaptionClass = '1,1,2';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(5; "Employee No"; Code[10])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                IF Employee.GET("Employee No") THEN
                    "Employee Name" := COPYSTR(Employee."First Name" + ' ' + Employee."Last Name", 1, MAXSTRLEN("Employee Name"));
            end;
        }
        field(6; "Employee Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Date Created"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Created By"; Code[70])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Date Approved"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; Consolidated; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Financial Year"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Current Budget"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(16; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Original,Revision';
            OptionMembers = Original,Revision;
        }
        field(17; "Approval Entries"; Integer)
        {
            CalcFormula = Count("Approval Entry" WHERE("Document No." = FIELD(Name)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; Name, "Global Dimension 2 Code", Type)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        IF Name = '' THEN BEGIN
            ProcurementSetup.GET;
            ProcurementSetup.TESTFIELD("Procurement Plan  Nos");
            Name := NoSeriesManagement.GetNextNo(ProcurementSetup."Procurement Plan  Nos", 0D, true);
        END;

        IF UserSetup.GET(USERID) THEN BEGIN
            UserSetup.TESTFIELD("Employee no");
            "Employee No" := UserSetup."Employee no";
            VALIDATE("Employee No");
        END ELSE
            ERROR('User Id %1 is not in user user setup', USERID);

        "Created By" := USERID;
        "Date Created" := TODAY;

        IF Type IN [Type::Revision] THEN BEGIN
            ProcurementSetup.GET;
            ProcurementSetup.TESTFIELD("Current Procurement Plan");
            Name := ProcurementSetup."Current Procurement Plan";
        END;
    end;

    var
        ProcurementSetup: Record "Procurement Setup";
        NoSeriesManagement: Codeunit "No. Series";
        Employee: Record "HR Employees";
        UserSetup: Record "User Setup";
}
