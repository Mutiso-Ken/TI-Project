#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
page 66095 "Rej. Purch. Requisition List"
{
    ApplicationArea = Basic;
    Caption = 'Rejected Purchase Requisitions';
    CardPageID = "Task Order Card";
    Editable = false;
    PageType = List;
    SourceTable = "Purchase Header";
    SourceTableView = where("Document Type" = const(Quote),
                            DocApprovalType = const(Requisition),
                            PR = filter(true),
                            Archived = const(false));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field(Title; Rec.Title)
                {
                    ApplicationArea = Basic;
                }
                field("Employee No"; Rec."Employee No")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field("Rejection Comments"; Rec."Rejection Comments")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetFilter("Rejection Comments", '<>%1', '');
    end;
}
