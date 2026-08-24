#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
page 50124 "Procurement Plan Lines"
{
    PageType = ListPart;
    SourceTable = "The Procurement Plan";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Plan No."; Rec."Plan No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Pillar Code"; Rec."Pillar Code")
                {
                    ApplicationArea = All;
                }
                field("Pillar Name"; Rec."Pillar Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Grant Code"; Rec."Grant Code")
                {
                    ApplicationArea = All;
                }
                field("Grant Name"; Rec."Grant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Activity Code"; Rec."Activity Code")
                {
                    ApplicationArea = All;
                }
                field("Activity Name"; Rec."Activity Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Partner Code"; Rec."Partner Code")
                {
                    ApplicationArea = All;
                }
                field("Partner Name"; Rec."Partner Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Description of service/Goods"; Rec."Description of service/Goods")
                {
                    ApplicationArea = All;
                }
                field(Quarter; Rec.Quarter)
                {
                    ApplicationArea = All;
                }
                field("Lead Logistics Officer Code"; Rec."Lead Logistics Officer Code")
                {
                    ApplicationArea = All;
                }
                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field(Frequency; Rec.Frequency)
                {
                    ApplicationArea = All;
                }
                field(Total; Rec.Total)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Committed; Rec.Committed)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field(Spent; Rec.Spent)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }
}
