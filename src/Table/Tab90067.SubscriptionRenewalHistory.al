table 90067 "Subscription Renewal History"
{
    Caption = 'Subscription Renewal History';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "Subscription No."; Code[20])
        {
            Caption = 'Subscription No.';
            TableRelation = Subscription;
        }
        field(3; "Renewal Date"; Date)
        {
            Caption = 'Renewal Date';
        }
        field(4; "Amount Paid"; Decimal)
        {
            Caption = 'Amount Paid';
            DecimalPlaces = 2 : 2;
        }
        field(5; "Previous Due Date"; Date)
        {
            Caption = 'Previous Due Date';
            Editable = false;
        }
        field(6; "New Due Date"; Date)
        {
            Caption = 'New Due Date';

            trigger OnValidate()
            begin
                if ("New Due Date" <> 0D) and ("Renewal Date" <> 0D) and ("New Due Date" < "Renewal Date") then
                    Error('New Due Date cannot be before the Renewal Date.');
            end;
        }
        field(7; "Renewed By"; Code[50])
        {
            Caption = 'Renewed By';
            Editable = false;
        }
        field(8; "Payment Method"; Text[50])
        {
            Caption = 'Payment Method';
        }
        field(9; Remarks; Text[250])
        {
            Caption = 'Remarks';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(SubKey; "Subscription No.", "Renewal Date")
        {
        }
    }

    trigger OnInsert()
    var
        SubscriptionRec: Record Subscription;
    begin
        if "Subscription No." = '' then
            Error('Save the subscription (enter its No. and leave the field) before adding a renewal line.');
        if not SubscriptionRec.Get("Subscription No.") then
            Error('Subscription %1 does not exist.', "Subscription No.");
        if SubscriptionRec.Status = SubscriptionRec.Status::Cancelled then
            Error('Subscription %1 is cancelled and cannot be renewed. Reactivate it first.', "Subscription No.");

        if "Renewal Date" = 0D then
            "Renewal Date" := Today;
        if "Renewed By" = '' then
            "Renewed By" := UserId;
        if "New Due Date" = 0D then
            Error('Please specify the New Due Date for this renewal before saving.');

        "Previous Due Date" := SubscriptionRec."Next Due Date";
        if ("Previous Due Date" <> 0D) and ("New Due Date" <= "Previous Due Date") then
            Error('New Due Date must be later than the current Next Due Date (%1).', "Previous Due Date");
        if "New Due Date" < "Renewal Date" then
            Error('New Due Date cannot be before the Renewal Date.');

        SubscriptionRec."Last Renewal Date" := "Renewal Date";
        SubscriptionRec."Next Due Date" := "New Due Date";
        SubscriptionRec.Modify(true);
    end;

    trigger OnModify()
    begin
        VerifySubscriptionActive();
    end;

    trigger OnDelete()
    begin
        VerifySubscriptionActive();
    end;

    local procedure VerifySubscriptionActive()
    var
        SubscriptionRec: Record Subscription;
    begin
        if SubscriptionRec.Get("Subscription No.") and (SubscriptionRec.Status = SubscriptionRec.Status::Cancelled) then
            Error('Subscription %1 is cancelled and its renewal history can no longer be changed. Reactivate it first.', "Subscription No.");
    end;
}