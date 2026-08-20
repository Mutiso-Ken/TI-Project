// namespace TISolution.TISolution;

page 74 "Asset Assignment History"
{
    Caption = 'Assignment History';
    PageType = ListPart;
    SourceTable = "Asset Assignment History";
    SourceTableView = sorting("Entry No.") order(descending);
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the employee the asset is assigned to.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the name of the employee.';
                }
                field("Assigned Date"; Rec."Assigned Date")
                {
                    ToolTip = 'Specifies the date the asset was assigned.';
                }
                field("Expected Return Date"; Rec."Expected Return Date")
                {
                    ToolTip = 'Specifies when the asset is expected back.';
                }
                field("Return Date"; Rec."Return Date")
                {
                    ToolTip = 'Specifies the date the asset was actually returned.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies whether this assignment is active or closed.';
                }
                field("Condition on Assignment"; Rec."Condition on Assignment")
                {
                    ToolTip = 'Specifies the condition of the asset when handed over.';
                }
                field("Condition on Return"; Rec."Condition on Return")
                {
                    ToolTip = 'Specifies the condition of the asset when returned.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies any remarks about this assignment.';
                }
                field("Assigned By"; Rec."Assigned By")
                {
                    ToolTip = 'Specifies who recorded the assignment.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ReturnAsset)
            {
                Caption = 'Return Asset';
                ToolTip = 'Marks the current assignment as returned and stamps today''s date.';
                Image = ReturnOrder;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Rec.Status = Rec.Status::Returned then
                        Error('This assignment is already marked as returned.');

                    Rec."Return Date" := Today;
                    Rec.Status := Rec.Status::Returned;
                    Rec.Modify(true);
                    CurrPage.Update(false);
                end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        AssetAssignmentHistory: Record "Asset Assignment History";
    begin
        AssetAssignmentHistory.Reset();
        if AssetAssignmentHistory.Find('-') then
            AssetAssignmentHistory.DeleteAll();
        AssetAssignmentHistory.SetRange("Fixed Asset No.", Rec."Fixed Asset No.");
        AssetAssignmentHistory.SetRange(Status, AssetAssignmentHistory.Status::Assigned);
        if not AssetAssignmentHistory.IsEmpty() then
            Error('Fixed Asset %1 is already assigned and has not been returned yet. Return it before reassigning.', Rec."Fixed Asset No.");
    end;
}