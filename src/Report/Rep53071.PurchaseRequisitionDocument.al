#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
report 53071 "Purchase Requisition Document"
{
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Purchase Requisition Document';
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Purchase Requisition Document.rdlc';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = where("Document Type" = const(Quote), PR = const(true));
            RequestFilterFields = "No.";

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
            column(SenderID; SenderID)
            {
            }
            column(DateTimeSend; DateTimeSend)
            {
            }
            column(FirstApproverID; FirstApproverID)
            {
            }
            column(DateTimeFirstApprove; DateTimeFirstApprove)
            {
            }
            column(SecondApproverID; SecondApproverID)
            {
            }
            column(DateTimeSecondApprove; DateTimeSecondApprove)
            {
            }
            column(ThirdApproverID; ThirdApproverID)
            {
            }
            column(DateTimeThirdApprove; DateTimeThirdApprove)
            {
            }
            column(FourthApproverID; FourthApproverID)
            {
            }
            column(DateTimeFourthApprove; DateTimeFourthApprove)
            {
            }
            column(FifthApproverID; FifthApproverID)
            {
            }
            column(DateTimeFifthApprove; DateTimeFifthApprove)
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
            column(RequestedReceiptDate_PurchaseHeader; "Purchase Header"."Requested Receipt Date")
            {
            }
            column(ProjectCode_PurchaseHeader; "Purchase Header"."Project Code")
            {
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");

                column(DocumentNo_PurchaseLine; "Purchase Line"."Document No.")
                {
                }
                column(Type_PurchaseLine; "Purchase Line".Type)
                {
                }
                column(No_PurchaseLine; "Purchase Line"."No.")
                {
                }
                column(Description_PurchaseLine; "Purchase Line".Description)
                {
                }
                column(Description2_PurchaseLine; "Purchase Line"."Description 3")
                {
                }
                column(Quantity_PurchaseLine; "Purchase Line".Quantity)
                {
                }
                column(DirectUnitCost_PurchaseLine; "Purchase Line"."Direct Unit Cost")
                {
                }
                column(Amount_PurchaseLine; "Purchase Line".Amount)
                {
                }
                column(UnitofMeasure_PurchaseLine; "Purchase Line"."Unit of Measure")
                {
                }
                column(ShortcutDimension1Code_PurchaseLine; "Purchase Line"."Shortcut Dimension 1 Code")
                {
                }
                column(ShortcutDimension2Code_PurchaseLine; "Purchase Line"."Shortcut Dimension 2 Code")
                {
                }
                column(LineNo_PurchaseLine; "Purchase Line"."Line No.")
                {
                }
                column(CarRepairMaintenance_PurchaseLine; "Purchase Line"."Car Repair/Maintenance")
                {
                }
                column(VehicleRegNo_PurchaseLine; "Purchase Line"."Vehicle Reg. No")
                {
                }
                column(sno; SNo)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    SNo += 1;
                    TotalAmount += "Purchase Line".Amount;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                SNo := 0;
                TotalAmount := 0;
                Clear(SenderID);
                Clear(DateTimeSend);
                Clear(FirstApproverID);
                Clear(DateTimeFirstApprove);
                Clear(SecondApproverID);
                Clear(DateTimeSecondApprove);
                Clear(ThirdApproverID);
                Clear(DateTimeThirdApprove);
                Clear(FourthApproverID);
                Clear(DateTimeFourthApprove);
                Clear(FifthApproverID);
                Clear(DateTimeFifthApprove);

                ApprovalEntry.Reset();
                ApprovalEntry.SetRange("Table ID", Database::"Purchase Header");
                ApprovalEntry.SetRange("Document No.", "Purchase Header"."No.");
                ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
                if ApprovalEntry.FindFirst() then begin
                    SenderID := ApprovalEntry."Sender ID";
                    DateTimeSend := Format(ApprovalEntry."Date-Time Sent for Approval");
                end;

                GetApprovalLevel(1, FirstApproverID, DateTimeFirstApprove);
                GetApprovalLevel(2, SecondApproverID, DateTimeSecondApprove);
                GetApprovalLevel(3, ThirdApproverID, DateTimeThirdApprove);
                GetApprovalLevel(4, FourthApproverID, DateTimeFourthApprove);
                GetApprovalLevel(5, FifthApproverID, DateTimeFifthApprove);
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
        ApprovalEntry: Record "Approval Entry";
        SenderID: Code[80];
        DateTimeSend: Text;
        FirstApproverID: Code[80];
        DateTimeFirstApprove: Text;
        SecondApproverID: Code[80];
        DateTimeSecondApprove: Text;
        ThirdApproverID: Code[80];
        DateTimeThirdApprove: Text;
        FourthApproverID: Code[80];
        DateTimeFourthApprove: Text;
        FifthApproverID: Code[80];
        DateTimeFifthApprove: Text;
        SNo: Integer;
        TotalAmount: Decimal;

    local procedure GetApprovalLevel(SequenceNo: Integer; var ApproverID: Code[80]; var DateTimeApproved: Text)
    var
        LevelApprovalEntry: Record "Approval Entry";
    begin
        LevelApprovalEntry.Reset();
        LevelApprovalEntry.SetRange("Table ID", Database::"Purchase Header");
        LevelApprovalEntry.SetRange("Document No.", "Purchase Header"."No.");
        LevelApprovalEntry.SetRange(Status, LevelApprovalEntry.Status::Approved);
        LevelApprovalEntry.SetRange("Sequence No.", SequenceNo);
        if LevelApprovalEntry.FindFirst() then begin
            ApproverID := LevelApprovalEntry."Approver ID";
            DateTimeApproved := Format(LevelApprovalEntry."Last Date-Time Modified");
        end;
    end;
}
