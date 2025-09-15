#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 20365 "Appaisal Card"
{
    PageType = Card;
    SourceTable = "Appraisal Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Employee No"; Rec."Employee No")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field("Review Period"; Rec."Review Period")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control7; "Performance Plan")
            {
                SubPageLink = "Employee No" = field("Employee No"),
                              "Review Period" = field("Review Period");
            }
            part(Control6; "Section B-D")
            {
                SubPageLink = "Employe No" = field("Employee No"),
                              "Review Period" = field("Review Period");
            }
        }
    }

    actions
    {
    }
}

