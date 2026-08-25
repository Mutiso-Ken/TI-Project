#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80033 "Mission Proposal"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Mission Proposal.rdlc';


    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {

            column(No_PurchaseHeader; "Purchase Header"."No.")
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
            column(ShortcutDimension3Code_PurchaseHeader; "Purchase Header"."Shortcut Dimension 3 Code")
            {
            }
            column(StrategicFocusArea_PurchaseHeader; "Purchase Header"."Strategic Focus Area")
            {
            }
            column(SubPillar_PurchaseHeader; "Purchase Header"."Sub Pillar")
            {
            }
            column(ProjectTitle_PurchaseHeader; "Purchase Header"."Project Title")
            {
            }
            column(Country_PurchaseHeader; "Purchase Header".Country)
            {
            }
            column(County_PurchaseHeader; "Purchase Header".County)
            {
            }
            column(DatesofActivity_PurchaseHeader; "Purchase Header"."Date(s) of Activity")
            {
            }
            column(MissionTeam_PurchaseHeader; "Purchase Header"."Mission Team")
            {
            }
            column(Background_PurchaseHeader; "Purchase Header".Background)
            {
            }
            column(Contributiontofocus_PurchaseHeader; "Purchase Header"."Contribution to focus")
            {
            }
            column(MainOutcome_PurchaseHeader; "Purchase Header"."Main Outcome")
            {
            }
            column(EmployeeName_PurchaseHeader; "Purchase Header"."Employee Name")
            {
            }
            column(InvitedMembersPartners_PurchaseHeader; "Purchase Header"."Invited Members/Partners")
            {
            }
            column(date1; date1)
            {
            }
            column(date2; date2)
            {
            }
            column(date3; date3)
            {
            }
            column(ApproverName1; ApproverName1)
            {
            }
            column(ApproverName2; ApproverName2)
            {
            }
            column(ApproverName3; ApproverName3)
            {
            }
            column(Signature1; Approver1Emp.Signature)
            {
            }
            column(Signature2; Approver2Emp.Signature)
            {
            }
            column(Signature3; Approver3Emp.Signature)
            {
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = where("Line Type" = const(Objectives));
                column(Description2_PurchaseLine; "Purchase Line"."Description 6")
                {
                }
                trigger OnPreDataItem();
                begin

                end;

                trigger OnAfterGetRecord();
                begin
                    SNo += 1;
                    if Type = Type::Item then begin
                        if Item.Get("No.") then
                            Item.CalcFields(Inventory);
                        Inventory := Item.Inventory;
                    end else
                        Inventory := 0;
                end;

            }
            dataitem("<Purchase Line2>"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = where("Line Type" = const("Team Roles"));
                column(Description2_PurchaseLine2; "<Purchase Line2>"."Description 2")
                {
                }
                column(Description3_PurchaseLine2; "<Purchase Line2>"."Description 3")
                {
                }

                trigger OnPreDataItem();
                begin

                end;

                trigger OnAfterGetRecord();
                begin
                    SNo += 1;
                    if Type = Type::Item then begin
                        if Item.Get("No.") then
                            Item.CalcFields(Inventory);
                        Inventory := Item.Inventory;
                    end else
                        Inventory := 0;
                end;

            }
            dataitem("<Purchase Line3>"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = where("Line Type" = const(Activity));
                column(ExpectedReceiptDate_PurchaseLine3; "<Purchase Line3>"."Expected Receipt Date")
                {
                }
                column(Description3_PurchaseLine3; "<Purchase Line3>"."Description 3")
                {
                }
                column(UnitofMeasure_PurchaseLine3; "<Purchase Line3>"."Unit of Measure")
                {
                }
                column(Description2_PurchaseLine3; "<Purchase Line3>"."Description 2")
                {
                }
                trigger OnPreDataItem();
                begin

                end;

                trigger OnAfterGetRecord();
                begin
                    SNo += 1;
                    if Type = Type::Item then begin
                        if Item.Get("No.") then
                            Item.CalcFields(Inventory);
                        Inventory := Item.Inventory;
                    end else
                        Inventory := 0;
                end;

            }
            dataitem("<Purchase Line4>"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = where("Line Type" = const("Budget Info"));

                column(Description3_PurchaseLine4; "<Purchase Line4>"."Description 3")
                {
                }
                column(Description2_PurchaseLine4; "<Purchase Line4>"."Description 2")
                {
                }
                column(Noofdays_PurchaseLine4; "<Purchase Line4>"."No of days")
                {
                }
                column(Noofpax_PurchaseLine4; "<Purchase Line4>"."No of pax")
                {
                }
                column(Ksh_PurchaseLine4; "<Purchase Line4>".Ksh)
                {
                }
                column(othercurrency_PurchaseLine4; "<Purchase Line4>"."other currency")
                {
                }
                column(TotalKsh_PurchaseLine4; "<Purchase Line4>"."Total Ksh")
                {
                }
                column(TotalOtherCurrency_PurchaseLine4; "<Purchase Line4>"."Total Other Currency")
                {
                }
                column(Description_6; "Description 6") { }
                trigger OnPreDataItem();
                begin

                end;

                trigger OnAfterGetRecord();
                begin
                    SNo += 1;
                    if Type = Type::Item then begin
                        if Item.Get("No.") then
                            Item.CalcFields(Inventory);
                        Inventory := Item.Inventory;
                    end else
                        Inventory := 0;
                end;

            }
            dataitem("<Purchase Line5>"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = where("Line Type" = const("Budget Notes"));

                column(Description3_PurchaseLine5; "<Purchase Line5>"."Description 3")
                {
                }
                column(Description2_PurchaseLine5; "<Purchase Line5>"."Description 2")
                {
                }
                column(Description4_PurchaseLine5; "<Purchase Line5>"."Description 4")
                {
                }
                column(Description5_PurchaseLine5; "<Purchase Line5>"."Description 5")
                {
                }
                column(Description6_PurchaseLine5; "<Purchase Line5>"."Description 6")
                {
                }
                trigger OnPreDataItem();
                begin
                end;

                trigger OnAfterGetRecord();
                begin
                    SNo += 1;
                    if Type = Type::Item then begin
                        if Item.Get("No.") then
                            Item.CalcFields(Inventory);
                        Inventory := Item.Inventory;
                    end else
                        Inventory := 0;
                end;

            }
            trigger OnPreDataItem();
            begin

            end;

            trigger OnAfterGetRecord();
            begin
                // Reviews & Approvals: one HR Employee (matched to the approver via User ID)
                // per approval sequence, each with their own approval date and signature.
                SetApprover("Purchase Header"."No.", 1, ApproverName1, date1, Approver1Emp);
                SetApprover("Purchase Header"."No.", 2, ApproverName2, date2, Approver2Emp);
                SetApprover("Purchase Header"."No.", 3, ApproverName3, date3, Approver3Emp);
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
        User1: Code[100];
        date1: DateTime;
        user2: Code[100];
        date2: DateTime;
        user3: Code[100];
        date3: DateTime;
        user4: Code[100];
        date4: DateTime;
        ApprovalEntry: Record "Approval Entry";
        user5: Code[100];
        date5: DateTime;
        Approvaldate: Date;
        ApproverName1: Text[100];
        ApproverName2: Text[100];
        ApproverName3: Text[100];
        Approver1Emp: Record "HR Employees";
        Approver2Emp: Record "HR Employees";
        Approver3Emp: Record "HR Employees";

    trigger OnInitReport();
    begin

    end;

    local procedure SetApprover(DocumentNo: Code[20]; SequenceNo: Integer; var ApproverName: Text[100]; var ApprovalDate: DateTime; var ApproverEmp: Record "HR Employees")
    begin
        ApproverName := '';
        ApprovalDate := 0DT;
        Clear(ApproverEmp);

        ApprovalEntry.Reset();
        ApprovalEntry.SetRange("Document No.", DocumentNo);
        ApprovalEntry.SetRange("Sequence No.", SequenceNo);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
        if ApprovalEntry.FindFirst() then begin
            ApprovalDate := ApprovalEntry."Last Date-Time Modified";

            ApproverEmp.Reset();
            ApproverEmp.SetRange("User ID", ApprovalEntry."Approver ID");
            if ApproverEmp.FindFirst() then begin
                ApproverEmp.CalcFields(Signature);
                ApproverName := ApproverEmp.FullName;
            end;
        end;
    end;

}