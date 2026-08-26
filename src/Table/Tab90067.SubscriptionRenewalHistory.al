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
        if "Renewal Date" = 0D then
            "Renewal Date" := Today;
        if "Renewed By" = '' then
            "Renewed By" := UserId;
        if "New Due Date" = 0D then
            Error('Please specify the New Due Date for this renewal before saving.');

        if SubscriptionRec.Get("Subscription No.") then begin
            "Previous Due Date" := SubscriptionRec."Next Due Date";
            SubscriptionRec."Last Renewal Date" := "Renewal Date";
            SubscriptionRec."Next Due Date" := "New Due Date";
            SubscriptionRec.Modify(true);
        end;
    end;
}