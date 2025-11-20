tableextension 50003 "Purchase Line3" extends "Purchase Line"
{
    fields
    {
        field(172000; "Description 3"; Text[1000])
        {
            Caption = 'Description 2';
            DataClassification = ToBeClassified;
        }
        field(7012; "Description 4"; Text[1000])
        {
            Caption = 'Description 4';
            DataClassification = ToBeClassified;
        }
        field(7013; "Description 5"; Text[1000])
        {
            Caption = 'Description 5';
            DataClassification = ToBeClassified;
        }
        field(7014; "Description 6"; Text[2048])
        {
            Caption = 'Description 6';
            DataClassification = ToBeClassified;
        }

        field(99000760; "ShortcutDimCode[3]"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(99000761; "ShortcutDimCode[4]"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(99000762; "ShortcutDimCode[5]"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(99000763; "ShortcutDimCode[6]"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(99000764; "ShortcutDimCode[7]"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(99000765; "ShortcutDimCode[8]"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(99000766; "Amount Spent"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                "Cash Refund" := "Line Amount" - "Amount Spent";
                Rec.Modify();
            end;
        }
        field(99000767; "Cash Refund"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(99000768; "Cash Refund  Account"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account";
        }
        field(99000769; "Expense Category"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Standard Text" where(Type = const("GL Category"));

            trigger OnValidate()
            begin
                exp := "Expense Category";
                Type := Type::"G/L Account";
                if StandardText.Get("Expense Category") then
                    Validate("No.", StandardText."GL Account");

                "Expense Category" := exp;
            end;
        }
        field(99000770; "Line Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = ,Objectives,"Team Roles",Activity,"Budget Info","Budget Notes",Performance,Sections,PersonalQualities,Reflections,CapacityNeeds,ActionPoints;
        }
        field(99000771; "No of days"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(99000772; "No of pax"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(99000773; Ksh; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Total Ksh" := "No of days" * "No of pax" * Ksh;
            end;
        }
        field(99000774; "other currency"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Total Other Currency" := "No of days" * "No of pax" * "other currency";
            end;
        }
        field(99000775; "Total Ksh"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(99000776; "Total Other Currency"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(99000777; "Mission Expense Category"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Standard Text" where(Type = const("GL Category"));
        }
        field(99000778; keyResultAreas; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'Performance start';
        }
        field(99000779; keyActivities; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(99000780; performanceMeasures; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(99000781; commentsOnAchievedResults; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(99000782; target; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(99000783; actualAchieved; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(99000784; percentageOfTarget; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(99000785; rating; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(99000786; weightingRating; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(99000787; weighting; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(99000788; appraisalType; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'Sections start';
            OptionCaption = 'Technical Capacity,Organisation and planning skills,Efficiency and Effectiveness,Communication,Leadership';
            OptionMembers = "Technical Capacity","Organisation and planning skills","Efficiency and Effectiveness",Communication,Leadership;
        }
        field(99000789; appraisalDescription; Text[300])
        {
            DataClassification = ToBeClassified;
        }
        field(99000790; staffRating; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(99000791; supervisorRating; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(99000792; personalDescription; Text[400])
        {
            DataClassification = ToBeClassified;
            Description = 'Personal Qualities start';
        }
        field(99000793; score; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(99000794; comments; Text[400])
        {
            DataClassification = ToBeClassified;
        }
        field(99000795; reflectionDescription; Text[400])
        {
            DataClassification = ToBeClassified;
            Description = 'Start refelctions';
        }
        field(99000796; selfAppraisal; Text[400])
        {
            DataClassification = ToBeClassified;
        }
        field(99000797; supervisorsFeedback; Text[400])
        {
            DataClassification = ToBeClassified;
        }
        field(99000798; capacity; Text[400])
        {
            DataClassification = ToBeClassified;
            Description = 'Start capacity needs';
        }
        field(99000799; completionDate; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(99000800; capacityNeedsDescription; Text[400])
        {
            DataClassification = ToBeClassified;
        }
        field(99000801; remedialMeasures; Text[400])
        {
            DataClassification = ToBeClassified;
        }
        field(99000802; planning; Text[400])
        {
            DataClassification = ToBeClassified;
            Description = 'Action points';
        }
        field(99000803; personResponsible; Text[400])
        {
            DataClassification = ToBeClassified;
        }
        field(99000804; agreedActionPoints; Text[400])
        {
            DataClassification = ToBeClassified;
        }
        field(99000805; timelines; Text[400])
        {
            DataClassification = ToBeClassified;
        }
    }
    var
        StandardText: Record "Standard Text";
        exp: Code[100];
}
