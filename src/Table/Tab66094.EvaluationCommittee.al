#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
table 66094 "Evaluation Committee"
{
    // version Procurement Iansoft


    fields
    {
        field(1; "Reference No"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "User Name"; Code[70])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID";

            trigger OnValidate();
            begin
                IF UserSetup.GET("User Name") THEN BEGIN
                    UserSetup.TESTFIELD("Employee no");
                    "Employee No." := UserSetup."Employee no";
                    VALIDATE("Employee No.");
                END;
            end;
        }
        field(3; "Employee No."; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate();
            begin
                IF Employee.GET("Employee No.") THEN
                    "Employee Name" := COPYSTR(Employee."First Name" + ' ' + Employee."Last Name", 1, MAXSTRLEN("Employee Name"))
                ELSE
                    "Employee Name" := '';
            end;
        }
        field(4; "Employee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Submitted Mandatory Evaluation"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Submitted Technical Evaluation"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(7; Substitute; Code[70])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Substitute Employee No."; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnLookup();
            begin
                IF UserSetup.GET(Substitute) THEN BEGIN
                    UserSetup.TESTFIELD("Employee no");
                    "Substitute Employee No." := UserSetup."Employee no";
                    VALIDATE("Substitute Employee No.");
                END;
            end;

            trigger OnValidate();
            begin
                IF Employee.GET("Substitute Employee No.") THEN
                    "Substitute Employee Name" := COPYSTR(Employee."First Name" + ' ' + Employee."Last Name", 1, MAXSTRLEN("Substitute Employee Name"))
                ELSE
                    "Substitute Employee Name" := '';
            end;
        }
        field(9; "Substitute Employee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; Stage; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = '" ,Mandatory,Technical"';
            OptionMembers = " ",Mandatory,Technical;
        }
    }

    keys
    {
        key(Key1; "Reference No", "User Name", Stage)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        IF ProcurementRequest.GET("Reference No") THEN BEGIN
            ProcurementRequest.TESTFIELD("Tender Status", ProcurementRequest."Tender Status"::Advertised);
        END;
    end;

    var
        UserSetup: Record "User Setup";
        Employee: Record "HR Employees";
        ProcurementRequest: Record "Procurement Request";
}
