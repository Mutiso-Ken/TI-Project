#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 80040 "Training Schedule"
{

    fields
    {
        field(1; Year; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Facilitator; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Department/Organization"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Topic; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Total Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Scheduled date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "No. of Staff trained"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Evidence of training"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = ,Pending,Done;
        }
        field(10; "Updated By"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Updated On"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Year, Topic)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        HRSetup.Get;
        if HRSetup."Open Training" = false then
            Error('The training calendar has not been opened for modification');


        "Updated By" := UserId;
        "Updated On" := Today;
    end;

    trigger OnModify()
    begin
        HRSetup.Get;
        if HRSetup."Open Training" = false then
            Error('The training calendar has not been opened for modification');


        "Updated By" := UserId;
        "Updated On" := Today;
    end;

    var
        HRSetup: Record "HR Setup";
}

