page 51042 "Partners List"
{

    Caption = 'Partners List';
    CardPageID = "Customer Card";
    Editable = false;
    PageType = List;
    SourceTable = Customer;
    SourceTableView = WHERE("Account Type" = FILTER("Implementing Partner"));
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater("repeater1")
            {
                field("No."; Rec."No.")
                {
                }

                field(Name; Rec.Name)
                {
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Post Code"; Rec."Post Code")
                {
                    Visible = false;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    Visible = false;
                }
                field("Phone No."; Rec."Phone No.")
                {
                }
                field("Fax No."; Rec."Fax No.")
                {
                    Visible = false;
                }
                field(Contact; Rec.Contact)
                {
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    Visible = false;
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    Caption = 'Donor Posting Group';
                    Visible = false;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    Visible = false;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    Visible = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Visible = false;
                }
                field("Search Name"; Rec."Search Name")
                {
                }
                field("Credit Limit (LCY)"; Rec."Credit Limit (LCY)")
                {
                    Visible = false;
                }
                field(Blocked; Rec.Blocked)
                {
                    Visible = false;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part("Customer Statistics FactBox"; "Customer Statistics FactBox")
            {
                Caption = 'Partner Statistics FactBox';
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = true;
            }
            part("Customer Details FactBox"; "Customer Details FactBox")
            {
                Caption = 'Partner Details FactBox';
                SubPageLink = "No." = FIELD("No."),
                              "Currency Filter" = FIELD("Currency Filter"),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                Visible = false;
            }
            systempart(Links; Links)
            {
                Visible = true;
            }
            systempart(Notes; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Customer")
            {
                Caption = '&Customer';
                Image = Customer;
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Customer),
                                  "No." = FIELD("No.");
                }

            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    Image = CustomerLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Customer Ledger Entries";
                    RunPageLink = "Customer No." = FIELD("No.");
                    RunPageView = SORTING("Customer No.");
                    ShortCutKey = 'Ctrl+F7';
                }
            }
        }
    }
}
