#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 80020 "Payroll Employee Card-Part_AU"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Payroll Employee_AU";

    layout
    {
        area(content)
        {
            group(General)
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
                field(Photo; Rec.Photo)
                {
                    ApplicationArea = Basic;
                }
                field("Joining Date"; Rec."Joining Date")
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1"; Rec."Global Dimension 1")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 2"; Rec."Global Dimension 2")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
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
                field("PIN No"; Rec."PIN No")
                {
                    ApplicationArea = Basic;
                }
                field("ID No/Passport No"; Rec."ID No/Passport No")
                {
                    ApplicationArea = Basic;
                }
                field("Contract Type"; Rec."Contract Type")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Pay Details")
            {
                field("Basic Pay"; Rec."Basic Pay")
                {
                    ApplicationArea = Basic;
                }
                field("Basic Pay(LCY)"; Rec."Basic Pay(LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Non Taxable"; Rec."Non Taxable")
                {
                    ApplicationArea = Basic;
                }
                field("Non Taxable(LCY)"; Rec."Non Taxable(LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Pays PAYE"; Rec."Pays PAYE")
                {
                    ApplicationArea = Basic;
                }
                field("Pays NSSF"; Rec."Pays NSSF")
                {
                    ApplicationArea = Basic;
                }
                field("Pays NHIF"; Rec."Pays NHIF")
                {
                    ApplicationArea = Basic;
                }
                field("Suspend Pay"; Rec."Suspend Pay")
                {
                    ApplicationArea = Basic;
                }
                field("Suspend Date"; Rec."Suspend Date")
                {
                    ApplicationArea = Basic;
                }
                field("Suspend Reason"; Rec."Suspend Reason")
                {
                    ApplicationArea = Basic;
                }
                field("Hourly Rate"; Rec."Hourly Rate")
                {
                    ApplicationArea = Basic;
                }
                field(Gratuity; Rec.Gratuity)
                {
                    ApplicationArea = Basic;
                }
                field("Gratuity Percentage"; Rec."Gratuity Percentage")
                {
                    ApplicationArea = Basic;
                }
                field("Gratuity Provision"; Rec."Gratuity Provision")
                {
                    ApplicationArea = Basic;
                }
                field("Gratuity Provision(LCY)"; Rec."Gratuity Provision(LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Days Absent"; Rec."Days Absent")
                {
                    ApplicationArea = Basic;
                }
                field("Paid per Hour"; Rec."Paid per Hour")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Bank Details")
            {
                field("Bank Code"; Rec."Bank Code")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = Basic;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = Basic;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Account No"; Rec."Bank Account No")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Other Details")
            {
                field("Payslip Message"; Rec."Payslip Message")
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
            action("Process Payroll")
            {
                ApplicationArea = Basic;
                Image = Allocations;
                Promoted = true;
                PromotedIsBig = true;

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
                    PayrollEmp.SetRange(PayrollEmp."Contract Type", PayrollEmp."contract type"::Contract);
                    PayrollEmp.SetRange(PayrollEmp."Suspend Pay", false);
                    if PayrollEmp.FindSet then begin

                        ProgressWindow.Open('Processing Salary for Employee No. #1#######');
                        repeat
                            PayrollEmp.TestField(PayrollEmp."Posting Group");
                            PayrollEmp.TestField(PayrollEmp."Joining Date");
                            // PayrollEmp.TESTFIELD(PayrollEmp."Basic Pay");
                            //PayrollEmp.TESTFIELD(PayrollEmp."PIN No");
                            //PayrollEmp.TESTFIELD(PayrollEmp."NHIF No");
                            //PayrollEmp.TESTFIELD(PayrollEmp."NSSF No");

                            //First Remove Any transactions for this Month
                            RemoveTrans(PayrollEmp."No.", "Payroll Period");
                            //End Remove Transactions
                            if PayrollEmp."Joining Date" <> 0D then begin

                                PayrollManager.ProcessPartTimePayroll(PayrollEmp."No.", "Payroll Period", PayrollEmp."Posting Group", PayrollEmp."Basic Pay", PayrollEmp."Basic Pay(LCY)",
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
            action("Process Current Employee")
            {
                ApplicationArea = Basic;
                Image = Allocations;
                Promoted = true;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    Rec.TestField("Posting Group");
                    Rec.TestField("Joining Date");
                    Rec.TestField("Basic Pay");
                    /*TESTFIELD("PIN No");
                    TESTFIELD("NHIF No");
                    TESTFIELD("NSSF No");*/

                    PayrollCalender.Reset;
                    PayrollCalender.SetRange(PayrollCalender.Closed, false);
                    if PayrollCalender.FindFirst then begin
                        "Payroll Period" := PayrollCalender."Date Opened";
                    end;
                    if "Payroll Period" = 0D then
                        Error('No Open Payroll Period');

                    PayrollEmp.Reset;
                    PayrollEmp.SetRange(PayrollEmp.Status, PayrollEmp.Status::Active);
                    PayrollEmp.SetRange(PayrollEmp."Contract Type", PayrollEmp."contract type"::Contract);
                    PayrollEmp.SetRange(PayrollEmp."No.", Rec."No.");
                    PayrollEmp.SetRange(PayrollEmp."Suspend Pay", false);
                    if PayrollEmp.FindFirst then begin
                        ProgressWindow.Open('Processing Salary for Employee No. #1#######');
                        //First Remove Any transactions for this Month
                        RemoveTrans(PayrollEmp."No.", "Payroll Period");
                        //End Remove Transactions
                        if PayrollEmp."Joining Date" <> 0D then begin
                            PayrollManager.ProcessPartTimePayroll(PayrollEmp."No.", "Payroll Period", PayrollEmp."Posting Group", PayrollEmp."Basic Pay", PayrollEmp."Basic Pay(LCY)",
                                                         PayrollEmp."Currency Code", PayrollEmp."Currency Factor", PayrollEmp."Joining Date", PayrollEmp."Date of Leaving",
                                                         false, PayrollEmp."Global Dimension 1", PayrollEmp."Global Dimension 2", '', PayrollEmp."Pays PAYE", PayrollEmp."Pays NHIF",
                                                         PayrollEmp."Pays NSSF", PayrollEmp.GetsPayeRelief, PayrollEmp.GetsPayeBenefit, PayrollEmp.Secondary, PayrollEmp.PayeBenefitPercent);
                            ProgressWindow.Update(1, PayrollEmp."No." + ':' + PayrollEmp."Full Name");
                        end;
                    end;
                    ProgressWindow.Close;
                    Message('Payroll processing completed successfully.');

                end;
            }
            action("Employee Earnings")
            {
                ApplicationArea = Basic;
                Image = AllLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Payroll Employee Earnings_AU";
                RunPageLink = "No." = field("No.");
            }
            action("Employee Deductions")
            {
                ApplicationArea = Basic;
                Image = EntriesList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Payroll Employee Ded_AU";
                RunPageLink = "No." = field("No.");
            }
            action("Employee Assignments")
            {
                ApplicationArea = Basic;
                Image = Apply;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Payroll Employee Assignp_AU";
                RunPageLink = "No." = field("No.");
            }
            action("Employee Cummulatives")
            {
                ApplicationArea = Basic;
                Image = History;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Payroll Emp. Cummulati_AU";
                RunPageLink = "No." = field("No.");
            }
            action("View PaySlip 2")
            {
                ApplicationArea = Basic;
                Image = PaymentHistory;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    PayrollEmp.Reset;
                    PayrollEmp.SetRange(PayrollEmp."No.", Rec."No.");
                    if PayrollEmp.FindFirst then begin
                        //    REPORT.RUN(REPORT::"Payroll Payslip",TRUE,FALSE,PayrollEmp);
                    end;
                end;
            }
            action("View PaySlip ")
            {
                ApplicationArea = Basic;
                Caption = 'View PaySlip ';
                Image = PaymentHistory;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    PayrollEmp.Reset;
                    PayrollEmp.SetRange(PayrollEmp."No.", Rec."No.");
                    PayrollEmp.SetRange(PayrollEmp."Period Filter", Rec."Period Filter");
                    //IF PayrollEmp.FINDFIRST THEN BEGIN
                    Report.Run(50066, true, false, PayrollEmp);
                    //END;
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
        PayrollEmp: Record "Payroll Employee_AU";
        ProgressWindow: Dialog;
        PayrollManager: Codeunit "Payroll Management_AU";
        "Payroll Period": Date;
        PayrollCalender: Record "Payroll Calender_AU";
        PayrollMonthlyTrans: Record "Payroll Monthly Trans_AU";
        PayrollEmployeeDed: Record "Payroll Employee Deductions_AU";
        PayrollEmployerDed: Record "Payroll Employer Deductions_AU";
        UserSetup: Record "User Setup";
        UserNotFound: label 'User Setup %1 not found.';
        PemissionDenied: label 'User Account is not Setup for Payroll Use. Contact System Administrator.';

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

