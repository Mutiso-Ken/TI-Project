report 90042 "Helpdesk Tickets Overview"
{
    Caption = 'Helpdesk Tickets Overview';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HelpdeskTicketsOverview.rdlc';

    dataset
    {
        dataitem("HelpDesk Tickets"; "HelpDesk Tickets")
        {
            RequestFilterFields = Status, "Employee ID", "Placed On";

            column(CompanyInfoName; CompanyInfo.Name) { }
            column(CompanyInfoPicture; CompanyInfo.Picture) { }
            column(GeneratedOnTxt; GeneratedOnTxt) { }
            column(Total_Count; TotalCount) { }
            column(New_Count; NewCount) { }
            column(Pending_Count; PendingCount) { }
            column(InProgress_Count; InProgressCount) { }
            column(Resolved_Count; ResolvedCount) { }
            column(Avg_Resolution_Days; AvgResolutionDaysTxt) { }
            column(Document_No; "Document No") { }
            column(Employee_Name; "Employee Name") { }
            column(Ticket_Title; Title) { }
            column(Placed_On; "Placed On") { }
            column(Resolved_On; "Resolved On") { }
            column(Status_Text; Format(Status)) { }
            column(Days_Open; DaysOpen) { }

            trigger OnPreDataItem()
            begin
                CalculateSummary("HelpDesk Tickets");
            end;

            trigger OnAfterGetRecord()
            begin
                if Status = Status::Resolved then
                    DaysOpen := "Resolved On" - "Placed On"
                else
                    DaysOpen := Today - "Placed On";
            end;
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        GeneratedOnTxt := Format(CurrentDateTime, 0, '<Day,2>/<Month,2>/<Year4> <Hours24>:<Minutes,2>');
    end;

    var
        CompanyInfo: Record "Company Information";
        GeneratedOnTxt: Text[50];
        AvgResolutionDaysTxt: Text[20];
        TotalCount: Integer;
        NewCount: Integer;
        PendingCount: Integer;
        InProgressCount: Integer;
        ResolvedCount: Integer;
        DaysOpen: Integer;

    local procedure CalculateSummary(FilteredTickets: Record "HelpDesk Tickets")
    var
        TicketCount: Record "HelpDesk Tickets";
        ResolvedTicket: Record "HelpDesk Tickets";
        TotalResolutionDays: Decimal;
        ResolvedCounter: Integer;
    begin
        TicketCount.CopyFilters(FilteredTickets);
        TotalCount := TicketCount.Count();

        TicketCount.SetRange(Status, TicketCount.Status::New);
        NewCount := TicketCount.Count();

        TicketCount.SetRange(Status, TicketCount.Status::Pending);
        PendingCount := TicketCount.Count();

        TicketCount.SetRange(Status, TicketCount.Status::"In Progress");
        InProgressCount := TicketCount.Count();

        TicketCount.SetRange(Status, TicketCount.Status::Resolved);
        ResolvedCount := TicketCount.Count();

        ResolvedTicket.CopyFilters(FilteredTickets);
        ResolvedTicket.SetRange(Status, ResolvedTicket.Status::Resolved);
        TotalResolutionDays := 0;
        ResolvedCounter := 0;
        if ResolvedTicket.FindSet() then
            repeat
                TotalResolutionDays += ResolvedTicket."Resolved On" - ResolvedTicket."Placed On";
                ResolvedCounter += 1;
            until ResolvedTicket.Next() = 0;

        if ResolvedCounter > 0 then
            AvgResolutionDaysTxt := Format(Round(TotalResolutionDays / ResolvedCounter, 0.1))
        else
            AvgResolutionDaysTxt := 'N/A';
    end;
}
