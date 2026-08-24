#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
page 50126 "Pending Procurement Plan Card"
{
    PageType = Card;
    SourceTable = "RCK Procurement Plan Header";
    Editable = false;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Created DateTime"; Rec."Created DateTime")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Sub-Office Code"; Rec."Sub-Office Code")
                {
                    ApplicationArea = All;
                }
                field("Sub-Office Name"; Rec."Sub-Office Name")
                {
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }
                field("Total Plan Amount"; Rec."Total Plan Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            part("Procurement Plan Lines"; "Procurement Plan Lines")
            {
                ApplicationArea = All;
                SubPageLink = "Plan No." = field("No.");
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Return to open")
            {
                ApplicationArea = All;
                Image = PreviousSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to return back to open?') then begin
                        Rec.Status := Rec.Status::Open;
                        if Rec.Modify() then begin
                            Message('Returned successfully.');
                        end;
                    end;
                    CurrPage.Close();
                end;
            }
            action("Approve")
            {
                ApplicationArea = All;
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to Approve?') then begin
                        Rec.Status := Rec.Status::Approved;
                        if Rec.Modify() then begin
                            Message('Approved successfully.');
                        end;
                    end;
                    CurrPage.Close();
                end;
            }
        }
    }
}
