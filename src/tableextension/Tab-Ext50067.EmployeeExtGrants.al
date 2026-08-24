tableextension 50067 "Employee Ext Grants" extends Employee
{
    fields
    {
        field(50071; "Full Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50072; Grade; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50073; "Nature Of Employment"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Consultant,Emp,Board';
            OptionMembers = " ",Consultant,Employee,Board;
        }
        field(50074; "CBS Member Id"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }
}
