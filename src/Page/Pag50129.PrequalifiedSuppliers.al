#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
page 50129 "Prequalified Suppliers"
{
    PageType = List;
    SourceTable = "PreQualified Suppliers";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field(FY; Rec.FY)
                {
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }
                field("Supplier Name"; Rec."Supplier Name")
                {
                    ApplicationArea = All;
                }
                field("Contact Person Name"; Rec."Contact Person Name")
                {
                    ApplicationArea = All;
                }
                field("E-mail"; Rec."E-mail")
                {
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Physical Address"; Rec."Physical Address")
                {
                    ApplicationArea = All;
                }
                field("Category Code"; Rec."Category Code")
                {
                    ApplicationArea = All;
                }
                field("Category Name"; Rec."Category Name")
                {
                    ApplicationArea = All;
                }
                field("Linked Vendor No."; Rec."Linked Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Linked Vendor Name"; Rec."Linked Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Mode of addition"; Rec."Mode of addition")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("mannual addition by user"; Rec."mannual addition by user")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Addition Date"; Rec."Addition Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Addition Time"; Rec."Addition Time")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
}
