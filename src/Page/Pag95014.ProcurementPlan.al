#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
page 95014 "Procurement Plan"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "The Procurement Plan";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                }
                field("Lead Logistics Officer Code"; Rec."Lead Logistics Officer Code")
                {
                }
                field("Full Name"; Rec."Full Name")
                {
                }
                field("Description of service/Goods"; Rec."Description of service/Goods")
                {
                }
                field("Sub-office code"; Rec."Sub-office code")
                {
                }
                field("Pillar Code"; Rec."Pillar Code")
                {
                }
                field("Grant Code"; Rec."Grant Code")
                {
                }
                field("Activity Code"; Rec."Activity Code")
                {
                }
                field("Partner Code"; Rec."Partner Code")
                {
                }
                field(Quarter; Rec.Quarter)
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                }
                field(Total; Rec.Total)
                {
                }
                field(Actuals; Rec.Actuals)
                {
                    Caption = 'Actual Expenditure';
                }
            }
        }
    }
}
