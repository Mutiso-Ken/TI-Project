page 51151 "Requisition Rates"
{
    PageType = List;
    SourceTable = "Payment Types";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec."Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("G/L Account"; Rec."G/L Account")
                {
                }
                field("Source Type"; Rec."Source Type")
                {
                }
                field(Taxable; Rec.Taxable)
                {
                }
                field("Exemption Amount"; Rec."Exemption Amount")
                {
                }
            }
        }
    }

    actions
    {
    }
}
