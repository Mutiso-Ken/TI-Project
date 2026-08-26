page 90078 "Subscription Card"
{
    Caption = 'Subscription Card';
    PageType = Card;
    SourceTable = Subscription;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the unique number for this subscription.';
                }
                field("Service Name"; Rec."Service Name")
                {
                    ToolTip = 'Specifies the name of the subscribed service.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ToolTip = 'Specifies the vendor or provider of the service.';
                }
                field(Category; Rec.Category)
                {
                    ToolTip = 'Specifies the category this subscription belongs to.';
                }
                field(Owner; Rec.Owner)
                {
                    ToolTip = 'Specifies who is responsible for this subscription.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies whether this subscription is active or cancelled.';
                }
            }
            group(Billing)
            {
                Caption = 'Billing';

                field("Subscription Type"; Rec."Subscription Type")
                {
                    ToolTip = 'Specifies the billing frequency.';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the amount charged per billing cycle.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the currency of the amount.';
                }
                field("Payment Method"; Rec."Payment Method")
                {
                    ToolTip = 'Specifies how this subscription is paid.';
                }
                field("Auto Renew"; Rec."Auto Renew")
                {
                    ToolTip = 'Specifies if this subscription renews automatically.';
                }
            }
            group(Dates)
            {
                Caption = 'Dates';

                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies when this subscription started.';
                }
                field("Last Renewal Date"; Rec."Last Renewal Date")
                {
                    ToolTip = 'Specifies the date of the most recent renewal.';
                }
                field("Next Due Date"; Rec."Next Due Date")
                {
                    ToolTip = 'Specifies when this subscription is next due for renewal.';
                }
                field("Reminder Days Before"; Rec."Reminder Days Before")
                {
                    ToolTip = 'Specifies how many days before the due date this should show as due soon.';
                }
                field(DaysUntilDueLbl; Rec.DaysUntilDue())
                {
                    Caption = 'Days Until Due';
                    ToolTip = 'Specifies the number of days remaining until this subscription is due. Negative means overdue.';
                    Editable = false;
                    StyleExpr = DueStyleExpr;
                }
            }
            group(Notes)
            {
                Caption = 'Notes';
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies any remarks about this subscription.';
                }
            }
            part("Renewal History"; "Subscription Renewal History")
            {
                ApplicationArea = All;
                Caption = 'Renewal History';
                SubPageLink = "Subscription No." = field("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CancelSubscription)
            {
                Caption = 'Cancel Subscription';
                ToolTip = 'Marks this subscription as cancelled.';
                Image = Cancel;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Rec.Status = Rec.Status::Cancelled then
                        Error('This subscription is already cancelled.');

                    Rec.Status := Rec.Status::Cancelled;
                    Rec."Cancelled Date" := Today;
                    Rec.Modify(true);
                    CurrPage.Update(false);
                end;
            }
            action(ReactivateSubscription)
            {
                Caption = 'Reactivate Subscription';
                ToolTip = 'Reactivates a cancelled subscription.';
                Image = ReOpen;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Rec.Status <> Rec.Status::Cancelled then
                        Error('This subscription is not cancelled.');

                    Rec.Status := Rec.Status::Active;
                    Rec."Cancelled Date" := 0D;
                    Rec.Modify(true);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
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