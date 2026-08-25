#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50018 "Payroll Project Allocation"
{
    PageType = List;
    SourceTable = "Payroll Project Allocation";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Period; Rec.Period)
                {
                    ApplicationArea = Basic;
                }
                field("Employee No"; Rec."Employee No")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field("Project Code"; Rec."Project Code")
                {
                    ApplicationArea = Basic;
                }
                field("Budget Line Code"; Rec."Budget Line Code")
                {
                    ApplicationArea = Basic;
                }
                field(Allocation; Rec.Allocation)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(LoadAllocations)
            {
                ApplicationArea = Basic;
                Caption = 'Load Allocations';
                Image = AddAction;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    LoadedCount: Integer;
                    SkippedCount: Integer;
                begin
                    PayrollCalender_AU.Reset;
                    PayrollCalender_AU.SetRange(Closed, true);
                    if not PayrollCalender_AU.FindLast then
                        Error('There is no closed payroll period to copy allocations from.');

                    PayrollCalender_AU2.Reset;
                    PayrollCalender_AU2.SetRange(Closed, false);
                    if not PayrollCalender_AU2.FindLast then
                        Error('There is no open payroll period to load allocations into. Open the next payroll period first.');

                    if PayrollCalender_AU2."Date Opened" = PayrollCalender_AU."Date Opened" then
                        Error('The latest closed period and the open period are the same (%1). Nothing to copy.', PayrollCalender_AU."Date Opened");

                    LoadedCount := 0;
                    SkippedCount := 0;
                    PayrollProjectAllocation.Reset;
                    PayrollProjectAllocation.SetRange(Period, PayrollCalender_AU."Date Opened");
                    if PayrollProjectAllocation.FindSet then begin
                        repeat
                            if PayrollProjectAllocation2.Get(PayrollCalender_AU2."Date Opened", PayrollProjectAllocation."Project Code", PayrollProjectAllocation."Employee No") then
                                SkippedCount += 1
                            else begin
                                PayrollProjectAllocation2.Init;
                                PayrollProjectAllocation2.Period := PayrollCalender_AU2."Date Opened";
                                PayrollProjectAllocation2."Project Code" := PayrollProjectAllocation."Project Code";
                                PayrollProjectAllocation2."Budget Line Code" := PayrollProjectAllocation."Budget Line Code";
                                PayrollProjectAllocation2."Employee No" := PayrollProjectAllocation."Employee No";
                                PayrollProjectAllocation2."Employee Name" := PayrollProjectAllocation."Employee Name";
                                PayrollProjectAllocation2.Allocation := PayrollProjectAllocation.Allocation;
                                PayrollProjectAllocation2.Insert();
                                LoadedCount += 1;
                            end;
                        until PayrollProjectAllocation.Next = 0;
                    end;

                    Message('Completed. %1 allocation(s) loaded into %2, %3 already existed and were skipped.',
                        LoadedCount, PayrollCalender_AU2."Date Opened", SkippedCount);

                    // Hide the previous period's rows now that the new period's allocations exist -
                    // show only the period just loaded into.
                    Rec.Reset();
                    Rec.SetRange(Period, PayrollCalender_AU2."Date Opened");
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Rec."Employee Name" = '' then begin
            if HREmployees.Get(Rec."Employee No") then begin
                Rec."Employee Name" := HREmployees.Firstname + ' ' + HREmployees.Lastname;
                Rec.Modify;
            end;
        end;
    end;

    trigger OnOpenPage()
    begin
        // Default the list to the current open period only - same period "Load Allocations"
        // loads into - so previous periods stay hidden until the user clears the filter.
        PayrollCalender_AU2.Reset();
        PayrollCalender_AU2.SetRange(Closed, false);
        if PayrollCalender_AU2.FindLast() then begin
            Rec.Reset();
            Rec.SetRange(Period, PayrollCalender_AU2."Date Opened");
        end;
    end;

    var
        HREmployees: Record "Payroll Employee_AU";
        PayrollProjectAllocation: Record "Payroll Project Allocation";
        PayrollCalender_AU: Record "Payroll Calender_AU";
        PayrollCalender_AU2: Record "Payroll Calender_AU";
        PayrollProjectAllocation2: Record "Payroll Project Allocation";
}

