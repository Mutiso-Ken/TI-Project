page 51062 "Grants Open Requests"
{

    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Grants Request Header";
    SourceTableView = WHERE("Request Type" = CONST(Disbursement),
                            Status = FILTER(<> Approved));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Partner No."; Rec."Partner No.")
                {
                }
                field("Partner Name"; Rec."Partner Name")
                {
                }
                field("Created On"; Rec."Created On")
                {
                }
                field(Purpose; Rec.Purpose)
                {
                }
                field("Imprest Amount"; Rec."Imprest Amount")
                {
                    Caption = 'Requested Amount';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord();
    begin
    end;



    trigger OnOpenPage();
    begin
    end;

    var
        UserSetup: Record "User Setup";
        IanSoftFactory: Codeunit "IanSoftFactory";
}
