#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80024 "Purchase Requisition"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Purchase Requisition.rdlc';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {

            column(No_PurchaseHeader; "Purchase Header"."No.")
            {
            }
            column(DocumentDate_PurchaseHeader; "Purchase Header"."Document Date")
            {
            }
            column(CompanyINfoName; CompanyINfo.Name)
            {
            }
            column(CompanyINfoAdd; CompanyINfo.Address)
            {
            }
            column(CompanyINfoPicture; CompanyINfo.Picture)
            {
            }
            column(ShortcutDimension1Code_PurchaseHeader; "Purchase Header"."Shortcut Dimension 1 Code")
            {
            }
            column(ShortcutDimension2Code_PurchaseHeader; "Purchase Header"."Shortcut Dimension 2 Code")
            {
            }
            column(LocationCode_PurchaseHeader; "Purchase Header"."Location Code")
            {
            }
            column(dim1name; Dim1Name)
            {
            }
            column(dim2name; Dim2Name)
            {
            }
            column(USERID; "Purchase Header"."User ID")
            {
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");

                column(Type_PurchaseLine; "Purchase Line".Type)
                {
                }
                column(No_PurchaseLine; "Purchase Line"."No.")
                {
                }
                column(Description_PurchaseLine; "Purchase Line".Description)
                {
                }
                column(Description2_PurchaseLine; "Purchase Line"."Description 2")
                {
                }
                column(UnitofMeasure_PurchaseLine; "Purchase Line"."Unit of Measure")
                {
                }
                column(Quantity_PurchaseLine; "Purchase Line".Quantity)
                {
                }
                column(ExpectedReceiptDate_PurchaseLine; "Purchase Line"."Expected Receipt Date")
                {
                }
                column(sno; SNo)
                {
                }
                column(inventory; Inventory)
                {
                }
                column(Amt; "Purchase Line"."Amount Including VAT")
                {
                }
                trigger OnPreDataItem();
                begin

                end;

                trigger OnAfterGetRecord();
                begin
                    SNo += 1;
                    if Type = Type::Item then begin
                        Item.Get("No.");
                        Item.CalcFields(Inventory);
                        Inventory := Item.Inventory;
                    end else
                        Inventory := 0;
                end;

            }
            dataitem("Approval Entry"; "Approval Entry")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = where("Document Type" = const(Quote), Status = const(Approved));

                column(ApproverID_ApprovalEntry; "Approval Entry"."Approver ID")
                {
                }
                column(DateTimeSentforApproval_ApprovalEntry; "Approval Entry"."Date-Time Sent for Approval")
                {
                }
                column(LastDateTimeModified_ApprovalEntry; "Approval Entry"."Last Date-Time Modified")
                {
                }
                column(SequenceNo_ApprovalEntry; "Sequence No.") { }
                trigger OnPreDataItem();
                begin

                end;
            }
            trigger OnPreDataItem();
            begin

            end;

            trigger OnAfterGetRecord();
            begin
                DimVal.Reset;
                DimVal.SetRange(Code, "Shortcut Dimension 1 Code");
                if DimVal.FindFirst then
                    Dim1Name := DimVal.Name;
                DimVal.Reset;
                DimVal.SetRange(Code, "Shortcut Dimension 2 Code");
                if DimVal.FindFirst then
                    Dim2Name := DimVal.Name;
            end;

        }
    }
    requestpage
    {
        SaveValues = false;
        layout
        {
        }

    }

    trigger OnPreReport()
    begin
        CompanyINfo.Get;
        CompanyINfo.CalcFields(Picture);
        SNo := 0;
        Dim1Name := '';
        Dim2Name := '';


    end;

    var
        CompanyINfo: Record "Company Information";
        Inventory: Decimal;
        SNo: Integer;
        Item: Record Item;
        DimVal: Record "Dimension Value";
        Dim1Name: Text;
        Dim2Name: Text;

    trigger OnInitReport();
    begin

    end;

}