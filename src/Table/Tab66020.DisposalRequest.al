#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
table 66020 "Disposal Request"
{

    DrillDownPageID = "Disposal Request List Approved";
    LookupPageID = "Disposal Request List Approved";

    fields
    {
        field(1; "Disposal No"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Employee No"; Code[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                IF Employee.GET("Employee No") THEN
                    "Emploayee Name" := COPYSTR(Employee."First Name" + ' ' + Employee."Last Name", 1, MAXSTRLEN("Emploayee Name"));
            end;
        }
        field(3; "Emploayee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Created By"; Code[70])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Created On"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "No. Series"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(8; "Order Created By"; Code[70])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Order Created"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Date Order Created"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Suggested Customer"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";

            trigger OnValidate();
            begin
                IF Customer.GET("Suggested Customer") THEN
                    "Customer Name" := Customer.Name;
            end;
        }
        field(12; "Customer Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Global Dimension 1 Code"; Code[50])
        {
            CaptionClass = '1,1,1';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(14; "Global Dimension 2 Code"; Code[50])
        {
            CaptionClass = '1,1,2';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
    }

    keys
    {
        key(Key1; "Disposal No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        IF "Disposal No" = '' THEN BEGIN
            ProcurementSetup.GET;
            ProcurementSetup.TESTFIELD("Disposal Request Nos");
            "Disposal No" := NoSeriesManagement.GetNextNo(ProcurementSetup."Disposal Request Nos", 0D, true);
        END;

        IF UserSetup.GET(USERID) THEN BEGIN
            UserSetup.TESTFIELD("Employee no");
            "Employee No" := UserSetup."Employee no";
            VALIDATE("Employee No");
        END;

        "Created By" := USERID;
        "Created On" := TODAY;
    end;

    var
        ProcurementSetup: Record "Procurement Setup";
        NoSeriesManagement: Codeunit "No. Series";
        UserSetup: Record "User Setup";
        Employee: Record "HR Employees";
        Customer: Record "Customer";
}
