#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
page 66112 "Proc. Line Types"
{
    // version Procurement Iansoft

    DataCaptionFields = "Code", "Service Name";
    PageType = List;
    SourceTable = "Proc. Line Service Types";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                }
                field("Service Name"; Rec."Service Name")
                {
                }
                field("G/L Account"; Rec."G/L Account")
                {
                }
            }
        }
    }

    actions
    {
    }
}
