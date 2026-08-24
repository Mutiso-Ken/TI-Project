page 67032 "Quotation Lines Subform"
{
    // version Procurement Iansoft

    PageType = ListPart;
    SourceTable = "Procurement Request Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                }
                field(No; Rec.No)
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Unit Price"; Rec."Unit Price")
                {
                }
                field("Total Amount"; Rec."Total Amount")
                {
                }
                field("Vendor To Award"; Rec."Vendor To Award")
                {
                }
                field(Location; Rec.Location)
                {
                }
                field("Procurement Plan"; Rec."Procurement Plan")
                {

                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                }
                field("ShortcutDimCode[4]"; Rec."ShortcutDimCode[4]")
                {
                }
                field("ShortcutDimCode[5]"; Rec."ShortcutDimCode[5]")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Vendor Bids")
            {
                Image = Quote;
                RunObject = Page 67037;
                RunPageLink = "Quote No" = FIELD("Procurement No");
            }

            action("Create Item/Fixed Asset")
            {

                trigger OnAction();
                var
                    FixedAsset: Record "Fixed Asset";
                    Item: Record "Item";
                    NoSeriesManagement: Codeunit "No. Series";
                    FASetup: Record "FA Setup";
                    InventorySetup: Record "Inventory Setup";
                begin
                    IF NOT CONFIRM('Are you sure you want to create ' + FORMAT(Rec.Type)) THEN
                        EXIT;

                    IF Rec.Type IN [Rec.Type::"Fixed Asset"] THEN BEGIN
                        FASetup.GET;
                        FASetup.TESTFIELD("Fixed Asset Nos.");
                        IF Rec.No = '' THEN BEGIN
                            Rec.No := NoSeriesManagement.GetNextNo(FASetup."Fixed Asset Nos.", 0D, TRUE);
                            Rec.MODIFY(TRUE);
                            FixedAsset.INIT;
                            FixedAsset.VALIDATE("No.", Rec.No);
                            FixedAsset.VALIDATE(Description, Rec.Name);
                            FixedAsset.VALIDATE("Location Code", Rec.Location);
                            FixedAsset.VALIDATE("FA Location Code", Rec.Location);
                            FixedAsset.INSERT;
                        END;
                        COMMIT;
                        IF FixedAsset.GET(Rec.No) THEN
                            PAGE.RUNMODAL(PAGE::"Fixed Asset Card", FixedAsset);
                    END;


                    IF Rec.Type IN [Rec.Type::Item] THEN BEGIN
                        IF Rec.No = '' THEN BEGIN
                            InventorySetup.GET;
                            InventorySetup.TESTFIELD("Item Nos.");
                            Rec.No := NoSeriesManagement.GetNextNo(InventorySetup."Item Nos.", 0D, TRUE);
                            Rec.MODIFY(TRUE);
                            Item.INIT;
                            Item."No." := Rec.No;
                            Item.VALIDATE(Description, Rec.Name);
                            Item.INSERT;
                        END;
                        COMMIT;
                        IF Item.GET(Rec.No) THEN
                            PAGE.RUNMODAL(PAGE::"Item Card", Item);
                    END;
                end;
            }
        }
    }
}

