#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50005 "Performance Appraisals Card"
{
    PageType = Card;
    SourceTable = "Purchase Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
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
                field("Review From"; Rec."Review From")
                {
                    ApplicationArea = Basic;
                }
                field("Review To"; Rec."Review To")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control8; "Performance Appraisal Subform")
            {
                SubPageLink = "Document No." = field("No.");
            }
            part(Control9; "Appraisal Points")
            {
                SubPageLink = "Document No." = field("No.");
            }
            part(Control10; "Personal Qualities")
            {
                SubPageLink = "Document No." = field("No.");
            }
            part(Control11; Reflections)
            {
                SubPageLink = "Document No." = field("No.");
            }
            part(Control12; "Capacity Needs")
            {
                SubPageLink = "Document No." = field("No.");
            }
            part(Control13; "Action Points")
            {
                SubPageLink = "Document No." = field("No.");
            }
        }
    }

    actions
    {
    }
}

