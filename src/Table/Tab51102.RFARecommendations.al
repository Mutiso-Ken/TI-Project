table 51102 "RFA Recommendations"
{

    fields
    {
        field(1; EntryNo; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; RFA; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Recommendation; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Stage; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'New,Bidding,Preliminary Assessment,Evaluation,Peer Review,Technical Review,Pre Award Survey,Sub Award';
            OptionMembers = New,Bidding,"Preliminary Assessment",Evaluation,"Peer Review","Technical Review","Pre Award Survey","Sub Award";
        }
    }

    keys
    {
        key(Key1; EntryNo, RFA, Stage)
        {
        }
    }

    fieldgroups
    {
    }
}
