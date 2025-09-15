#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50015 "Staff Project Allocation"
{
    PageType = List;
    SourceTable = "Staff Project Allocation";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Staff Code"; Rec."Staff Code")
                {
                    ApplicationArea = Basic;
                }
                field("Staff Name"; Rec."Staff Name")
                {
                    ApplicationArea = Basic;
                }
                field("Fund Code"; Rec."Fund Code")
                {
                    ApplicationArea = Basic;
                }
                field("Fund Name"; "Fund Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Blocked; Blocked)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Hours; Rec.Hours)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        DimensionValue.Reset;
        DimensionValue.SetRange("Dimension Code", 'FUND');
        DimensionValue.SetRange(Code, Rec."Fund Code");
        if DimensionValue.FindFirst then begin
            "Fund Name" := DimensionValue.Name;
            Blocked := DimensionValue.Blocked;
        end;
    end;

    var
        DimensionValue: Record "Dimension Value";
        "Fund Name": Text;
        Blocked: Boolean;
}

