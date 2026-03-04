namespace TISolution.TISolution;

page 2 "Appraisal Questions"
{
    ApplicationArea = All;
    Caption = 'Appraisal Questions';
    PageType = List;
    SourceTable = "Appraisal Questions";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field(Section; Rec.Section)
                {
                    ToolTip = 'Specifies the value of the Section field.', Comment = '%';
                }
                field(Part; Rec.Part)
                {
                    ToolTip = 'Specifies the value of the Part field.', Comment = '%';
                }
            }
        }
    }
}
