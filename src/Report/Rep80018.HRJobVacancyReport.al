#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80018 "HR Job Vacancy Report"
{
    UsageCategory = ReportsAndAnalysis;
    WordLayout = 'Layouts/HRJobVacancyReport.docx';
    DefaultLayout = Word;

    dataset
    {
        dataitem("HR Jobss"; "HR Jobss")
        {

            column(CompanyAddress; CompanyInformation.Address)
            {
            }
            column(CompanyPhoneNo; CompanyInformation."Phone No.")
            {
            }
            column(CompanyLogo; CompanyInformation.Picture)
            {
            }
            column(CompanyMail; CompanyInformation."E-Mail")
            {
            }
            column(CompanyPostCode; CompanyInformation."Post Code")
            {
            }
            column(CompanyCity; CompanyInformation.City)
            {
            }
            column(CompanyRegionCountry; CompanyInformation."Country/Region Code")
            {
            }
            column(HomePage; CompanyInformation."Home Page")
            {
            }
            column(Address2; CompanyInformation."Address 2")
            {
            }
            column(JobDescription; "HR Jobss"."Job Description")
            {
            }
            column(NoOfPosts; "HR Jobss"."No of Posts")
            {
            }
            column(OccupiedPositions; "HR Jobss"."Occupied Positions")
            {
            }
            column(VacantPositions; "HR Jobss"."Vacant Positions")
            {
            }
            trigger OnPreDataItem();
            begin

            end;
        }
    }
    requestpage
    {
        SaveValues = false;
        layout
        {
            area(Content)
            {
                field(StartPeriod; StartPeriod)
                {
                    ApplicationArea = Basic;
                    Caption = 'Start Date';
                    Visible = false;
                }
                field(EndPeriod; EndPeriod)
                {
                    ApplicationArea = Basic;
                    Caption = 'End Date';
                    Visible = false;
                }

            }
        }

    }

    trigger OnPreReport()
    begin


    end;

    var
        CompanyInformation: Record "Company Information";
        StartPeriod: Date;
        EndPeriod: Date;
        From: Text[100];
        AsAtCaption: Text[150];
        ItemLedgerEntry: Record "Item Ledger Entry";
        Openbal: Decimal;
        PurchseAmount: Decimal;
        SalesAmount: Decimal;
        ValueEntry: Record "Value Entry";

    trigger OnInitReport();
    begin

    end;

}