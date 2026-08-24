#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
report 50040 "TimeSheet Report EU Contract"
{
    // Reproduces the EU/NDICI-contract-style timesheet (one row per calendar day, Contract No.,
    // Contract Title, Position, Hours worked, Per Diems, Place of Performance, Task) sampled
    // from the "TUNU" timesheet, bound to the existing "TE Time Sheet1" data. Contract No.,
    // Contract Title and Place of Performance are not held anywhere in the data model today,
    // so they are entered on the request page instead of being guessed from another table.
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/TimeSheet Report EU Contract.rdlc';
    Caption = 'TimeSheet Report EU Contract';

    dataset
    {
        dataitem(DayLoop; Integer)
        {
            DataItemTableView = sorting(Number);

            column(ContractNo; ContractNo)
            {
            }
            column(ContractTitle; ContractTitle)
            {
            }
            column(EmployeeName; EmployeeName)
            {
            }
            column(Position; Position)
            {
            }
            column(MonthCaption; MonthCaption)
            {
            }
            column(YearCaption; YearCaption)
            {
            }
            column(DayNo; Number)
            {
            }
            column(EntryDate; EntryDate)
            {
            }
            column(HoursWorked; HoursWorked)
            {
            }
            column(PerDiem; PerDiem)
            {
            }
            column(PlaceOfPerformance; PlaceOfPerformance)
            {
            }
            column(Task; Task)
            {
            }
            column(IsWeekend; IsWeekend)
            {
            }

            trigger OnAfterGetRecord()
            var
                WeekdayText: Text[15];
            begin
                EntryDate := CalcDate(StrSubstNo('<+%1D>', Number - 1), FirstDayOfMonth);

                HoursWorked := 0;
                Task := '';
                TETimeSheet.Reset();
                TETimeSheet.SetRange("Employee No", EmployeeNo);
                TETimeSheet.SetRange(Date, EntryDate);
                if TETimeSheet.FindFirst() then begin
                    HoursWorked := TETimeSheet.Hours;
                    Task := TETimeSheet.Narration;
                end;

                WeekdayText := Format(EntryDate, 0, '<Weekday Text>');
                IsWeekend := (WeekdayText = 'Saturday') or (WeekdayText = 'Sunday');
            end;

            trigger OnPreDataItem()
            var
                DaysInMonth: Integer;
            begin
                if AsAt = 0D then
                    AsAt := Today;
                FirstDayOfMonth := CalcDate('-CM', AsAt);
                DaysInMonth := Date2DMY(CalcDate('CM', AsAt), 1);
                SetRange(Number, 1, DaysInMonth);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                field(AsAtDate; AsAt)
                {
                    ApplicationArea = Basic;
                    Caption = 'Month';
                    ToolTip = 'Any date within the month to report on.';
                }
                field(Employee; EmployeeNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee No.';
                    TableRelation = "HR Employees";
                    ToolTip = 'Specifies the employee to report on.';
                }
                field(ContractNoField; ContractNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract No.';
                    ToolTip = 'Specifies the contract number to print on the timesheet.';
                }
                field(ContractTitleField; ContractTitle)
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Title';
                    ToolTip = 'Specifies the contract title to print on the timesheet.';
                }
                field(PlaceOfPerformanceField; PlaceOfPerformance)
                {
                    ApplicationArea = Basic;
                    Caption = 'Place of Performance';
                    ToolTip = 'Specifies the place of performance to print on the timesheet.';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if AsAt = 0D then
            AsAt := Today;
        MonthCaption := Format(AsAt, 0, '<Month Text>');
        YearCaption := Format(AsAt, 0, '<Year4>');

        EmployeeName := '';
        Position := '';
        if HREmployees.Get(EmployeeNo) then begin
            EmployeeName := HREmployees.FullName;
            Position := HREmployees.Position;
        end;
    end;

    var
        HREmployees: Record "HR Employees";
        TETimeSheet: Record "TE Time Sheet1";
        AsAt: Date;
        FirstDayOfMonth: Date;
        EmployeeNo: Code[30];
        ContractNo: Text[50];
        ContractTitle: Text[250];
        PlaceOfPerformance: Text[100];
        EmployeeName: Text[100];
        Position: Text[80];
        MonthCaption: Text[30];
        YearCaption: Text[10];
        EntryDate: Date;
        HoursWorked: Decimal;
        PerDiem: Text[30];
        Task: Text[2048];
        IsWeekend: Boolean;
}
