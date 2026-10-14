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
                field("Document Number"; Rec."Document Number") { ApplicationArea = all; Editable = false; }

                field("Original File Name"; Rec."Original File Name") { Caption = 'Description'; ApplicationArea = all; ShowMandatory = true; Editable = false; }
                field("Local Url"; Rec."Local Url") { ApplicationArea = all; Editable = false; ExtendedDatatype = URL; }
                field("Shared With Vendors"; Rec."Shared With Vendors")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies whether vendors invited to this RFQ / Direct Procurement can see and download this document in the vendor portal.';
                }
                field("Source Document No."; Rec."Source Document No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the purchase request this document was uploaded on.';
                }
                field("Shared By"; Rec."Shared By") { ApplicationArea = all; }
                field("Shared On"; Rec."Shared On") { ApplicationArea = all; }
                field(SystemCreatedAt; Rec.SystemCreatedAt) { Caption = 'Uploaded on'; ApplicationArea = all; Editable = false; }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ShareSelected)
            {
                Caption = 'Share With Vendors';
                ApplicationArea = All;
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Make the selected documents visible to the vendors on this RFQ / Direct Procurement.';

                trigger OnAction()
                begin
                    SetSharing(true);
                end;
            }
            action(UnshareSelected)
            {
                Caption = 'Stop Sharing';
                ApplicationArea = All;
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Hide the selected documents from vendors.';

                trigger OnAction()
                begin
                    SetSharing(false);
                end;
            }
        }
    }

    local procedure SetSharing(Share: Boolean)
    var
        PortalDocument: Record "Portal Documents";
    begin
        CurrPage.SetSelectionFilter(PortalDocument);
        if PortalDocument.FindSet() then
            repeat
                PortalDocument.Validate("Shared With Vendors", Share);
                PortalDocument.Modify(true);
            until PortalDocument.Next() = 0;
        CurrPage.Update(false);
    end;
}
