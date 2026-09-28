table 90080 "Laptop Replacement Request"
{
    Caption = 'Laptop Replacement Request';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(2; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = "HR Employees";
            NotBlank = true;

            trigger OnValidate()
            var
                Employee: Record "HR Employees";
            begin
                if Employee.Get("Employee No.") then begin
                    "Employee Name" := Employee.FullName();
                    "Department Code" := Employee."Department Code";
                    "Department Name" := Employee."Department Name";
                    "Email Address" := Employee."E-Mail";
                end else begin
                    "Employee Name" := '';
                    "Department Code" := '';
                    "Department Name" := '';
                    "Email Address" := '';
                end;

                if "Employee No." <> xRec."Employee No." then begin
                    "Current Fixed Asset No." := '';
                    "Current Assignment Entry No." := 0;
                    "Current Laptop Description" := '';
                    "Current Laptop Tag No." := '';
                    "Current Laptop Acquired On" := 0D;
                end;
            end;
        }
        field(3; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(4; "Department Code"; Code[50])
        {
            Caption = 'Department Code';
            Editable = false;
        }
        field(5; "Department Name"; Text[200])
        {
            Caption = 'Department Name';
            Editable = false;
        }
        field(6; "Email Address"; Text[80])
        {
            Caption = 'Email Address';
            Editable = false;
        }
        field(7; "Request Date"; Date)
        {
            Caption = 'Request Date';
        }
        field(8; "Reason for Replacement"; Text[2048])
        {
            Caption = 'Reason for Replacement';
        }
        field(9; "Contacted ICT"; Option)
        {
            Caption = 'Have you contacted the ICT department regarding this issue?';
            OptionMembers = No,Yes;
            OptionCaption = 'No,Yes';
        }
        field(10; "Assessed by ICT"; Option)
        {
            Caption = 'Has the laptop been assessed or diagnosed by the ICT department?';
            OptionMembers = "Not Assessed",Assessed;
            OptionCaption = 'No, not yet assessed,Yes, it was assessed';
        }
        field(11; "Assessment Feedback"; Text[2048])
        {
            Caption = 'Assessment Feedback';
        }
        field(12; "Current Fixed Asset No."; Code[20])
        {
            Caption = 'Current Laptop (Fixed Asset No.)';
            TableRelation = "Asset Assignment History"."Fixed Asset No." where("Employee No." = field("Employee No."), Status = const(Assigned));

            trigger OnValidate()
            var
                AssetAssignmentHistory: Record "Asset Assignment History";
                FixedAsset: Record "Fixed Asset";
            begin
                if "Current Fixed Asset No." = '' then begin
                    "Current Assignment Entry No." := 0;
                    "Current Laptop Description" := '';
                    "Current Laptop Tag No." := '';
                    "Current Laptop Acquired On" := 0D;
                    exit;
                end;

                TestField("Employee No.");

                AssetAssignmentHistory.SetRange("Employee No.", "Employee No.");
                AssetAssignmentHistory.SetRange(Status, AssetAssignmentHistory.Status::Assigned);
                AssetAssignmentHistory.SetRange("Fixed Asset No.", "Current Fixed Asset No.");
                if not AssetAssignmentHistory.FindLast() then
                    Error('Fixed Asset %1 is not currently assigned to %2.', "Current Fixed Asset No.", "Employee No.");

                "Current Assignment Entry No." := AssetAssignmentHistory."Entry No.";
                "Current Laptop Description" := AssetAssignmentHistory."Fixed Asset Description";

                if FixedAsset.Get("Current Fixed Asset No.") then begin
                    "Current Laptop Tag No." := FixedAsset."Tag Number";
                    "Current Laptop Acquired On" := FixedAsset."Acquisition Date";
                end;
            end;
        }
        field(13; "Current Assignment Entry No."; Integer)
        {
            Caption = 'Current Assignment Entry No.';
            Editable = false;
        }
        field(14; "Current Laptop Description"; Text[100])
        {
            Caption = 'Current Laptop Description';
            Editable = false;
        }
        field(15; "Current Laptop Tag No."; Code[50])
        {
            Caption = 'Current Laptop Tag No.';
            Editable = false;
        }
        field(16; "Current Laptop Acquired On"; Date)
        {
            Caption = 'Current Laptop Acquired On';
            Editable = false;
        }
        field(17; "Resource Identified"; Option)
        {
            Caption = 'Have you identified the resource/fund for the replacement?';
            OptionMembers = No,Yes;
            OptionCaption = 'No,Yes';

            trigger OnValidate()
            begin
                if "Resource Identified" = "Resource Identified"::No then
                    "Resource Details" := '';
            end;
        }
        field(18; "Resource Details"; Text[250])
        {
            Caption = 'Resource Details (Project and Budget Amount)';
        }
        field(19; "Additional Information"; Text[2048])
        {
            Caption = 'Additional Information';
        }
        field(20; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = "Pending Review","ICT Assessed",Approved,Rejected,Fulfilled;
            OptionCaption = 'Pending Review,ICT Assessed,Approved,Rejected,Fulfilled';
            Editable = false;
        }
        field(21; "Submitted By"; Code[50])
        {
            Caption = 'Submitted By';
            Editable = false;
        }
        field(22; "Reviewed By"; Code[50])
        {
            Caption = 'Reviewed By';
            Editable = false;
        }
        field(23; "Approved Date"; Date)
        {
            Caption = 'Approved Date';
            Editable = false;
        }
        field(24; "Rejected Reason"; Text[250])
        {
            Caption = 'Rejected Reason';
        }
        field(25; "Rejected Date"; Date)
        {
            Caption = 'Rejected Date';
            Editable = false;
        }
        field(26; "New Fixed Asset No."; Code[20])
        {
            Caption = 'New Laptop (Fixed Asset No.)';
            TableRelation = "Fixed Asset"."No.";
        }
        field(27; "New Laptop Description"; Text[100])
        {
            Caption = 'New Laptop Description';
            Editable = false;
        }
        field(28; "New Assignment Entry No."; Integer)
        {
            Caption = 'New Assignment Entry No.';
            Editable = false;
        }
        field(29; "Fulfilled Date"; Date)
        {
            Caption = 'Fulfilled Date';
            Editable = false;
        }
        field(30; "Fulfilled By"; Code[50])
        {
            Caption = 'Fulfilled By';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(EmployeeKey; "Employee No.")
        {
        }
        key(StatusKey; Status)
        {
        }
    }

    trigger OnInsert()
    var
        HRSetup: Record "HR Setup";
        NoSeriesManagement: Codeunit "No. Series";
    begin
        if "No." = '' then begin
            HRSetup.Get();
            HRSetup.TestField("Laptop Replacement Nos.");
            "No." := NoSeriesManagement.GetNextNo(HRSetup."Laptop Replacement Nos.", Today, true);
        end;
        if "Request Date" = 0D then
            "Request Date" := Today;
        if "Submitted By" = '' then
            "Submitted By" := UserId;
        Status := Status::"Pending Review";
    end;

    procedure LogUpdate(UpdateComment: Text[250])
    var
        LaptopReplacementUpdates: Record "Laptop Replacement Updates";
    begin
        LaptopReplacementUpdates.Init();
        LaptopReplacementUpdates."Request No." := "No.";
        LaptopReplacementUpdates."Update DateTime" := CurrentDateTime;
        LaptopReplacementUpdates.Status := Status;
        LaptopReplacementUpdates.Comment := UpdateComment;
        LaptopReplacementUpdates."Updated By" := UserId;
        LaptopReplacementUpdates.Insert(true);
    end;
}
