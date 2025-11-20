table 1336 "Appraisal Lines Section B"
{
    Caption = 'Appraisal Lines';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No"; Integer)
        {
            Caption = 'Line No';
            AutoIncrement = true;
        }
        field(2; "Appraisal Code"; Code[50])
        {
            Caption = 'Appraisal Code';
        }
        field(3; Section; Option)
        {
            OptionCaption = '"Section 1","Section 2","Section 3","Section 4"';
            OptionMembers = "Section 1","Section 2","Section 3","Section 4";
        }
        field(4; "Question"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = AppraisalQuestions.Code where(Section = const("Section B"));
            trigger
            OnValidate()
            begin
                if AppraisalQuestions.Get(Question) then
                    "Question Description" := AppraisalQuestions.Description;
            end;
        }
        field(5; "Question Description"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Employee Answer"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Self-appraisal (Comments)"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Comments by the supervisor"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Line No", "Appraisal Code")
        {
            Clustered = true;
        }
    }

    trigger
    OnInsert()
    begin

    end;

    var
        AppraisalQuestions: Record AppraisalQuestions;
}
