#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 //  ForNAV settings
Page 20365 "Appraisal Card"
{
    PageType = Card;
    SourceTable = "Appraisal Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Appraisal Code"; Rec."Appraisal Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Employee No"; Rec."Employee No")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Deparment"; Rec."Employee Deparment")
                {
                    ApplicationArea = Basic;
                }
                field(ApprovalSteps; Rec.ApprovalSteps)
                {
                    Caption = 'Approval Steps';
                    ApplicationArea = Basic;
                }
                field("Supervisor Name"; Rec."Supervisor Name")
                {
                    Caption = 'Current Approving Supervisor';
                    ApplicationArea = Basic;
                }
                field("Review Period"; Rec."Review Period")
                {
                    ApplicationArea = Basic;
                }
            }
            label("SECTION A")
            {
                ApplicationArea = Basic, Suite;
                Style = Strong;
                Caption = 'SECTION A: PERFORMANCE RESULTS (MEASURES 5 CORE RESULTS) 50 MARKS';
            }
            part("Appraisal Section A Part 1"; "Appraisal Section A Part 1")
            {
                Caption = '';
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }
            part("Appraisal Section A Part 2"; "Appraisal Section A Part 2")
            {
                Caption = '';
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }

            label("SECTION B")
            {
                ApplicationArea = Basic, Suite;
                Style = Strong;
                Caption = 'SECTION B: PERFORMANCE RESULTS (MEASURES 5 CORE RESULTS) 50 MARKS';
            }
            part(Section1; "Appraisal Section B Part 1")
            {
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }
            part(Section2; "Appraisal Section B Part 2")
            {
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }
            part(Section3; "Appraisal Section B Part 3")
            {
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }
            part(Section4; "Appraisal Section B Part 4")
            {
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }
            label("SECTION C")
            {
                ApplicationArea = Basic, Suite;
                Style = Strong;
                Caption = 'SECTION C: VALUES AND COMPETENCIES (TECHNICAL & BEHAVIOURAL) (25 MARKS)';
            }
            part(SectionC1; "Appraisal Section C Part 1")
            {
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }
            part(SectionC2; "Appraisal Section C Part 2")
            {
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }
            part(SectionC3; "Appraisal Section C Part 3")
            {
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }
            part(SectionC4; "Appraisal Section C Part 4")
            {
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }
            part(SectionC5; "Appraisal Section C Part 5")
            {
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }
            label("SECTION D")
            {
                ApplicationArea = Basic, Suite;
                Style = Strong;
                Caption = 'SECTION D: PERSONAL QUALITIES: 25 MARKS (TO BE FILLED BY THE SUPERVISOR)';
            }
            part(SectionD1; "Appraisal Section D Part 1")
            {
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
                Editable = false;
            }
            part(SectionD2; "Appraisal Section D Part 2")
            {
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }
            part(SectionD3; "Appraisal Section D Part 3")
            {
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }
            part(SectionD4; "Appraisal Section D Part 4")
            {
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }
            part(SectionD5; "Appraisal Section D Part 5")
            {
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        HrSetup.Get;
        HRsetup.TestField("Appraisal Nos.");
        Rec."Appraisal Code" := NoSeriesManagement.GetNextNo(HrSetup."Appraisal Nos.", Today, true);
    end;

    var
        HrSetup: Record "HR Setup";
        NoSeriesManagement: Codeunit "No. Series";
        AppraisalLinesSectionA: record "Appraisal Lines Section A";
        AppraisalLinesSectionB: record "Appraisal Lines Section B";
        AppraisalLinesSectionC: record "Appraisal Lines Section C";
        AppraisalLinesSectionD: record "Appraisal Lines Section D";
}

