table 12 AppraisalQuestions
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
            OptionCaption = '"Section A","Section B","Section C"';
            OptionMembers = "Section A","Section B","Section C";
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
