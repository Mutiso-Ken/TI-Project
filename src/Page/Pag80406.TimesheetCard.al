#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 80406 "Timesheet Card"
{
    PageType = Card;
    SourceTable = TimesheetLines;

    layout
    {
        area(content)
        {
            group(General)
            {
            }
            field(Timesheetcode; Rec.Timesheetcode)
            {
                ApplicationArea = Basic;
            }
            field(From; Rec.From)
            {
                ApplicationArea = Basic;
            }
            field("To Date"; Rec."To Date")
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
                Editable = false;
            }
            field("Supervisor ID"; Rec."Supervisor ID")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            group("Timesheet Lines")
            {
                Caption = 'Timesheet Lines';
            }
            part(Control6; "Timesheet Lines")
            {
                SubPageLink = "Document No." = field(Timesheetcode);
                ApplicationArea = all;
            }
        }
    }

    actions
    {

        area(Processing)
        {

            action(SendApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Request approval of the document.';


                trigger OnAction()
                var
                    CustomApprovalsCodeunit: Codeunit "Custom Approvals Codeunit";
                begin
                    Rec.TestField(Status, Rec.Status::Open);
                    varrvariant := Rec;
                    if CustomApprovalsCodeunit.CheckApprovalsWorkflowEnabled(varrvariant) then
                        CustomApprovalsCodeunit.RunWorkflowOnSendApprovalRequest(varrvariant);
                end;
            }
            action("Time Sheet Report")
            {
                ApplicationArea = Basic, Suite;
                Image = Timesheet;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = report "TimeSheet Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Request approval of the document.';
            }
            action("Time report summary")
            {
                ApplicationArea = Basic, Suite;
                Image = Timesheet;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = report "TimeSheet Report Summary";
                PromotedIsBig = true;
                PromotedOnly = true;
            }
            action("TimeSheet Report Portal")
            {
                ApplicationArea = Basic, Suite;
                Image = Timesheet;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = report "TimeSheet Report Portal";
                PromotedIsBig = true;
                PromotedOnly = true;
            }
        }
    }
    var
        CustomApprovalsCodeunit: Codeunit "Custom Approvals Codeunit";
        varrvariant: Variant;

}
