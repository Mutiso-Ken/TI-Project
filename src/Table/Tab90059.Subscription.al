table 90059 Subscription
{
    Caption = 'Subscription';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(2; "Service Name"; Text[100])
        {
            Caption = 'Service Name';
            NotBlank = true;
        }
        field(3; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
        }
        field(4; Category; Text[50])
        {
            Caption = 'Category';
        }
        field(5; "Subscription Type"; Option)
        {
            Caption = 'Subscription Type';
            OptionMembers = Monthly,Quarterly,"Semi-Annual",Annual,Custom;
        }
        field(6; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(7; "Last Renewal Date"; Date)
        {
            Caption = 'Last Renewal Date';
            Editable = false;
        }
        field(8; "Next Due Date"; Date)
        {
            Caption = 'Next Due Date';
        }
        field(9; Amount; Decimal)
        {
            Caption = 'Amount';
            DecimalPlaces = 2 : 2;
            MinValue = 0;
        }
        field(10; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(11; "Auto Renew"; Boolean)
        {
            Caption = 'Auto Renew';
        }
        field(12; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Active,Cancelled;
            Editable = false;
        }
        field(13; Owner; Text[100])
        {
            Caption = 'Owner';
        }
        field(14; "Payment Method"; Text[50])
        {
            Caption = 'Payment Method';
        }
        field(15; "Reminder Days Before"; Integer)
        {
            Caption = 'Reminder Days Before';
            MinValue = 0;
        }
        field(16; Remarks; Text[250])
        {
            Caption = 'Remarks';
        }
        field(17; "Cancelled Date"; Date)
        {
            Caption = 'Cancelled Date';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(DueKey; "Next Due Date")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Reminder Days Before" = 0 then
            "Reminder Days Before" := 7;
        if Status <> Status::Cancelled then
            Status := Status::Active;
    end;

    procedure DaysUntilDue(): Integer
    begin
        if "Next Due Date" = 0D then
            exit(0);
        exit("Next Due Date" - Today);
    end;

    procedure IsOverdue(): Boolean
    begin
        exit((Status = Status::Active) and ("Next Due Date" <> 0D) and ("Next Due Date" < Today));
    end;

    procedure IsDueSoon(): Boolean
    begin
        exit((Status = Status::Active) and ("Next Due Date" <> 0D) and
             ("Next Due Date" >= Today) and ("Next Due Date" <= Today + "Reminder Days Before"));
    end;
}