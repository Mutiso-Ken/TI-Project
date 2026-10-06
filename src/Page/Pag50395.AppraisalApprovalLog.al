page 50395 "Appraisal Approval Log"
{
    PageType = List;
    SourceTable = "Appraisal Approval Log";
    Caption = 'Appraisal Approval History';
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Appraisal Code"; Rec."Appraisal Code") { ApplicationArea = All; }
                field(Action; Rec.Action) { ApplicationArea = All; }
                field("Approver Role"; Rec."Approver Role") { ApplicationArea = All; }
                field("Approver Code"; Rec."Approver Code") { ApplicationArea = All; }
                field("Approver Name"; Rec."Approver Name") { ApplicationArea = All; }
                field(Comment; Rec.Comment) { ApplicationArea = All; }
                field("Action Date"; Rec."Action Date") { ApplicationArea = All; }
                field("Action Time"; Rec."Action Time") { ApplicationArea = All; }
                field("User ID"; Rec."User ID") { ApplicationArea = All; }
            }
        }
    }
}
