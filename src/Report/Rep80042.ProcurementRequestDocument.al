#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006
report 80042 "Procurement Request Document"
{
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Procurement Request Document';
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Procurement Request Document.rdlc';

    dataset
    {
        dataitem("Procurement Request"; "Procurement Request")
        {
            RequestFilterFields = "No.", "Procurement Method";

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
            column(No_ProcurementRequest; "No.")
            {
            }
            column(Status_ProcurementRequest; Format(Status))
            {
            }
            column(Title_ProcurementRequest; Title)
            {
            }
            column(RequisitonNo_ProcurementRequest; "Requisiton No")
            {
            }
            column(ProcurementMethod_ProcurementRequest; Format("Procurement Method"))
            {
            }
            column(CreatedBy_ProcurementRequest; "Created By")
            {
            }
            column(CreatedOn_ProcurementRequest; "Creation Date")
            {
            }
            column(CurrentBudget_ProcurementRequest; "Current Budget")
            {
            }
            column(TotalAmount_ProcurementRequest; "Total Amount")
            {
            }
            column(SupplierCategory_ProcurementRequest; "Supplier Category")
            {
            }
            column(SourceOfFunds_ProcurementRequest; "Source of Funds")
            {
            }
            column(VendorNo_ProcurementRequest; "Vendor No")
            {
            }
            column(VendorName_ProcurementRequest; "Vendor Name")
            {
            }
            column(ExpectedDeliveryDate_ProcurementRequest; "Expected Delivery Date")
            {
            }
            column(RFQDeadlineDate_ProcurementRequest; "RFQ Deadlne Date")
            {
            }
            column(RFQDeadlineTime_ProcurementRequest; "RFQ Deadline Time")
            {
            }
            column(GlobalDimension1Code_ProcurementRequest; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code_ProcurementRequest; "Global Dimension 2 Code")
            {
            }

            dataitem("Procurement Request Lines"; "Procurement Request Lines")
            {
                DataItemLink = "Procurement No" = field("No.");
                DataItemTableView = sorting("Procurement No", "Line No.");

                column(sno; SNo)
                {
                }
                column(Type_ProcurementRequestLines; Format(Type))
                {
                }
                column(No_ProcurementRequestLines; No)
                {
                }
                column(Description_ProcurementRequestLines; Description)
                {
                }
                column(UnitOfMeasure_ProcurementRequestLines; "Unit of Measure")
                {
                }
                column(Quantity_ProcurementRequestLines; Quantity)
                {
                }
                column(UnitPrice_ProcurementRequestLines; "Unit Price")
                {
                }
                column(TotalAmount_ProcurementRequestLines; "Total Amount")
                {
                }
                column(CarRepairMaintenance_ProcurementRequestLines; "Car Repair/Maintenance")
                {
                }
                column(VehicleRegNo_ProcurementRequestLines; "Vehicle Reg. No")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    SNo += 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Total Amount");
                SNo := 0;
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
                ApprovalEntry.SetRange("Table ID", Database::"Procurement Request");
                ApprovalEntry.SetRange("Document No.", "No.");
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

    local procedure GetApprovalLevel(SequenceNo: Integer; var ApproverID: Code[80]; var DateTimeApproved: Text)
    var
        LevelApprovalEntry: Record "Approval Entry";
    begin
        LevelApprovalEntry.Reset();
        LevelApprovalEntry.SetRange("Table ID", Database::"Procurement Request");
        LevelApprovalEntry.SetRange("Document No.", "Procurement Request"."No.");
        LevelApprovalEntry.SetRange(Status, LevelApprovalEntry.Status::Approved);
        LevelApprovalEntry.SetRange("Sequence No.", SequenceNo);
        if LevelApprovalEntry.FindFirst() then begin
            ApproverID := LevelApprovalEntry."Approver ID";
            DateTimeApproved := Format(LevelApprovalEntry."Last Date-Time Modified");
        end;
    end;
}
