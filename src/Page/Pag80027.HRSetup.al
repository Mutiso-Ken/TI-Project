#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 80027 "HR Setup"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    RefreshOnActivate = false;
    SourceTable = "HR Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Leave Posting Period[FROM]"; Rec."Leave Posting Period[FROM]")
                {
                    ApplicationArea = Basic;
                }
                field("Leave Posting Period[TO]"; Rec."Leave Posting Period[TO]")
                {
                    ApplicationArea = Basic;
                }
                field("Default Leave Posting Template"; Rec."Default Leave Posting Template")
                {
                    ApplicationArea = Basic;
                }
                field("Positive Leave Posting Batch"; Rec."Positive Leave Posting Batch")
                {
                    ApplicationArea = Basic;
                }
                field("Negative Leave Posting Batch"; Rec."Negative Leave Posting Batch")
                {
                    ApplicationArea = Basic;
                }
                field("Max Appraisal Rating"; Rec."Max Appraisal Rating")
                {
                    ApplicationArea = Basic;
                }
                field("Training GL"; Rec."Training GL")
                {
                    ApplicationArea = Basic;
                }
                field("Open Training"; Rec."Open Training")
                {
                    ApplicationArea = Basic;
                    Caption = 'Open Training Calendar for modification';
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = Basic;
                    Caption = 'Grievances Email';
                }
                field("Feedback Email"; Rec."Feedback Email")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Base Calendar"; Rec."Base Calendar")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Nos."; Rec."Employee Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Timesheet Nos."; Rec."Timesheet Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Appraisal Nos."; Rec."Appraisal Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Training Analysis Nos"; Rec."Training Analysis Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Training Application Nos."; Rec."Training Application Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Leave Application Nos."; Rec."Leave Application Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Disciplinary Cases Nos."; Rec."Disciplinary Cases Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Requisition Nos."; Rec."Employee Requisition Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Medical Claims Nos"; Rec."Medical Claims Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Job Application Nos"; Rec."Job Application Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Exit Interview Nos"; Rec."Exit Interview Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Appraisal Nos"; Rec."Appraisal Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Company Activities"; Rec."Company Activities")
                {
                    ApplicationArea = Basic;
                }
                field("Job Nos"; Rec."Job Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Job Interview Nos"; Rec."Job Interview Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Notice Board Nos."; Rec."Notice Board Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Transport Req Nos"; Rec."Transport Req Nos")
                {
                    ApplicationArea = Basic;
                }
                field("HR Policies"; Rec."HR Policies")
                {
                    ApplicationArea = Basic;
                }
                field("Leave Reimbursment Nos."; Rec."Leave Reimbursment Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Leave Carry Over App Nos."; Rec."Leave Carry Over App Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Pay-change No."; Rec."Pay-change No.")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Transfer Nos."; Rec."Employee Transfer Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Leave Planner Nos."; Rec."Leave Planner Nos.")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Leave)
            {
                Caption = 'Leave';
                field("Min. Leave App. Months"; Rec."Min. Leave App. Months")
                {
                    ApplicationArea = Basic;
                }
                field("Leave Template"; Rec."Leave Template")
                {
                    ApplicationArea = Basic;
                }
                field("Leave Batch"; Rec."Leave Batch")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin

        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
    end;
}

