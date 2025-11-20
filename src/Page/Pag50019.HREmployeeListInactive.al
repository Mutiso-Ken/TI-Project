page 50019 "HR Employee List-Inactive"
{
    ApplicationArea = Basic;
    CardPageID = "HR Employee Card";
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Employee';
    SourceTable = "HR Employees";
    SourceTableView = where(Status = filter(Inactive));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                Editable = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                    StyleExpr = true;
                }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Join"; Rec."Date Of Join")
                {
                    ApplicationArea = Basic;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic;
                }
                field("Portal Password"; Rec."Portal Password")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Company E-Mail"; Rec."Company E-Mail")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
                field("Cellular Phone Number"; Rec."Cellular Phone Number")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field("Supervisor ID"; Rec."Supervisor ID")
                {
                    ApplicationArea = Basic;
                }
                field("Supervisor User ID"; Rec."Supervisor User ID")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            part(Control1102755002; "HR Employees Factbox")
            {
                SubPageLink = "No." = field("No.");
            }
            systempart(Control1102755003; Outlook)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Employee)
            {
                Caption = 'Employee';
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = Card;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "HR Employee Card";
                    RunPageLink = "No." = field("No.");
                }
                action("Kin/Beneficiaries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Kin/Beneficiaries';
                    Image = Relatives;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "HR Employee Kin SF";
                    RunPageLink = "Employee Code" = field("No.");
                }
                action("Assigned Assets")
                {
                    ApplicationArea = Basic;
                    Caption = 'Assigned Assets';
                    Image = ResourceJournal;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Fixed Asset List";
                    RunPageLink = "Responsible Employee" = field("No.");
                }
                action("HR Leave Allocation")
                {
                    ApplicationArea = Basic;
                    Caption = 'HR Leave Allocation';
                    Image = ChangeDates;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Report "HR Leave Adjustment";
                }
                action("HR Leave Journal Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'HR Leave Journal Lines';
                    Image = Journals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "HR Leave Journal Lines";
                }
                action("HR Job Vacancy Report")
                {
                    ApplicationArea = Basic;
                    Caption = 'HR Job Vacancy Report';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Report "HR Job Vacancy Report";
                }
                action("HR Employee List")
                {
                    ApplicationArea = Basic;
                    Caption = 'HR Employee List';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Report "HR Employee List";
                }
                action("HR Employee PIF")
                {
                    ApplicationArea = Basic;
                    Caption = 'HR Employee PIF';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Report "HR Employee PIF";
                }
                action(" HR Leave Applications ")
                {
                    ApplicationArea = Basic;
                    Caption = ' HR Leave Applications ';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Report "HR Leave Applications List";
                }
                action("HR Leave Liability")
                {
                    ApplicationArea = Basic;
                    Caption = 'HR Leave Liability Report';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Report "HR Leave Balance Report";
                }
                action("Close Period")
                {
                    ApplicationArea = Basic;
                    Caption = 'Close Period';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Report "Close Period";
                }
            }
        }
    }

    var
        HREmp: Record "HR Employees";
        EmployeeFullName: Text;
}

