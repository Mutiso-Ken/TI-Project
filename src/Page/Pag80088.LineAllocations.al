#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 80088 "Line Allocations"
{
    ApplicationArea = Basic;
    CardPageID = "Line Allocation Card";
    PageType = List;
    SourceTable = "Allocation Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Allocation No"; Rec."Allocation No")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = Basic;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Generate")
            {
                Caption = '&Generate';
                Image = Quote;
                action("Generate Journal")
                {
                    ApplicationArea = Basic;
                    Caption = 'Generate  Journal';
                    Ellipsis = true;
                    Image = PickWorksheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Report "Generate Journal";
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if UserSetup.Get(UserId) then begin
            if not UserSetup."View Payroll" then
                Error('You do not have the permissions to access the Allocations');
        end else begin
            Error('User Account not set up');
        end;
    end;

    var
        UserSetup: Record "User Setup";
}

