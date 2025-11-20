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
}
