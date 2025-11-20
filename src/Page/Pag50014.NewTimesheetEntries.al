#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50014 "New Timesheet Entries"
{
    CardPageID = "Timesheet Card";
    PageType = List;
    SourceTable = TimesheetLines;
    SourceTableView = where(Status = const(Open));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Timesheetcode; Rec.Timesheetcode)
                {
                    ApplicationArea = Basic;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field(From; Rec.From)
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Staff Project Hours")
            {
                ApplicationArea = Basic;
                Image = Receipt;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
               // RunObject = Report "BD Customer Report";
            }
            action("TimeSheet Report")
            {
                ApplicationArea = Basic;
                Image = Receipt;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                //RunObject = Report "Update Dates";
            }
            action("TimeSheet Report Summary")
            {
                ApplicationArea = Basic;
                Image = Receipt;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                //RunObject = Report "BD RCK RB";
            }
            action("TimeSheet Report Portal")
            {
                ApplicationArea = Basic;
                Image = Receipt;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    TimesheetLines.Reset;
                    TimesheetLines.SetRange(Timesheetcode, Rec.Timesheetcode);
                    TimesheetLines.SetFilter(From, '%1..%2', Rec.From, CalcDate('CM', Rec.From));
                    if TimesheetLines.Find('-') then begin
                        Report.Run(50037, true, false, TimesheetLines);
                    end;
                end;
            }
        }
    }

    var
        TimesheetLines: Record TimesheetLines;
}

