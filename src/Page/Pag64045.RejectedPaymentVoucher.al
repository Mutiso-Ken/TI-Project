page 64045 "Rejected Payment Voucher"
{
    Caption = 'Rejected Payment Vouchers';
    ApplicationArea = All;
    CardPageId = "Payment Voucher Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Payment Voucher";
    SourceTableView = sorting("No.") order(descending) where(Status = const(Rejected), Posted = const(false), "Payment Type" = const("Payment Voucher"));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Voucher Date"; Rec."Voucher Date")
                {
                    ApplicationArea = All;
                }
                field(Payee; Rec.Payee)
                {
                    ApplicationArea = All;
                }
                field("Payment For"; Rec."Payment For")
                {
                    ApplicationArea = All;
                }
                field("Paying Bank"; Rec."Paying Bank")
                {
                    ApplicationArea = All;
                }
                field("Paying Bank Name"; Rec."Paying Bank Name")
                {
                    ApplicationArea = All;
                }
                field("Gross Amount"; Rec."Gross Amount")
                {
                    ApplicationArea = All;
                }
                field("Net Amount"; Rec."Net Amount")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part("Pending Approval FactBox"; "Pending Approval FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Table ID" = const(64024),
                              "Document No." = field("No.");
            }
        }
    }
}
