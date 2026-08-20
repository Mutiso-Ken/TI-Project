// namespace TISolution.TISolution;

// using Microsoft.FixedAssets.FixedAsset;

page 70 "Asset Tracker"
{
    ApplicationArea = All;
    Caption = 'Asset Tracker';
    PageType = List;
    SourceTable = "Fixed Asset";
    UsageCategory = Administration;
    CardPageId = "Asset Tracking Details";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies a description of the fixed asset.';
                }
                field("FA Class Code"; Rec."FA Class Code")
                {
                    Caption = 'Asset Type';
                    ToolTip = 'Specifies the class that the fixed asset belongs to.';
                }
                field("Tag Number"; Rec."Tag Number")
                {
                    ToolTip = 'Specifies the value of the Tag Number field.', Comment = '%';
                }
            }
        }
    }
}
