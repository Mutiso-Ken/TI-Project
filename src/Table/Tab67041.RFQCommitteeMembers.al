table 67041 "RFQ Committee Members"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "RFQ No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Committee UserID"; Code[100])
        {
            Caption = 'User ID';
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID" where("Procurement Committee Member" = const(true));

            trigger OnValidate()
            var
                UserSetup: Record "User Setup";
            begin
                if UserSetup.Get("Committee UserID") then begin
                    UserSetup.TestField("Employee no");
                    UserSetup.CalcFields("Full Name");
                    "Employee No." := UserSetup."Employee no";
                    "Committee Member Name" := UserSetup."Full Name";
                end;
            end;
        }
        field(3; "Employee No."; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Employees"."No." where("Procurement Comm. Member" = const(true), Status = filter(Active));

            trigger OnValidate()
            var
                HREmployee: Record "HR Employees";
            begin
                if HREmployee.Get("Employee No.") then
                    "Committee Member Name" := CopyStr(HREmployee."First Name" + ' ' + HREmployee."Last Name", 1, MaxStrLen("Committee Member Name"));
            end;
        }
        field(4; "Committee Member Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Email Sent"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "RFQ No.", "Committee UserID", "Employee No.")
        {
        }
    }
}
