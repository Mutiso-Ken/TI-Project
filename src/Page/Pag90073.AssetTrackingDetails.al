// namespace TISolution.TISolution;
// using Microsoft.FixedAssets.FixedAsset;

page 90073 "Asset Tracking Details"
{
    ApplicationArea = All;
    Caption = 'Asset Tracking Details';
    PageType = Card;
    SourceTable = "Fixed Asset";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies a description of the fixed asset.';
                }
                field("FA Class Code"; Rec."FA Class Code")
                {
                    ToolTip = 'Specifies the class that the fixed asset belongs to.';
                }
                field("FA Subclass Code"; Rec."FA Subclass Code")
                {
                    ToolTip = 'Specifies the subclass that the fixed asset belongs to.';
                }
                field("Tag Number"; Rec."Tag Number")
                {
                    ToolTip = 'Specifies the value of the Tag Number field.', Comment = '%';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ToolTip = 'Specifies the fixed asset''s serial number.';
                }
                field("Acquisition Date"; Rec."Acquisition Date")
                {
                    ToolTip = 'Specifies the date the fixed asset was acquired.';
                }
                field("Staff Assigned"; Rec."Staff Assigned")
                {
                    ToolTip = 'Specifies the staff member currently assigned this fixed asset.';
                    Editable = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Caption = 'Fund Code';
                    ToolTip = 'Specifies the fund that this fixed asset belongs to.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Caption = 'Department';
                    ToolTip = 'Specifies the department that this fixed asset belongs to.';
                }
                field("Warranty Date"; Rec."Warranty Date")
                {
                    ToolTip = 'Specifies the warranty expiration date of the fixed asset.';
                }
                field("Under Maintenance"; Rec."Under Maintenance")
                {
                    ToolTip = 'Specifies if the fixed asset is currently being repaired.';
                }
                field("Next Service Date"; Rec."Next Service Date")
                {
                    ToolTip = 'Specifies the next scheduled service date for the fixed asset. This is used as a filter in the Maintenance - Next Service report.';
                }
            }
            part("Asset Assignment History"; "Asset Assignment History")
            {
                ApplicationArea = All;
                Caption = 'Assignment History';
                SubPageLink = "Fixed Asset No." = field("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(PrintAssignmentHistory)
            {
                Caption = 'Print Assignment History';
                ToolTip = 'Prints the assignment history report for this fixed asset.';
                Image = Print;
                ApplicationArea = All;

                trigger OnAction()
                var
                    FixedAsset: Record "Fixed Asset";
                begin
                    FixedAsset.SetRange("No.", Rec."No.");
                    Report.RunModal(Report::"Asset Assignment History", true, false, FixedAsset);
                end;
            }
        }
    }
}