#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 80027 "HR Setup"
{

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "Employee Nos."; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(3; "Training Application Nos."; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(4; "Leave Application Nos."; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(6; "Disciplinary Cases Nos."; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(7; "Base Calendar"; Code[10])
        {
            TableRelation = "Base Calendar";
        }
        field(8; "Job Nos"; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(13; "Transport Req Nos"; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(14; "Employee Requisition Nos."; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(15; "Leave Posting Period[FROM]"; Date)
        {
        }
        field(16; "Leave Posting Period[TO]"; Date)
        {
        }
        field(17; "Job Application Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(18; "Exit Interview Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(19; "Appraisal Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(20; "Company Activities"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(21; "Default Leave Posting Template"; Code[10])
        {
            TableRelation = "HR Leave Journal Batch"."Journal Template Name";
        }
        field(22; "Positive Leave Posting Batch"; Code[10])
        {
            TableRelation = "HR Leave Journal Batch".Name;
        }
        field(23; "Leave Template"; Code[10])
        {
            TableRelation = "HR Leave Journal Template".Name;
        }
        field(24; "Leave Batch"; Code[10])
        {
            TableRelation = "HR Leave Journal Batch".Name;
        }
        field(25; "Job Interview Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(26; "Company Documents"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(27; "HR Policies"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(28; "Notice Board Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(29; "Leave Reimbursment Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(30; "Min. Leave App. Months"; Integer)
        {
            Caption = 'Minimum Leave Application Months';
        }
        field(31; "Negative Leave Posting Batch"; Code[10])
        {
            TableRelation = "HR Leave Journal Batch".Name;
        }
        field(32; "Appraisal Method"; Option)
        {
            OptionCaption = ' ,Normal Appraisal,360 Appraisal';
            OptionMembers = " ","Normal Appraisal","360 Appraisal";
        }
        field(50000; "Loan Application Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50001; "Leave Carry Over App Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50002; "Pay-change No."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50003; "Max Appraisal Rating"; Decimal)
        {
        }
        field(50004; "Medical Claims Nos"; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(50005; "Employee Transfer Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50006; "Leave Planner Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50007; "Deployed Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50008; "Full Time Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50009; "Board Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50010; "Committee Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50011; "Training Analysis Nos"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50012; "Training GL"; Code[50])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(50013; "Open Training"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "Notice Board"; Text[2000])
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "Appreciation Title"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50016; "Employee Picture"; Blob)
        {
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(50017; "Appreciation Narration"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50018; "Appraisal Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50019; Email; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50020; "Feedback Email"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50021; "Timesheet Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50022; "Ticket Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Error('cannot delete');
    end;
}

