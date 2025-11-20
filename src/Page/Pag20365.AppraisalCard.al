#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
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
                field("Supervisor Name"; Rec."Supervisor Name")
                {
                    ApplicationArea = Basic;
                }
                field("Review Period"; Rec."Review Period")
                {
                    ApplicationArea = Basic;
                }
            }
            label(SECTIONA)
            {
                ApplicationArea = Basic, Suite;
                Style = Strong;
                Caption = 'SECTION A: PERFORMANCE RESULTS (MEASURES 5 CORE RESULTS) 50 MARKS';
            }
            part("Appraisal Section A"; "Appraisal Section A")
            {
                Caption = '';
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }
            part(AppraisalSecApart2; AppraisalSecApart2)
            {
                Caption = '';
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }

            label(SECTIONB)
            {
                ApplicationArea = Basic, Suite;
                Style = Strong;
                Caption = 'SECTION B: PERFORMANCE RESULTS (MEASURES 5 CORE RESULTS) 50 MARKS';
            }

            part("Appraisal Section B"; "Appraisal Section B")
            {
                ApplicationArea = all;
                SubPageLink = "Appraisal Code" = field("Appraisal Code");
            }
            // part("Appraisal Section B2"; "Appraisal Section B2")
            // {
            //     ApplicationArea = all;
            //     SubPageLink = "Appraisal Code" = field("Appraisal Code");
            // }
            // part("Appraisal Section B3"; "Appraisal Section B3")
            // {
            //     ApplicationArea = all;
            //     SubPageLink = "Appraisal Code" = field("Appraisal Code");
            // }
            // part("Appraisal Section B4"; "Appraisal Section B4")
            // {
            //     ApplicationArea = all;
            //     SubPageLink = "Appraisal Code" = field("Appraisal Code");
            // }
            // part("Appraisal Section B5"; "Appraisal Section B5")
            // {
            //     ApplicationArea = all;
            //     SubPageLink = "Appraisal Code" = field("Appraisal Code");

            // }



        }
    }

    actions
    {
    }
}

