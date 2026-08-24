tableextension 50060 "Customer Ext Grants" extends Customer
{
    fields
    {
        field(50060; "Account Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = ,Donor,"Implementing Partner";
        }
    }
}
