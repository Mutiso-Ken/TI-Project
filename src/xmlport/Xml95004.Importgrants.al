xmlport 95004 "Import Grants"
{
    schema
    {
        textelement(NodeName1)
        {
            tableelement(Grants; "Grant Lines")
            {
                fieldattribute("Line_No"; Grants."Line No")
                {
                }
                fieldattribute("Line_Type"; Grants."Line Type")
                {
                }
                fieldattribute(Grant_No; Grants."Grant No")
                {
                }
                fieldattribute(code; Grants.Code)
                {
                }
                fieldattribute(External_Partner_Code; Grants."External Partner Code")
                {
                }
                fieldattribute(Description; Grants.Description)
                {
                }


            }
        }
    }

    requestpage
    {
        layout
        {

        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {

                }
            }
        }
    }
    trigger OnPostXmlPort()
    var
        myInt: Integer;
    begin
        Message('Successfuly Uploaded');
    end;

    var
        myInt: Integer;
}
