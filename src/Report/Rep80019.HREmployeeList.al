#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80019 "HR Employee List"
{
    UsageCategory = ReportsAndAnalysis;
    WordLayout = 'Layouts/HREmployeeList.docx';
    DefaultLayout = Word;

    dataset
    {
        dataitem("HR Employees"; "HR Employees")
        {
            RequestFilterFields = "No.", Status, Gender;

            column(CI_Name; CI.Name)
            {
                IncludeCaption = true;
            }
            column(CI_Address; CI.Address)
            {
                IncludeCaption = true;
            }
            column(CI_Address2; CI."Address 2")
            {
                IncludeCaption = true;
            }
            column(CI_City; CI.City)
            {
                IncludeCaption = true;
            }
            column(CI_PhoneNo; CI."Phone No.")
            {
                IncludeCaption = true;
            }
            column(CI_Picture; CI.Picture)
            {
                IncludeCaption = true;
            }
            column(HR_Employees__No__; "HR Employees"."No.")
            {
            }
            column(HR_Employees__ID_Number_; "HR Employees"."ID Number")
            {
            }
            column(HR_Employees__Job_Description_; "HR Employees"."Job Title")
            {
            }
            column(HR_Employees__Date_Of_Joining_the_Company_; "HR Employees"."Date Of Join")
            {
            }
            column(HR_Employees__Cell_Phone_Number_; "HR Employees"."Cell Phone Number")
            {
            }
            column(HR_Employees__No__Caption; FieldCaption("No."))
            {
            }
            column(HR_Employees__ID_Number_Caption; FieldCaption("ID Number"))
            {
            }
            column(HR_Employees__Job_Description_Caption; FieldCaption("Job Title"))
            {
            }
            column(HR_Employees__Date_Of_Joining_the_Company_Caption; FieldCaption("Date Of Joining the Company"))
            {
            }
            column(Full_NamesCaption; Full_NamesCaptionLbl)
            {
            }
            column(HR_Employees__Cell_Phone_Number_Caption; FieldCaption("Cell Phone Number"))
            {
            }
            column(DOb; "HR Employees"."Date Of Birth")
            {
            }
            column(Name; StrName)
            {
            }
            column(Gender; "HR Employees".Gender)
            {
            }
            column(Status; "HR Employees".Status)
            {
            }
            trigger OnPreDataItem();
            begin

            end;

            trigger OnAfterGetRecord();
            begin
                StrName := "HR Employees"."First Name" + ' ' + "HR Employees"."Middle Name" + ' ' + "HR Employees"."Last Name";
                "No of Employees" := "No of Employees" + 1;
            end;

        }
    }
    requestpage
    {
        SaveValues = false;
        layout
        {
        }

    }

    trigger OnPreReport()
    begin
        CI.Get();
        CI.CalcFields(CI.Picture);
        "No of Employees" := 0;


    end;

    var
        CI: Record "Company Information";
        EmployeeCaptionLbl: label 'Employee';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Employee_ListCaptionLbl: label 'Employee List';
        P_O__BoxCaptionLbl: label 'P.O. Box';
        Full_NamesCaptionLbl: label 'Full Names';
        "No of Employees": Integer;
        StrName: Text[100];

    trigger OnInitReport();
    begin

    end;

}