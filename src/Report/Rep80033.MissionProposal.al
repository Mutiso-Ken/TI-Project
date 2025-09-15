#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80033 "Mission Proposal"
{
    WordLayout = 'Layouts/MissionProposal.docx';
    DefaultLayout = Word;

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
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = where("Line Type" = const(Objectives));
                column(Description2_PurchaseLine; "Purchase Line"."Description 2")
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
            dataitem("Approval Entry"; "Approval Entry")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = where("Document Type" = const(Quote), Status = const(Approved));
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
                ApprovalEntry.Reset;
                ApprovalEntry.SetRange("Document No.", "Purchase Header"."No.");
                ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
                ApprovalEntry.SetRange("Sequence No.", 1);
                if ApprovalEntry.FindFirst then begin
                    date1 := ApprovalEntry."Date-Time Sent for Approval";
                end;
                ApprovalEntry.Reset;
                ApprovalEntry.SetRange("Document No.", "Purchase Header"."No.");
                ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
                ApprovalEntry.SetRange("Sequence No.", 1);
                if ApprovalEntry.FindFirst then begin
                    User1 := ApprovalEntry."Last Modified By User ID";
                    date1 := ApprovalEntry."Last Date-Time Modified";
                end;
                ApprovalEntry.Reset;
                ApprovalEntry.SetRange("Document No.", "Purchase Header"."No.");
                ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
                ApprovalEntry.SetRange("Sequence No.", 2);
                if ApprovalEntry.FindFirst then begin
                    user2 := ApprovalEntry."Last Modified By User ID";
                    date2 := ApprovalEntry."Last Date-Time Modified";
                end;
                ApprovalEntry.Reset;
                ApprovalEntry.SetRange("Document No.", "Purchase Header"."No.");
                ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
                ApprovalEntry.SetRange("Sequence No.", 3);
                if ApprovalEntry.FindFirst then begin
                    user3 := ApprovalEntry."Last Modified By User ID";
                    date3 := ApprovalEntry."Last Date-Time Modified";
                end;
                ApprovalEntry.Reset;
                ApprovalEntry.SetRange("Document No.", "Purchase Header"."No.");
                ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
                ApprovalEntry.SetRange("Sequence No.", 4);
                if ApprovalEntry.FindFirst then begin
                    user4 := ApprovalEntry."Last Modified By User ID";
                    date4 := ApprovalEntry."Last Date-Time Modified";
                end;
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

    trigger OnInitReport();
    begin

    end;

}