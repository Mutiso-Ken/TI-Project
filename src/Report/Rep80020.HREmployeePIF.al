#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80020 "HR Employee PIF"
{
    UsageCategory = ReportsAndAnalysis;
    WordLayout = 'Layouts/HREmployeePIF.docx';
    DefaultLayout = Word;

    dataset
    {
        dataitem("HR Employees"; "HR Employees")
        {
            RequestFilterFields = "No.";

            column(HR_Employees__No__; "HR Employees"."No.")
            {
            }
            column(HR_Employees__ID_Number_; "HR Employees"."ID Number")
            {
            }
            column(HR_Employees__Date_Of_Birth_; "HR Employees"."Date Of Birth")
            {
            }
            column(HR_Employees__Marital_Status_; "HR Employees"."Marital Status")
            {
            }
            column(HR_Employees__PIN_Number_; "HR Employees"."PIN No.")
            {
            }
            column(HR_Employees__NSSF_No__; "HR Employees"."NSSF No.")
            {
            }
            column(HR_Employees__NHIF_No__; "HR Employees"."NHIF No.")
            {
            }
            column(HR_Employees__Cell_Phone_Number_; "HR Employees"."Cell Phone Number")
            {
            }
            column(HR_Employees__Postal_Address_; "HR Employees"."Postal Address")
            {
            }
            column(HR_Employees_City; "HR Employees".City)
            {
            }
            column(joindate; "HR Employees"."Date Of Join")
            {
            }
            column(HR_Employees__Post_Code_; "HR Employees"."Post Code")
            {
            }
            column(HR_Employees__Main_Bank_; "HR Employees"."Main Bank")
            {
            }
            column(HR_Employees__Branch_Bank_; "HR Employees"."Branch Bank")
            {
            }
            column(HR_Employees__Bank_Account_Number_; "HR Employees"."Bank Account Number")
            {
            }
            column(HR_Employees__FullName; FullName)
            {
            }
            column(pic; "HR Employees".Picture)
            {
            }
            column(Section_A__Personal_DetailsCaption; Section_A__Personal_DetailsCaptionLbl)
            {
            }
            column(HR_Employees__NHIF_No__Caption; FieldCaption("NHIF No."))
            {
            }
            column(HR_Employees__NSSF_No__Caption; FieldCaption("NSSF No."))
            {
            }
            column(HR_Employees__PIN_Number_Caption; FieldCaption("PIN No."))
            {
            }
            column(HR_Employees__Marital_Status_Caption; FieldCaption("Marital Status"))
            {
            }
            column(HR_Employees__Date_Of_Birth_Caption; FieldCaption("Date Of Birth"))
            {
            }
            column(HR_Employees__ID_Number_Caption; FieldCaption("ID Number"))
            {
            }
            column(HR_Employees__Date_Of_Joining_the_Company_Caption; FieldCaption("Date Of Joining the Company"))
            {
            }
            column(HR_Employees__No__Caption; FieldCaption("No."))
            {
            }
            column(HR_Employees__Cell_Phone_Number_Caption; FieldCaption("Cell Phone Number"))
            {
            }
            column(HR_Employees__Postal_Address_Caption; FieldCaption("Postal Address"))
            {
            }
            column(Section_B__ContactsCaption; Section_B__ContactsCaptionLbl)
            {
            }
            column(HR_Employees_CityCaption; FieldCaption(City))
            {
            }
            column(HR_Employees__Post_Code_Caption; FieldCaption("Post Code"))
            {
            }
            column(Section_C__Bank_Account_DetailsCaption; Section_C__Bank_Account_DetailsCaptionLbl)
            {
            }
            column(HR_Employees__Main_Bank_Caption; FieldCaption("Main Bank"))
            {
            }
            column(HR_Employees__Branch_Bank_Caption; FieldCaption("Branch Bank"))
            {
            }
            column(HR_Employees__Bank_Account_Number_Caption; FieldCaption("Bank Account Number"))
            {
            }
            column(NamesCaption; NamesCaptionLbl)
            {
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
            trigger OnPreDataItem();
            begin

            end;

            trigger OnAfterGetRecord();
            begin
                //"HR Employees".GET("HR Employees"."No.");
                CalcFields(Picture);
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


    end;

    var
        CI: Record "Company Information";
        EmployeeCaptionLbl: label 'Employee';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Personal_Information_FormCaptionLbl: label 'Personal Information Form';
        Section_A__Personal_DetailsCaptionLbl: label 'Section A: Personal Details';
        Section_B__ContactsCaptionLbl: label 'Section B: Contacts';
        Section_C__Bank_Account_DetailsCaptionLbl: label 'Section C: Bank Account Details';
        PictureCaptionLbl: label 'Picture';
        NamesCaptionLbl: label 'Names';
        Section_D__Academic_and_Professional_QualificationsCaptionLbl: label 'Section D: Academic and Professional Qualifications';
        Qualification_CodeCaptionLbl: label 'Qualification Code';
        Section_E__Employment_HistoryCaptionLbl: label 'Section E: Employment History';

    trigger OnInitReport();
    begin

    end;

}