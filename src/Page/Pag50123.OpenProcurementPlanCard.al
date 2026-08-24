#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
page 50123 "Open Procurement Plan Card"
{
    PageType = Card;
    SourceTable = "RCK Procurement Plan Header";
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
                field("Period"; Rec."Period")
                {
                    ApplicationArea = All;
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
            action("Send For Approval")
            {
                ApplicationArea = All;
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to send for approval?') then begin
                        Rec.Status := Rec.Status::Pending;
                        if Rec.Modify() then begin
                            Message('Sent successfully.');
                        end;
                    end;
                    CurrPage.Close();
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        ProcurementYears: Record "Procurement Years";
    begin
        ProcurementYears.Reset();
        ProcurementYears.SetRange("Current Year", true);
        if ProcurementYears.FindFirst() then begin
            Rec.Period := ProcurementYears."FY Code";
        end;
    end;
}
