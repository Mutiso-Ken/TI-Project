page 79 "Subscription List"
{
    Caption = 'Subscriptions';
    PageType = List;
    SourceTable = Subscription;
    CardPageId = "Subscription Card";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the subscription number.';
                }
                field("Service Name"; Rec."Service Name")
                {
                    ToolTip = 'Specifies the name of the subscribed service.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ToolTip = 'Specifies the vendor of the service.';
                }
                field(Category; Rec.Category)
                {
                    ToolTip = 'Specifies the category.';
                }
                field(Owner; Rec.Owner)
                {
                    ToolTip = 'Specifies who is responsible for this subscription.';
                }
                field("Next Due Date"; Rec."Next Due Date")
                {
                    ToolTip = 'Specifies when this subscription is next due.';
                    StyleExpr = DueStyleExpr;
                }
                field(DaysUntilDueLbl; Rec.DaysUntilDue())
                {
                    Caption = 'Days Until Due';
                    ToolTip = 'Specifies days remaining until due. Negative means overdue.';
                    StyleExpr = DueStyleExpr;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the billing amount.';
                }
                field("Auto Renew"; Rec."Auto Renew")
                {
                    ToolTip = 'Specifies if this renews automatically.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies whether this subscription is active or cancelled.';
                    StyleExpr = DueStyleExpr;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ShowDueSoon)
            {
                Caption = 'Show Due Soon / Overdue';
                ToolTip = 'Filters the list to subscriptions that are overdue or due within their reminder window.';
                Image = FilterLines;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.Reset();
                    Rec.SetRange(Status, Rec.Status::Active);
                    Rec.SetFilter("Next Due Date", '<>%1', 0D);
                    CurrPage.Update(false);
                end;
            }
            action(ClearFilter)
            {
                Caption = 'Show All';
                ToolTip = 'Removes all filters.';
                Image = ClearFilter;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.Reset();
                    CurrPage.Update(false);
                end;
            }
            action(PrintSubscriptionsDue)
            {
                Caption = 'Print Subscriptions Due';
                ToolTip = 'Runs the Subscriptions Due report for the subscriptions currently shown in this list.';
                Image = Print;
                ApplicationArea = All;

                trigger OnAction()
                var
                    SubscriptionRec: Record Subscription;
                begin
                    CurrPage.SetSelectionFilter(SubscriptionRec);
                    Report.RunModal(Report::"Subscriptions Due", true, false, SubscriptionRec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetDueStyle();
    end;

    local procedure SetDueStyle()
    begin
        if Rec.Status = Rec.Status::Cancelled then
            DueStyleExpr := 'Subordinate'
        else
            if Rec.IsOverdue() then
                DueStyleExpr := 'Unfavorable'
            else
                if Rec.IsDueSoon() then
                    DueStyleExpr := 'Ambiguous'
                else
                    DueStyleExpr := 'Favorable';
    end;

    var
        DueStyleExpr: Text;
}