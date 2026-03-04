table 12 "Appraisal Questions"
{
    Caption = 'AppraisalQuestions';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[2048])
        {
            Caption = 'Description';
        }
        field(3; Section; Option)
        {
            OptionMembers = "Section A","Section B","Section C","Section D";
        }
        field(4; Part; Option)
        {
            OptionMembers = "Part 1","Part 2","Part 3","Part 4","Part 5","Part 6";
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if "Code" = '' then begin
            HRsetup.Get();
            HRsetup.TestField("Appraisal Question Nos.");
            "Code" := NoSeriesManagement.GetNextNo(HRsetup."Appraisal Question Nos.", 0D, true);
        end;
    end;

    var
        HRsetup: Record "HR Setup";
        NoSeriesManagement: Codeunit "No. Series";
}
