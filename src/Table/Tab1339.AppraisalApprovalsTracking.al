table 1339 "Appraisal Approvals Tracking"
{
    Caption = 'Appraisal Lines Section D';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Appraisal Code"; Code[100])
        {
            Caption = 'Appraisal Code';
            TableRelation = "Appraisal Header"."Appraisal Code";
        }
        field(3; "Supervisor Code"; Code[50])
        {
        }
        field(4; Approved; Boolean)
        {
        }
        field(5; "Supervisor Comment"; Text[2048])
        {
            Caption = 'Remarks by Supervisor';
        }
        field(6; "Update Date"; Date) { }
        field(7; "Update Time"; Time) { }
    }
    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
    }
}
