
report 40 "Asset Assignment History"
{
    Caption = 'Asset Assignment History';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/AssetAssignmentHistory.rdlc';

    dataset
    {
        dataitem(FixedAsset; "Fixed Asset")
        {
            RequestFilterFields = "No.";

            column(FA_No; "No.") { }
            column(FA_Description; Description) { }
            column(FA_Type; "FA Class Code") { }
            column(FA_Serial_Number; "Serial No.") { }
            column(FA_Tag_Number; "Tag Number") { }
            column(FA_Warranty_Date; "Warranty Date") { }
            column(FA_Next_Service; "Next Service Date") { }
            column(CompanyINfoName; CompanyINfo.Name) { }
            column(CompanyINfoAdd; CompanyINfo.Address) { }
            column(CompanyINfoPicture; CompanyINfo.Picture) { }

            dataitem(AssetAssignmentHistory; "Asset Assignment History")
            {
                DataItemLink = "Fixed Asset No." = field("No.");
                DataItemTableView = sorting("Fixed Asset No.", "Assigned Date");

                column(Entry_No; "Entry No.") { }
                column(Employee_No; "Employee No.") { }
                column(Employee_Name; "Employee Name") { }
                column(Assigned_Date; "Assigned Date") { }
                column(Expected_Return_Date; "Expected Return Date") { }
                column(Return_Date; "Return Date") { }
                column(Status_Text; Format(Status)) { }
                column(Condition_On_Assignment; "Condition on Assignment") { }
                column(Condition_On_Return; "Condition on Return") { }
                column(Remarks_Field; Remarks) { }
                column(Assigned_By; "Assigned By") { }

                trigger OnPreDataItem()
                begin
                    if EmployeeNoFilter <> '' then
                        SetRange("Employee No.", EmployeeNoFilter);
                    if DateFromFilter <> 0D then
                        SetFilter("Assigned Date", '>=%1', DateFromFilter);
                    if DateToFilter <> 0D then
                        SetFilter("Assigned Date", '<=%1', DateToFilter);
                    if ActiveOnlyFilter then
                        SetRange(Status, Status::Assigned);
                end;
            }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(EmployeeNo; EmployeeNoFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Employee No.';
                        ToolTip = 'Show only assignments for this employee.';
                        TableRelation = Employee;
                    }
                    field(DateFrom; DateFromFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Assigned From';
                        ToolTip = 'Show only assignments from this date onward.';
                    }
                    field(DateTo; DateToFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Assigned To';
                        ToolTip = 'Show only assignments up to this date.';
                    }
                    field(ActiveOnly; ActiveOnlyFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Only Active Assignments';
                        ToolTip = 'If checked, only assignments that have not been returned are included.';
                    }
                }
            }
        }
    }
    trigger OnPreReport()

    begin
        CompanyINfo.Get;
        CompanyINfo.CalcFields(Picture);
    end;

    var
        CompanyINfo: Record "Company Information";
        EmployeeNoFilter: Code[20];
        DateFromFilter: Date;
        DateToFilter: Date;
        ActiveOnlyFilter: Boolean;
}