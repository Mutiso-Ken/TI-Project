table 51087 "Concept Notes"
{

    Caption = 'Job';
    DataCaptionFields = "No.", Description;
    DrillDownPageID = "Concept Notes";
    LookupPageID = "Concept Notes";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate();
            begin

                IF Status = Status::"Concept Formulation" THEN BEGIN
                    IF "No." <> xRec."No." THEN BEGIN
                        JobSetup.GET;
                        JobSetup.TESTFIELD("Concept Nos");
                        NoSeriesMgt.TestManual(JobSetup."Concept Nos");
                        "No. Series" := '';
                    END;
                END ELSE
                    IF Status = Status::Proposal THEN BEGIN
                        IF "No." = '' THEN BEGIN
                            JobSetup.GET;
                            JobSetup.TESTFIELD("Proposal Nos");
                            NoSeriesMgt.TestManual(JobSetup."Proposal Nos");
                            "No. Series" := '';

                        END;
                    END ELSE
                        IF Status = Status::Contract THEN BEGIN
                            IF "No." = '' THEN BEGIN
                                JobSetup.GET;
                                JobSetup.TESTFIELD("Proposal Nos");
                                NoSeriesMgt.TestManual(JobSetup."Proposal Nos");
                                "No. Series" := '';
                            END;
                        END;

            end;
        }
        field(2; "Search Description"; Code[250])
        {
            Caption = 'Search Description';
        }
        field(3; Description; Text[250])
        {
            Caption = 'Description';

            trigger OnValidate();
            begin
                IF ("Search Description" = UPPERCASE(xRec.Description)) OR ("Search Description" = '') THEN
                    "Search Description" := Description;
                TESTFIELD("Approval Status", "Approval Status"::Open);

            end;
        }
        field(4; "Description 2"; Text[80])
        {
            Caption = 'Description 2';
        }
        field(5; Donor; Code[20])
        {
            Caption = 'Donor';
            TableRelation = Customer."No.";

            trigger OnValidate();
            begin

                Cust.GET(Donor);
                "Donor Address" := Cust.Address;
                "Donor Address 2" := Cust."E-Mail";
                "Donor Contact" := Cust."Phone No.";

            end;
        }
        field(6; "Donor Address"; Text[50])
        {
            Caption = 'Address';
        }
        field(7; "Donor Address 2"; Text[50])
        {
            Caption = 'Email Address';
            ExtendedDatatype = EMail;
        }
        field(8; "Donor Contact"; Text[50])
        {
            Caption = 'Contact';
        }
        field(9; "Proposal Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'New,Submitted,Rejected,Pending with Donors,Awarded Proposal';
            OptionMembers = New,Submitted,Rejected,"Pending with Donors","Awarded Proposal";
        }
        field(10; "Date Notified"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Type of Concept Note"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Call of Proposal,Fund Raising';
            OptionMembers = ,"Call of Proposal","Fund Raising";
        }
        field(12; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

        }
        field(13; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(14; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Concept Formulation,Proposal,Contract,Project,Completed';
            OptionMembers = "Concept Formulation",Proposal,Contract,Project,Completed;

        }
        field(15; "Approval Status"; Option)
        {
            Editable = true;
            OptionCaption = 'Open,Pending Approval,Approved,Cancelled';
            OptionMembers = Open,"Pending Approval",Approved,Cancelled;
        }
        field(16; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(17; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }

        field(18; "Creation Date"; Date)
        {

        }
        field(19; "Person Responsible"; Code[20])
        {
            Caption = 'Person Responsible';
            TableRelation = "User Setup"."User ID";
        }


    }
    keys
    {
        key(Key1; "No.")
        {
        }

    }

    var
        Cust: Record Customer;
        Text011: Label '%1 must be equal to or earlier than %2.';
        JobSetup: Record "Jobs Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;


    local procedure CheckDate();
    begin
        IF ("Starting Date" > "Ending Date") AND ("Ending Date" <> 0D) THEN
            ERROR(Text011, FIELDCAPTION("Starting Date"), FIELDCAPTION("Ending Date"));
    end;

    trigger OnInsert();
    begin
        IF Status = Status::"Concept Formulation" THEN BEGIN
            IF "No." = '' THEN BEGIN
                JobSetup.GET;
                JobSetup.TESTFIELD("Concept Nos");
                NoSeriesMgt.InitSeries(JobSetup."Concept Nos", xRec."No. Series", 0D, "No.", "No. Series");
            END;
        END ELSE
            IF Status = Status::Proposal THEN BEGIN
                IF "No." = '' THEN BEGIN
                    JobSetup.GET;
                    JobSetup.TESTFIELD("Proposal Nos");
                    NoSeriesMgt.InitSeries(JobSetup."Proposal Nos", xRec."No. Series", 0D, "No.", "No. Series");
                END;
            END ELSE
                IF Status = Status::Contract THEN BEGIN
                    IF "No." = '' THEN BEGIN
                        JobSetup.GET;
                        JobSetup.TESTFIELD("System Contract Nos");
                        NoSeriesMgt.InitSeries(JobSetup."System Contract Nos", xRec."No. Series", 0D, "No.", "No. Series");
                    END;
                END;

        "Creation Date" := TODAY;
        "Last Date Modified" := "Creation Date";
    end;

    trigger OnModify();
    begin
        IF "Approval Status" = "Approval Status"::Approved THEN BEGIN
            IF CONFIRM('Are you sure you want to adjust the project and change the status to open?') = TRUE THEN BEGIN
                "Approval Status" := "Approval Status"::Open;
            END;
        END;

        "Last Date Modified" := TODAY;
    end;

    trigger OnRename();
    begin
        "Last Date Modified" := TODAY;
        TESTFIELD("Approval Status", "Approval Status"::Open);
    end;

}
