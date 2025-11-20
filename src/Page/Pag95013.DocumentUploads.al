page 95013 "Document Uploads"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Portal Documents";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document Number"; Rec."Document Number") { ApplicationArea = all; }

                field("Original File Name"; Rec."Original File Name") { Caption = 'Description'; ApplicationArea = all; ShowMandatory = true; Editable = false; }
                field("Local Url"; Rec."Local Url") { ApplicationArea = all; Editable = false; ExtendedDatatype = URL; }
                field(SystemCreatedAt; Rec.SystemCreatedAt) { Caption = 'Uploaded on'; ApplicationArea = all; Editable = false; }

            }
        }
        area(Factboxes)
        {

        }
    }

}