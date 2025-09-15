#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 80047 "Exit Interviews"
{

    fields
    {
        field(1; "Employee No"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Employees";
        }
        field(2; "Employee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Designation; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "main reason(s) for your exit"; Text[2000])
        {
            Caption = '1. Please describe in detail the main reason(s) for your exit.';
            DataClassification = ToBeClassified;
        }
        field(5; "overall impression"; Text[2000])
        {
            Caption = '2. Describe your overall impression of TI-Kenya as an employer.';
            DataClassification = ToBeClassified;
        }
        field(6; "clear objectives"; Text[2000])
        {
            Caption = '3.Did you have clear objectives regarding your performance and did your supervisor provide adequate support to fulfill these objectives?';
            DataClassification = ToBeClassified;
        }
        field(7; "your performance reviewed"; Text[2000])
        {
            Caption = '4.How often was your performance reviewed and did you receive constructive feedback to help you improve your performance?';
            DataClassification = ToBeClassified;
        }
        field(8; "received enough recognition"; Text[2000])
        {
            Caption = '5.Do you feel that you received enough recognition for your work? Explain ¬';
            DataClassification = ToBeClassified;
        }
        field(9; "career aspirations"; Text[2000])
        {
            Caption = '6.Did you feel that your career aspirations were being met in TI-Kenya? Explain';
            DataClassification = ToBeClassified;
        }
        field(10; "relationship with your"; Text[2000])
        {
            Caption = '7.Describe your relationship with your line supervisor(s). ';
            DataClassification = ToBeClassified;
        }
        field(11; "with your immediate team"; Text[2000])
        {
            Caption = '8.Describe your relationship with your immediate team/colleagues. ';
            DataClassification = ToBeClassified;
        }
        field(12; "greatest accomplishments"; Text[2000])
        {
            Caption = '9.What were your greatest accomplishments while working for TI-Kenya? ';
            DataClassification = ToBeClassified;
        }
        field(13; "perception on TI-Kenya’s"; Text[2000])
        {
            Caption = '10.What is your perception on TI-Kenya’s conditions of service and benefits? ';
            DataClassification = ToBeClassified;
        }
        field(14; "most fulfilling"; Text[2000])
        {
            Caption = '11.What did you find most fulfilling about working in TI-Kenya?';
            DataClassification = ToBeClassified;
        }
        field(15; "most frustrating"; Text[2000])
        {
            Caption = '12.What did you find most frustrating about working in TI-Kenya?';
            DataClassification = ToBeClassified;
        }
        field(16; "better place"; Text[2000])
        {
            Caption = '13.What would you change, if anything, to make TI-Kenya a better place to work in?';
            DataClassification = ToBeClassified;
        }
        field(17; "TI-Kenya in the future"; Text[2000])
        {
            Caption = '14.Would you consider working at TI-Kenya in the future? Under what circumstances?';
            DataClassification = ToBeClassified;
        }
        field(18; "next step"; Text[2000])
        {
            Caption = '15.What is the next step after TI Kenya? ';
            DataClassification = ToBeClassified;
        }
        field(19; "constructive feedback"; Text[2000])
        {
            Caption = '16.Please add any other constructive feedback on your experience at TI-Kenya.';
            DataClassification = ToBeClassified;
        }
        field(20; "Intervire Conducted By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Interview Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Date of Exit"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Employee No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

