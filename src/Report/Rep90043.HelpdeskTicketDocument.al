report 90043 "Helpdesk Ticket Document"
{
    Caption = 'Helpdesk Ticket Document';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HelpdeskTicketDocument.rdlc';

    dataset
    {
        dataitem("HelpDesk Tickets"; "HelpDesk Tickets")
        {
            RequestFilterFields = "Document No", Status;

            column(CompanyInfoName; CompanyInfo.Name) { }
            column(CompanyInfoPicture; CompanyInfo.Picture) { }
            column(GeneratedOnTxt; GeneratedOnTxt) { }
            column(Document_No; "Document No") { }
            column(Ticket_Title; Title) { }
            column(Ticket_Description; Description) { }
            column(Employee_ID; "Employee ID") { }
            column(Employee_Name; "Employee Name") { }
            column(Placed_On; "Placed On") { }
            column(Resolved_On; "Resolved On") { }
            column(Status_Text; Format(Status)) { }
            column(Document_Link; "Document Link") { }

            dataitem("Tickets Updates"; "Tickets Updates")
            {
                DataItemLink = "Ticket No" = field("Document No");
                DataItemTableView = sorting("Entry No") order(ascending);

                column(Update_DateTime; "Update DateTime") { }
                column(Ticket_Status_Text; Format("Ticket Status")) { }
                column(Update_Comment; Comment) { }
            }
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
}
