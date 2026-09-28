page 90081 "Laptop Replacement Req Card"
{
    PageType = Card;
    SourceTable = "Laptop Replacement Request";
    Caption = 'Laptop Replacement Request';
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the request.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the request.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee this request is for.';
                    Editable = Rec.Status = Rec.Status::"Pending Review";
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the employee.';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department of the employee.';
                }
                field("Email Address"; Rec."Email Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the email address of the employee.';
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date the request was submitted.';
                }
            }
            group(RequestDetails)
            {
                Caption = 'Request Details';

                field("Reason for Replacement"; Rec."Reason for Replacement")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a thorough description of the challenges being experienced with the current laptop.';
                    Editable = Rec.Status = Rec.Status::"Pending Review";
                    MultiLine = true;
                }
                field("Contacted ICT"; Rec."Contacted ICT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the ICT department has been contacted regarding this issue.';
                    Editable = Rec.Status = Rec.Status::"Pending Review";
                }
                field("Assessed by ICT"; Rec."Assessed by ICT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the laptop has been assessed or diagnosed by the ICT department.';
                    Editable = Rec.Status = Rec.Status::"Pending Review";
                }
                field("Assessment Feedback"; Rec."Assessment Feedback")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the feedback from the ICT assessment.';
                    Editable = (Rec.Status = Rec.Status::"Pending Review") or (Rec.Status = Rec.Status::"ICT Assessed");
                    MultiLine = true;
                }
            }
            group(CurrentLaptop)
            {
                Caption = 'Current Laptop';

                field("Current Fixed Asset No."; Rec."Current Fixed Asset No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the laptop currently assigned to the employee. Only laptops assigned to the selected employee can be chosen.';
                    Editable = Rec.Status = Rec.Status::"Pending Review";
                }
                field("Current Laptop Description"; Rec."Current Laptop Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the current laptop.';
                }
                field("Current Laptop Tag No."; Rec."Current Laptop Tag No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the tag number of the current laptop.';
                }
                field("Current Laptop Acquired On"; Rec."Current Laptop Acquired On")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the current laptop was acquired or issued.';
                }
            }
            group(Funding)
            {
                Caption = 'Funding';

                field("Resource Identified"; Rec."Resource Identified")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the resource/fund for the replacement has been identified.';
                    Editable = Rec.Status = Rec.Status::"Pending Review";
                }
                field("Resource Details"; Rec."Resource Details")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the project and budget amount for the replacement, if the resource has been identified.';
                    Editable = (Rec.Status = Rec.Status::"Pending Review") and (Rec."Resource Identified" = Rec."Resource Identified"::Yes);
                }
            }
            group(AdditionalInformation)
            {
                Caption = 'Additional Information';

                field("Additional Information"; Rec."Additional Information")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies any additional information to help understand the laptop replacement needs.';
                    Editable = Rec.Status = Rec.Status::"Pending Review";
                    MultiLine = true;
                }
            }
            group(ApprovalAndFulfillment)
            {
                Caption = 'Approval and Fulfillment';

                field("Reviewed By"; Rec."Reviewed By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies who last reviewed this request.';
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date the request was approved.';
                }
                field("Rejected Reason"; Rec."Rejected Reason")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reason the request was rejected.';
                    Editable = (Rec.Status = Rec.Status::"Pending Review") or (Rec.Status = Rec.Status::"ICT Assessed");
                }
                field("Rejected Date"; Rec."Rejected Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date the request was rejected.';
                }
                field("New Fixed Asset No."; Rec."New Fixed Asset No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the replacement laptop to be issued. Must be set before fulfilling the request.';
                    Editable = Rec.Status = Rec.Status::Approved;
                }
                field("New Laptop Description"; Rec."New Laptop Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the replacement laptop.';
                }
                field("Fulfilled Date"; Rec."Fulfilled Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date the request was fulfilled.';
                }
                field("Fulfilled By"; Rec."Fulfilled By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies who fulfilled the request.';
                }
            }
            part(Updates; "Laptop Replacement Updates")
            {
                ApplicationArea = All;
                Caption = 'Updates';
                SubPageLink = "Request No." = field("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(MarkICTAssessed)
            {
                Caption = 'Mark ICT Assessed';
                ToolTip = 'Marks the laptop as assessed by the ICT department, based on the assessment feedback entered.';
                Image = Approve;
                ApplicationArea = All;
                Enabled = Rec.Status = Rec.Status::"Pending Review";

                trigger OnAction()
                begin
                    Rec.TestField("Current Fixed Asset No.");
                    Rec.TestField("Assessment Feedback");
                    Rec.Status := Rec.Status::"ICT Assessed";
                    Rec."Reviewed By" := UserId;
                    Rec.Modify(true);
                    Rec.LogUpdate('Assessed by ICT.');
                    CurrPage.Update(false);
                end;
            }
            action(ApproveRequest)
            {
                Caption = 'Approve';
                ToolTip = 'Approves the laptop replacement request.';
                Image = Approve;
                ApplicationArea = All;
                Enabled = Rec.Status = Rec.Status::"ICT Assessed";

                trigger OnAction()
                begin
                    Rec."Approved Date" := Today;
                    Rec."Reviewed By" := UserId;
                    Rec.Status := Rec.Status::Approved;
                    Rec.Modify(true);
                    Rec.LogUpdate('Approved.');
                    CurrPage.Update(false);
                end;
            }
            action(RejectRequest)
            {
                Caption = 'Reject';
                ToolTip = 'Rejects the laptop replacement request.';
                Image = Cancel;
                ApplicationArea = All;
                Enabled = (Rec.Status = Rec.Status::"Pending Review") or (Rec.Status = Rec.Status::"ICT Assessed");

                trigger OnAction()
                begin
                    Rec.TestField("Rejected Reason");
                    Rec."Rejected Date" := Today;
                    Rec."Reviewed By" := UserId;
                    Rec.Status := Rec.Status::Rejected;
                    Rec.Modify(true);
                    Rec.LogUpdate('Rejected: ' + Rec."Rejected Reason");
                    CurrPage.Update(false);
                end;
            }
            action(FulfillRequest)
            {
                Caption = 'Fulfill Request';
                ToolTip = 'Closes out the current laptop assignment and assigns the replacement laptop to the employee.';
                Image = PostOrder;
                ApplicationArea = All;
                Enabled = Rec.Status = Rec.Status::Approved;

                trigger OnAction()
                var
                    OldAssignment: Record "Asset Assignment History";
                    NewAssignment: Record "Asset Assignment History";
                    ExistingAssignment: Record "Asset Assignment History";
                    NewFixedAsset: Record "Fixed Asset";
                begin
                    Rec.TestField("New Fixed Asset No.");
                    if Rec."New Fixed Asset No." = Rec."Current Fixed Asset No." then
                        Error('The replacement laptop must be different from the current laptop.');

                    NewFixedAsset.Get(Rec."New Fixed Asset No.");

                    ExistingAssignment.SetRange("Fixed Asset No.", Rec."New Fixed Asset No.");
                    ExistingAssignment.SetRange(Status, ExistingAssignment.Status::Assigned);
                    if not ExistingAssignment.IsEmpty() then
                        Error('Fixed Asset %1 is already assigned to another employee and has not been returned yet.', Rec."New Fixed Asset No.");

                    OldAssignment.Get(Rec."Current Assignment Entry No.", Rec."Current Fixed Asset No.");
                    if OldAssignment.Status = OldAssignment.Status::Returned then
                        Error('This assignment is already marked as returned.');
                    if OldAssignment."Assigned Date" = 0D then
                        Error('Assigned Date must be set before this asset can be returned.');
                    if OldAssignment."Assigned Date" > Today then
                        Error('This asset cannot be returned before its Assigned Date.');
                    OldAssignment."Return Date" := Today;
                    OldAssignment.Status := OldAssignment.Status::Returned;
                    OldAssignment.Modify(true);

                    NewAssignment.Init();
                    NewAssignment.Validate("Fixed Asset No.", Rec."New Fixed Asset No.");
                    NewAssignment.Validate("Employee No.", Rec."Employee No.");
                    NewAssignment.Insert(true);

                    Rec."New Laptop Description" := NewFixedAsset.Description;
                    Rec."New Assignment Entry No." := NewAssignment."Entry No.";
                    Rec."Fulfilled Date" := Today;
                    Rec."Fulfilled By" := UserId;
                    Rec.Status := Rec.Status::Fulfilled;
                    Rec.Modify(true);
                    Rec.LogUpdate('Fulfilled - reassigned to ' + Rec."New Fixed Asset No." + '.');
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
