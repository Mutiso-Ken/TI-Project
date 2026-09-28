page 90080 "Laptop Replacement Requests"
{
    PageType = List;
    SourceTable = "Laptop Replacement Request";
    Caption = 'Laptop Replacement Requests';
    CardPageId = "Laptop Replacement Req Card";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the request.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the employee who submitted the request.';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department of the employee.';
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date the request was submitted.';
                }
                field("Current Fixed Asset No."; Rec."Current Fixed Asset No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the laptop currently assigned to the employee that this request is about.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the request.';
                }
            }
        }
    }
}
