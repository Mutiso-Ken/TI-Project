#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
page 67078 "Customer Category"
{
    // version Procurement Iansoft

    PageType = List;
    SourceTable = "Customer Category";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Category Code"; Rec."Category Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                }
            }
        }
    }

    actions
    {
    }
}
