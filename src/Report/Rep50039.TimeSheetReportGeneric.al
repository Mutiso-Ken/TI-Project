#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
report 50039 "TimeSheet Report Generic"
{
    // Reproduces the TI-Kenya generic blank timesheet (Date / Hours / % Daily Equivalent /
    // Description / Hours on other projects / Fund) as a printable report bound to the
    // existing "TE Time Sheet1" data.
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/TimeSheet Report Generic.rdlc';
    Caption = 'TimeSheet Report Generic';

    dataset
    {
        dataitem("TE Time Sheet1"; "TE Time Sheet1")
        {
            RequestFilterFields = "Employee No";

            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(StaffName; StaffName)
            {
            }
            column(StaffTitle; StaffTitle)
            {
            }
            column(MonthCaption; MonthCaption)
            {
            }
            column(YearCaption; YearCaption)
            {
            }
            column(EntryDate; "TE Time Sheet1".Date)
            {
            }
            column(Hours; "TE Time Sheet1".Hours)
            {
            }
            column(PercentDailyEquivalent; PercentDailyEquivalent)
            {
            }
            column(Narration; "TE Time Sheet1".Narration)
            {
            }
            column(HoursOtherProjects; HoursOtherProjects)
            {
            }
            column(FundName; FundName)
            {
            }

            trigger OnAfterGetRecord()
            begin
                HREmployees.Reset();
                if HREmployees.Get("TE Time Sheet1"."Employee No") then begin
                    StaffName := HREmployees.FullName;
                    StaffTitle := HREmployees.Position;
                end;

                // % Daily Equivalent = hours on this line as a % of a standard 8-hour day.
                PercentDailyEquivalent := Format(Round("TE Time Sheet1".Hours / 8 * 100, 1)) + ' %';

                // Hours on other projects = hours the same employee logged on the same date
                // under a different timesheet document/fund.
                HoursOtherProjects := 0;
                TETimeSheet.Reset();
                TETimeSheet.SetRange("Employee No", "TE Time Sheet1"."Employee No");
                TETimeSheet.SetRange(Date, "TE Time Sheet1".Date);
                if TETimeSheet.FindSet() then
                    repeat
                        if TETimeSheet."Document No." <> "TE Time Sheet1"."Document No." then
                            HoursOtherProjects += TETimeSheet.Hours;
                    until TETimeSheet.Next() = 0;

                FundName := '';
                DimensionValue.Reset();
                DimensionValue.SetRange(Code, "TE Time Sheet1"."Global Dimension 1 Code");
                if DimensionValue.FindFirst() then
                    FundName := DimensionValue.Name;
            end;

            trigger OnPreDataItem()
            begin
                SetFilter(Date, '%1..%2', CalcDate('-CM', AsAt), CalcDate('CM', AsAt));
                if EmployeeNo <> '' then
                    SetRange("Employee No", EmployeeNo);
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
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    trigger OnPreReport()
    begin
        if AsAt = 0D then
            AsAt := Today;
        MonthCaption := Format(AsAt, 0, '<Month Text>');
        YearCaption := Format(AsAt, 0, '<Year4>');
    end;

    var
        CompanyInfo: Record "Company Information";
        HREmployees: Record "HR Employees";
        TETimeSheet: Record "TE Time Sheet1";
        DimensionValue: Record "Dimension Value";
        AsAt: Date;
        EmployeeNo: Code[30];
        StaffName: Text[100];
        StaffTitle: Text[80];
        MonthCaption: Text[30];
        YearCaption: Text[10];
        PercentDailyEquivalent: Text[10];
        HoursOtherProjects: Decimal;
        FundName: Text[100];
}
