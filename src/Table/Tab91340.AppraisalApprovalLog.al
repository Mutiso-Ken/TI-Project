table 91340 "Appraisal Approval Log"
{
    Caption = 'Appraisal Approval Log';
    DataClassification = ToBeClassified;

    // Append-only history of every submit/approve/reject on an appraisal.
    // "Appraisal Approvals Tracking" only keeps the latest decision per approver, so it cannot be used for audit.
    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "Appraisal Code"; Code[50])
        {
            TableRelation = "Appraisal Header"."Appraisal Code";
        }
        field(3; Action; Option)
        {
            OptionMembers = Submitted,Approved,Rejected;
        }
        field(4; "Approver Code"; Code[50])
        {
        }
        field(5; "Approver Name"; Text[300])
        {
        }
        field(6; "Approver Role"; Text[50])
        {
        }
        field(7; Comment; Text[2048])
        {
        }
        field(8; "Action Date"; Date)
        {
        }
        field(9; "Action Time"; Time)
        {
        }
        field(10; "User ID"; Code[50])
        {
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(AppraisalKey; "Appraisal Code", "Entry No.")
        {
        }
    }
}
