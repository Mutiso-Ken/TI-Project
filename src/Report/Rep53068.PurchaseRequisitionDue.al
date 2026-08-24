#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
report 53068 "Purchase Requisition Due"
{
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Purchase Requisition Due';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = where("Document Type" = const(Quote),
                                      PR = const(true),
                                      Status = const(Released),
                                      "Process Initiated" = filter(true));
            RequestFilterFields = "Shortcut Dimension 1 Code", "Created On", "Employee No";

            column(CompanyName; CompanyInformation.Name)
            {
            }
            column(CompanyPicture; CompanyInformation.Picture)
            {
            }
            column(CompanyAddress; CompanyInformation.Address)
            {
            }
            column(CompanyPhone; CompanyInformation."Phone No.")
            {
            }
            column(CompanyEmail; CompanyInformation."E-Mail")
            {
            }
            column(CompanyWebsite; CompanyInformation."Home Page")
            {
            }
            column(CompanyPostCode; CompanyInformation."Post Code")
            {
            }
            column(PeriodDue; PeriodDue)
            {
            }
            column(No_PurchaseHeader; "Purchase Header"."No.")
            {
            }
            column(EmployeeNo_PurchaseHeader; "Purchase Header"."Employee No")
            {
            }
            column(EmployeeName_PurchaseHeader; "Purchase Header"."Employee Name")
            {
            }
            column(ShortcutDimension3Code_PurchaseHeader; "Purchase Header"."Shortcut Dimension 3 Code")
            {
            }
            column(ShortcutDimension2Code_PurchaseHeader; "Purchase Header"."Shortcut Dimension 2 Code")
            {
            }
            column(ShortcutDimension1Code_PurchaseHeader; "Purchase Header"."Shortcut Dimension 1 Code")
            {
            }
            column(Status_PurchaseHeader; "Purchase Header".Status)
            {
            }
            column(CreatedBy_PurchaseHeader; "Purchase Header"."Created By")
            {
            }
            column(CreatedOn_PurchaseHeader; "Purchase Header"."Created On")
            {
            }
            column(NoSeries_PurchaseHeader; "Purchase Header"."No. Series")
            {
            }
            column(TotalAmount_PurchaseHeader; TotalAmount)
            {
            }
            column(Posted_PurchaseHeader; "Purchase Header".Posted)
            {
            }
            column(Title_PurchaseHeader; "Purchase Header".Title)
            {
            }
            column(PostedBy_PurchaseHeader; "Purchase Header"."Posted By")
            {
            }
            column(PostedOn_PurchaseHeader; "Purchase Header"."Posted On")
            {
            }
            column(PostingDate_PurchaseHeader; "Purchase Header"."Posting Date")
            {
            }
            column(TimePosted_PurchaseHeader; "Purchase Header"."Time Posted")
            {
            }
            column(BudgetCode_PurchaseHeader; "Purchase Header"."Budget Code")
            {
            }
            column(SupplierCategory_PurchaseHeader; "Purchase Header"."Supplier Category")
            {
            }
            column(RequestingPerson_PurchaseHeader; "Purchase Header"."Requesting Person")
            {
            }
            column(ApprovalEntries_PurchaseHeader; "Purchase Header"."Approval Entries")
            {
            }
            column(ProcessInitiated_PurchaseHeader; "Purchase Header"."Process Initiated")
            {
            }

            trigger OnAfterGetRecord()
            var
                PurchaseLine: Record "Purchase Line";
            begin
                PeriodDue := CreateDateTime(Today, 0T) - CreateDateTime("Purchase Header"."Created On", 0T);

                TotalAmount := 0;
                PurchaseLine.Reset();
                PurchaseLine.SetRange("Document Type", "Purchase Header"."Document Type");
                PurchaseLine.SetRange("Document No.", "Purchase Header"."No.");
                if PurchaseLine.FindSet() then
                    repeat
                        TotalAmount += PurchaseLine.Amount;
                    until PurchaseLine.Next() = 0;
            end;

            trigger OnPreDataItem()
            begin
                CompanyInformation.Get();
                CompanyInformation.CalcFields(Picture);
            end;
        }
    }

    requestpage
    {
        layout
        {
        }
        actions
        {
        }
    }

    var
        CompanyInformation: Record "Company Information";
        PeriodDue: Duration;
        TotalAmount: Decimal;
}
