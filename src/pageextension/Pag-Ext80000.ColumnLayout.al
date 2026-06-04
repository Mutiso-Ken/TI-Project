pageextension 80000 "ColumnLayout" extends "Column Layout"
{
    layout
    {
        addafter("Comparison Date Formula")
        {
            field(ComparisonPeriodFormula; rec."Comparison Period Formula") { ApplicationArea = all; }

            field("Dimension1 Totaling"; Rec."Dimension 1 Totaling") { ApplicationArea = all; }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}


pageextension 50102 WorksheetExt extends "Account Schedule"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here

        // modify(Overview)
        // {
        //     Visible = true;
        // }
        // modify(EditColumnLayoutSetup)
        // {
        //     Visible= true;
        // }
    }

    var
        myInt: Integer;
}