namespace TISolution.TISolution;
using Microsoft.FixedAssets.FixedAsset;

table 90057 "Asset Assignment History"
{
    Caption = 'Asset Assignment History';
    // DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "Fixed Asset No."; Code[20])
        {
            Caption = 'Fixed Asset No.';
            TableRelation = "Fixed Asset"."No.";
            NotBlank = true;

            trigger OnValidate()
            var
                FixedAsset: Record "Fixed Asset";
            begin
                if FixedAsset.Get("Fixed Asset No.") then
                    "Fixed Asset Description" := FixedAsset.Description
                else
                    "Fixed Asset Description" := '';
            end;
        }
        field(3; "Fixed Asset Description"; Text[100])
        {
            Caption = 'Fixed Asset Description';
            Editable = false;
        }
        field(4; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = "HR Employees";
            NotBlank = true;

            trigger OnValidate()
            var
                Employee: Record "HR Employees";
            begin
                if Employee.Get("Employee No.") then
                    "Employee Name" := Employee.FullName()
                else
                    "Employee Name" := '';
            end;
        }
        field(5; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(6; "Assigned Date"; Date)
        {
            Caption = 'Assigned Date';
        }
        field(7; "Expected Return Date"; Date)
        {
            Caption = 'Expected Return Date';
        }
        field(8; "Return Date"; Date)
        {
            Caption = 'Return Date';
            Editable = false;
        }
        field(9; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Assigned,Returned;
            OptionCaption = 'Assigned,Returned';
            Editable = false;
        }
        field(10; "Assigned By"; Code[50])
        {
            Caption = 'Assigned By';
            Editable = false;
        }
        field(11; "Condition on Assignment"; Text[250])
        {
            Caption = 'Condition on Assignment';
        }
        field(12; "Condition on Return"; Text[250])
        {
            Caption = 'Condition on Return';
        }
        field(13; Remarks; Text[250])
        {
            Caption = 'Remarks';
        }
    }

    keys
    {
        key(PK; "Entry No.", "Fixed Asset No.")
        {
            Clustered = true;
        }
        key(AssetKey; "Fixed Asset No.", "Assigned Date")
        {
        }
        // key(EmployeeKey; "Employee No.")
        // {
        // }
    }

    // trigger OnInsert()
    // var
    //     AssetAssignmentHistory: Record "Asset Assignment History";
    // begin
    //     if "Assigned Date" = 0D then
    //         "Assigned Date" := Today;
    //     if "Assigned By" = '' then
    //         "Assigned By" := UserId;
    //     Status := Status::Assigned;

    //     AssetAssignmentHistory.SetRange("Fixed Asset No.", "Fixed Asset No.");
    //     AssetAssignmentHistory.SetRange(Status, AssetAssignmentHistory.Status::Assigned);
    //     if not AssetAssignmentHistory.IsEmpty() then
    //         Error('Fixed Asset %1 is already assigned and has not been returned yet. Return it before reassigning.', "Fixed Asset No.");
    // end;
}