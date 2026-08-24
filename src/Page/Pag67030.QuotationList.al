#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
page 67030 "Quotation List"
{
    CardPageID = "Quotation Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Procurement Request";
    SourceTableView = where("Procurement Method" = const(RFQ), "Quotation Status" = const(New));
    ApplicationArea = All;
    UsageCategory = Lists;

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
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Title; Rec.Title)
                {
                    ApplicationArea = All;
                }
                field("Requisiton No"; Rec."Requisiton No")
                {
                    ApplicationArea = All;
                }
                field("Supplier Category"; Rec."Supplier Category")
                {
                    ApplicationArea = All;
                }
                field("RFQ Deadlne Date"; Rec."RFQ Deadlne Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
