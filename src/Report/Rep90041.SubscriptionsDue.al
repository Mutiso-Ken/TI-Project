report 90041 "Subscriptions Due"
{
    Caption = 'Subscriptions Due';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/SubscriptionsDue.rdlc';

    dataset
    {
        dataitem(Subscription; Subscription)
        {
            RequestFilterFields = Status, Category, "Next Due Date";
            column(No_; "No.") { }
            column(ServiceName; "Service Name") { }
            column(VendorName; "Vendor Name") { }
            column(CategoryFld; Category) { }
            column(OwnerFld; Owner) { }
            column(NextDueDate; "Next Due Date") { }
            column(DaysUntilDue; "Next Due Date" - Today) { }
            column(AmountFld; Amount) { }
            column(CurrencyCodeFld; "Currency Code") { }
            column(AutoRenewFld; "Auto Renew") { }
            column(StatusText; Format(Status)) { }

            trigger OnPreDataItem()
            begin
                if DueWithinDaysFilter > 0 then
                    SetFilter("Next Due Date", '<=%1', Today + DueWithinDaysFilter);
                if not ShowCancelledFilter then
                    SetRange(Status, Status::Active);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(DueWithinDays; DueWithinDaysFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Due Within (Days)';
                        ToolTip = 'Shows only subscriptions due within this many days. Leave blank to show all.';
                    }
                    field(ShowCancelled; ShowCancelledFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Include Cancelled Subscriptions';
                        ToolTip = 'If checked, cancelled subscriptions are included in the report.';
                    }
                }
            }
        }
    }

    var
        DueWithinDaysFilter: Integer;
        ShowCancelledFilter: Boolean;
}