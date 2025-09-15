page 50017 "Payroll employee Inactive"
{
    ApplicationArea = All;
    Caption = 'Payroll employee Inactive';
    CardPageID = "Payroll Employee Card_AU";
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Payroll Employee_AU";
    UsageCategory = Lists;
    SourceTableView = where(Status = filter(<> Active));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(Surname; Rec.Surname)
                {
                    ApplicationArea = Basic;
                }
                field(Firstname; Rec.Firstname)
                {
                    ApplicationArea = Basic;
                }
                field(Lastname; Rec.Lastname)
                {
                    ApplicationArea = Basic;
                }
                field("Joining Date"; Rec."Joining Date")
                {
                    ApplicationArea = Basic;
                }
                field("<Employee Status>"; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Status';
                }
                field("Contract Type"; Rec."Contract Type")
                {
                    ApplicationArea = Basic;
                }
                field("PIN No"; Rec."PIN No")
                {
                    ApplicationArea = Basic;
                }
                field("NSSF No"; Rec."NSSF No")
                {
                    ApplicationArea = Basic;
                }
                field("NHIF No"; Rec."NHIF No")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control9; Outlook)
            {
            }
            systempart(Control10; Notes)
            {
            }
            systempart(Control11; MyNotes)
            {
            }
            systempart(Control12; Links)
            {
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Process Payroll")
            {
                ApplicationArea = Basic;
                Image = Allocations;
                Promoted = true;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    PayrollCalender.Reset;
                    PayrollCalender.SetRange(PayrollCalender.Closed, false);
                    if PayrollCalender.FindFirst then begin
                        "Payroll Period" := PayrollCalender."Date Opened";
                    end;
                    if "Payroll Period" = 0D then
                        Error('No Open Payroll Period');

                    PayrollEmp.Reset;
                    PayrollEmp.SetRange(PayrollEmp.Status, PayrollEmp.Status::Active);
                    PayrollEmp.SetRange(PayrollEmp."Suspend Pay", false);
                    if PayrollEmp.FindSet then begin
                        ProgressWindow.Open('Processing Salary for Employee No. #1#######');
                        repeat
                            PayrollEmp.TestField(PayrollEmp."Posting Group");
                            PayrollEmp.TestField(PayrollEmp."Joining Date");
                            PayrollEmp.TestField(PayrollEmp."Basic Pay");
                            /*PayrollEmp.TESTFIELD(PayrollEmp."PIN No");
                            PayrollEmp.TESTFIELD(PayrollEmp."NHIF No");
                            PayrollEmp.TESTFIELD(PayrollEmp."NSSF No");*/

                            //First Remove Any transactions for this Month
                            RemoveTrans(PayrollEmp."No.", "Payroll Period");
                            //End Remove Transactions
                            if PayrollEmp."Joining Date" <> 0D then begin
                                PayrollManager.ProcessPayroll(PayrollEmp."No.", "Payroll Period", PayrollEmp."Posting Group", PayrollEmp."Basic Pay", PayrollEmp."Basic Pay(LCY)",
                                                              PayrollEmp."Currency Code", PayrollEmp."Currency Factor", PayrollEmp."Joining Date", PayrollEmp."Date of Leaving",
                                                              false, PayrollEmp."Global Dimension 1", PayrollEmp."Global Dimension 2", '', PayrollEmp."Pays PAYE", PayrollEmp."Pays NHIF",
                                                              PayrollEmp."Pays NSSF", PayrollEmp.GetsPayeRelief, PayrollEmp.GetsPayeBenefit, PayrollEmp.Secondary, PayrollEmp.PayeBenefitPercent);
                                ProgressWindow.Update(1, PayrollEmp."No." + ':' + PayrollEmp."Full Name");
                            end;
                        until PayrollEmp.Next = 0;
                    end;
                    ProgressWindow.Close;
                    Message('Payroll processing completed successfully.');

                end;
            }
        }
        area(reporting)
        {
            action("Payroll Summary")
            {
                ApplicationArea = Basic;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "Payroll Summary P_AU";

                trigger OnAction()
                var
                    PayrollCalender: Record "Payroll Calender_AU";
                    "Payroll Period": Date;
                    "Period Name": Text;
                    PayrollManager: Codeunit "Payroll Management_AU";
                begin
                end;
            }
            action("Detailed Payroll  Summary")
            {
                ApplicationArea = Basic;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "Detailed Payroll Summary KES";

                trigger OnAction()
                var
                    PayrollCalender: Record "Payroll Calender_AU";
                    "Payroll Period": Date;
                    "Period Name": Text;
                    PayrollManager: Codeunit "Payroll Management_AU";
                begin
                end;
            }
            action("Payroll Detailed Summary")
            {
                ApplicationArea = Basic;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "Payroll Detailed Summary_AU";
                Visible = false;

                trigger OnAction()
                var
                    PayrollCalender: Record "Payroll Calender_AU";
                    "Payroll Period": Date;
                    "Period Name": Text;
                    PayrollManager: Codeunit "Payroll Management_AU";
                begin
                end;
            }
            action("Company Payroll Summary")
            {
                ApplicationArea = Basic;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "Company Payroll Summary_AU";

                trigger OnAction()
                var
                    PayrollCalender: Record "Payroll Calender_AU";
                    "Payroll Period": Date;
                    "Period Name": Text;
                    PayrollManager: Codeunit "Payroll Management_AU";
                begin
                end;
            }
            action("Deductions Summary")
            {
                ApplicationArea = Basic;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "Deductions Summary_AU";

                trigger OnAction()
                var
                    PayrollCalender: Record "Payroll Calender_AU";
                    "Payroll Period": Date;
                    "Period Name": Text;
                    PayrollManager: Codeunit "Payroll Management_AU";
                begin
                end;
            }
            action("Earnings Summary")
            {
                ApplicationArea = Basic;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "Payments Summary_AU";

                trigger OnAction()
                var
                    PayrollCalender: Record "Payroll Calender_AU";
                    "Payroll Period": Date;
                    "Period Name": Text;
                    PayrollManager: Codeunit "Payroll Management_AU";
                begin
                end;
            }
            action("PAYE Schedule")
            {
                ApplicationArea = Basic;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "Paye Schedule_AU";

                trigger OnAction()
                var
                    PayrollCalender: Record "Payroll Calender_AU";
                    "Payroll Period": Date;
                    "Period Name": Text;
                    PayrollManager: Codeunit "Payroll Management_AU";
                begin
                end;
            }
            action("NHIF Schedule")
            {
                ApplicationArea = Basic;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "NHIF Schedule_AU";

                trigger OnAction()
                var
                    PayrollCalender: Record "Payroll Calender_AU";
                    "Payroll Period": Date;
                    "Period Name": Text;
                    PayrollManager: Codeunit "Payroll Management_AU";
                begin
                end;
            }
            action("NSSF Schedule")
            {
                ApplicationArea = Basic;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "NSSF Schedule_AU";

                trigger OnAction()
                var
                    PayrollCalender: Record "Payroll Calender_AU";
                    "Payroll Period": Date;
                    "Period Name": Text;
                    PayrollManager: Codeunit "Payroll Management_AU";
                begin
                end;
            }
            action("BANK Schedule")
            {
                ApplicationArea = Basic;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "Bank Schedule_AU";

                trigger OnAction()
                var
                    PayrollCalender: Record "Payroll Calender_AU";
                    "Payroll Period": Date;
                    "Period Name": Text;
                    PayrollManager: Codeunit "Payroll Management_AU";
                begin
                end;
            }
            action("Pension Report")
            {
                ApplicationArea = Basic;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "Pension Report_AU";

                trigger OnAction()
                var
                    PayrollCalender: Record "Payroll Calender_AU";
                    "Payroll Period": Date;
                    "Period Name": Text;
                    PayrollManager: Codeunit "Payroll Management_AU";
                begin
                end;
            }
            action(P9)
            {
                ApplicationArea = Basic;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report P9Report;

                trigger OnAction()
                var
                    PayrollCalender: Record "Payroll Calender_AU";
                    "Payroll Period": Date;
                    "Period Name": Text;
                    PayrollManager: Codeunit "Payroll Management_AU";
                begin
                end;
            }
        }
    }

    trigger OnInit()
    begin
        if UserSetup.Get(UserId) then begin
            if not UserSetup."View Payroll" then
                Error(PemissionDenied);
        end else begin
            Error(UserNotFound, UserId);
        end;
    end;

    var
        Employee: Record "Payroll Employee_AU";
        UserSetup: Record "User Setup";
        UserNotFound: label 'User Setup %1 not found.';
        PemissionDenied: label 'User Account is not Setup for Payroll Use. Contact System Administrator.';
        PayrollEmp: Record "Payroll Employee_AU";
        ProgressWindow: Dialog;
        PayrollManager: Codeunit "Payroll Management_AU";
        "Payroll Period": Date;
        PayrollCalender: Record "Payroll Calender_AU";
        PayrollMonthlyTrans: Record "Payroll Monthly Trans_AU";
        PayrollEmployeeDed: Record "Payroll Employee Deductions_AU";
        PayrollEmployerDed: Record "Payroll Employer Deductions_AU";

    local procedure RemoveTrans(EmpNo: Code[20]; PayrollPeriod: Date)
    begin
        //Remove Monthly Transactions
        PayrollMonthlyTrans.Reset;
        PayrollMonthlyTrans.SetRange(PayrollMonthlyTrans."No.", EmpNo);
        PayrollMonthlyTrans.SetRange(PayrollMonthlyTrans."Period Month", Date2dmy(PayrollPeriod, 2));
        PayrollMonthlyTrans.SetRange(PayrollMonthlyTrans."Period Year", Date2dmy(PayrollPeriod, 3));
        if PayrollMonthlyTrans.FindSet then
            PayrollMonthlyTrans.DeleteAll;

        //Remove Employee Deductions
        //Remove Employer Deductions
    end;
}


